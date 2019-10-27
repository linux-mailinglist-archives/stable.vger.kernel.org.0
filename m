Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A49E677B
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731917AbfJ0VVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731915AbfJ0VVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:21:22 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 278F9208C0;
        Sun, 27 Oct 2019 21:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211281;
        bh=Q8vUDBGLJFLxIk07CFtJ+L5M4yWGiFa+eMw6EKM12Qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0xAzLuSfqz2nnIKm5+THlE+gBiuZJwYGiSbgcvIsKJa7tFiUQUG8tHq+H0VASXHGN
         iInG+1GmD3ftwv4k4paS4Q+RTvyGijOQi+PLyv0JmwSjE7RN45+TngVEjtMaYbQFES
         xGTWfMZ3ebseTupNA/5uL/NHOG6L76PNlwENloTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.3 097/197] ALSA: hda/realtek - Add support for ALC711
Date:   Sun, 27 Oct 2019 22:00:15 +0100
Message-Id: <20191027203357.003358388@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 83629532ce45ef9df1f297b419b9ea112045685d upstream.

Support new codec ALC711.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -393,6 +393,7 @@ static void alc_fill_eapd_coef(struct hd
 	case 0x10ec0700:
 	case 0x10ec0701:
 	case 0x10ec0703:
+	case 0x10ec0711:
 		alc_update_coef_idx(codec, 0x10, 1<<15, 0);
 		break;
 	case 0x10ec0662:
@@ -7965,6 +7966,7 @@ static int patch_alc269(struct hda_codec
 	case 0x10ec0700:
 	case 0x10ec0701:
 	case 0x10ec0703:
+	case 0x10ec0711:
 		spec->codec_variant = ALC269_TYPE_ALC700;
 		spec->gen.mixer_nid = 0; /* ALC700 does not have any loopback mixer path */
 		alc_update_coef_idx(codec, 0x4a, 1 << 15, 0); /* Combo jack auto trigger control */
@@ -9105,6 +9107,7 @@ static const struct hda_device_id snd_hd
 	HDA_CODEC_ENTRY(0x10ec0700, "ALC700", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0701, "ALC701", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0703, "ALC703", patch_alc269),
+	HDA_CODEC_ENTRY(0x10ec0711, "ALC711", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0867, "ALC891", patch_alc662),
 	HDA_CODEC_ENTRY(0x10ec0880, "ALC880", patch_alc880),
 	HDA_CODEC_ENTRY(0x10ec0882, "ALC882", patch_alc882),


