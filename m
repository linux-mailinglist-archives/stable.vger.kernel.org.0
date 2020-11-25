Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2562C48E0
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 21:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgKYUMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 15:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgKYUMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 15:12:43 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E16C0613D4
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 12:12:43 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id a186so3079914wme.1
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 12:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rLckGLeAjtT46XUjHrEQu8vj1VogMulqErUOW937k/E=;
        b=jtU3KcwF1Mnu7AgK7efH/4quGOGthUudAMFT6C7bgj6SkPZ1kfAmKIqjp7pA4UdMdL
         rrW1jWVawXBut8QpU1u4r0CYGtLhSbrLdu9QP+uXM9+Is8jW6yM/hqIF0NhdsfPtA3f+
         VNqjQ0kYCVuwcpSe2pTGJitRblFR+GRZCgKSDOBwQI1jm5wjbbOC6zBbbcwcYlUidaeM
         N3i53QHHmeuZfAZ1akLOhgzGQk2rWg8hcAPrKRdqAW3vCfGxh+yicW7skdV9DSKn2OCg
         YSQYg6rDW1GBtsk4QsEFQaL+Ovp311YmxXo9or+QNTED74MvVtkYsafsWG/oT3W2J7LT
         O4Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=rLckGLeAjtT46XUjHrEQu8vj1VogMulqErUOW937k/E=;
        b=F4TGMPA19YGS2zNdVWWdLGoXP524l7NdV7fKuH92JxC51nwy16ESLVyM53U/3HNttI
         tDwwv0WdRrARlS9ezViaN9FyMwg3wlozZUtK8ZeSkChkKhXuGOFGBK5eERzTbcUknbXt
         SEUh9mtk04wuDK55stdMPZzVyT7Z8pvf4rYBXcYSWteA+sAj697n3Yl6sZuj6Ss39i4u
         iTbk80PNaqdeSCcZwuLfNMe0F5xNfad8ysxeP9lq7psAaT9zIaG/VUDrHX1W6Myx0QuL
         HL+TtuYE7Bfku3rEn3/FiQ6kqiBcGRbbXn/E0X7mj/jQAHwBU6nIFjPZgKbSdhMdkOUk
         TWXQ==
X-Gm-Message-State: AOAM532UDwNPPgUNGsUJYiHFrnbI/jIDCsfX5/mQKnwiwp6VjmYhKqhx
        6/1gDXu6PKNK41uT4Vy2weA=
X-Google-Smtp-Source: ABdhPJz3bMWh2R0DMnwnpD92hV/bl7Lbwcof3Vy/XPFLlsBdbEOmR95xHCJgUIMIrw5w3DOA3mb4ww==
X-Received: by 2002:a1c:4e06:: with SMTP id g6mr5657483wmh.119.1606335161741;
        Wed, 25 Nov 2020 12:12:41 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id d17sm5767415wro.62.2020.11.25.12.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 12:12:39 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable@vger.kernel.org
Cc:     Andrey Zhizhikin <andrey.z@gmail.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mike Leach <mike.leach@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Robert Walker <robert.walker@arm.com>,
        Suzuki K Poulouse <suzuki.poulose@arm.com>,
        coresight ml <coresight@lists.linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 1/2] perf cs-etm: Change tuple from traceID-CPU# to traceID-metadata
Date:   Wed, 25 Nov 2020 21:12:14 +0100
Message-Id: <20201125201215.26455-1-carnil@debian.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201122134339.GA6071@leoy-ThinkPad-X240s>
References: <20201122134339.GA6071@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

commit 95c6fe970a0160cb770c5dce9f80311b42d030c0 upstream.

If packet processing wants to know the packet is bound with which ETM
version, it needs to access metadata to decide that based on metadata
magic number; but we cannot simply to use CPU logic ID number as index
to access metadata sequential array, especially when system have
hotplugged off CPUs, the metadata array are only allocated for online
CPUs but not offline CPUs, so the CPU logic number doesn't match with
its index in the array.

This patch is to change tuple from traceID-CPU# to traceID-metadata,
thus it can use the tuple to retrieve metadata pointer according to
traceID.

For safe accessing metadata fields, this patch provides helper function
cs_etm__get_cpu() which is used to return CPU number according to
traceID; cs_etm_decoder__buffer_packet() is the first consumer for this
helper function.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Robert Walker <robert.walker@arm.com>
Cc: Suzuki K Poulouse <suzuki.poulose@arm.com>
Cc: coresight ml <coresight@lists.linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/20190129122842.32041-6-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[Salvatore Bonaccorso: Adjust for context changes in
tools/perf/util/cs-etm-decoder/cs-etm-decoder.c]
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
---
 .../perf/util/cs-etm-decoder/cs-etm-decoder.c |  8 +++---
 tools/perf/util/cs-etm.c                      | 26 ++++++++++++++-----
 tools/perf/util/cs-etm.h                      |  9 ++++++-
 3 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c b/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
index 938def6d0bb9..f540037eb705 100644
--- a/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
+++ b/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
@@ -278,14 +278,12 @@ cs_etm_decoder__buffer_packet(struct cs_etm_decoder *decoder,
 			      enum cs_etm_sample_type sample_type)
 {
 	u32 et = 0;
-	struct int_node *inode = NULL;
+	int cpu;
 
 	if (decoder->packet_count >= MAX_BUFFER - 1)
 		return OCSD_RESP_FATAL_SYS_ERR;
 
-	/* Search the RB tree for the cpu associated with this traceID */
-	inode = intlist__find(traceid_list, trace_chan_id);
-	if (!inode)
+	if (cs_etm__get_cpu(trace_chan_id, &cpu) < 0)
 		return OCSD_RESP_FATAL_SYS_ERR;
 
 	et = decoder->tail;
@@ -296,7 +294,7 @@ cs_etm_decoder__buffer_packet(struct cs_etm_decoder *decoder,
 	decoder->packet_buffer[et].sample_type = sample_type;
 	decoder->packet_buffer[et].exc = false;
 	decoder->packet_buffer[et].exc_ret = false;
-	decoder->packet_buffer[et].cpu = *((int *)inode->priv);
+	decoder->packet_buffer[et].cpu = cpu;
 	decoder->packet_buffer[et].start_addr = CS_ETM_INVAL_ADDR;
 	decoder->packet_buffer[et].end_addr = CS_ETM_INVAL_ADDR;
 
diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 7b5e15cc6b71..5cde3956e19a 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -91,6 +91,20 @@ static int cs_etm__update_queues(struct cs_etm_auxtrace *etm);
 static int cs_etm__process_timeless_queues(struct cs_etm_auxtrace *etm,
 					   pid_t tid, u64 time_);
 
+int cs_etm__get_cpu(u8 trace_chan_id, int *cpu)
+{
+	struct int_node *inode;
+	u64 *metadata;
+
+	inode = intlist__find(traceid_list, trace_chan_id);
+	if (!inode)
+		return -EINVAL;
+
+	metadata = inode->priv;
+	*cpu = (int)metadata[CS_ETM_CPU];
+	return 0;
+}
+
 static void cs_etm__packet_dump(const char *pkt_string)
 {
 	const char *color = PERF_COLOR_BLUE;
@@ -230,7 +244,7 @@ static void cs_etm__free(struct perf_session *session)
 	cs_etm__free_events(session);
 	session->auxtrace = NULL;
 
-	/* First remove all traceID/CPU# nodes for the RB tree */
+	/* First remove all traceID/metadata nodes for the RB tree */
 	intlist__for_each_entry_safe(inode, tmp, traceid_list)
 		intlist__remove(traceid_list, inode);
 	/* Then the RB tree itself */
@@ -1316,9 +1330,9 @@ int cs_etm__process_auxtrace_info(union perf_event *event,
 				    0xffffffff);
 
 	/*
-	 * Create an RB tree for traceID-CPU# tuple. Since the conversion has
-	 * to be made for each packet that gets decoded, optimizing access in
-	 * anything other than a sequential array is worth doing.
+	 * Create an RB tree for traceID-metadata tuple.  Since the conversion
+	 * has to be made for each packet that gets decoded, optimizing access
+	 * in anything other than a sequential array is worth doing.
 	 */
 	traceid_list = intlist__new(NULL);
 	if (!traceid_list) {
@@ -1384,8 +1398,8 @@ int cs_etm__process_auxtrace_info(union perf_event *event,
 			err = -EINVAL;
 			goto err_free_metadata;
 		}
-		/* All good, associate the traceID with the CPU# */
-		inode->priv = &metadata[j][CS_ETM_CPU];
+		/* All good, associate the traceID with the metadata pointer */
+		inode->priv = metadata[j];
 	}
 
 	/*
diff --git a/tools/perf/util/cs-etm.h b/tools/perf/util/cs-etm.h
index 37f8d48179ca..fb5fc6538b7f 100644
--- a/tools/perf/util/cs-etm.h
+++ b/tools/perf/util/cs-etm.h
@@ -53,7 +53,7 @@ enum {
 	CS_ETMV4_PRIV_MAX,
 };
 
-/* RB tree for quick conversion between traceID and CPUs */
+/* RB tree for quick conversion between traceID and metadata pointers */
 struct intlist *traceid_list;
 
 #define KiB(x) ((x) * 1024)
@@ -69,6 +69,7 @@ static const u64 __perf_cs_etmv4_magic   = 0x4040404040404040ULL;
 #ifdef HAVE_CSTRACE_SUPPORT
 int cs_etm__process_auxtrace_info(union perf_event *event,
 				  struct perf_session *session);
+int cs_etm__get_cpu(u8 trace_chan_id, int *cpu);
 #else
 static inline int
 cs_etm__process_auxtrace_info(union perf_event *event __maybe_unused,
@@ -76,6 +77,12 @@ cs_etm__process_auxtrace_info(union perf_event *event __maybe_unused,
 {
 	return -1;
 }
+
+static inline int cs_etm__get_cpu(u8 trace_chan_id __maybe_unused,
+				  int *cpu __maybe_unused)
+{
+	return -1;
+}
 #endif
 
 #endif
-- 
2.29.2

