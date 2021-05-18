Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A54386F1D
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 03:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhERB1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 21:27:37 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36509 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345638AbhERB1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 21:27:35 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 237EF5C0101;
        Mon, 17 May 2021 21:26:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 17 May 2021 21:26:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=Qx5EOO9JcORbUxQvF4VZ6WpeCO
        3MxZZJb0IuffeAra0=; b=ovGNGL1J9LzmVfzkucnGHZ3JkI9vriLMHMUYte9S52
        RJ1aVVE7g1tfJtKxuBE9jC+qHZsEPhqU9Vu1ddHXNeIeLv5jMXvCnMk2jk+McDrT
        EMsXm8P/Xk/gV3l6+FtdOg9IZc4TGvOYR14U6OLNGyFI9aST+AeeFBRlBOMU7upt
        egp/MVVPQm5kdtvhfbSX5xPd1QmPtk+griKSoyIHniED1K7UyUwObeleuAbIZM6H
        CKWEQkwLgCMV0mqZGL0ziCuxXUSjHEvoZZVRQCerl8oGuGk7OmHSoeieqt5a0GkC
        tHB/Awdun42vHNi3iCVx6jQ5zK09oGg+Z1m44kP1+LEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Qx5EOO9JcORbUxQvF
        4VZ6WpeCO3MxZZJb0IuffeAra0=; b=Di6b8QXTOU+YxMiUTnC1c62jpvdgwlWGD
        HgqsRkb+Kb2W1hNP1x8cWwyPoIQDfGTsMW8z5maMo+gj2hYjQ3B+3a4y7w/tj5I9
        yCm4AOE4P3Yb8Ov4xbr3FjQwMfm7BOIDLI/8psn5ncWBm4rZdk/L4+sLd+V6bjen
        0ZG2QDhCHzliLPxCkEaPd4LkH1x2ZczwVGYiJ9XzQpl8xsuwRViHHBGX3j3ENUEd
        HhGlnmLPkE5kDqJNcHLWSYoCTQEDvZbzD077n/Z+bLecyOfaI5D6moOJk6V6oqOP
        ilas+d55QFYEuK/4Slqb6dCr7JvDK2uKAITRoyVj4OA9vhKhKZrmg==
X-ME-Sender: <xms:uBejYGLNYwcshtKFymGJ4izaThHYjU-MXhxQI1nanwYF9es9vSJUrg>
    <xme:uBejYOKaUmryTh89EcsrvOhbusPNwmwEgtdKhYs5bgheqc-PDfZp176Q0PbTZ7qj6
    NjmGh_kfY3PZCvvq64>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeiiedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhh
    ihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepudejteelhfdttd
    ekgfdtueeilefhgfetjeejheekgeevuddvveegieehueeukeejnecukfhppedugedrfedr
    ieehrddujeehnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrh
    homhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:uBejYGtWCzie_nWvgGRp2txNwayxoTx7V4HHMKqCVhBC03dnwOSeBg>
    <xmx:uBejYLZZ_8Uf4mGFY5JNWctGXCg4dMKlxiNePmuRrvRIYOUt7fZ_kw>
    <xmx:uBejYNZ6XnzcjnQf2vO01t3b_nezldlDiZd2zM3Bf69j5cVXlOLm1A>
    <xmx:uBejYMylRzuj1mWHnAonotJb_go4XyxJoB-7WB8XKMbZBIPHORFmxw>
Received: from workstation.flets-east.jp (ae065175.dynamic.ppp.asahi-net.or.jp [14.3.65.175])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 21:26:14 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: dice: fix stream format for TC Electronic Konnekt Live at high sampling transfer frequency
Date:   Tue, 18 May 2021 10:26:12 +0900
Message-Id: <20210518012612.37268-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

At high sampling transfer frequency, TC Electronic Konnekt Live
transfers/receives 6 audio data frames in multi bit linear audio data
channel of data block in CIP payload. Current hard-coded stream format
is wrong.

Cc: <stable@vger.kernel.org>
Fixes: f1f0f330b1d0 ("ALSA: dice: add parameters of stream formats for models produced by TC Electronic")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/dice/dice-tcelectronic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/firewire/dice/dice-tcelectronic.c b/sound/firewire/dice/dice-tcelectronic.c
index a8875d24ba2a..43a3bcb15b3d 100644
--- a/sound/firewire/dice/dice-tcelectronic.c
+++ b/sound/firewire/dice/dice-tcelectronic.c
@@ -38,8 +38,8 @@ static const struct dice_tc_spec konnekt_24d = {
 };
 
 static const struct dice_tc_spec konnekt_live = {
-	.tx_pcm_chs = {{16, 16, 16}, {0, 0, 0} },
-	.rx_pcm_chs = {{16, 16, 16}, {0, 0, 0} },
+	.tx_pcm_chs = {{16, 16, 6}, {0, 0, 0} },
+	.rx_pcm_chs = {{16, 16, 6}, {0, 0, 0} },
 	.has_midi = true,
 };
 
-- 
2.27.0

