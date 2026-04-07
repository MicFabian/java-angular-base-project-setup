package com.example.baseproject.api.architecture

import com.tngtech.archunit.core.importer.ClassFileImporter
import com.tngtech.archunit.core.importer.ImportOption
import spock.lang.Specification

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses

class CleanArchitectureRulesSpec extends Specification {

    private final importedClasses = new ClassFileImporter()
            .withImportOption(ImportOption.Predefined.DO_NOT_INCLUDE_TESTS)
            .importPackages('com.example.baseproject.api.features')

    private final featureClassesMustLiveInALayerPackage = classes()
            .that().resideInAPackage('..features..')
            .should().resideInAnyPackage(
                    '..features..domain..',
                    '..features..application..',
                    '..features..infrastructure..',
                    '..features..presentation..'
            )

    private final domainMustNotDependOnFrameworkOrOuterLayers = noClasses()
            .that().resideInAPackage('..features..domain..')
            .should().dependOnClassesThat().resideInAnyPackage(
                    '..features..application..',
                    '..features..infrastructure..',
                    '..features..presentation..',
                    'org.springframework..',
                    'jakarta..'
            )

    private final applicationMustNotDependOnFrameworkOrOuterLayers = noClasses()
            .that().resideInAPackage('..features..application..')
            .should().dependOnClassesThat().resideInAnyPackage(
                    '..features..infrastructure..',
                    '..features..presentation..',
                    'org.springframework..',
                    'jakarta..'
            )

    private final presentationMustNotDependOnInfrastructure = noClasses()
            .that().resideInAPackage('..features..presentation..')
            .should().dependOnClassesThat().resideInAnyPackage('..features..infrastructure..')

    private final infrastructureMustNotDependOnPresentation = noClasses()
            .that().resideInAPackage('..features..infrastructure..')
            .should().dependOnClassesThat().resideInAnyPackage('..features..presentation..')

    private final noMultiPurposeServiceClassNames = noClasses()
            .that().resideInAPackage('..features..')
            .should().haveSimpleNameEndingWith('Service')

    def 'feature classes must live in a layer package'() {
        expect:
        featureClassesMustLiveInALayerPackage.check(importedClasses)
    }

    def 'domain must not depend on framework or outer layers'() {
        expect:
        domainMustNotDependOnFrameworkOrOuterLayers.check(importedClasses)
    }

    def 'application must not depend on framework or outer layers'() {
        expect:
        applicationMustNotDependOnFrameworkOrOuterLayers.check(importedClasses)
    }

    def 'presentation must not depend on infrastructure'() {
        expect:
        presentationMustNotDependOnInfrastructure.check(importedClasses)
    }

    def 'infrastructure must not depend on presentation'() {
        expect:
        infrastructureMustNotDependOnPresentation.check(importedClasses)
    }

    def 'no multi-purpose service class names'() {
        expect:
        noMultiPurposeServiceClassNames.check(importedClasses)
    }
}
