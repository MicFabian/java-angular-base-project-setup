package com.example.baseproject.api.architecture

import com.tngtech.archunit.core.importer.ClassFileImporter
import com.tngtech.archunit.core.importer.ImportOption
import spock.lang.Specification

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses

class CleanArchitectureRulesSpec extends Specification {

    private final importedClasses = new ClassFileImporter()
            .withImportOption(ImportOption.Predefined.DO_NOT_INCLUDE_TESTS)
            .importPackages(
                    'com.example.baseproject.api.controller',
                    'com.example.baseproject.api.domain',
                    'com.example.baseproject.api.accessor'
            )

    private final backendClassesMustLiveInAKnownRoot = classes()
            .should().resideInAnyPackage(
                    '..controller..',
                    '..domain..',
                    '..accessor..'
            )

    private final domainMustNotDependOnControllerOrAccessor = noClasses()
            .that().resideInAPackage('..domain..')
            .should().dependOnClassesThat().resideInAnyPackage(
                    '..controller..',
                    '..accessor..',
                    'org.springframework..',
                    'jakarta..'
            )

    private final controllerMustNotDependOnAccessor = noClasses()
            .that().resideInAPackage('..controller..')
            .should().dependOnClassesThat().resideInAnyPackage('..accessor..')

    private final accessorMustNotDependOnController = noClasses()
            .that().resideInAPackage('..accessor..')
            .should().dependOnClassesThat().resideInAnyPackage('..controller..')

    private final controllersMustLiveInControllerRoot = classes()
            .that().haveSimpleNameEndingWith('Controller')
            .should().resideInAPackage('..controller..')

    private final noMultiPurposeServiceClassNames = noClasses()
            .should().haveSimpleNameEndingWith('Service')

    def 'backend classes must live in a known root'() {
        expect:
        backendClassesMustLiveInAKnownRoot.check(importedClasses)
    }

    def 'domain must not depend on controller, accessor, or framework types'() {
        expect:
        domainMustNotDependOnControllerOrAccessor.check(importedClasses)
    }

    def 'controller must not depend on accessor'() {
        expect:
        controllerMustNotDependOnAccessor.check(importedClasses)
    }

    def 'accessor must not depend on controller'() {
        expect:
        accessorMustNotDependOnController.check(importedClasses)
    }

    def 'controllers must live in the controller root'() {
        expect:
        controllersMustLiveInControllerRoot.check(importedClasses)
    }

    def 'no multi-purpose service class names'() {
        expect:
        noMultiPurposeServiceClassNames.check(importedClasses)
    }
}
