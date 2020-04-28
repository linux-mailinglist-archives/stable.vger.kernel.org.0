Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E161BCA28
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730926AbgD1SrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:47:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730185AbgD1SmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:42:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 765B32085B;
        Tue, 28 Apr 2020 18:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099336;
        bh=Aooe9Fb48jC9fdzwF9kNFkcDjIHYxpG4lZ1BoJLlwSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YE2y5h9PN047oN7z0Lh4P3YCONz33T2K8EFd1CHD3Ausw3xA1Rg+2jPBN9/uOFKoo
         rrwrFTSsWAzgNnzXi3LRNnob0U8QFhRbojsVn86nXIHhG7ZsU0j4yb1Uzjl/WTuixR
         RwVaCrCCT0jUTR+2J8AIGfJ9/4bzd1ukSdh91YhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 110/168] ALSA: hda/realtek - Add new codec supported for ALC245
Date:   Tue, 28 Apr 2020 20:24:44 +0200
Message-Id: <20200428182246.434778530@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 7fbdcd8301a84c09cebfa64f1317a6dafeec9188 upstream.

Enable new codec supported for ALC245.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/8c0804738b2c42439f59c39c8437817f@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -369,6 +369,7 @@ static void alc_fill_eapd_coef(struct hd
 	case 0x10ec0233:
 	case 0x10ec0235:
 	case 0x10ec0236:
+	case 0x10ec0245:
 	case 0x10ec0255:
 	case 0x10ec0256:
 	case 0x10ec0257:
@@ -8102,6 +8103,7 @@ static int patch_alc269(struct hda_codec
 		spec->gen.mixer_nid = 0;
 		break;
 	case 0x10ec0215:
+	case 0x10ec0245:
 	case 0x10ec0285:
 	case 0x10ec0289:
 		spec->codec_variant = ALC269_TYPE_ALC215;
@@ -9363,6 +9365,7 @@ static const struct hda_device_id snd_hd
 	HDA_CODEC_ENTRY(0x10ec0234, "ALC234", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0235, "ALC233", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0236, "ALC236", patch_alc269),
+	HDA_CODEC_ENTRY(0x10ec0245, "ALC245", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0255, "ALC255", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0256, "ALC256", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0257, "ALC257", patch_alc269),


