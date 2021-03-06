'use strict';

/* http://docs.angularjs.org/guide/dev_guide.e2e-testing */

describe('Contacts', function () {


    describe('Default Route', function () {
        beforeEach(function () {
            browser().navigateTo(appDir + 'index-test.html');
        });
        it('should automatically redirect to /nonvalidated/contacts when location hash/fragment is empty', function () {
            expect(browser().location().url()).toBe("/nonvalidated/contacts");
        });
    });

    describe('#/nonvalidated/contacts', function () {
        beforeEach(function () {
            browser().navigateTo('#/nonvalidated/contacts');
        });

        checkBreadCrumbs('Non-validated', 'Contacts');
        hasResultsDescription('Non-Validated Contact');

        hasActionsButton(true);
        hasEditAction(true);
        hasValidateAction(true);
        hasRejectNonValidAction(true);
        hasRejectValidAction(false);
        hasDeleteAction(false);
        listsRelatedMetadata("886", "Non-validated Metadata", "nvowner", "nvemail");
        clickEditActionOpensNewTab()
    });

    describe('#/validated/contacts', function () {
        beforeEach(function () {
            browser().navigateTo('#/validated/contacts');
        });

        checkBreadCrumbs('Validated', 'Contacts');
        hasResultsDescription('Validated Contact')

        hasActionsButton(true);
        hasEditAction(true);
        hasValidateAction(false);
        hasRejectNonValidAction(false);
        hasRejectValidAction(true);
        hasDeleteAction(false);
        listsRelatedMetadata("887", "Validated Metadata", "owner", "email");
    });
});
