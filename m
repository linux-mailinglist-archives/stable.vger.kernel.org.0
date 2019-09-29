Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212C0C14C1
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 15:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbfI2N5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbfI2N5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:57:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E055721882;
        Sun, 29 Sep 2019 13:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765472;
        bh=WFPSs1XY6ltViKwCO9RVIRh0ygbXm+W+QOBH+Hvw6PI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YVl9/LGoLTyHwcRFBv4MnjwpCGgaDeQ3KsFTPj2THLDhG+Brv2PPHPuooC844EWCf
         Kpj/0qhsbsBYcc77Oc3WR++yNfzAf3xhQzAePPDExVzRYua0OjhVsOWvZ3Ecb5Mq39
         xm5BFdjfCAmuuWow08GEqsDCkNig5WPpkCSkp41g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Shih-Yuan Lee (FourDollars)" <fourdollars@debian.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 30/63] ALSA: hda - Add laptop imic fixup for ASUS M9V laptop
Date:   Sun, 29 Sep 2019 15:54:03 +0200
Message-Id: <20190929135037.683062639@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shih-Yuan Lee (FourDollars) <fourdollars@debian.org>

commit 7b485d175631be676424aedb8cd2f66d0c93da78 upstream.

The same fixup to enable laptop imic is needed for ASUS M9V with AD1986A
codec like another HP machine.

Signed-off-by: Shih-Yuan Lee (FourDollars) <fourdollars@debian.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190920134052.GA8035@localhost
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_analog.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -370,6 +370,7 @@ static const struct hda_fixup ad1986a_fi
 
 static const struct snd_pci_quirk ad1986a_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x30af, "HP B2800", AD1986A_FIXUP_LAPTOP_IMIC),
+	SND_PCI_QUIRK(0x1043, 0x1153, "ASUS M9V", AD1986A_FIXUP_LAPTOP_IMIC),
 	SND_PCI_QUIRK(0x1043, 0x1443, "ASUS Z99He", AD1986A_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x1043, 0x1447, "ASUS A8JN", AD1986A_FIXUP_EAPD),
 	SND_PCI_QUIRK_MASK(0x1043, 0xff00, 0x8100, "ASUS P5", AD1986A_FIXUP_3STACK),


