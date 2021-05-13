Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD5E37F842
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 14:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229466AbhEMM6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 08:58:11 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46799 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230153AbhEMM6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 08:58:11 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 2FA655C018D;
        Thu, 13 May 2021 08:57:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 13 May 2021 08:57:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=yl6WsJ+8WiVfG
        i4QQz4Tx8e0Pc0dhvQ1v4iJrm4iw9w=; b=VATk/n/FpUTHcvSNGrmZemRetz4pz
        RV20l6xwI7Wb+pbe13gqo+uDCxULRhMb067OuZ5jSB/usRK6JFq+HFO8CDpToN3b
        1EX3+eVW7G1W8rd7Zv6ox9pFr5MoCrNUCJ8Ec4UmqlAzXQBCWHquFjP6eyVbM71o
        fYm3QYdiyFVSxme1+aRNGraJtufchAmXthSWfDaYyPZTzsYFdGanMPVUy5WpWBsk
        mUpw5O+y+UatcvyF6sH71TTu0ocAjWGei3xFJfF+N+3pH73ZUlx/p8r1YEgUR8Em
        +LlZNsDs4N80lWpJUojX9mJLAY7JNkJklCcfkYCIk86n1c4F0BGDbxeeA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=yl6WsJ+8WiVfGi4QQz4Tx8e0Pc0dhvQ1v4iJrm4iw9w=; b=VRnmhL+U
        15bFtlTIeyW8RjHUEacDKKoJrAGu5DrKzXNNUEUpPIN2vJ+/uXhQscB/lXQ0c2Gf
        YdcaQli5TeNa0a2cOkxohGVYIMN/qRnVYBvhh4YylW9mwiY54sqXIWi2HgnjFRpN
        cVXb5fKD7Y9l+lMvIIDJE+1FpttekFArJaOFzAWOo/XCQRtpE/YTIaxVaQg/dP6r
        zWAIomWU8ZDUmhjZpOnZ5/AW9GULpHLx9FVnOMFyKOh0DW3O/x3STXHC38XbCoon
        05HGIxUv59VkM2CGNHNyi4nr6bSYypSfB+VN7LuSq3/JK5VzUk5vP80nxSHIGVsa
        RozP3kFwJ76Ncw==
X-ME-Sender: <xms:HSKdYGUOH2x2cncqheDNBojegJ6fAuhVxKOC7xBLMPRx1HuFH-f3_g>
    <xme:HSKdYCn7OROubDTtM-JIxp4wyBgU1C_EdZY_2WyqsRBNeDHgbEy4qEJddvmZdsk-9
    24OLIsh3rGzBOT-L7M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehgedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgr
    shhhihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepveefffefke
    etgfevgeefleehfffhueejtdejveethfekveektdejjedvtdejhfejnecukfhppedugedr
    fedrieehrddujeehnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilh
    hfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:HSKdYKYeg1bGSmZA4gABT-Xn6--j1p6TW7nzgYQEhy8jjaN52xHVkw>
    <xmx:HSKdYNWcSB3gX410GgI48-_6H_Wb62nqKyR5VXIQSy6KFnb2IgOTnQ>
    <xmx:HSKdYAnpcTt57rUDHIgkOkSuuqzUwu8BiD8JGczKMdBL7ZWmLehGyA>
    <xmx:HSKdYMuN5PDCfypUI96hi-irwDgQoAY95QeAafvc6VTPLMPevdiykQ>
Received: from workstation.flets-east.jp (ae065175.dynamic.ppp.asahi-net.or.jp [14.3.65.175])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 13 May 2021 08:56:59 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH 2/5] ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro
Date:   Thu, 13 May 2021 21:56:49 +0900
Message-Id: <20210513125652.110249-3-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210513125652.110249-1-o-takashi@sakamocchi.jp>
References: <20210513125652.110249-1-o-takashi@sakamocchi.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mackie d.2 has an extension card for IEEE 1394 communication, which uses
BridgeCo DM1000 ASIC. On the other hand, Mackie d.4 Pro has built-in
function for IEEE 1394 communication by Oxford Semiconductor OXFW971,
according to schematic diagram available in Mackie website. Although I
misunderstood that Mackie d.2 Pro would be also a model with OXFW971,
it's wrong. Mackie d.2 Pro is a model which includes the extension card
as factory settings.

This commit fixes entries in Kconfig and comment in ALSA OXFW driver.

Cc: <stable@vger.kernel.org>
Fixes: fd6f4b0dc167 ("ALSA: bebob: Add skelton for BeBoB based devices")
Fixes: ec4dba5053e1 ("ALSA: oxfw: Add support for Behringer/Mackie devices")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/Kconfig       | 4 ++--
 sound/firewire/bebob/bebob.c | 2 +-
 sound/firewire/oxfw/oxfw.c   | 1 -
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/firewire/Kconfig b/sound/firewire/Kconfig
index 25778765cbfe..9897bd26a438 100644
--- a/sound/firewire/Kconfig
+++ b/sound/firewire/Kconfig
@@ -38,7 +38,7 @@ config SND_OXFW
 	   * Mackie(Loud) Onyx 1640i (former model)
 	   * Mackie(Loud) Onyx Satellite
 	   * Mackie(Loud) Tapco Link.Firewire
-	   * Mackie(Loud) d.2 pro/d.4 pro
+	   * Mackie(Loud) d.4 pro
 	   * Mackie(Loud) U.420/U.420d
 	   * TASCAM FireOne
 	   * Stanton Controllers & Systems 1 Deck/Mixer
@@ -84,7 +84,7 @@ config SND_BEBOB
 	  * PreSonus FIREBOX/FIREPOD/FP10/Inspire1394
 	  * BridgeCo RDAudio1/Audio5
 	  * Mackie Onyx 1220/1620/1640 (FireWire I/O Card)
-	  * Mackie d.2 (FireWire Option)
+	  * Mackie d.2 (FireWire Option) and d.2 Pro
 	  * Stanton FinalScratch 2 (ScratchAmp)
 	  * Tascam IF-FW/DM
 	  * Behringer XENIX UFX 1204/1604
diff --git a/sound/firewire/bebob/bebob.c b/sound/firewire/bebob/bebob.c
index 2c8e3392a490..daeecfa8b9aa 100644
--- a/sound/firewire/bebob/bebob.c
+++ b/sound/firewire/bebob/bebob.c
@@ -387,7 +387,7 @@ static const struct ieee1394_device_id bebob_id_table[] = {
 	SND_BEBOB_DEV_ENTRY(VEN_BRIDGECO, 0x00010049, &spec_normal),
 	/* Mackie, Onyx 1220/1620/1640 (Firewire I/O Card) */
 	SND_BEBOB_DEV_ENTRY(VEN_MACKIE2, 0x00010065, &spec_normal),
-	/* Mackie, d.2 (Firewire Option) */
+	// Mackie, d.2 (Firewire option card) and d.2 Pro (the card is built-in).
 	SND_BEBOB_DEV_ENTRY(VEN_MACKIE1, 0x00010067, &spec_normal),
 	/* Stanton, ScratchAmp */
 	SND_BEBOB_DEV_ENTRY(VEN_STANTON, 0x00000001, &spec_normal),
diff --git a/sound/firewire/oxfw/oxfw.c b/sound/firewire/oxfw/oxfw.c
index 1f1e3236efb8..9eea25c46dc7 100644
--- a/sound/firewire/oxfw/oxfw.c
+++ b/sound/firewire/oxfw/oxfw.c
@@ -355,7 +355,6 @@ static const struct ieee1394_device_id oxfw_id_table[] = {
 	 *  Onyx-i series (former models):	0x081216
 	 *  Mackie Onyx Satellite:		0x00200f
 	 *  Tapco LINK.firewire 4x6:		0x000460
-	 *  d.2 pro:				Unknown
 	 *  d.4 pro:				Unknown
 	 *  U.420:				Unknown
 	 *  U.420d:				Unknown
-- 
2.27.0

