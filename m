Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9FF4F2BA0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239214AbiDEIoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241123AbiDEIcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B358216584;
        Tue,  5 Apr 2022 01:28:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EF97609D0;
        Tue,  5 Apr 2022 08:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E334C385A1;
        Tue,  5 Apr 2022 08:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147296;
        bh=FjlwNEak2Y5XHLiuM71zpUltWSfxCrU7knvshYNWE0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+zkipLGwWcfop8jTB2itFaVq6jPS2HukyvxjPIrbhhG6ry0t6UCKjyxm3DZI5MeM
         I9INxh17hcRPtxftGNZuDMPouaPkOuTy1JbtABa6NEjjECBcI2a2ViWibsvZFlMCkk
         pdI9lpbDuAphT1pr/qCRz7eFuiAtLdwJ9q3qufh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaxin Yu <jiaxin.yu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.17 1046/1126] ASoC: mediatek: mt6358: add missing EXPORT_SYMBOLs
Date:   Tue,  5 Apr 2022 09:29:53 +0200
Message-Id: <20220405070438.174765036@linuxfoundation.org>
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

From: Jiaxin Yu <jiaxin.yu@mediatek.com>

commit a7663c89f4193dbf717572e46e5a3251940dbdc8 upstream.

Fixes the following build errors when mt6358 is configured as module:

>> ERROR: modpost: "mt6358_set_mtkaif_protocol"
>> [sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.ko] undefined!
>> ERROR: modpost: "mt6358_set_mtkaif_protocol"
>> [sound/soc/mediatek/mt8186/mt8186-mt6366-da7219-max98357.ko] undefined!

Fixes: 6a8d4198ca80 ("ASoC: mediatek: mt6358: add codec driver")
Signed-off-by: Jiaxin Yu <jiaxin.yu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220319120325.11882-1-jiaxin.yu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/mt6358.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/soc/codecs/mt6358.c
+++ b/sound/soc/codecs/mt6358.c
@@ -107,6 +107,7 @@ int mt6358_set_mtkaif_protocol(struct sn
 	priv->mtkaif_protocol = mtkaif_protocol;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mt6358_set_mtkaif_protocol);
 
 static void playback_gpio_set(struct mt6358_priv *priv)
 {
@@ -273,6 +274,7 @@ int mt6358_mtkaif_calibration_enable(str
 			   1 << RG_AUD_PAD_TOP_DAT_MISO_LOOPBACK_SFT);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mt6358_mtkaif_calibration_enable);
 
 int mt6358_mtkaif_calibration_disable(struct snd_soc_component *cmpnt)
 {
@@ -296,6 +298,7 @@ int mt6358_mtkaif_calibration_disable(st
 	capture_gpio_reset(priv);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mt6358_mtkaif_calibration_disable);
 
 int mt6358_set_mtkaif_calibration_phase(struct snd_soc_component *cmpnt,
 					int phase_1, int phase_2)
@@ -310,6 +313,7 @@ int mt6358_set_mtkaif_calibration_phase(
 			   phase_2 << RG_AUD_PAD_TOP_PHASE_MODE2_SFT);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mt6358_set_mtkaif_calibration_phase);
 
 /* dl pga gain */
 enum {


