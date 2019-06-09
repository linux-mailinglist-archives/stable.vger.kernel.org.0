Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8F5D3A4AE
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 12:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfFIK3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 06:29:19 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51393 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727039AbfFIK3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 06:29:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5425621E3E;
        Sun,  9 Jun 2019 06:29:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 09 Jun 2019 06:29:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=QLRpEhb6FyE9oJCXalev4ADuAG
        sI7bOmvY4IuabcQxQ=; b=n5DKxvFbq+rS0JSvFx89N7e7inTkqGVBeineJFMfFs
        KNm7aXe5V7lo+OJYSzgZ1b3slHz2rUrk0eL1jWudTflrPoWVXqcJZzPwiFgNxCRW
        lczWhNAC/+5tpumaEeYYogVCkz3n0kwwgFa03tCTbX/sXw5X0GAY8wLXl5Et38Gk
        8/us/B/Lj0nYUzn/YXQ71Hmb7oYAy0YwbgPSphkulDzzd1HZ+bzy/tpAi/7F4Rf8
        MUZ9s6Zo3RA7T5iVWoQTeFg5wh53kk31oufRhISEYQB525hZHt2AylNTGM/DznNO
        D57Q6yn46RmK8e/7cC33eiaYUsiy9o0P8P1MusTST5Vw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QLRpEhb6FyE9oJCXa
        lev4ADuAGsI7bOmvY4IuabcQxQ=; b=wU98CDIEjKQYfpi6JXcgeSh/LYacz5KNR
        BtxB7xoDumvIFSQQ/U5RSxP2k1qxKlGlNrIB/UJR+vatm9PkzlbOnSGC6SUwpLC3
        +SwF/fKkDUAbs2i92EqGnD1KhgebarlJnY4x6yJ3W8Ab0zU089/c0qCY/yjIj17A
        0nkYeJ32fROHewXXH3qX9+RhU08cq+0CxMj5EXf8IhzkfMnNW4Bv1lBlQtkGWqgp
        0Pu56geORCtZgpaU/GpeS/Ru11ebZg3puD+hblZQG0UCsBWJTH3XarJUZk950Wlm
        U/DKfyc8t4kgQOBP2/Ar34QjUtQPF32/J8XFxEPjluN9TSYMvscGQ==
X-ME-Sender: <xms:fN_8XHGsIGlYi3_nIxbFWv4M3jkWPHMbV9qDru44wwDf27KfRRk6EQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhh
    ihesshgrkhgrmhhotggthhhirdhjpheqnecukfhppedugedrfedrjeehrddukedunecurf
    grrhgrmhepmhgrihhlfhhrohhmpehoqdhtrghkrghshhhisehsrghkrghmohgttghhihdr
    jhhpnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:fN_8XInnJ7Ui1OBVWKU7zRO97JxiDaSMxOA00ghVipaT-FOifhcf0g>
    <xmx:fN_8XEKY-f3YgQLvgwpZNrN3yUFXFftK0FckjCmOUayhlF6P9aor4A>
    <xmx:fN_8XJYp6Anvkv-7yTeqHI0onk4Ttu1BWgj6g2PDQsftL0bHpPX2zQ>
    <xmx:ft_8XD3Q70lGEN7ZmHFZJQOdWzLyCLf4Nr9IaB70_1Mvd4Kl2BfpLw>
Received: from localhost.localdomain (ae075181.dynamic.ppp.asahi-net.or.jp [14.3.75.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5C0A780065;
        Sun,  9 Jun 2019 06:29:15 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     clemens@ladisch.de, tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: [PATCH] ALSA: oxfw: allow PCM capture for Stanton SCS.1m
Date:   Sun,  9 Jun 2019 19:29:12 +0900
Message-Id: <20190609102912.9717-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stanton SCS.1m can transfer isochronous packet with Multi Bit Linear
Audio data channels, therefore it allows software to capture PCM
substream. However, ALSA oxfw driver doesn't.

This commit changes the driver to add one PCM substream for capture
direction.

Fixes: de5126cc3c0b ("ALSA: oxfw: add stream format quirk for SCS.1 models")
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/oxfw/oxfw.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/firewire/oxfw/oxfw.c b/sound/firewire/oxfw/oxfw.c
index 3d27f3378d5d..b4bef574929d 100644
--- a/sound/firewire/oxfw/oxfw.c
+++ b/sound/firewire/oxfw/oxfw.c
@@ -148,9 +148,6 @@ static int detect_quirks(struct snd_oxfw *oxfw)
 		oxfw->midi_input_ports = 0;
 		oxfw->midi_output_ports = 0;
 
-		/* Output stream exists but no data channels are useful. */
-		oxfw->has_output = false;
-
 		return snd_oxfw_scs1x_add(oxfw);
 	}
 
-- 
2.20.1

