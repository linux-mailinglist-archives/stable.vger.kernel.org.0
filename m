Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED7BC158A
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbfI2OCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730133AbfI2OCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:02:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27DFA21835;
        Sun, 29 Sep 2019 14:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765721;
        bh=87zlzf+tQryHwKDeD7jX0p1gK1qQ5FkxsipXvxePW8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHddjkTMZr2owWW7g+4XzouwpQspctIqcTr7s8SvFiRSyDGAILdBJG+spkb9uP1sN
         KVaBH10NqM7XGxDUI3/gTw0nj956WDPdKGwZvzONezpvOjpdkaX+AZ+XnQfsb/9N1V
         iLPOIFNyq75s7haD4TKzTD4t4t+iuMzAMBCeFWlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Shih-Yuan Lee (FourDollars)" <fourdollars@debian.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.2 26/45] ALSA: hda - Add laptop imic fixup for ASUS M9V laptop
Date:   Sun, 29 Sep 2019 15:55:54 +0200
Message-Id: <20190929135031.448652942@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
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
@@ -357,6 +357,7 @@ static const struct hda_fixup ad1986a_fi
 
 static const struct snd_pci_quirk ad1986a_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x30af, "HP B2800", AD1986A_FIXUP_LAPTOP_IMIC),
+	SND_PCI_QUIRK(0x1043, 0x1153, "ASUS M9V", AD1986A_FIXUP_LAPTOP_IMIC),
 	SND_PCI_QUIRK(0x1043, 0x1443, "ASUS Z99He", AD1986A_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x1043, 0x1447, "ASUS A8JN", AD1986A_FIXUP_EAPD),
 	SND_PCI_QUIRK_MASK(0x1043, 0xff00, 0x8100, "ASUS P5", AD1986A_FIXUP_3STACK),


