Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79111635530
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237256AbiKWJOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237287AbiKWJO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:14:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19201107E4D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:14:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA31961B14
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A984C433D7;
        Wed, 23 Nov 2022 09:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194865;
        bh=uRIb+m49OBhCrmfBdz8AcUfRxXEcuxfqhSK8uAUYD6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJcecDPbJLZC+AAKrEfl9PbAjw2wSQRGuWumVMdNGk3ntOsH4ok/oYESAzPuwB5Sf
         b1rb3m7qOVaRVhZJraRbVsff6/gusjlUrhsTHsjOOh2elHyNhRKQVM49VWp1pGj/C+
         ejbEjGp5c4eEbXOQPmVDcsbQ5JbfA9hTQ8BVhsz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Colin Ian King <colin.i.king@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paul Cercueil <paul@crapouillou.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/156] ASoC: codecs: jz4725b: Fix spelling mistake "Sourc" -> "Source", "Routee" -> "Route"
Date:   Wed, 23 Nov 2022 09:50:38 +0100
Message-Id: <20221123084600.940520618@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
index ebe643e4aa2f..48c40a44b763 100644
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



