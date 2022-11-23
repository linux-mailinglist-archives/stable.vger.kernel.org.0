Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A575463559E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237385AbiKWJUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237442AbiKWJU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:20:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E1D3FB85
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:20:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 23F85CE20F1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE69C433B5;
        Wed, 23 Nov 2022 09:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195223;
        bh=5dDY1NPJIyPb8sR50fuoCWdWQ9FzrjWaVcV9w/BadrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMZ+rNL+CDNl6Xo0IANg1qoWi9zgPHSgwdWgT2WfqW+nTqsfH2f2UP9XRoA107Cz9
         BW697K0JkVfWS2WBBKSj4A9ZQwkM8DwGK7jywhX64dVRMV3A3CftjpJN7LQG/k9PR1
         BO4qCcoSUMiCdmSd4vQHVUU1OC2pdc1tft+XNJ4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Colin Ian King <colin.i.king@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paul Cercueil <paul@crapouillou.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/149] ASoC: codecs: jz4725b: Fix spelling mistake "Sourc" -> "Source", "Routee" -> "Route"
Date:   Wed, 23 Nov 2022 09:50:06 +0100
Message-Id: <20221123084558.851052845@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit df496157a5afa1b6d1f4c46ad6549c2c346d1e59 ]

There are two spelling mistakes in codec routing description. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Acked-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20221019071639.1003730-1-colin.i.king@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/jz4725b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/jz4725b.c b/sound/soc/codecs/jz4725b.c
index ab744e375367..8a830d0ad950 100644
--- a/sound/soc/codecs/jz4725b.c
+++ b/sound/soc/codecs/jz4725b.c
@@ -288,7 +288,7 @@ static const struct snd_soc_dapm_route jz4725b_codec_dapm_routes[] = {
 
 	{"Mixer to ADC", NULL, "Mixer"},
 	{"ADC Source Capture Route", "Mixer", "Mixer to ADC"},
-	{"ADC Sourc Capture Routee", "Line In", "Line In"},
+	{"ADC Source Capture Route", "Line In", "Line In"},
 	{"ADC Source Capture Route", "Mic 1", "Mic 1"},
 	{"ADC Source Capture Route", "Mic 2", "Mic 2"},
 	{"ADC", NULL, "ADC Source Capture Route"},
-- 
2.35.1



