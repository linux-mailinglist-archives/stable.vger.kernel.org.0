Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837A243A2CA
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237479AbhJYTwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:52:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237701AbhJYTui (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:50:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 746D460240;
        Mon, 25 Oct 2021 19:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190938;
        bh=j+QF2LcPO7hmfNxMDbnM5e9gK1V7JghTd8HSxp1SmkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXW6xn7q3U7Hsdv5gTKf3CqqH2ga9rEutlYFB7g1cOhgj+9rNxUHMEmedJpF0uSTY
         EzUNj+B0ErM0anj16yXHrP/FV3++Ekzy5JgqpH1QbhxvUOP/J86N/v8ol7CDFez5aO
         MnES0LpIeXeO9/YYbwzZW7THg0PqJhWFq7e7aWJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Clarkson <sc@lambdal.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 087/169] ALSA: hda/realtek: Add quirk for Clevo PC50HS
Date:   Mon, 25 Oct 2021 21:14:28 +0200
Message-Id: <20211025191028.244594305@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Clarkson <sc@lambdal.com>

commit aef454b40288158b850aab13e3d2a8c406779401 upstream.

Apply existing PCI quirk to the Clevo PC50HS and related models to fix
audio output on the built in speakers.

Signed-off-by: Steven Clarkson <sc@lambdal.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211014133554.1326741-1-sc@lambdal.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2547,6 +2547,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1558, 0x65d2, "Clevo PB51R[CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65e1, "Clevo PB51[ED][DF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65e5, "Clevo PC50D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x65f1, "Clevo PC50HS", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67d1, "Clevo PB71[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e1, "Clevo PB71[DE][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e5, "Clevo PC70D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),


