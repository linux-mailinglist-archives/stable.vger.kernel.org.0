Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A1D20D399
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbgF2TAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730365AbgF2TAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E88E25548;
        Mon, 29 Jun 2020 15:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446109;
        bh=YpJd79kjTQ4kVh6u8tT6HFP2u0rptIoIcXXL4A7Y5BM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERv47LKmoLIMv6OshN8CCdgdampeFtSxMxDMQ61uE9IfbGPrEjxLdZrwMZ7MwMCBD
         z4z6wC1jV8v2ncpdc5cfVZxI3oktOHSDjcALWN0LjAj30DPGbFsgd2TYc03pRSDyQR
         aApo9apNYTa0UOW4r0RQyBT/ruB+UCw+6d/75Buk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Yick W. Tse" <y_w_tse@yahoo.com.hk>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 100/135] ALSA: usb-audio: add quirk for Denon DCD-1500RE
Date:   Mon, 29 Jun 2020 11:52:34 -0400
Message-Id: <20200629155309.2495516-101-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
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
index b7a7bf0e566c4..47979c9c3e290 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1162,6 +1162,7 @@ bool snd_usb_get_sample_rate_quirk(struct snd_usb_audio *chip)
 static bool is_marantz_denon_dac(unsigned int id)
 {
 	switch (id) {
+	case USB_ID(0x154e, 0x1002): /* Denon DCD-1500RE */
 	case USB_ID(0x154e, 0x1003): /* Denon DA-300USB */
 	case USB_ID(0x154e, 0x3005): /* Marantz HD-DAC1 */
 	case USB_ID(0x154e, 0x3006): /* Marantz SA-14S1 */
-- 
2.25.1

