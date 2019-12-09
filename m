Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34C61116D13
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 13:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbfLIMYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 07:24:42 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:52659 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727232AbfLIMYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 07:24:42 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 73754AD5;
        Mon,  9 Dec 2019 07:24:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 09 Dec 2019 07:24:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zihwKM
        4mgPrHxBkXpM0IG1YUA40fgKJXUQgyeE0oEJs=; b=qN0NmpRzHHFdvwBf+pF6yf
        U49UbYqWjk39zPbQ35rL+nEn8S3dQWWOHpkxroylBEvmLLJm70s5d4iJpDoHyXYh
        jBPjISfEXTi+ERcZEgFL5f1QH8+9xF/Ywryxj9gmrFfdNUczTUtp/kfIlz6Qlsmm
        5fBVyrM1D+s7rmY5wBLMHa7zwyid09rfnzfB94EmrXlkGzHIYTA3B/Ze+4IbsDKg
        E8rQJjOFEi4AXTzwv21mc9VA3JyT1kez94fyrCwMhT4gX+ZfFBrjfMWTB7JsOu5M
        xR3cAOVseMqSHdMG5pHZmmh84uaJunjNBmPEtCmCs4m8sY13cMqSx0veO/+Hm3iw
        ==
X-ME-Sender: <xms:CD3uXQKvaKsABSdrCmn9QsLbzFcJCISgih1r4LZGqebezQrAa-hF8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeltddggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:CD3uXXSBxY00Cz3m6sIZ9CGijWYC1NhHD9U8-P2ragSnMfc6dI1WNA>
    <xmx:CD3uXTHTMK5T3Pysynkoy2dGz-kzXvGZRfQH9yYzB6wv-586TLVCXw>
    <xmx:CD3uXXHcE_VoSy3w3sap_Fu63r22RioAWLd62b9tTNW_HnzBGpwsAw>
    <xmx:CT3uXR20DBTNwNnMecNn9RMKL_4aK_Zec4hebpVYSCruJb1dS5HC7A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 24D088005B;
        Mon,  9 Dec 2019 07:24:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek - Dell headphone has noise on unmute for" failed to apply to 4.4-stable tree
To:     kailang@realtek.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Dec 2019 13:24:38 +0100
Message-ID: <15758942788852@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

