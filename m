Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13751116D14
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 13:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfLIMYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 07:24:50 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:33737 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727232AbfLIMYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 07:24:50 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id EE450AC7;
        Mon,  9 Dec 2019 07:24:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 09 Dec 2019 07:24:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dYsceR
        2HlHrBihzHAtFgVF5gwmFt1ZUxrns0OFpw2PM=; b=GrkYjP8UikRl0Udq+OGwSB
        CBGymEzq09zWnqrNu/ox0tJsF3J+O9p6P+9ij7yoOspxMqH76zOmQPBzgEk4NvLS
        7/SOPNsJPUfTEd1ZiwHvC/h7iMOYsTr78abLEdBdvLkmRyMl9OL8SI6y82UmgNlv
        f82oZOGOn09BVG0YN8K41YgiXFSzXDIBeW31qXnZH26aLNdmsFr9x09ckKE4wgTV
        aH+RzGuLPsf27Rzi7Z4GooHLFmYa5hYRVKE8PM8hsGfKkQka/IgxEFoUbbGNMqwZ
        GKr1IAqk9FW6+ArI0jehaEoBvD5Y9l9AhNVRuGiOL9sEG2sFRFjX11S3rHGbeRyw
        ==
X-ME-Sender: <xms:ED3uXdEOY4NA1VNC3Gjmvvw06TN3VCOEW00647cJM9Adismp_MhOEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeltddggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:ED3uXQJyldv7IG1oNBCFz2t1FO4Ka3nbxbqeiiOaw3D2gSBxlBUSPg>
    <xmx:ED3uXQDWybmtHHddzQolv4U685pr6MlD8g_AgaPpUK5B-ltL1KQIWQ>
    <xmx:ED3uXeAkDBAnlnOltKRrTHqp7pcGQw5oKiYuXZ_yGWYWO-VWffLWVQ>
    <xmx:ED3uXRxbloO1tcryll9b0QarXGaZxZr16Ntljh-GDVEfun4DnaNSIA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1BE7E8005B;
        Mon,  9 Dec 2019 07:24:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek - Dell headphone has noise on unmute for" failed to apply to 4.9-stable tree
To:     kailang@realtek.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Dec 2019 13:24:38 +0100
Message-ID: <1575894278206142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e1e8c1fdce8b00fce08784d9d738c60ebf598ebc Mon Sep 17 00:00:00 2001
From: Kailang Yang <kailang@realtek.com>
Date: Tue, 26 Nov 2019 17:04:23 +0800
Subject: [PATCH] ALSA: hda/realtek - Dell headphone has noise on unmute for
 ALC236

headphone have noise even the volume is very small.
Let it fill up pcbeep hidden register to default value.
The issue was gone.

Fixes: 4344aec84bd8 ("ALSA: hda/realtek - New codec support for ALC256")
Fixes: 736f20a70608 ("ALSA: hda/realtek - Add support for ALC236/ALC3204")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/9ae47f23a64d4e41a9c81e263cd8a250@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d2bf70a1d2fd..9f355b2f7d7b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -367,9 +367,7 @@ static void alc_fill_eapd_coef(struct hda_codec *codec)
 	case 0x10ec0215:
 	case 0x10ec0233:
 	case 0x10ec0235:
-	case 0x10ec0236:
 	case 0x10ec0255:
-	case 0x10ec0256:
 	case 0x10ec0257:
 	case 0x10ec0282:
 	case 0x10ec0283:
@@ -381,6 +379,11 @@ static void alc_fill_eapd_coef(struct hda_codec *codec)
 	case 0x10ec0300:
 		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
 		break;
+	case 0x10ec0236:
+	case 0x10ec0256:
+		alc_write_coef_idx(codec, 0x36, 0x5757);
+		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
+		break;
 	case 0x10ec0275:
 		alc_update_coef_idx(codec, 0xe, 0, 1<<0);
 		break;

