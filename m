Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B28381672
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 09:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhEOHMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 03:12:32 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33617 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232364AbhEOHMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 03:12:31 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id D3EA55C00BE;
        Sat, 15 May 2021 03:11:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 15 May 2021 03:11:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=5r4qNJ6Slnn2w
        YcWFM1v2Bcgl5wWb46dH9GLsqSOK5g=; b=mZUrFzC0CFIcTq4801vGgFTf1LJ2E
        c0rCfOXRaOONWhG9mqeyeuhf41nDzA5f6/NqduH92tmuZw9QSujg3CCJcAhpjhbk
        JCR/iTd29PNJyrUMIVcPget27LD4qGrkN9/94PLfHdBctW8f1rDydJgZtKO/4YDC
        S5JHKODFpkj1wznxz9AgiU5e5R5tSVb3OzlCltbRdUkpQ9rr4P56TyVasxxOBhTH
        BBoJ05AO5MOT5TnNOAX4FXf8IsI3r1i1XJRdsqfSxhf8ha6tMxWWKCa6drTWahOG
        D+wRCVslzTLYfnoU4wUhNjTzO85U5d0i4cnNei2zKF2iS0S7Y0HLFkjxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=5r4qNJ6Slnn2wYcWFM1v2Bcgl5wWb46dH9GLsqSOK5g=; b=g0pJR6V0
        CHni31HLcbo4Bf1ZmMuQcoWIznT19CIO35yjDyWpPgtvWuTeYUnkAvT1fU8XmThm
        g/GAIcuRj7LUVQTyewmUUxDi2COqDW0VJkj1oszm0QO2uxU+dzWCVXO7nFApynsZ
        J3GUHL8jKqepcPC8MwedGsSnUJ65Iv6OdrK+ubfirsCm0/tDzJBrsdFN+TIViIuD
        yP/oDI9Q+YZLE0GjEGvy9gq53MgUskBy2E32KthHLH9VvlWHegFnqxo0/IEnhAcH
        iQP/nuLuMbqrkP7K/2PiNYm6NzBLT+ljN0nUSrmVrfPwnFLB2E2Ie48WKHRQNfLZ
        w+35eFE+fpfGGQ==
X-ME-Sender: <xms:FnSfYIVZZ80sl_dLmTj1Gwk9Ry3A4-kLrT-RyEMdrtJgDdiwSBX26g>
    <xme:FnSfYMm3AHSHpDcY4GQ3uhMaLLoSgr5bq0dqzbsVEjyOpNUDbc963f-seum-zsCcr
    u-7YKNISV1ZH-G7AaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehledguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgr
    shhhihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepveefffefke
    etgfevgeefleehfffhueejtdejveethfekveektdejjedvtdejhfejnecukfhppedugedr
    fedrieehrddujeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:FnSfYMYuGbzNO9x04feFAMXSUs4pK_BFpbDFdRbgf420DH544fCxYw>
    <xmx:FnSfYHU6Ks7R9ANz9OsgUDzyhtHqtp9AxHwBAU9Pxn5qCdY9I77x-g>
    <xmx:FnSfYCnGn07Vp_flzU8VJflYQNSEzvqqknsslp1SxwsmFKTxi_QxBw>
    <xmx:FnSfYGs_AAeA9n8umL3axbXJGyKvFtnEE-b6lXA0faRklox-rD6tcg>
Received: from workstation.flets-east.jp (ae065175.dynamic.ppp.asahi-net.or.jp [14.3.65.175])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 15 May 2021 03:11:17 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH v2 01/10] Revert "ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro"
Date:   Sat, 15 May 2021 16:11:03 +0900
Message-Id: <20210515071112.101535-2-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210515071112.101535-1-o-takashi@sakamocchi.jp>
References: <20210515071112.101535-1-o-takashi@sakamocchi.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 0edabdfe89581669609eaac5f6a8d0ae6fe95e7f.

I've explained that optional FireWire card for d.2 is also built-in to
d.2 Pro, however it's wrong. The optional card uses DM1000 ASIC and has
'Mackie DJ Mixer' in its model name of configuration ROM. On the other
hand, built-in FireWire card for d.2 Pro and d.4 Pro uses OXFW971 ASIC
and has 'd.Pro' in its model name according to manuals and user
experiences. The former card is not the card for d.2 Pro. They are similar
in appearance but different internally.

Fixes: 0edabdfe8958 ("ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/Kconfig       | 4 ++--
 sound/firewire/bebob/bebob.c | 2 +-
 sound/firewire/oxfw/oxfw.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/firewire/Kconfig b/sound/firewire/Kconfig
index 9897bd26a438..def1f3d5ecf5 100644
--- a/sound/firewire/Kconfig
+++ b/sound/firewire/Kconfig
@@ -38,7 +38,7 @@ config SND_OXFW
 	   * Mackie(Loud) Onyx 1640i (former model)
 	   * Mackie(Loud) Onyx Satellite
 	   * Mackie(Loud) Tapco Link.Firewire
-	   * Mackie(Loud) d.4 pro
+	   * Mackie(Loud) d.2 pro/d.4 pro (built-in FireWire card with OXFW971 ASIC)
 	   * Mackie(Loud) U.420/U.420d
 	   * TASCAM FireOne
 	   * Stanton Controllers & Systems 1 Deck/Mixer
@@ -84,7 +84,7 @@ config SND_BEBOB
 	  * PreSonus FIREBOX/FIREPOD/FP10/Inspire1394
 	  * BridgeCo RDAudio1/Audio5
 	  * Mackie Onyx 1220/1620/1640 (FireWire I/O Card)
-	  * Mackie d.2 (FireWire Option) and d.2 Pro
+	  * Mackie d.2 (optional FireWire card with DM1000 ASIC)
 	  * Stanton FinalScratch 2 (ScratchAmp)
 	  * Tascam IF-FW/DM
 	  * Behringer XENIX UFX 1204/1604
diff --git a/sound/firewire/bebob/bebob.c b/sound/firewire/bebob/bebob.c
index daeecfa8b9aa..90e98a6d1546 100644
--- a/sound/firewire/bebob/bebob.c
+++ b/sound/firewire/bebob/bebob.c
@@ -387,7 +387,7 @@ static const struct ieee1394_device_id bebob_id_table[] = {
 	SND_BEBOB_DEV_ENTRY(VEN_BRIDGECO, 0x00010049, &spec_normal),
 	/* Mackie, Onyx 1220/1620/1640 (Firewire I/O Card) */
 	SND_BEBOB_DEV_ENTRY(VEN_MACKIE2, 0x00010065, &spec_normal),
-	// Mackie, d.2 (Firewire option card) and d.2 Pro (the card is built-in).
+	// Mackie, d.2 (optional Firewire card with DM1000).
 	SND_BEBOB_DEV_ENTRY(VEN_MACKIE1, 0x00010067, &spec_normal),
 	/* Stanton, ScratchAmp */
 	SND_BEBOB_DEV_ENTRY(VEN_STANTON, 0x00000001, &spec_normal),
diff --git a/sound/firewire/oxfw/oxfw.c b/sound/firewire/oxfw/oxfw.c
index 9eea25c46dc7..5490637d278a 100644
--- a/sound/firewire/oxfw/oxfw.c
+++ b/sound/firewire/oxfw/oxfw.c
@@ -355,7 +355,7 @@ static const struct ieee1394_device_id oxfw_id_table[] = {
 	 *  Onyx-i series (former models):	0x081216
 	 *  Mackie Onyx Satellite:		0x00200f
 	 *  Tapco LINK.firewire 4x6:		0x000460
-	 *  d.4 pro:				Unknown
+	 *  d.2 pro/d.4 pro (built-in card):	Unknown
 	 *  U.420:				Unknown
 	 *  U.420d:				Unknown
 	 */
-- 
2.27.0

