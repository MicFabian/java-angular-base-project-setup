package com.example.baseproject.api.architecture

import com.tngtech.archunit.core.importer.ClassFileImporter
import com.tngtech.archunit.core.importer.ImportOption
import jakarta.persistence.Entity
import spock.lang.Specification

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses

class CleanArchitectureRulesSpec extends Specification {

    private final importedClasses = new ClassFileImporter()
            .withImportOption(ImportOption.Predefined.DO_NOT_INCLUDE_TESTS)
            .importPackages(
                    'com.example.baseproject.api.controller',
                    'com.example.baseproject.api.domain',
                    'com.example.baseproject.api.accessor',
                    'com.example.baseproject.api.config',
                    'com.example.baseproject.api.shared'
            )

    private final backendClassesMustLiveInAKnownRoot = classes()
            .should().resideInAnyPackage(
                    '..controller..',
                    '..domain..',
                    '..accessor..',
                    '..config..',
                    '..shared..'
            )

    private final domainMustNotDependOnControllerAccessorOrConfig = noClasses()
            .that().resideInAPackage('..domain..')
            .should().dependOnClassesThat().resideInAnyPackage(
                    '..controller..',
                    '..accessor..',
                    '..config..'
            )

    private final controllerMustNotDependOnAccessorOrConfig = noClasses()
            .that().resideInAPackage('..controller..')
            .should().dependOnClassesThat().resideInAnyPackage('..accessor..', '..config..')

    private final accessorMustNotDependOnController = noClasses()
            .that().resideInAPackage('..accessor..')
            .should().dependOnClassesThat().resideInAnyPackage('..controller..')
            .allowEmptyShould(true)

    private final controllersMustLiveInControllerRoot = classes()
            .that().haveSimpleNameEndingWith('Controller')
            .should().resideInAPackage('..controller..')

    private final transportResourcesMustLiveUnderControllerResources = classes()
            .that().haveSimpleNameEndingWith('Request')
            .or().haveSimpleNameEndingWith('Response')
            .or().haveSimpleNameEndingWith('Resource')
            .should().resideInAPackage('..controller..resources..')

    private final repositoriesMustLiveInDomainRoot = classes()
            .that().haveSimpleNameEndingWith('Repository')
            .should().resideInAPackage('..domain..')

    private final jpaEntitiesMustLiveInDomainRoot = classes()
            .that().areAnnotatedWith(Entity)
            .should().resideInAPackage('..domain..')

    def 'backend classes must live in a known root'() {
        expect:
        backendClassesMustLiveInAKnownRoot.check(importedClasses)
    }

    def 'domain must not depend on controller accessor or config'() {
        expect:
        domainMustNotDependOnControllerAccessorOrConfig.check(importedClasses)
    }

    def 'controller must not depend on accessor or config'() {
        expect:
        controllerMustNotDependOnAccessorOrConfig.check(importedClasses)
    }

    def 'accessor must not depend on controller'() {
        expect:
        accessorMustNotDependOnController.check(importedClasses)
    }

    def 'controllers must live in the controller root'() {
        expect:
        controllersMustLiveInControllerRoot.check(importedClasses)
    }

    def 'transport resources must live under controller resources'() {
        expect:
        transportResourcesMustLiveUnderControllerResources.check(importedClasses)
    }

    def 'repositories must live in the domain root'() {
        expect:
        repositoriesMustLiveInDomainRoot.check(importedClasses)
    }

    def 'JPA entities must live in the domain root'() {
        expect:
        jpaEntitiesMustLiveInDomainRoot.check(importedClasses)
    }
}
