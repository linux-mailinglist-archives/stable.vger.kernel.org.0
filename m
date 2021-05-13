Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA7437F841
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 14:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhEMM6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 08:58:11 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34551 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229466AbhEMM6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 08:58:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 8FA905C00DA;
        Thu, 13 May 2021 08:56:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 13 May 2021 08:56:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=oqnqLSzWwArX3
        UFdvvQl06g8qMhU2lbmwvSxgSDHNd4=; b=0XW2hESeiRm31CL5g1XZ7Wvp7asut
        4Ofb58Neay0so1+969lKOtQd8uLopxFb0dppHOwDUAUQ/98wPZ6QfFcgIwHoy30w
        BnJ3eSbKiZIjoxsZn/BVk258A7AN+LJpB0JYVjCwlKlK8mmyYI0Qx1FpTUDPcAka
        SvmExRThRr4zDZwXkVcohQXKkf/iI59npaiUozymJ9/aHldaefDG7JNKjoLufaXH
        NXfqPcDcAirbEGHKXmPgizsOOgrs5bazUJPTpuE2d7PNTaCcWSUaASbNo3EmKY6t
        RxTebz/ybsa26Jv2uIhvvIDm5zFdIqbqwpYSLQu0M1j26AijDLN2O6org==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=oqnqLSzWwArX3UFdvvQl06g8qMhU2lbmwvSxgSDHNd4=; b=YO6+Bqg/
        YcQYo9OhI+Lr2xwKf+tC1iE8CEy4+1yd2aI3zi8kaUTAuaaPcaZRoZGfOeYKG6Ga
        i5pksK25roEcT8pqRIzqhRE3cEx9Vm4ILM+x6XP2ch7uZ3DA9Lju9gD/0WPFd8pa
        PIn1cvCjGGrIxFOf8RBOTuHdBfjQ/5aTCgGFs/gAz8SEoWDyP11PyMAinmzGe2g6
        0btjj6ASnvooM2QkpgpFyyMnTsAM1bwdbIvfDHclrvuHFjXYJ/GfUmFYWX5pcCpr
        n+3sCUSRoTzcVW/sPaR2+PKPYMMyjdSZeMzNAxYVf1J9u9Z4ZE2cnniObDxM0Ksd
        A7K5qpQNOhIuIw==
X-ME-Sender: <xms:GyKdYA54XIrCgWNNkySfm4DxsLqREbOGRHpLzMA4zMjjsfDOA0H14Q>
    <xme:GyKdYB7OGRa2bdTxijEnTdszx9PcvRwCTmc0ezF9y5tJ-QOz0Y179bLPc2ZgqCWvT
    aX13glcxZyKHt9lVAs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehgedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgr
    shhhihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepveefffefke
    etgfevgeefleehfffhueejtdejveethfekveektdejjedvtdejhfejnecukfhppedugedr
    fedrieehrddujeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:GyKdYPcONJcUh4itQ3-uWjCT2wrwWr6JOyISwEt-35cQwbpaAgpQvQ>
    <xmx:GyKdYFK1M2lKU9sHizzOJU85MqKubu0mRd-xPWYoLYbTUrnP7M8Zow>
    <xmx:GyKdYEKkx7_nIbWHJrAjw9_uSVnpfTQ6YlIZm2wfpyPiTaH_A4EsWw>
    <xmx:GyKdYOhYeevTL5bQkf9FEDFgB_jW5sola-LZY4jrm61De6_uOuI9Vw>
Received: from workstation.flets-east.jp (ae065175.dynamic.ppp.asahi-net.or.jp [14.3.65.175])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 13 May 2021 08:56:58 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH 1/5] ALSA: dice: fix stream format at middle sampling rate for Alesis iO 26
Date:   Thu, 13 May 2021 21:56:48 +0900
Message-Id: <20210513125652.110249-2-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210513125652.110249-1-o-takashi@sakamocchi.jp>
References: <20210513125652.110249-1-o-takashi@sakamocchi.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Alesis iO 26 FireWire has two pairs of digital optical interface. It
delivers PCM frames from the interfaces by second isochronous packet
streaming. Although both of the interfaces are available at 44.1/48.0
kHz, first one of them is only available at 88.2/96.0 kHz. It reduces
the number of PCM samples to 4 in Multi Bit Linear Audio data channel
of data blocks on the second isochronous packet streaming.

This commit fixes hardcoded stream formats.

Cc: <stable@vger.kernel.org>
Fixes: 28b208f600a3 ("ALSA: dice: add parameters of stream formats for models produced by Alesis")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/dice/dice-alesis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/firewire/dice/dice-alesis.c b/sound/firewire/dice/dice-alesis.c
index 0916864511d5..27c13b9cc9ef 100644
--- a/sound/firewire/dice/dice-alesis.c
+++ b/sound/firewire/dice/dice-alesis.c
@@ -16,7 +16,7 @@ alesis_io14_tx_pcm_chs[MAX_STREAMS][SND_DICE_RATE_MODE_COUNT] = {
 static const unsigned int
 alesis_io26_tx_pcm_chs[MAX_STREAMS][SND_DICE_RATE_MODE_COUNT] = {
 	{10, 10, 4},	/* Tx0 = Analog + S/PDIF. */
-	{16, 8, 0},	/* Tx1 = ADAT1 + ADAT2. */
+	{16, 4, 0},	/* Tx1 = ADAT1 + ADAT2 (available at low rate). */
 };
 
 int snd_dice_detect_alesis_formats(struct snd_dice *dice)
-- 
2.27.0

