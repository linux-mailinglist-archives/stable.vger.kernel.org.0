Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4594C579F0A
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243071AbiGSNKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243284AbiGSNJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:09:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48EC62A73;
        Tue, 19 Jul 2022 05:28:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A4F6B81B10;
        Tue, 19 Jul 2022 12:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E602BC341C6;
        Tue, 19 Jul 2022 12:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233668;
        bh=uwPXRMAA96VqSh+TZh2f80g4MkVZh92p9R/dw4aDIT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvfVPqd3W/a3VGH+PbAZ5g/V39Y78nkf20+OSciZAzy1Ermn4wmvO2X5D1N9Yxe6g
         1hoWC3/Fp8UPit5CJlO1VOUHNRQWLVDQKw9KSbtrEHojRe774hl0Yhl/BsFJYrGIi0
         ovEbAW03kTb2/6wnGunAGTtL/GoC0yWNj4TTRbiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 200/231] ASoC: cs35l41: Correct some control names
Date:   Tue, 19 Jul 2022 13:54:45 +0200
Message-Id: <20220719114730.857350006@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit c6a5f22f9b4fd5f21414be690ce34046d9712f05 ]

Various boolean controls on cs35l41 are missing the required "Switch" in
the name, add these.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220621102041.1713504-3-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l41.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/cs35l41.c b/sound/soc/codecs/cs35l41.c
index 6b784a62df0c..20c76a53a508 100644
--- a/sound/soc/codecs/cs35l41.c
+++ b/sound/soc/codecs/cs35l41.c
@@ -392,7 +392,7 @@ static const struct snd_kcontrol_new cs35l41_aud_controls[] = {
 	SOC_SINGLE("HW Noise Gate Enable", CS35L41_NG_CFG, 8, 63, 0),
 	SOC_SINGLE("HW Noise Gate Delay", CS35L41_NG_CFG, 4, 7, 0),
 	SOC_SINGLE("HW Noise Gate Threshold", CS35L41_NG_CFG, 0, 7, 0),
-	SOC_SINGLE("Aux Noise Gate CH1 Enable",
+	SOC_SINGLE("Aux Noise Gate CH1 Switch",
 		   CS35L41_MIXER_NGATE_CH1_CFG, 16, 1, 0),
 	SOC_SINGLE("Aux Noise Gate CH1 Entry Delay",
 		   CS35L41_MIXER_NGATE_CH1_CFG, 8, 15, 0),
@@ -400,15 +400,15 @@ static const struct snd_kcontrol_new cs35l41_aud_controls[] = {
 		   CS35L41_MIXER_NGATE_CH1_CFG, 0, 7, 0),
 	SOC_SINGLE("Aux Noise Gate CH2 Entry Delay",
 		   CS35L41_MIXER_NGATE_CH2_CFG, 8, 15, 0),
-	SOC_SINGLE("Aux Noise Gate CH2 Enable",
+	SOC_SINGLE("Aux Noise Gate CH2 Switch",
 		   CS35L41_MIXER_NGATE_CH2_CFG, 16, 1, 0),
 	SOC_SINGLE("Aux Noise Gate CH2 Threshold",
 		   CS35L41_MIXER_NGATE_CH2_CFG, 0, 7, 0),
-	SOC_SINGLE("SCLK Force", CS35L41_SP_FORMAT, CS35L41_SCLK_FRC_SHIFT, 1, 0),
-	SOC_SINGLE("LRCLK Force", CS35L41_SP_FORMAT, CS35L41_LRCLK_FRC_SHIFT, 1, 0),
-	SOC_SINGLE("Invert Class D", CS35L41_AMP_DIG_VOL_CTRL,
+	SOC_SINGLE("SCLK Force Switch", CS35L41_SP_FORMAT, CS35L41_SCLK_FRC_SHIFT, 1, 0),
+	SOC_SINGLE("LRCLK Force Switch", CS35L41_SP_FORMAT, CS35L41_LRCLK_FRC_SHIFT, 1, 0),
+	SOC_SINGLE("Invert Class D Switch", CS35L41_AMP_DIG_VOL_CTRL,
 		   CS35L41_AMP_INV_PCM_SHIFT, 1, 0),
-	SOC_SINGLE("Amp Gain ZC", CS35L41_AMP_GAIN_CTRL,
+	SOC_SINGLE("Amp Gain ZC Switch", CS35L41_AMP_GAIN_CTRL,
 		   CS35L41_AMP_GAIN_ZC_SHIFT, 1, 0),
 	WM_ADSP2_PRELOAD_SWITCH("DSP1", 1),
 	WM_ADSP_FW_CONTROL("DSP1", 0),
-- 
2.35.1



