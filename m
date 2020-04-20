Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F761B0B05
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgDTMqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:46:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728446AbgDTMqy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:46:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8ED32072B;
        Mon, 20 Apr 2020 12:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386814;
        bh=aj7jSU0TCG/lF1yPRu6YAFGC5R8mSASegSlZmQ/WKYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vP/xPgbJ4kLICZfhTHLlEOQPxEHfXF6ZWL/kPQD4IIjQE/L3Lks3vsyiLxn2ne45X
         f/k+t5lA46E6HTf5Qe/a07rnnA09CoWGAN2Dw9yGLNVn2ig00iXP/zZRtxyFoFJv0+
         b8ok8sZLvcyE2W5e99y9Ef+JxB+Mw2W4zVVkaVgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Barber <barberadam995@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 36/60] ALSA: hda/realtek - Enable the headset mic on Asus FX505DT
Date:   Mon, 20 Apr 2020 14:39:14 +0200
Message-Id: <20200420121510.843220125@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121500.490651540@linuxfoundation.org>
References: <20200420121500.490651540@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Barber <barberadam995@gmail.com>

commit 4963d66b8a26c489958063abb6900ea6ed8e4836 upstream.

On Asus FX505DT with Realtek ALC233, the headset mic is connected
to pin 0x19, with default 0x411111f0.

Enable headset mic by reconfiguring the pin to an external mic
associated with the headphone on 0x21. Mic jack detection was also
found to be working.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207131
Signed-off-by: Adam Barber <barberadam995@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200410090032.2759-1-barberadam995@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7253,6 +7253,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x17d1, "ASUS UX431FL", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),
 	SND_PCI_QUIRK(0x1043, 0x1a30, "ASUS X705UD", ALC256_FIXUP_ASUS_MIC),


