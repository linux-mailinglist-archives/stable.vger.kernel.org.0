Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BAB38E2D8
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 10:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhEXJAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 05:00:47 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:41223 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232313AbhEXJAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 05:00:47 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 765231940191;
        Mon, 24 May 2021 04:59:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 24 May 2021 04:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=96cpoI
        GVLVIz6LovrpHOHLVx9HHUT865kLUDnRs3c10=; b=I4MDo9wxZFzbkOcIlASUOr
        uWjswd/3EUCqItugsfl8mm0anciDL6qCTYJumsYGu0GGlIbHT40+3T9xoC6H6lz6
        Ch9ox89EjoRe8Y0JX2QA8OBxzt0HidGtsBR6ws1vzAYim8KWVv0Chb9Sx1xC1MBZ
        gb0hcy7hfxJoCiv1ZiAPYXTqQQum1MacPgYX9L+8De/hQTdYRq+wt0R5DYk9JGyC
        14xIqRv6bwABcsjG6JN7aUR7gF2bOtWdfatyGY4PPxTyH/skhSEFzoYnvkk5+DDJ
        2pT8UUKS5JPGzH0GQeiXn0JZWZvdmSbyABlgCa3NWJnyQ/i46jra3GvROjOi9zGQ
        ==
X-ME-Sender: <xms:52qrYHDMalQ72_OMOER1x_KEz7usaUygVL14sC89fPrKc-2DYxLaxQ>
    <xme:52qrYNjHW8TS97-CbJegKI4pjc3ztSCvYVIVp8l0eP8QW7RQf4-9y-6tx0jYVJRSD
    W86dfnP9VNNZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:52qrYCl_IJMCtQq9tRy_xpgBIe_BLP_o9TjvE-LFqt5mv8NbKUCF-A>
    <xmx:52qrYJxmxONldvxKi8jHGxjOnTpNzbmgzio9SFKGD5hh2p3qtriJJw>
    <xmx:52qrYMSc44od58csEOLPOaXaVMH2zIKd0X8rzlxDpltcFW041VweHQ>
    <xmx:52qrYHIp7yukqQIHLL8wStXNzn3CxxN5hUJnIdMD7T3kMxrilbtraw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 04:59:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: firewire-lib: fix amdtp_packet tracepoints event for" failed to apply to 5.4-stable tree
To:     o-takashi@sakamocchi.jp, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 May 2021 10:59:15 +0200
Message-ID: <162184675587154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 814b43127f4ac69332e809152e30773941438aff Mon Sep 17 00:00:00 2001
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Date: Thu, 13 May 2021 21:56:52 +0900
Subject: [PATCH] ALSA: firewire-lib: fix amdtp_packet tracepoints event for
 packet_index field

The snd_firewire_lib:amdtp_packet tracepoints event includes index of
packet processed in a context handling. However in IR context, it is not
calculated as expected.

Cc: <stable@vger.kernel.org>
Fixes: 753e717986c2 ("ALSA: firewire-lib: use packet descriptor for IR context")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210513125652.110249-6-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/firewire/amdtp-stream-trace.h b/sound/firewire/amdtp-stream-trace.h
index 26e7cb555d3c..aa53c13b89d3 100644
--- a/sound/firewire/amdtp-stream-trace.h
+++ b/sound/firewire/amdtp-stream-trace.h
@@ -14,8 +14,8 @@
 #include <linux/tracepoint.h>
 
 TRACE_EVENT(amdtp_packet,
-	TP_PROTO(const struct amdtp_stream *s, u32 cycles, const __be32 *cip_header, unsigned int payload_length, unsigned int data_blocks, unsigned int data_block_counter, unsigned int index),
-	TP_ARGS(s, cycles, cip_header, payload_length, data_blocks, data_block_counter, index),
+	TP_PROTO(const struct amdtp_stream *s, u32 cycles, const __be32 *cip_header, unsigned int payload_length, unsigned int data_blocks, unsigned int data_block_counter, unsigned int packet_index, unsigned int index),
+	TP_ARGS(s, cycles, cip_header, payload_length, data_blocks, data_block_counter, packet_index, index),
 	TP_STRUCT__entry(
 		__field(unsigned int, second)
 		__field(unsigned int, cycle)
@@ -48,7 +48,7 @@ TRACE_EVENT(amdtp_packet,
 		__entry->payload_quadlets = payload_length / sizeof(__be32);
 		__entry->data_blocks = data_blocks;
 		__entry->data_block_counter = data_block_counter,
-		__entry->packet_index = s->packet_index;
+		__entry->packet_index = packet_index;
 		__entry->irq = !!in_interrupt();
 		__entry->index = index;
 	),
diff --git a/sound/firewire/amdtp-stream.c b/sound/firewire/amdtp-stream.c
index 73aff017dc9a..e0faa6601966 100644
--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -526,7 +526,7 @@ static void build_it_pkt_header(struct amdtp_stream *s, unsigned int cycle,
 	}
 
 	trace_amdtp_packet(s, cycle, cip_header, payload_length, data_blocks,
-			   data_block_counter, index);
+			   data_block_counter, s->packet_index, index);
 }
 
 static int check_cip_header(struct amdtp_stream *s, const __be32 *buf,
@@ -630,7 +630,7 @@ static int parse_ir_ctx_header(struct amdtp_stream *s, unsigned int cycle,
 			       unsigned int *payload_length,
 			       unsigned int *data_blocks,
 			       unsigned int *data_block_counter,
-			       unsigned int *syt, unsigned int index)
+			       unsigned int *syt, unsigned int packet_index, unsigned int index)
 {
 	const __be32 *cip_header;
 	unsigned int cip_header_size;
@@ -668,7 +668,7 @@ static int parse_ir_ctx_header(struct amdtp_stream *s, unsigned int cycle,
 	}
 
 	trace_amdtp_packet(s, cycle, cip_header, *payload_length, *data_blocks,
-			   *data_block_counter, index);
+			   *data_block_counter, packet_index, index);
 
 	return err;
 }
@@ -707,12 +707,13 @@ static int generate_device_pkt_descs(struct amdtp_stream *s,
 				     unsigned int packets)
 {
 	unsigned int dbc = s->data_block_counter;
+	unsigned int packet_index = s->packet_index;
+	unsigned int queue_size = s->queue_size;
 	int i;
 	int err;
 
 	for (i = 0; i < packets; ++i) {
 		struct pkt_desc *desc = descs + i;
-		unsigned int index = (s->packet_index + i) % s->queue_size;
 		unsigned int cycle;
 		unsigned int payload_length;
 		unsigned int data_blocks;
@@ -721,7 +722,7 @@ static int generate_device_pkt_descs(struct amdtp_stream *s,
 		cycle = compute_cycle_count(ctx_header[1]);
 
 		err = parse_ir_ctx_header(s, cycle, ctx_header, &payload_length,
-					  &data_blocks, &dbc, &syt, i);
+					  &data_blocks, &dbc, &syt, packet_index, i);
 		if (err < 0)
 			return err;
 
@@ -729,13 +730,15 @@ static int generate_device_pkt_descs(struct amdtp_stream *s,
 		desc->syt = syt;
 		desc->data_blocks = data_blocks;
 		desc->data_block_counter = dbc;
-		desc->ctx_payload = s->buffer.packets[index].buffer;
+		desc->ctx_payload = s->buffer.packets[packet_index].buffer;
 
 		if (!(s->flags & CIP_DBC_IS_END_EVENT))
 			dbc = (dbc + desc->data_blocks) & 0xff;
 
 		ctx_header +=
 			s->ctx_data.tx.ctx_header_size / sizeof(*ctx_header);
+
+		packet_index = (packet_index + 1) % queue_size;
 	}
 
 	s->data_block_counter = dbc;

