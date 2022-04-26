Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8418E510839
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353747AbiDZTFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353746AbiDZTFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B838819982E;
        Tue, 26 Apr 2022 12:02:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AF1CB8224A;
        Tue, 26 Apr 2022 19:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB72EC385AF;
        Tue, 26 Apr 2022 19:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999737;
        bh=nkHXMlkQYvJ0VAZul9wxWujXNsFjkiphNohHPwXVGtE=;
        h=From:To:Cc:Subject:Date:From;
        b=HXUp2EYLFyhcwJzOx7VCCl713bZgHz/aFuTOVzHwhn68JBQ1Rb65EJXuXocntQmMH
         x39P3cyh1p7RsIohxgoN1n/zCJ4FLsQxAghqQnawHgZZlOSFwgGuu+2oDup6w88ynu
         roNlD0+VH3mdJK2vtOGtvpzmtsADLeOtD9reynorrplTDUV/RJtPxmejIaKPpWMdQR
         SW2wDMm12QAM4FNm7RA+gORb7L+mPJkYYrF1R+Bb3WNNRHNzqsN+67+RueC5nugdNa
         vxNjv6kFOgnh0vXPbyTINtRRPxuQUrKrFIwA+8VE5CSA2C31WMsxbAhQX+zzsF1tym
         SaA1RtsohHSkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Song <chao.song@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, yang.jie@linux.intel.com,
        perex@perex.cz, tiwai@suse.com, yung-chuan.liao@linux.intel.com,
        rander.wang@intel.com, peter.ujfalusi@linux.intel.com,
        brent.lu@intel.com, balamurugan.c@intel.com,
        gongjun.song@intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 01/15] ASoC: Intel: soc-acpi: correct device endpoints for max98373
Date:   Tue, 26 Apr 2022 15:02:00 -0400
Message-Id: <20220426190216.2351413-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Song <chao.song@linux.intel.com>

[ Upstream commit 97326be14df7bacc6ba5c62c0556298c27ea0432 ]

The left speaker of max98373 uses spk_r_endpoint, and right
speaker uses spk_l_endpoint, this is obviously wrong.

This patch corrects the endpoints for max98373 codec.

Signed-off-by: Chao Song <chao.song@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220406192341.271465-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-tgl-match.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-tgl-match.c b/sound/soc/intel/common/soc-acpi-intel-tgl-match.c
index 11801b905ecc..c93d8019b0e5 100644
--- a/sound/soc/intel/common/soc-acpi-intel-tgl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-tgl-match.c
@@ -127,13 +127,13 @@ static const struct snd_soc_acpi_adr_device mx8373_1_adr[] = {
 	{
 		.adr = 0x000123019F837300ull,
 		.num_endpoints = 1,
-		.endpoints = &spk_l_endpoint,
+		.endpoints = &spk_r_endpoint,
 		.name_prefix = "Right"
 	},
 	{
 		.adr = 0x000127019F837300ull,
 		.num_endpoints = 1,
-		.endpoints = &spk_r_endpoint,
+		.endpoints = &spk_l_endpoint,
 		.name_prefix = "Left"
 	}
 };
-- 
2.35.1

