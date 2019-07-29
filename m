Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB37879921
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387530AbfG2Tax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727991AbfG2Tar (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:30:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A055221655;
        Mon, 29 Jul 2019 19:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428647;
        bh=tDQDRQ12fLgTyrsfORkgshblzGCDzEYvHzE8aV8oW/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+buXZmwpBEtkmoMyrFmKrGdCz+1WaUDmNKRUw+o7vB5oQDEJ5miYZ2QyL5jLi/zo
         oY7Ia0CF9pXE2UXkB8ymji6dS3QO23uPhtRvfc/nBIgZjPHs8hi/pWsLMchPVDy0VD
         0C0U/HmSD8178K+dTz9rbQFEs+CfGM2gF4j/HE7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 140/293] ALSA: hda/realtek: apply ALC891 headset fixup to one Dell machine
Date:   Mon, 29 Jul 2019 21:20:31 +0200
Message-Id: <20190729190835.277958453@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 4b4e0e32e4b09274dbc9d173016c1a026f44608c upstream.

Without this patch, the headset-mic and headphone-mic don't work.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8149,6 +8149,11 @@ static const struct snd_hda_pin_quirk al
 		{0x18, 0x01a19030},
 		{0x1a, 0x01813040},
 		{0x21, 0x01014020}),
+	SND_HDA_PIN_QUIRK(0x10ec0867, 0x1028, "Dell", ALC891_FIXUP_DELL_MIC_NO_PRESENCE,
+		{0x16, 0x01813030},
+		{0x17, 0x02211010},
+		{0x18, 0x01a19040},
+		{0x21, 0x01014020}),
 	SND_HDA_PIN_QUIRK(0x10ec0662, 0x1028, "Dell", ALC662_FIXUP_DELL_MIC_NO_PRESENCE,
 		{0x14, 0x01014010},
 		{0x18, 0x01a19020},


