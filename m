Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E19D13A6ED
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbgANKQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:16:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730743AbgANKJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:09:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8019207FF;
        Tue, 14 Jan 2020 10:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996587;
        bh=kj5oLprT9pQG69urIPM3UZ0hDiIFQcdBiSg9DXCNPXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swo++ogz1/UjAZGRYHcZnkvP0NRnFEnPFI4ZS+9aaHf1A3vQELto12kb3z6Zokjzz
         HcTNTNINI74623lEFYEQIJBgEiHPnJOXU2F25D9mMBp1GqwRsD9N2MDwjFjYQc7jGV
         11z6mGJHmQNZEMPrIEBvY+nZsGoZhqjz7LwNTxyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 04/39] ALSA: hda/realtek - Add new codec supported for ALCS1200A
Date:   Tue, 14 Jan 2020 11:01:38 +0100
Message-Id: <20200114094338.882263254@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094336.210038037@linuxfoundation.org>
References: <20200114094336.210038037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 6d9ffcff646bbd0ede6c2a59f4cd28414ecec6e0 upstream.

Add ALCS1200A supported.
It was similar as ALC900.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/a9bd3cdaa02d4fa197623448d5c51e50@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -396,6 +396,7 @@ static void alc_fill_eapd_coef(struct hd
 		break;
 	case 0x10ec0899:
 	case 0x10ec0900:
+	case 0x10ec0b00:
 	case 0x10ec1168:
 	case 0x10ec1220:
 		alc_update_coef_idx(codec, 0x7, 1<<1, 0);
@@ -2389,6 +2390,7 @@ static int patch_alc882(struct hda_codec
 	case 0x10ec0882:
 	case 0x10ec0885:
 	case 0x10ec0900:
+	case 0x10ec0b00:
 	case 0x10ec1220:
 		break;
 	default:
@@ -8398,6 +8400,7 @@ static const struct hda_device_id snd_hd
 	HDA_CODEC_ENTRY(0x10ec0892, "ALC892", patch_alc662),
 	HDA_CODEC_ENTRY(0x10ec0899, "ALC898", patch_alc882),
 	HDA_CODEC_ENTRY(0x10ec0900, "ALC1150", patch_alc882),
+	HDA_CODEC_ENTRY(0x10ec0b00, "ALCS1200A", patch_alc882),
 	HDA_CODEC_ENTRY(0x10ec1168, "ALC1220", patch_alc882),
 	HDA_CODEC_ENTRY(0x10ec1220, "ALC1220", patch_alc882),
 	{} /* terminator */


