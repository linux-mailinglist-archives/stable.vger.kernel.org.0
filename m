Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BF637F845
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 14:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhEMM6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 08:58:16 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49437 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230488AbhEMM6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 08:58:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id D4F965C0197;
        Thu, 13 May 2021 08:57:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 13 May 2021 08:57:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=yIOUXRrhJlj24
        pXsLaNjfbJbZgrWDk96Ed9u/NT2zKQ=; b=NSAHLN/iEwK5ZaQJHTsYgYrgE5ii6
        vZDwg567atDIAt5P6NAxZBVYp1DVoYp2Q8wm5/CWimolSaahkextERow4A3h9sR7
        VQkTbPtNn+TwKF07FP0ucvc3UQjmU1U43pGQrOanOYVrB/+mjZIWLQHZb2DuJO4C
        hMgBqwJyRFoa/INLrSNLT7YjEGoVApG2RpKlgJFp6kKmwOy1P+S9KYgQoIGfIKYy
        yLbLrhoeHQGHlccxQ/ias0Xzrbac+PXNpHJ36mhYMV54s1L84yFbPI0aPhz2zd8f
        fab4kFLX8Xz7gfLCcfS4plw+ZpbOGc6QD9aV8jWjhPfnsH9KBN0gNzH4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=yIOUXRrhJlj24pXsLaNjfbJbZgrWDk96Ed9u/NT2zKQ=; b=l364LjYt
        E7KAODSaFcL/I6YLji+wss9zBTia79zMgKbbr6DvA0ujPJwYim1QPBIO092qUUH/
        or2qOioSn11ceLy6UOz78RJCrDv63D3jUf+QQk0DfInYhcwhrdgjvIwGH0zxMl8S
        NG2i5WSTPQWcGHes5eppkIy+IFq86KX6Zxbbm0VSslR1GqJJe+67bD3DVvk6NuMz
        Qj2EF2gIE5OZtSoXTOtTUhU+Hc184KdrDajatdm5SxpEVj11m1JAUioUVcr0ULp6
        uCRPpd2l4OTiGuWWq1CWRdcwpsiwUVf9rzHyiClIgjQUgaO/MyTjBQTZPlizngd7
        sJblZb2uWTo5hQ==
X-ME-Sender: <xms:ISKdYPRkBMZakflg4HAwlWo2RRIAPmcRc_wU3n5wdHJXQHYOaVvW7w>
    <xme:ISKdYAxQeDM8ZHIzAlOEb4zgLnxr6BIzwfdUrbmJKc7lOGSSk9Ano2ykxWOyKRvLz
    HNY0_nfKn87UPRCg0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehgedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgr
    shhhihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepveefffefke
    etgfevgeefleehfffhueejtdejveethfekveektdejjedvtdejhfejnecukfhppedugedr
    fedrieehrddujeehnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilh
    hfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:ISKdYE01lSyihdQzyOdB2jz5OyQXcqrPF8p2SoJhR3cpGfo2iFtROg>
    <xmx:ISKdYPBLSjf3JMZUWjufK8mOhpjFGMOjw3qrYVMzfSIxNBI0BwiwNg>
    <xmx:ISKdYIi5X6jDzs0u2t5evg_O9nOnOSq0H2roCjuEa5SpBCT70y3tsA>
    <xmx:ISKdYEblxGrT40K9Lq1Ie2udDkpeMt_vGCpASs8dtE53ElYKDmXDkA>
Received: from workstation.flets-east.jp (ae065175.dynamic.ppp.asahi-net.or.jp [14.3.65.175])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 13 May 2021 08:57:04 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH 5/5] ALSA: firewire-lib: fix amdtp_packet tracepoints event for packet_index field
Date:   Thu, 13 May 2021 21:56:52 +0900
Message-Id: <20210513125652.110249-6-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210513125652.110249-1-o-takashi@sakamocchi.jp>
References: <20210513125652.110249-1-o-takashi@sakamocchi.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The snd_firewire_lib:amdtp_packet tracepoints event includes index of
packet processed in a context handling. However in IR context, it is not
calculated as expected.

Cc: <stable@vger.kernel.org>
Fixes: 753e717986c2 ("ALSA: firewire-lib: use packet descriptor for IR context")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/amdtp-stream-trace.h |  6 +++---
 sound/firewire/amdtp-stream.c       | 15 +++++++++------
 2 files changed, 12 insertions(+), 9 deletions(-)

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
-- 
2.27.0

