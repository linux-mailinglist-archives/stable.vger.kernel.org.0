Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891962D626F
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390790AbgLJOhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:37:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391064AbgLJOhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:37:09 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.9 14/75] ALSA: hda/realtek - Add new codec supported for ALC897
Date:   Thu, 10 Dec 2020 15:26:39 +0100
Message-Id: <20201210142606.774731247@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit e5782a5d5054bf1e03cb7fbd87035037c2a22698 upstream.

Enable new codec supported for ALC897.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/3b00520f304842aab8291eb8d9191bd8@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -445,6 +445,7 @@ static void alc_fill_eapd_coef(struct hd
 			alc_update_coef_idx(codec, 0x7, 1<<5, 0);
 		break;
 	case 0x10ec0892:
+	case 0x10ec0897:
 		alc_update_coef_idx(codec, 0x7, 1<<5, 0);
 		break;
 	case 0x10ec0899:
@@ -10189,6 +10190,7 @@ static const struct hda_device_id snd_hd
 	HDA_CODEC_ENTRY(0x10ec0888, "ALC888", patch_alc882),
 	HDA_CODEC_ENTRY(0x10ec0889, "ALC889", patch_alc882),
 	HDA_CODEC_ENTRY(0x10ec0892, "ALC892", patch_alc662),
+	HDA_CODEC_ENTRY(0x10ec0897, "ALC897", patch_alc662),
 	HDA_CODEC_ENTRY(0x10ec0899, "ALC898", patch_alc882),
 	HDA_CODEC_ENTRY(0x10ec0900, "ALC1150", patch_alc882),
 	HDA_CODEC_ENTRY(0x10ec0b00, "ALCS1200A", patch_alc882),


