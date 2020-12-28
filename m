Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFFC2E3FCE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503104AbgL1OYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:24:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503084AbgL1OYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CD63221F0;
        Mon, 28 Dec 2020 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165466;
        bh=L52cPrg8JXjiNTVL8rEOylDP9smaXWdzqiUSoSApO6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=muW9rN0wJ3oo7DHIdkBBtx1WsFA4oloWM8MzPGEdhlxTeC4D4vdgi9nmS/rDwMi7n
         /HFtykORpoY+aHJZTf1u6+PrgH56s45R8OMfJZeBYl5sTvv1OsMstdh5aBmd0u7FAb
         Z5AZzzSUJFr2TCLthLczWjfUj/9+gUojj4KNnerY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 540/717] ALSA: hda/realtek - Add supported for more Lenovo ALC285 Headset Button
Date:   Mon, 28 Dec 2020 13:48:58 +0100
Message-Id: <20201228125046.828807710@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 607184cb1635eaee239fe3fb9648a8b82a5232d7 upstream.

Add supported for more Lenovo ALC285 Headset Button.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/bb1f1da1526d460885aa4257be81eb94@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8577,6 +8577,10 @@ static const struct snd_hda_pin_quirk al
 		{0x12, 0x90a60130},
 		{0x19, 0x03a11020},
 		{0x21, 0x0321101f}),
+	SND_HDA_PIN_QUIRK(0x10ec0285, 0x17aa, "Lenovo", ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
+		{0x14, 0x90170110},
+		{0x19, 0x04a11040},
+		{0x21, 0x04211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0285, 0x17aa, "Lenovo", ALC285_FIXUP_LENOVO_PC_BEEP_IN_NOISE,
 		{0x12, 0x90a60130},
 		{0x14, 0x90170110},


