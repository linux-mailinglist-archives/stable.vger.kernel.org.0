Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BB950F6E6
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbiDZJBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346049AbiDZI7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:59:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354513AA5D;
        Tue, 26 Apr 2022 01:43:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38EF761338;
        Tue, 26 Apr 2022 08:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4060EC385AE;
        Tue, 26 Apr 2022 08:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962579;
        bh=gylZe0XJUpkh0pl4BBjl+oWL65orNRhQm0YgsYC6tBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZU4hwe/1n8xCTQsNy1J7nZe8WNzp9dUx59HIeVbdIIpao04U83RCpBYOi0/qs+YY
         /N9ms+/rTSYxuUwWt1YMtcqv20x8xeu6s3g4WuYt7004H8Kq6hXJkXHwgJTbYFsYAb
         mB3VfUoKpxB8bU0aLDiG/FQTM1Aycoh5YlLuDEnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maurizio Avogadro <mavoga@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 009/146] ALSA: usb-audio: add mapping for MSI MAG X570S Torpedo MAX.
Date:   Tue, 26 Apr 2022 10:20:04 +0200
Message-Id: <20220426081750.325268107@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Avogadro <mavoga@gmail.com>

commit 4ddef9c4d70aae0c9029bdec7c3f7f1c1c51ff8c upstream.

The USB audio device 0db0:a073 based on the Realtek ALC4080 chipset
exposes all playback volume controls as "PCM". This makes
distinguishing the individual functions hard.
The mapping already adopted for device 0db0:419c based on the same
chipset fixes the issue, apply it for this device too.

Signed-off-by: Maurizio Avogadro <mavoga@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/Yl1ykPaGgsFf3SnW@ryzen
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_maps.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -599,6 +599,10 @@ static const struct usbmix_ctl_map usbmi
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


