Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8972BAF56
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 16:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgKTPxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 10:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbgKTPxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 10:53:20 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04408C0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 07:53:20 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c9so10786990wml.5
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 07:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RSx9RQPizVvdVCfQXPExJYnkiedn9StpsDqS98CuyYY=;
        b=Ya3I79GmxjAOqIip0LxmKVHIUWAs4KkceIbch1EQ2pR+DUJyZHZDtW8ylzULK9As8u
         Mh87DPI7PgV3cZ1eGu1/ABs4KaNCSFOI9O1Bi50TfkJXxrTZD6CnEFE3uCTnprGlZCO3
         kbVD8ywjv4QIyESOPvpO0cb76OEh20vse7SLxnAAB2PylUp1Tpo8uNcB7onkD+d4hniU
         tooaPl+r3jmOxEcDv0lex2hP+TF8phEuvLvXbs5ljzQVwCmI+20j+XeDWoEwtOVkVXDF
         6hXxp8jZf2phhz6JFinAm/tH6grGU+Fi7btWxB6RIfmyYkcvA0EhmNnBfjo0X0WliUxD
         DjCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=RSx9RQPizVvdVCfQXPExJYnkiedn9StpsDqS98CuyYY=;
        b=DztsjKrnr6jZU8g+QrCf0Sjv/YHoNbrxzmCgVKq0LKwFLz1DUhjVHQhw44WQiMiMjV
         SpFlqg1UiPqDM2EFvRwGH9E3tUYQqE0K6O7Uyt9agJR3tRZ5uLdcTMGuy1iFQzIVCeTt
         Fi8yfiNynT7fKlEqT40yVpHCbESrDaypTSCr6FTbvlJQUAopcLvePc5YV7FJEBo49xKd
         Z2P8yhsXTqTLpRA+K8iV9nxwcGMMJhHvWjT8jQFLzIIV8KOPFC8a82KJR7+nQ/Qtp3c+
         a26FG4ybhhaB7baIMDXkmR3EIOKIdOG22Vou7UlDEdHTrTGzCyfRsoN1jgLoxtG9B5+n
         YQow==
X-Gm-Message-State: AOAM531GU/CExDdFlYwNDuWzYzJsLaw0cA2j5DlTLoLEafLfB/QqGH8b
        4BuF07GBsJQad36VDXy2UTQ=
X-Google-Smtp-Source: ABdhPJxG0QJM3qgGL1WRbUaqus1dAI4dMSNUFI78E0boixvOJsxauNUaqp0fPXBT0De30coPC3RNJQ==
X-Received: by 2002:a1c:c284:: with SMTP id s126mr3077506wmf.109.1605887598707;
        Fri, 20 Nov 2020 07:53:18 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id k64sm4774843wmb.11.2020.11.20.07.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 07:53:17 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Fri, 20 Nov 2020 16:53:17 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Andrey Zhizhikin <andrey.z@gmail.com>
Cc:     stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        Tor Jeremiassen <tor@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Revert "perf cs-etm: Move definition of 'traceid_list'
 global variable from header file"
Message-ID: <20201120155317.GA502412@eldamar.lan>
References: <20201120073909.357536-1-carnil@debian.org>
 <CAHtQpK6xA4Ej_LCKBv6TWgiypzwzFzPy3ANvH8BRw-y_FkuJqg@mail.gmail.com>
 <20201120133400.GA405401@eldamar.lan>
 <CAHtQpK7=hpWLM-ztyTS8vzGDfG_46Qx2vc6q0fm1dDDU3W6+UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHtQpK7=hpWLM-ztyTS8vzGDfG_46Qx2vc6q0fm1dDDU3W6+UA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrey,

On Fri, Nov 20, 2020 at 03:29:39PM +0100, Andrey Zhizhikin wrote:
> Hello Salvatore,
> 
> On Fri, Nov 20, 2020 at 2:34 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
> >
> > Hi Andrey,
> >
> > On Fri, Nov 20, 2020 at 10:54:22AM +0100, Andrey Zhizhikin wrote:
> > > On Fri, Nov 20, 2020 at 8:39 AM Salvatore Bonaccorso <carnil@debian.org> wrote:
> > > >
> > > > This reverts commit 168200b6d6ea0cb5765943ec5da5b8149701f36a upstream.
> > > > (but only from 4.19.y)
> > >
> > > This revert would fail the build of 4.19.y with gcc10, I believe the
> > > original commit was introduced to address exactly this case. If this
> > > is intended behavior that 4.19.y is not compiled with newer gcc
> > > versions - then this revert is OK.
> >
> > TTBOMK, this would not regress the build for newer gcc (specifically
> > gcc10) as 4.19.158 is failing perf tool builds there as well (without
> > the above commit reverted). Just as an example v4.19.y does not have
> > cff20b3151cc ("perf tests bp_account: Make global variable static")
> > which is there in v5.6-rc6 to fix build failures with 10.0.1.
> >
> > But it did regress builds with older gcc's as for instance used in
> > Debian buster (gcc 8.3.0) since 4.19.152.
> >
> > Do I possibly miss something? If there is a solution to make it build
> > with newer GCCs and *not* regress previously working GCC versions then
> > this is surely the best outcome though.
> 
> I guess (and from what I understand in Leo's reply), porting of
> 95c6fe970a01 ("perf cs-etm: Change tuple from traceID-CPU# to
> traceID-metadata") should solve the issue for both older and newer gcc
> versions.
> 
> The breakage is now in
> [tools/perf/util/cs-etm-decoder/cs-etm-decoder.c] file (which uses
> traceid_list inside). This is solved with the above commit, which
> concealed traceid_list internally inside [tools/perf/util/cs-etm.c]
> file and exposed to [tools/perf/util/cs-etm-decoder/cs-etm-decoder.c]
> via cs_etm__get_cpu() call.
> 
> Can you try out to port that commit to see if that would solve your
> regression?

So something like the following will compile as well with the older
gcc version.

I realize: I mainline the order of the commits was:

95c6fe970a01 ("perf cs-etm: Change tuple from traceID-CPU# to traceID-metadata")
168200b6d6ea ("perf cs-etm: Move definition of 'traceid_list' global variable from header f
ile")

But to v4.19.y only 168200b6d6ea was backported, and while that was
done I now realize the comment was also changed including the change
fom 95c6fe970a01.

Thus the proposed backported patch would drop the change in
tools/perf/util/cs-etm.c to the comment as this was already done.
Thecnically currently the comment would be wrong, because it reads:

/* RB tree for quick conversion between traceID and metadata pointers */

but backport of 95c6fe970a01 is not included.

Would the right thing to do thus be:

- Revert b801d568c7d8 "perf cs-etm: Move definition of 'traceid_list' global variable from header file"
- Backport 95c6fe970a01 ("perf cs-etm: Change tuple from traceID-CPU# to traceID-metadata")
- Backport 168200b6d6ea ("perf cs-etm: Move definition of 'traceid_list' global variable from header file")

?

Leo ist that what you were proposing?

Regards,
Salvatore

From 7d6b3668d8ae5d3aea8827670ade8ac43b92db4a Mon Sep 17 00:00:00 2001
From: Leo Yan <leo.yan@linaro.org>
Date: Tue, 29 Jan 2019 20:28:39 +0800
Subject: [PATCH] perf cs-etm: Change tuple from traceID-CPU# to
 traceID-metadata

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
[Salvatore Bonaccorso: Drop comment change in tools/perf/util/cs-etm.h
which was already changed with b801d568c7d8 ("perf cs-etm: Move
definition of 'traceid_list' global variable from header file")]
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
---
 .../perf/util/cs-etm-decoder/cs-etm-decoder.c |  8 +++---
 tools/perf/util/cs-etm.c                      | 26 ++++++++++++++-----
 tools/perf/util/cs-etm.h                      |  7 +++++
 3 files changed, 30 insertions(+), 11 deletions(-)

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
index ad33b99f5d21..3275b8dc9344 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -94,6 +94,20 @@ static int cs_etm__update_queues(struct cs_etm_auxtrace *etm);
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
@@ -233,7 +247,7 @@ static void cs_etm__free(struct perf_session *session)
 	cs_etm__free_events(session);
 	session->auxtrace = NULL;
 
-	/* First remove all traceID/CPU# nodes for the RB tree */
+	/* First remove all traceID/metadata nodes for the RB tree */
 	intlist__for_each_entry_safe(inode, tmp, traceid_list)
 		intlist__remove(traceid_list, inode);
 	/* Then the RB tree itself */
@@ -1319,9 +1333,9 @@ int cs_etm__process_auxtrace_info(union perf_event *event,
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
@@ -1387,8 +1401,8 @@ int cs_etm__process_auxtrace_info(union perf_event *event,
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
index c7ef97b198c7..97c3152f5bfd 100644
--- a/tools/perf/util/cs-etm.h
+++ b/tools/perf/util/cs-etm.h
@@ -66,6 +66,7 @@ static const u64 __perf_cs_etmv4_magic   = 0x4040404040404040ULL;
 #ifdef HAVE_CSTRACE_SUPPORT
 int cs_etm__process_auxtrace_info(union perf_event *event,
 				  struct perf_session *session);
+int cs_etm__get_cpu(u8 trace_chan_id, int *cpu);
 #else
 static inline int
 cs_etm__process_auxtrace_info(union perf_event *event __maybe_unused,
@@ -73,6 +74,12 @@ cs_etm__process_auxtrace_info(union perf_event *event __maybe_unused,
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

