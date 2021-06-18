Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEC63AC1C0
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 06:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhFREHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 00:07:02 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36107 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229466AbhFREHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 00:07:02 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2BF685C0164;
        Fri, 18 Jun 2021 00:04:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 18 Jun 2021 00:04:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=xJDE0vGMmQognTkuv3PR5iAnF9
        qfNxOnot9Cue/GBi8=; b=wRObDCK4ruc8ZL+mUE2ZzgapYVdF9e3jsjhelM+K6M
        jppkIgmLSPCBKdgUHzm9Kcd5/mkXbNViPnLf9wZqwaiefQjT4owZUiksQe40cNrw
        XK0MRd7TByO46MjL9TLgPVhTWTg9hUovo4DULOlcHymCElPSzdaFQgZnt6NHGWN+
        sBMYMGCsXJ5SrUJveG6HSEQuFJp/YmahsPf37DC2gLBCSkWFdhPJoFsclOglxVb2
        YBpBnPeEMqYNjYji9Gom2p20XayJKiJ75daIZRNFW0QEFGzSoYaWzbJGKfCBjPOI
        +auslsJFlPyxQO1iDj+3SubGc+PQVfQt0Z6fZvIYQCGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xJDE0vGMmQognTkuv
        3PR5iAnF9qfNxOnot9Cue/GBi8=; b=Jc4gSKE0br8Y2mzlx71IKBrJdFAhExupx
        ROdh/RTwK/fh8THzerPN6oYA00SwdS64KKINB40+H07iNwXf5oMO62Lzdx+EBjjs
        1njE0gdL0/GyCeRjey1bSmVmAyNzgAaeImAX1SkG06/MUD7dWtowPmGgikX7A5/0
        X08KgyQyV2ysC9xfotP+3hLk5wxuniOz/QLO2yHiV3aXfxCGBdzW1RtHT4dX87DE
        /fE+wW6gTxXpbSf+jlCj4SLGSlxw/Q0jTuf42JJhRtmf3DprqqVMXJXlo+9h6BL8
        njFiAb/UhVyQgBy3HjaFs3syqWF+tkiIJrGlSb0/GfXYVn0k7WKJg==
X-ME-Sender: <xms:ZBvMYIuJZCIjxnJ-46nu1bDuc3xFX81vQPBXS3gLlY9vxLiYTXGzBw>
    <xme:ZBvMYFeOe5bcaTVDKdDj_T5vGop0nMXuSshJZrK7M_ROu_-M2hkK4U6fvVOfospjF
    xKixLMCTjf4nNG0edM>
X-ME-Received: <xmr:ZBvMYDwdErYVSV_2IOUHLGweedAK00KxoixpK43coTE2VFO1neqCiCh8UKlZOx9Ib1iD3Y19UD1UiXjHhKe3Uo0U1urTu8-otDhfpQmnZ7VRZSvpKUhW>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefvddgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhh
    ihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepudejteelhfdttd
    ekgfdtueeilefhgfetjeejheekgeevuddvveegieehueeukeejnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkh
    grmhhotggthhhirdhjph
X-ME-Proxy: <xmx:ZBvMYLPGLQz_bIAvUNQfOZ2ErCoTcgnPvA6T9nsnsd8E7g35W960zw>
    <xmx:ZBvMYI8wSvMNXz-yL2yb5h1dyrDBf0F8mezaDxUQLwo6hDBA4c-_1w>
    <xmx:ZBvMYDXD8YTw7WO3t4HyUnN3pfr1ISS6BgxiX9EEA59RFdVhmvswPQ>
    <xmx:ZRvMYKIgLwMklYzYesA9H-BfGD0UuZr73Ek_WFwepeRXrwfjsHFpnQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Jun 2021 00:04:50 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: bebob: fix rx packet format for Yamaha GO44/GO46, Terratec Phase 24/x24
Date:   Fri, 18 Jun 2021 13:04:47 +0900
Message-Id: <20210618040447.113306-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Below devices reports zero as the number of channels for external output
plug with MIDI type:

 * Yamaha GO44/GO46
 * Terratec Phase 24/X24

As a result, rx packet format is invalid and they generate silent sound.
This is a regression added in v5.13.

This commit fixes the bug, addressed at a commit 1bd1b3be8655 ("ALSA:
bebob: perform sequence replay for media clock recovery").

Cc: <stable@vger.kernel.org>
Fixes: 5c6ea94f2b7c ("ALSA: bebob: detect the number of available MIDI ports")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/bebob/bebob_stream.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/firewire/bebob/bebob_stream.c b/sound/firewire/bebob/bebob_stream.c
index e3e23e42add3..8629b14ded76 100644
--- a/sound/firewire/bebob/bebob_stream.c
+++ b/sound/firewire/bebob/bebob_stream.c
@@ -856,6 +856,11 @@ static int detect_midi_ports(struct snd_bebob *bebob,
 		err = avc_bridgeco_get_plug_ch_count(bebob->unit, addr, &ch_count);
 		if (err < 0)
 			break;
+		// Yamaha GO44, GO46, Terratec Phase 24, Phase x24 reports 0 for the number of
+		// channels in external output plug 3 (MIDI type) even if it has a pair of physical
+		// MIDI jacks. As a workaround, assume it as one.
+		if (ch_count == 0)
+			ch_count = 1;
 		*midi_ports += ch_count;
 	}
 
@@ -934,12 +939,12 @@ int snd_bebob_stream_discover(struct snd_bebob *bebob)
 	if (err < 0)
 		goto end;
 
-	err = detect_midi_ports(bebob, bebob->rx_stream_formations, addr, AVC_BRIDGECO_PLUG_DIR_IN,
+	err = detect_midi_ports(bebob, bebob->tx_stream_formations, addr, AVC_BRIDGECO_PLUG_DIR_IN,
 				plugs[2], &bebob->midi_input_ports);
 	if (err < 0)
 		goto end;
 
-	err = detect_midi_ports(bebob, bebob->tx_stream_formations, addr, AVC_BRIDGECO_PLUG_DIR_OUT,
+	err = detect_midi_ports(bebob, bebob->rx_stream_formations, addr, AVC_BRIDGECO_PLUG_DIR_OUT,
 				plugs[3], &bebob->midi_output_ports);
 	if (err < 0)
 		goto end;
-- 
2.30.2

