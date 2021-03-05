Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E41632EA0E
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhCEMgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:36:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:48376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232824AbhCEMfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:35:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C98A564FF0;
        Fri,  5 Mar 2021 12:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947752;
        bh=1rLMzXttGaSSBGoOJ/iNU/JVeKrD01NsPbqeHwF1kpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBpSchWT5N1BJHZttavBDt3/93YHRg4/+1aog3RXeNAL0WSXuXLLXQToUrEr0QpDU
         ZIlLne1OZz9z5YwZOplqQSLcxijXZU9NxP1DKAVxWq5un8RaSTBoDib2JNnEegvQ31
         KA2AFU0hnkkHky3G9j2TJaezBX0XkSjqa131oUgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 72/72] ALSA: hda/realtek: Apply dual codec quirks for MSI Godlike X570 board
Date:   Fri,  5 Mar 2021 13:22:14 +0100
Message-Id: <20210305120900.857054835@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 26af17722a07597d3e556eda92c6fce8d528bc9f upstream.

There is another MSI board (1462:cc34) that has dual Realtek codecs,
and we need to apply the existing quirk for fixing the conflicts of
Master control.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211743
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210303142346.28182-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2522,6 +2522,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1462, 0x1276, "MSI-GL73", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1293, "MSI-GP65", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x7350, "MSI-7350", ALC889_FIXUP_CD),
+	SND_PCI_QUIRK(0x1462, 0xcc34, "MSI Godlike X570", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1462, 0xda57, "MSI Z270-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK_VENDOR(0x1462, "MSI", ALC882_FIXUP_GPIO3),
 	SND_PCI_QUIRK(0x147b, 0x107a, "Abit AW9D-MAX", ALC882_FIXUP_ABIT_AW9D_MAX),


