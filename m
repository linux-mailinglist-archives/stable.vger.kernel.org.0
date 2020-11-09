Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37542AB99A
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731384AbgKINKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:10:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732121AbgKINKm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:10:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6ABA2076E;
        Mon,  9 Nov 2020 13:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927441;
        bh=+wxpK4Hjd3cd1G9LKmSFcHe5QMuyc1xSa6ysGbzwHwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spvs1nVo7raiytkX3kOgbV8G73R3TRSW7/LA8cMcA6S9B+LNOlPDSoWjFYWAzGocM
         i9OhlUfuDeCh/4Y6GrcAo4SL//SNjThh/MMAu+8Oghudagr2iFo1PJbn+mXxG0ubBU
         lJFMVx2NoiuvO44GMzCYIKolp1QKy/eyvk8H3m2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artem Lapkin <art@khadas.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 33/71] ALSA: usb-audio: add usb vendor id as DSD-capable for Khadas devices
Date:   Mon,  9 Nov 2020 13:55:27 +0100
Message-Id: <20201109125021.465082291@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artem Lapkin <art@khadas.com>

commit 07815a2b3501adeaae6384a25b9c4a9c81dae59f upstream.

Khadas audio devices ( USB_ID_VENDOR 0x3353 )
have DSD-capable implementations from XMOS
need add new usb vendor id for recognition

Signed-off-by: Artem Lapkin <art@khadas.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201103103311.5435-1-art@khadas.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1466,6 +1466,7 @@ u64 snd_usb_interface_dsd_format_quirks(
 	case 0x278b:  /* Rotel? */
 	case 0x292b:  /* Gustard/Ess based devices */
 	case 0x2ab6:  /* T+A devices */
+	case 0x3353:  /* Khadas devices */
 	case 0x3842:  /* EVGA */
 	case 0xc502:  /* HiBy devices */
 		if (fp->dsd_raw)


