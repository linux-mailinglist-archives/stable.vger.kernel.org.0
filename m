Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41564F2B15
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236450AbiDEJC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238368AbiDEIab (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:30:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E2325EAA;
        Tue,  5 Apr 2022 01:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC9E160FF7;
        Tue,  5 Apr 2022 08:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8083C385A0;
        Tue,  5 Apr 2022 08:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146930;
        bh=kKgbNHwddUiwkQ0fNo9UvyNztXfEeCzHFDRq0uA6vRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YW63rmkaEZUpjJKtCTNKnZ7ime9wA4k74FRsqIRhnbd1j2TaZiw21stOcYXc+1Zuq
         lCbOguZb4HLLgmdcdkOHebE1RgujeyhXFrV1VGeh+YusfQh10VsZ9JxjXpuY442MZT
         5R8hLPP+F87ad68rvWME8qC49Y8bHxPJERoFWf/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, anthony tonitch <d.tonitch@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0940/1126] ASoC: Intel: soc-acpi: add more ACPI HIDs for ES83x6 devices
Date:   Tue,  5 Apr 2022 09:28:07 +0200
Message-Id: <20220405070435.102516338@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 1cedb6eabf0f2dd8285d3bb0ce1abd2369529084 ]

We only saw ESSX8336 so far, but now with reports of 'ESSX8326' we
need to expand to a full list. Let's reuse the 'snd_soc_acpi_codecs'
structure to store the information.

Note that ES8326 will need a dedicated codec driver, but the plan is
to use the same machine driver for all Everest Audio devices.

Reported-by: anthony tonitch <d.tonitch@gmail.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220308192610.392950-9-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-bxt-match.c | 7 ++++++-
 sound/soc/intel/common/soc-acpi-intel-cml-match.c | 7 ++++++-
 sound/soc/intel/common/soc-acpi-intel-glk-match.c | 7 ++++++-
 sound/soc/intel/common/soc-acpi-intel-jsl-match.c | 7 ++++++-
 sound/soc/intel/common/soc-acpi-intel-tgl-match.c | 7 ++++++-
 5 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-bxt-match.c b/sound/soc/intel/common/soc-acpi-intel-bxt-match.c
index 342d34052204..04a92e74d99b 100644
--- a/sound/soc/intel/common/soc-acpi-intel-bxt-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-bxt-match.c
@@ -41,6 +41,11 @@ static struct snd_soc_acpi_mach *apl_quirk(void *arg)
 	return mach;
 }
 
+static const struct snd_soc_acpi_codecs essx_83x6 = {
+	.num_codecs = 3,
+	.codecs = { "ESSX8316", "ESSX8326", "ESSX8336"},
+};
+
 static const struct snd_soc_acpi_codecs bxt_codecs = {
 	.num_codecs = 1,
 	.codecs = {"MX98357A"}
@@ -83,7 +88,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_bxt_machines[] = {
 		.sof_tplg_filename = "sof-apl-tdf8532.tplg",
 	},
 	{
-		.id = "ESSX8336",
+		.comp_ids = &essx_83x6,
 		.drv_name = "sof-essx8336",
 		.sof_fw_filename = "sof-apl.ri",
 		.sof_tplg_filename = "sof-apl-es8336.tplg",
diff --git a/sound/soc/intel/common/soc-acpi-intel-cml-match.c b/sound/soc/intel/common/soc-acpi-intel-cml-match.c
index 4eebc79d4b48..14395833d89e 100644
--- a/sound/soc/intel/common/soc-acpi-intel-cml-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-cml-match.c
@@ -9,6 +9,11 @@
 #include <sound/soc-acpi.h>
 #include <sound/soc-acpi-intel-match.h>
 
+static const struct snd_soc_acpi_codecs essx_83x6 = {
+	.num_codecs = 3,
+	.codecs = { "ESSX8316", "ESSX8326", "ESSX8336"},
+};
+
 static const struct snd_soc_acpi_codecs rt1011_spk_codecs = {
 	.num_codecs = 1,
 	.codecs = {"10EC1011"}
@@ -82,7 +87,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_cml_machines[] = {
 		.sof_tplg_filename = "sof-cml-da7219-max98390.tplg",
 	},
 	{
-		.id = "ESSX8336",
+		.comp_ids = &essx_83x6,
 		.drv_name = "sof-essx8336",
 		.sof_fw_filename = "sof-cml.ri",
 		.sof_tplg_filename = "sof-cml-es8336.tplg",
diff --git a/sound/soc/intel/common/soc-acpi-intel-glk-match.c b/sound/soc/intel/common/soc-acpi-intel-glk-match.c
index 8492b7e2a945..7aa6a870d5a5 100644
--- a/sound/soc/intel/common/soc-acpi-intel-glk-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-glk-match.c
@@ -9,6 +9,11 @@
 #include <sound/soc-acpi.h>
 #include <sound/soc-acpi-intel-match.h>
 
+static const struct snd_soc_acpi_codecs essx_83x6 = {
+	.num_codecs = 3,
+	.codecs = { "ESSX8316", "ESSX8326", "ESSX8336"},
+};
+
 static const struct snd_soc_acpi_codecs glk_codecs = {
 	.num_codecs = 1,
 	.codecs = {"MX98357A"}
@@ -58,7 +63,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_glk_machines[] = {
 		.sof_tplg_filename = "sof-glk-cs42l42.tplg",
 	},
 	{
-		.id = "ESSX8336",
+		.comp_ids = &essx_83x6,
 		.drv_name = "sof-essx8336",
 		.sof_fw_filename = "sof-glk.ri",
 		.sof_tplg_filename = "sof-glk-es8336.tplg",
diff --git a/sound/soc/intel/common/soc-acpi-intel-jsl-match.c b/sound/soc/intel/common/soc-acpi-intel-jsl-match.c
index 278ec196da7b..9d0d0e1437a4 100644
--- a/sound/soc/intel/common/soc-acpi-intel-jsl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-jsl-match.c
@@ -9,6 +9,11 @@
 #include <sound/soc-acpi.h>
 #include <sound/soc-acpi-intel-match.h>
 
+static const struct snd_soc_acpi_codecs essx_83x6 = {
+	.num_codecs = 3,
+	.codecs = { "ESSX8316", "ESSX8326", "ESSX8336"},
+};
+
 static const struct snd_soc_acpi_codecs jsl_7219_98373_codecs = {
 	.num_codecs = 1,
 	.codecs = {"MX98373"}
@@ -87,7 +92,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_jsl_machines[] = {
 		.sof_tplg_filename = "sof-jsl-cs42l42-mx98360a.tplg",
 	},
 	{
-		.id = "ESSX8336",
+		.comp_ids = &essx_83x6,
 		.drv_name = "sof-essx8336",
 		.sof_fw_filename = "sof-jsl.ri",
 		.sof_tplg_filename = "sof-jsl-es8336.tplg",
diff --git a/sound/soc/intel/common/soc-acpi-intel-tgl-match.c b/sound/soc/intel/common/soc-acpi-intel-tgl-match.c
index da31bb3cca17..e2658bca6931 100644
--- a/sound/soc/intel/common/soc-acpi-intel-tgl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-tgl-match.c
@@ -10,6 +10,11 @@
 #include <sound/soc-acpi-intel-match.h>
 #include "soc-acpi-intel-sdw-mockup-match.h"
 
+static const struct snd_soc_acpi_codecs essx_83x6 = {
+	.num_codecs = 3,
+	.codecs = { "ESSX8316", "ESSX8326", "ESSX8336"},
+};
+
 static const struct snd_soc_acpi_codecs tgl_codecs = {
 	.num_codecs = 1,
 	.codecs = {"MX98357A"}
@@ -389,7 +394,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_tgl_machines[] = {
 		.sof_tplg_filename = "sof-tgl-rt1011-rt5682.tplg",
 	},
 	{
-		.id = "ESSX8336",
+		.comp_ids = &essx_83x6,
 		.drv_name = "sof-essx8336",
 		.sof_fw_filename = "sof-tgl.ri",
 		.sof_tplg_filename = "sof-tgl-es8336.tplg",
-- 
2.34.1



