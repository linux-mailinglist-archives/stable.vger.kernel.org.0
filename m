Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554C6411359
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 13:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhITLJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 07:09:07 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56771 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232382AbhITLJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 07:09:06 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 076615C0048;
        Mon, 20 Sep 2021 07:07:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 20 Sep 2021 07:07:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=1MCndy9cLnlMIcCifBnqzwJc/+
        Zfm3QLxX/qfshnxIM=; b=giIS6sDgRzSwSn+8t9vSyp8FA8blvOcarGEp41GDea
        XOLUI3hsP0s6mIRKJDlqB0f1Tt04RjEZ7UcHnQcT8p1HMTlzPKwnxUZCucXTZqj2
        ILAt+LOBBUrD1xTngkTnmClXReSKinylePKK9GXOC0kFDqOWkkW097bMcY9XzBIo
        XgvGqLzivMFGlZR860eDWb9r0AouLgeKKwCrPC/0uh6vbRKNW7aMwmjwW9Bx8Nbg
        k3XfB6ndPAlqaXvEEPI4wjSEKZoP8B+YLvE9sicfreSmunDdyAQCGibos6YR1Onj
        WvTAUbxpOxNP/+hd0QGwToIX63OzPmD5LMagxSBC9zWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1MCndy9cLnlMIcCif
        BnqzwJc/+Zfm3QLxX/qfshnxIM=; b=NFpRM1F1ztT+Hv6+pKC4XEP2TEkhPdpqN
        vBusmnHVP+qj2l9bb3cRZFspHcKxSeJRXDXnsPQM3BDKgyzCdedeVGpmZ0El0JGu
        CXiVQG+5qkPN86wZ6SCOY8x4tyCPwWwEGNaIxXNe50vjltgAFrGLH3yFgZjqD6j/
        nfxUSneRqfAhoHJyXXk1pV4QrRBOFRe/rLi1Sqalu3mqAbuuV3n8EkdhN1Tk2mcO
        ItU1n29AwV9KVJP/aOYycHvx94nOXfCwFnZnUeUZzpec5lM6tmcg9S5M9NH+jAFv
        HIt5chMAbQopMwLwoRfZdFk4OBC/6waP5cCDWM0FcT9fbSEnfJXAA==
X-ME-Sender: <xms:e2tIYVvDmFINcuJiFK2d_MRyk0XC2Lx8iuxgSyfl7ZZ4A1iXch1CUw>
    <xme:e2tIYecLabQswtpiWAoEUeRLX5qEy5QLRl2rTuJnNBqNl35czPzl-7-fkfnLGZ-0E
    xZGXP6cf_e2wwcBj70>
X-ME-Received: <xmr:e2tIYYzzv3OwSkch2C1p7gC-0CAUD2to6WsgJQI2fvVx37UdWwN2Fkx8j6CFPdxFbJrNtzGPxnHERfTyslyRG_wKRgFhZo5m09c-H0yrlw6InYwtcJ55>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeivddgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhh
    ihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepudejteelhfdttd
    ekgfdtueeilefhgfetjeejheekgeevuddvveegieehueeukeejnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkh
    grmhhotggthhhirdhjph
X-ME-Proxy: <xmx:e2tIYcPmfe_Bww4c149BsVcW6oDPm6Mb1MZnP8VUBFgAnpAZE5W-Nw>
    <xmx:e2tIYV839ie9qBygWjakTWzEUgu90N9k40C65cFW1TNFbkny788zDg>
    <xmx:e2tIYcWJDyi_YJAFMo2ccN5TQZjjjXqietw9jgw9aqG5tGJxj4TpYA>
    <xmx:fGtIYXIxp9H9wO4Ldz6JEAjqXRTVDA5_7DDyCbsSLC0zHOJEgskEnA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Sep 2021 07:07:37 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: firewire-motu: fix truncated bytes in message tracepoints
Date:   Mon, 20 Sep 2021 20:07:34 +0900
Message-Id: <20210920110734.27161-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In MOTU protocol v2/v3, first two data chunks across 2nd and 3rd data
channels includes message bytes from device. The total size of message
is 48 bits per data block.

The 'data_block_message' tracepoints event produced by ALSA firewire-motu
driver exposes the sequence of messages to userspace in 64 bit storage,
however lower 32 bits are actually available since current implementation
truncates 16 bits in upper of the message as a result of bit shift
operation within 32 bit storage.

This commit fixes the bug by perform the bit shift in 64 bit storage.

Fixes: c6b0b9e65f09 ("ALSA: firewire-motu: add tracepoints for messages for unique protocol")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/motu/amdtp-motu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/firewire/motu/amdtp-motu.c b/sound/firewire/motu/amdtp-motu.c
index 5388b85fb60e..a18c2c033e83 100644
--- a/sound/firewire/motu/amdtp-motu.c
+++ b/sound/firewire/motu/amdtp-motu.c
@@ -276,10 +276,11 @@ static void __maybe_unused copy_message(u64 *frames, __be32 *buffer,
 
 	/* This is just for v2/v3 protocol. */
 	for (i = 0; i < data_blocks; ++i) {
-		*frames = (be32_to_cpu(buffer[1]) << 16) |
-			  (be32_to_cpu(buffer[2]) >> 16);
+		*frames = be32_to_cpu(buffer[1]);
+		*frames <<= 16;
+		*frames |= be32_to_cpu(buffer[2]) >> 16;
+		++frames;
 		buffer += data_block_quadlets;
-		frames++;
 	}
 }
 
-- 
2.30.2

