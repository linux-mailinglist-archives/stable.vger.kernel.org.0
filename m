Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09724138D26
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 09:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgAMIqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 03:46:37 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57077 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727331AbgAMIqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 03:46:36 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id BC04021EE9;
        Mon, 13 Jan 2020 03:46:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 13 Jan 2020 03:46:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=rhuVkKtv5umrP
        EeEXUwkoXh28X3nBK7ZAdb/LzUkY+w=; b=NY0tLvHkIFB737ZP7E1v5mFdboHu/
        FojrK5ciPW69c4Fvvu6vhE5m/bZS6gIhpdtEt+V9olyo5JC+KTGj3/JVXNHUJg00
        +TjkSZYYN0FkDheCanqSx9KGAUvheefvtXgBrNHHZK9VECmfQMgZm8G1sxCkQZ73
        eg1DA7xaT8jKTeCUbpNRjhYwo+/4xdLCU5dWWKM6KGE6hitGCkfp5eFAcVXy9r80
        0rleOcxyTi6u8NHTVtRmpYHPBluQhsj8J/CGWiKjZRbWpLXyn9Q+SUg4SH68Y+Dy
        f8A9u8cKi2DuXHOGM7jhDxtX3Ej+LoOtac46/HVuMUUq2zJAyuUIUQdMg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=rhuVkKtv5umrPEeEXUwkoXh28X3nBK7ZAdb/LzUkY+w=; b=CBsSJfk2
        afPbLWsVLtu/IApiXEZ83rVB6Il4ysK6A0tDWJFDTNrNp9URfOpSyFw0shOoM2OD
        sbmmASedIVCB6Qv+OsJehudV+GwuzB1yQFZQpb6yKfHWtPo9RIEbiOVTxbC0AIAE
        b0LKRCESKjBloOjlsM+DVQWvjVww4adxA3lYxZhx2lzqoRdaN9QIZ5RrC+aKH+zM
        5IGDxaA55DkNks/BsyQRVF8QOdgVmiUIVZzF6Xtm7XvXxkRs1QBuzuJdDYDQX/DQ
        w1zpMnsOq+ea81SoUQahZLVBFZCVuOkVVdbTAWMUjD6W89lxQjL792q5i1+Wzfzy
        5b1kMY4kaha2Pw==
X-ME-Sender: <xms:ay4cXtTSFx-631veqB2pMiN2L-TPEZw-PYNW9OuRCzr6lrorDsqTEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeiledguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefvrghkrghshhhiucfurghkrghmohhtohcuoehoqdhtrghk
    rghshhhisehsrghkrghmohgttghhihdrjhhpqeenucfkphepudegrdefrdejhedrudekud
    enucfrrghrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggt
    hhhirdhjphenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:ay4cXuST9o-iTJON0YBR2H4ckc3ZkpGVPOUbpey93Xn_Ft_d_rM-qQ>
    <xmx:ay4cXo7mr2wUbFNPprUU3dq3bhdN3kyLvUWfGg8YJfCVrRiZGvEFqw>
    <xmx:ay4cXjHIoU4fncTDW7Vu81ibZRnMYSZ-GjF6vLJYCz4nG5DTYay_SA>
    <xmx:ay4cXg-MXFlYA-rJpTpY8kSChInfY6IpQ-OLByKJHp1-7qn1gjy47g>
Received: from workstation.flets-east.jp (ae075181.dynamic.ppp.asahi-net.or.jp [14.3.75.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9DE5530607B4;
        Mon, 13 Jan 2020 03:46:34 -0500 (EST)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: [PATCH 1/3] dice: fix fallback from protocol extension into limited functionality
Date:   Mon, 13 Jan 2020 17:46:28 +0900
Message-Id: <20200113084630.14305-2-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200113084630.14305-1-o-takashi@sakamocchi.jp>
References: <20200113084630.14305-1-o-takashi@sakamocchi.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

At failure of attempt to detect protocol extension, ALSA dice driver
should be fallback to limited functionality. However it's not.

This commit fixes it.

Cc: <stable@vger.kernel.org> # v4.18+
Fixes: 58579c056c1c9 ("ALSA: dice: use extended protocol to detect available stream formats")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/dice/dice-extension.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/firewire/dice/dice-extension.c b/sound/firewire/dice/dice-extension.c
index a63fcbc875ad..02f4a8318e38 100644
--- a/sound/firewire/dice/dice-extension.c
+++ b/sound/firewire/dice/dice-extension.c
@@ -159,8 +159,11 @@ int snd_dice_detect_extension_formats(struct snd_dice *dice)
 		int j;
 
 		for (j = i + 1; j < 9; ++j) {
-			if (pointers[i * 2] == pointers[j * 2])
+			if (pointers[i * 2] == pointers[j * 2]) {
+				// Fallback to limited functionality.
+				err = -ENXIO;
 				goto end;
+			}
 		}
 	}
 
-- 
2.20.1

