Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A617FCA16F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730358AbfJCPzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfJCPzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:55:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D0F221783;
        Thu,  3 Oct 2019 15:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118153;
        bh=WFPSs1XY6ltViKwCO9RVIRh0ygbXm+W+QOBH+Hvw6PI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAdjekYdhG5aBk6GuV0W4yGfzy6BTqvgqapgMWBI0RhTSqctqA4QNCndoJqqf9hp0
         uXrIxRhP6HhgGiwj5/8nizODzEHPCtsuE2tWYD1CAw9AAMZF/Ofxn26zA2EDLE9jgh
         OYK3RARnEjJDE9TI/7cMGMKvK4AMceDNZE33LP14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Shih-Yuan Lee (FourDollars)" <fourdollars@debian.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 10/99] ALSA: hda - Add laptop imic fixup for ASUS M9V laptop
Date:   Thu,  3 Oct 2019 17:52:33 +0200
Message-Id: <20191003154257.959228889@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
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


