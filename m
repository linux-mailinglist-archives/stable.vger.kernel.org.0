Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6693A5E69
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 10:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbhFNIdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 04:33:44 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43799 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232546AbhFNIdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 04:33:43 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B49665C00D2;
        Mon, 14 Jun 2021 04:31:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 14 Jun 2021 04:31:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=5eSTmm+NAW9ROR1XOx1dA3b+IS
        DGGRiqhEv9BxcYwv0=; b=Mg+T9H7mcehoBsmp0WLEMTZnxtUzXI8e5tCMxmYbER
        uMRyjCQYpprbNouIysXTDACaTTP8dawlVSx8D2MoL2IPEuIbeA+gmgbR1FDvBXnD
        J6b3B0MFKFADP+RkKJjkPS6janVCEPoP4M7/mXDm3ALru40KS0fpPxWZ6ww60OA1
        cBOB1Ciu3ZizE1u3Yxxyk09kWyps6c0r34WwRf2b3mvkbrbMBSeCAjyvMAT4tVPw
        svW//P6M0lt9TNAAEhW43tL3WP/R/VC3otKpXNFfBbr+5mBUJ34B+Q+Jx8NEKMwW
        Ivy+vMN3brusOlg6WfY+uKgNWMBENYcuiNF1J31FjSPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5eSTmm+NAW9ROR1XO
        x1dA3b+ISDGGRiqhEv9BxcYwv0=; b=hO9II/tsPGswi49CU6rMX5xYpS0VgepIO
        VEpKtj1QBN8adimp65PAUoxNTq9h25AEi5RcHUNdvE1BbzLbcHP92KsQS6NBS1eT
        5Tjkyy26GvdvwGYxJKWcGTWaY2G3WqAKTGj9Y3kMhCvFhNTL34pDxkuMOeFiQJMh
        mod4OgsMRH+1TU/UBvqUG1coDYD9/YEeMfhx1t2L980M3dNS8zwwrCJ3mfHxAijI
        9ET4NAD7xFZRo+BSJT6kFKzvcN9+HRzVBC106NEvojXD0b/ZlR4xo4vzSiD0SDgu
        KFbmNSeOIlkEmQevSgMV+WWglSRszYsazeIzY994b9FL7tTIHlCUA==
X-ME-Sender: <xms:6RPHYHe-PhHsdiP9CUktGQzLuEUuAziibXjPCvWETtSfazDRUKDcHQ>
    <xme:6RPHYNMegMb2sdo9mWjQz7lT2F9uoaEJVMNMzL8qafq8_lf1vxXbMokplbpa_LJzH
    VIlIBBn-FDPiKvrbps>
X-ME-Received: <xmr:6RPHYAgKI_x5Y4Hz88BgKwa3xOfzH9An7SGsa6mCMtVTwHpymi2K3bw2isUSp7EWoYfglC8Xxa8OntOkdHi1epFozwFnuUYS74UW6_7HKo489KKlXu8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvhedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhh
    ihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepudejteelhfdttd
    ekgfdtueeilefhgfetjeejheekgeevuddvveegieehueeukeejnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkh
    grmhhotggthhhirdhjph
X-ME-Proxy: <xmx:6RPHYI_hMUrIXDEgGBybp0017cD97TZDYFyG72GrqgGAduCaCqMtCA>
    <xmx:6RPHYDtI-5VWmM4qjqayObiIIv65L_XO5m2eGLQe887XkzUiCpFeXw>
    <xmx:6RPHYHFfLeCIZ0S3V3R0UNAOyxi6lKg4WI0CVKlr8YGGDXjKc7Kwwg>
    <xmx:6hPHYM4BkzkO6ISQqfWPPJPcocTrNxeTOdabRG1M1GOpyqQSwq55Cw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Jun 2021 04:31:36 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: firewire-motu: fix stream format for MOTU 8pre FireWire
Date:   Mon, 14 Jun 2021 17:31:33 +0900
Message-Id: <20210614083133.39753-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My previous refactoring for ALSA firewire-motu driver brought regression
to handle MOTU 8pre FireWire. The packet format is not operated correctly.

Cc: <stable@vger.kernel.org>
Fixes: dfbaa4dc11eb ("ALSA: firewire-motu: add model-specific table of chunk count")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/motu/motu-protocol-v2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/firewire/motu/motu-protocol-v2.c b/sound/firewire/motu/motu-protocol-v2.c
index e59e69ab1538..784073aa1026 100644
--- a/sound/firewire/motu/motu-protocol-v2.c
+++ b/sound/firewire/motu/motu-protocol-v2.c
@@ -353,6 +353,7 @@ const struct snd_motu_spec snd_motu_spec_8pre = {
 	.protocol_version = SND_MOTU_PROTOCOL_V2,
 	.flags = SND_MOTU_SPEC_RX_MIDI_2ND_Q |
 		 SND_MOTU_SPEC_TX_MIDI_2ND_Q,
-	.tx_fixed_pcm_chunks = {10, 6, 0},
-	.rx_fixed_pcm_chunks = {10, 6, 0},
+	// Two dummy chunks always in the end of data block.
+	.tx_fixed_pcm_chunks = {10, 10, 0},
+	.rx_fixed_pcm_chunks = {6, 6, 0},
 };
-- 
2.30.2

