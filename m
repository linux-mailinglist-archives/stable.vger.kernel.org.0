Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADAB20DC61
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729995AbgF2UOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:14:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732833AbgF2TaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC77C25235;
        Mon, 29 Jun 2020 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444951;
        bh=ix28kzNZAtsW/tcVDmTuz2aPst4XXKF4XxK/P+xnxFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTU0J/Tnj2KK4DZnRrQd0mCJv5alTKfgbVFea57GEXZG9mER0vmfjJfuQed+xChSU
         DMs7OXkC7i+Fn9SOGO11BnQCWifoch2X7/Xy1OJnBdeg8+27U0KL9C7iSr21LPQ1xN
         z2EL0HLChWK59MwpzDGyG47BdVGeMLiupzM6LZOI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Yick W. Tse" <y_w_tse@yahoo.com.hk>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 049/131] ALSA: usb-audio: add quirk for Denon DCD-1500RE
Date:   Mon, 29 Jun 2020 11:33:40 -0400
Message-Id: <20200629153502.2494656-50-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Yick W. Tse" <y_w_tse@yahoo.com.hk>

commit c9808bbfed3cfc911ecb60fe8e80c0c27876c657 upstream.

fix error "clock source 41 is not valid, cannot use"

[] New USB device found, idVendor=154e, idProduct=1002, bcdDevice= 1.00
[] New USB device strings: Mfr=1, Product=2, SerialNumber=0
[] Product: DCD-1500RE
[] Manufacturer: D & M Holdings Inc.
[]
[] clock source 41 is not valid, cannot use
[] usbcore: registered new interface driver snd-usb-audio

Signed-off-by: Yick W. Tse <y_w_tse@yahoo.com.hk>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1373857985.210365.1592048406997@mail.yahoo.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index aac23acfdd360..976eee06907c9 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1203,6 +1203,7 @@ bool snd_usb_get_sample_rate_quirk(struct snd_usb_audio *chip)
 static bool is_itf_usb_dsd_dac(unsigned int id)
 {
 	switch (id) {
+	case USB_ID(0x154e, 0x1002): /* Denon DCD-1500RE */
 	case USB_ID(0x154e, 0x1003): /* Denon DA-300USB */
 	case USB_ID(0x154e, 0x3005): /* Marantz HD-DAC1 */
 	case USB_ID(0x154e, 0x3006): /* Marantz SA-14S1 */
-- 
2.25.1

