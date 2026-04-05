package com.example.baseproject.api.architecture;

import com.tngtech.archunit.core.importer.ImportOption;
import com.tngtech.archunit.junit.AnalyzeClasses;
import com.tngtech.archunit.junit.ArchTest;
import com.tngtech.archunit.lang.ArchRule;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes;
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses;

@AnalyzeClasses(
        packages = "com.example.baseproject.api.features",
        importOptions = ImportOption.DoNotIncludeTests.class
)
class CleanArchitectureRulesTest {

    @ArchTest
    static final ArchRule feature_classes_must_live_in_a_layer_package =
            classes()
                    .that().resideInAPackage("..features..")
                    .should().resideInAnyPackage(
                            "..features..domain..",
                            "..features..application..",
                            "..features..infrastructure..",
                            "..features..presentation.."
                    );

    @ArchTest
    static final ArchRule domain_must_not_depend_on_framework_or_outer_layers =
            noClasses()
                    .that().resideInAPackage("..features..domain..")
                    .should().dependOnClassesThat().resideInAnyPackage(
                            "..features..application..",
                            "..features..infrastructure..",
                            "..features..presentation..",
                            "org.springframework..",
                            "jakarta.."
                    );

    @ArchTest
    static final ArchRule application_must_not_depend_on_framework_or_outer_layers =
            noClasses()
                    .that().resideInAPackage("..features..application..")
                    .should().dependOnClassesThat().resideInAnyPackage(
                            "..features..infrastructure..",
                            "..features..presentation..",
                            "org.springframework..",
                            "jakarta.."
                    );

    @ArchTest
    static final ArchRule presentation_must_not_depend_on_infrastructure =
            noClasses()
                    .that().resideInAPackage("..features..presentation..")
                    .should().dependOnClassesThat().resideInAnyPackage("..features..infrastructure..");

    @ArchTest
    static final ArchRule infrastructure_must_not_depend_on_presentation =
            noClasses()
                    .that().resideInAPackage("..features..infrastructure..")
                    .should().dependOnClassesThat().resideInAnyPackage("..features..presentation..");

    @ArchTest
    static final ArchRule no_multi_purpose_service_class_names =
            noClasses()
                    .that().resideInAPackage("..features..")
                    .should().haveSimpleNameEndingWith("Service");
}
