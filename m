Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2060378893
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhEJLWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237283AbhEJLLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74A1A61925;
        Mon, 10 May 2021 11:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644916;
        bh=+O1awEC6LLjUZL7jHfPVU/co9F9cpQMtrow0VxvOvkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyaQfXN45lE/zQV6e9JmFNJGkUoZn6HHYdFi2dzPn/fNCvuUe/lGxbYNzT9XqCdjZ
         t5CCg3pWVJbvaGf2ziawJVdrUSfOH3GORxZs0iL/6tQT3DgHUC+Sex+kZkEPAf50f1
         28UeV2tDDtkM4tmCLOBScSxUuFMyBXWIVXkoxk6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luke D Jones <luke@ljones.dev>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 277/384] ALSA: hda/realtek: GA503 use same quirks as GA401
Date:   Mon, 10 May 2021 12:21:06 +0200
Message-Id: <20210510102023.961360429@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke D Jones <luke@ljones.dev>

commit 76fae6185f5456865ff1bcb647709d44fd987eb6 upstream.

The GA503 has almost exactly the same default setup as the GA401
model with the same issues. The GA401 quirks solve all the issues
so we will use the full quirk chain.

Signed-off-by: Luke D Jones <luke@ljones.dev>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210419030411.28304-1-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8138,6 +8138,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
+	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1881, "ASUS Zephyrus S/M", ALC294_FIXUP_ASUS_GX502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),


