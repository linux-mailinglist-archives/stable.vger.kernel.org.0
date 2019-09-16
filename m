Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09933B37E7
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 12:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbfIPKS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 06:18:59 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59033 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725853AbfIPKS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 06:18:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 99E3521F14;
        Mon, 16 Sep 2019 06:18:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 16 Sep 2019 06:18:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=/bWvUivzmNG8RHNsplCy4y5Ys0
        ybNPBibO9YcJrASks=; b=Ru72na0ewJiquIrxWYQoknjIktLmPJ6zOEOuUiyn9z
        T9XZekqwpXiS4VqX2+LpZL75RtdxHwNCe3K+HhATOP1JN8kpS4L4rNdDLDLzSGia
        tV1u4jKg3HWwF/cu6vxyIgn+33/dhGHRAe5pvUvQEaTk5GvPhUurZr3QJmwX4kDq
        y4DNxfL+Ks+SN8fd/fPF8g/y3JbxDaWzG3PaxMp+aja5HrKtdI/eQ9qt5Zh8newY
        RgRMOoKv8NCliM1CjbRFBuVYMvoTJUIc0q+2FkmfkQY7Tc5sWTFb0WImM0xQR1Q/
        G73RKxKkOfTYOurnrAKKXfOk/a7vpU5W4UPNqhJaY/mQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/bWvUivzmNG8RHNsp
        lCy4y5Ys0ybNPBibO9YcJrASks=; b=WV2IjC7U78hbpTaGx5p6TRU83hHjXVntb
        BXSsWlFA0L1lHaKErvjP+X/oh6WvXVNgAkdwwS4e+ITIfQ9x2VRFGyVxE9ywWJm5
        eIOZ/fcCdQhy3KayCsZ6pGIqgKMA1mCd4gL44YyLy2nccA58M7vmzaIlH3sYPPNX
        o78o/kAFHtqYXNEh47fbjZHfryvsQ2fF2c+efqBuWnnYu2R9RY9be6qtzCWO/Jk6
        r0w9i2oOEHVqpl2yRIHz3eRBT865wVQh7jQ04GAhb3MG+6TPSLBD5HriH1TP43/2
        nRf3BxY3a6zDMRYMDenRDI36tCYi7vvDVz8JVrMA/jbDR6+NJv2uQ==
X-ME-Sender: <xms:kGF_XbAJmwDS8eTPrT04ABBchlpV5xUv2XcHtUVYV1oSluvCG8MrAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudefgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefvrghkrghshhhiucfurghkrghmohhtohcuoehoqdhtrghkrghshhhi
    sehsrghkrghmohgttghhihdrjhhpqeenucfkphepudegrdefrdejhedrudekudenucfrrg
    hrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhj
    phenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:kGF_XcdeJ6rD8BJjN6hxfXEbyRwgEclkxGVDg_l2Vpgas0NBTHd8hw>
    <xmx:kGF_XVmbZtG85YB9fEYiAzLRvzV-RljErHDEefAxxfEJ-TkkQbqblg>
    <xmx:kGF_XTEfHLsn4TSaI2w_25nDpnlXXaRN5bxBXrXzId2kDP11U_TZCw>
    <xmx:kWF_XfVGqL7yWwxfW-gVaimSQ3OUfD4D0t1mgj6binsb6JfMgGzUVQ>
Received: from workstation.flets-east.jp (ae075181.dynamic.ppp.asahi-net.or.jp [14.3.75.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 32D9DD60067;
        Mon, 16 Sep 2019 06:18:54 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     clemens@ladisch.de, tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: [PATCH] ALSA: dice: fix wrong packet parameter for Alesis iO26
Date:   Mon, 16 Sep 2019 19:18:51 +0900
Message-Id: <20190916101851.30409-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

At higher sampling rate (e.g. 192.0 kHz), Alesis iO26 transfers 4 data
channels per data block in CIP.

Both iO14 and iO26 have the same contents in their configuration ROM.
For this reason, ALSA Dice driver attempts to distinguish them according
to the value of TX0_AUDIO register at probe callback. Although the way is
valid at lower and middle sampling rate, it's lastly invalid at higher
sampling rate because because the two models returns the same value for
read transaction to the register.

In the most cases, users just plug-in the device and ALSA dice driver
detects it. In the case, the device runs at lower sampling rate and
the driver detects expectedly. For this reason, this commit leaves the
way to detect as is.

Fixes: 28b208f600a3 ("ALSA: dice: add parameters of stream formats for models produced by Alesis")
Cc: <stable@vger.kernel.org> # v4.18+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/dice/dice-alesis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/firewire/dice/dice-alesis.c b/sound/firewire/dice/dice-alesis.c
index 218292bdace6..f5b325263b67 100644
--- a/sound/firewire/dice/dice-alesis.c
+++ b/sound/firewire/dice/dice-alesis.c
@@ -15,7 +15,7 @@ alesis_io14_tx_pcm_chs[MAX_STREAMS][SND_DICE_RATE_MODE_COUNT] = {
 
 static const unsigned int
 alesis_io26_tx_pcm_chs[MAX_STREAMS][SND_DICE_RATE_MODE_COUNT] = {
-	{10, 10, 8},	/* Tx0 = Analog + S/PDIF. */
+	{10, 10, 4},	/* Tx0 = Analog + S/PDIF. */
 	{16, 8, 0},	/* Tx1 = ADAT1 + ADAT2. */
 };
 
-- 
2.20.1

