Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABED3187F7C
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgCQLBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbgCQLBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:01:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CE27205ED;
        Tue, 17 Mar 2020 11:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442912;
        bh=jIj8bDtRNdSjSkw3/Yjf0wMwP1auwRWihaaB+uWLOEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8KvGhJkRNhCQVL1mslKjpYKhk/5E5JphA8suoj73DpGjQXvnBr1TJqh1+SBG8JlD
         ayoA3QRGTot4vey21We8EWUv8y+hZcQNZQ+4HXXHCDomiC+4XCN+0G7vtdQaXPfXBM
         tlZlleGGOp8trPgUirEAyKq6c8+1eui673iv/XsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 004/123] ALSA: hda/realtek - Fixed one of HP ALC671 platform Headset Mic supported
Date:   Tue, 17 Mar 2020 11:53:51 +0100
Message-Id: <20200317103307.889339486@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit f2adbae0cb20c8eaf06914b2187043ea944b0aff upstream.

HP want to keep BIOS verb table for release platform.
So, it need to add 0x19 pin for quirk.

Fixes: 5af29028fd6d ("ALSA: hda/realtek - Add Headset Mic supported for HP cPC")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/74636ccb700a4cbda24c58a99dc430ce@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9169,6 +9169,7 @@ static const struct snd_hda_pin_quirk al
 	SND_HDA_PIN_QUIRK(0x10ec0671, 0x103c, "HP cPC", ALC671_FIXUP_HP_HEADSET_MIC2,
 		{0x14, 0x01014010},
 		{0x17, 0x90170150},
+		{0x19, 0x02a11060},
 		{0x1b, 0x01813030},
 		{0x21, 0x02211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0671, 0x103c, "HP cPC", ALC671_FIXUP_HP_HEADSET_MIC2,


