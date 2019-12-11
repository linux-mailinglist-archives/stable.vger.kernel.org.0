Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D0911B664
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbfLKQAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:00:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:37686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731491AbfLKPNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD0FA22B48;
        Wed, 11 Dec 2019 15:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077223;
        bh=8zBpuO12cXO1RswKC2eHP1PylRrkm7I8FK3/Ol9du+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bAv92Awg4cnD9QVFQYQuamn8ZKsVeXLJfzCEOclD373kPrpHtsN31zctQx9BXN1B5
         Fp4xXHeZABY0myq16KHDHMXpD3cDkdeVRlN9voOA+m/27J8a0vDvRv+ocLiwXhCHvZ
         iOD+uehO9hPlb2/x6O+gNCT5TBtOTWI4IE76o6LI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gayatri Kammela <gayatri.kammela@intel.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kan Liang <kan.liang@intel.com>,
        "David E . Box" <david.e.box@intel.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 102/134] platform/x86: intel_pmc_core: Fix the SoC naming inconsistency
Date:   Wed, 11 Dec 2019 10:11:18 -0500
Message-Id: <20191211151150.19073-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gayatri Kammela <gayatri.kammela@intel.com>

[ Upstream commit 43e82d8aa92503d264309fb648b251b2d85caf1a ]

Intel's SoCs follow a naming convention which spells out the SoC name as
two words instead of one word (E.g: Cannon Lake vs Cannonlake). Thus fix
the naming inconsistency across the intel_pmc_core driver, so future
SoCs can follow the naming consistency as below.

Cometlake -> Comet Lake
Tigerlake -> Tiger Lake
Elkhartlake -> Elkhart Lake

Cc: Mario Limonciello <mario.limonciello@dell.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kan Liang <kan.liang@intel.com>
Cc: David E. Box <david.e.box@intel.com>
Cc: Rajneesh Bhardwaj <rajneesh.bhardwaj@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_pmc_core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/intel_pmc_core.c b/drivers/platform/x86/intel_pmc_core.c
index 94a008efb09b8..6b6edc30f8359 100644
--- a/drivers/platform/x86/intel_pmc_core.c
+++ b/drivers/platform/x86/intel_pmc_core.c
@@ -158,7 +158,7 @@ static const struct pmc_reg_map spt_reg_map = {
 	.pm_vric1_offset = SPT_PMC_VRIC1_OFFSET,
 };
 
-/* Cannonlake: PGD PFET Enable Ack Status Register(s) bitmap */
+/* Cannon Lake: PGD PFET Enable Ack Status Register(s) bitmap */
 static const struct pmc_bit_map cnp_pfear_map[] = {
 	{"PMC",                 BIT(0)},
 	{"OPI-DMI",             BIT(1)},
@@ -185,7 +185,7 @@ static const struct pmc_bit_map cnp_pfear_map[] = {
 	{"SDX",                 BIT(4)},
 	{"SPE",                 BIT(5)},
 	{"Fuse",                BIT(6)},
-	/* Reserved for Cannonlake but valid for Icelake */
+	/* Reserved for Cannon Lake but valid for Ice Lake */
 	{"SBR8",		BIT(7)},
 
 	{"CSME_FSC",            BIT(0)},
@@ -229,12 +229,12 @@ static const struct pmc_bit_map cnp_pfear_map[] = {
 	{"HDA_PGD4",            BIT(2)},
 	{"HDA_PGD5",            BIT(3)},
 	{"HDA_PGD6",            BIT(4)},
-	/* Reserved for Cannonlake but valid for Icelake */
+	/* Reserved for Cannon Lake but valid for Ice Lake */
 	{"PSF6",		BIT(5)},
 	{"PSF7",		BIT(6)},
 	{"PSF8",		BIT(7)},
 
-	/* Icelake generation onwards only */
+	/* Ice Lake generation onwards only */
 	{"RES_65",		BIT(0)},
 	{"RES_66",		BIT(1)},
 	{"RES_67",		BIT(2)},
@@ -324,7 +324,7 @@ static const struct pmc_bit_map cnp_ltr_show_map[] = {
 	{"ISH",			CNP_PMC_LTR_ISH},
 	{"UFSX2",		CNP_PMC_LTR_UFSX2},
 	{"EMMC",		CNP_PMC_LTR_EMMC},
-	/* Reserved for Cannonlake but valid for Icelake */
+	/* Reserved for Cannon Lake but valid for Ice Lake */
 	{"WIGIG",		ICL_PMC_LTR_WIGIG},
 	/* Below two cannot be used for LTR_IGNORE */
 	{"CURRENT_PLATFORM",	CNP_PMC_LTR_CUR_PLT},
@@ -871,8 +871,8 @@ static int pmc_core_probe(struct platform_device *pdev)
 	pmcdev->map = (struct pmc_reg_map *)cpu_id->driver_data;
 
 	/*
-	 * Coffeelake has CPU ID of Kabylake and Cannonlake PCH. So here
-	 * Sunrisepoint PCH regmap can't be used. Use Cannonlake PCH regmap
+	 * Coffee Lake has CPU ID of Kaby Lake and Cannon Lake PCH. So here
+	 * Sunrisepoint PCH regmap can't be used. Use Cannon Lake PCH regmap
 	 * in this case.
 	 */
 	if (pmcdev->map == &spt_reg_map && !pci_dev_present(pmc_pci_ids))
-- 
2.20.1

