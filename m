Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455F956FD24
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbiGKJvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbiGKJuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:50:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665E723150;
        Mon, 11 Jul 2022 02:24:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01C2961363;
        Mon, 11 Jul 2022 09:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12865C34115;
        Mon, 11 Jul 2022 09:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531488;
        bh=sU8MHd1BAT9pPPmpxJARHgNTc6LMa/2QtgH3sVlDSB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJqGIbYlHnyo2Dn3Us2xjj2cjycwcaCndA+8VpJbngON6fGdT9lLtv8m4Ui8Esd0W
         BM8tGTG2u6OqIZY1DRojTqupiBDws75g1u6IbcZrZ3dzyeGFeNxd6IjPHD5MNLS7ma
         NIV8rQ0YnjnLcovf6w6EV9hZ0iHEqTQb3p6Nj+zM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maurizio Avogadro <mavoga@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/230] ALSA: usb-audio: add mapping for MSI MAG X570S Torpedo MAX.
Date:   Mon, 11 Jul 2022 11:06:18 +0200
Message-Id: <20220711090607.526500681@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Avogadro <mavoga@gmail.com>

[ Upstream commit 4ddef9c4d70aae0c9029bdec7c3f7f1c1c51ff8c ]

The USB audio device 0db0:a073 based on the Realtek ALC4080 chipset
exposes all playback volume controls as "PCM". This makes
distinguishing the individual functions hard.
The mapping already adopted for device 0db0:419c based on the same
chipset fixes the issue, apply it for this device too.

Signed-off-by: Maurizio Avogadro <mavoga@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/Yl1ykPaGgsFf3SnW@ryzen
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_maps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 64fdca76b40e..997425ef0a29 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -586,6 +586,10 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x0db0, 0x419c),
 		.map = msi_mpg_x570s_carbon_max_wifi_alc4080_map,
 	},
+	{	/* MSI MAG X570S Torpedo Max */
+		.id = USB_ID(0x0db0, 0xa073),
+		.map = msi_mpg_x570s_carbon_max_wifi_alc4080_map,
+	},
 	{	/* MSI TRX40 */
 		.id = USB_ID(0x0db0, 0x543d),
 		.map = trx40_mobo_map,
-- 
2.35.1



