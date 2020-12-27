Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476F22E3098
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 10:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgL0J32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 04:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgL0J31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Dec 2020 04:29:27 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A63C061794
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 01:28:46 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id g20so10749257ejb.1
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 01:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b3XfiZGTmdtILp+unm6rSSuThTHGpNqTBR1owWhke04=;
        b=G0s73267c0w0axAQajWTEYK2o7gF7BNjzv4WbWX6fD13vVy3UMCkFVEv5EErPCY+so
         R6VY3PeLQcQs1GoIKMHgEih9fGp5qQAnVZR3XFvCdMCFFFXrrBLNty7zm1f/8zIXReTX
         H1/NLhmUV/lIQ27UfD+oO+3KatCWg6NOiA5I/NMh5p+FmOO+xKqGxDaMnvf+vBUwNCsP
         CmdxMHdx3II2YmoDlt7PaKiYmwa20Nxwk+UR+5XcB9Uli70SvvENmGxed+UTJhiik64I
         ybD/LZhymP6TD+QogBUPyjb0Yzu3dEU4HJDVweE0XApm5Ju/VwuDE+H/fTaoa0tPvbtx
         aILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=b3XfiZGTmdtILp+unm6rSSuThTHGpNqTBR1owWhke04=;
        b=jl5lu3ttsHNBoRk96C1RR5ooze9awtlsVxhamom/8GyjeqiTZUQaamvahzq0mMF/kS
         HV8LxtC4iFBz6reKz1Rkcz8dGcjTQISTXpMsfJVFz2cB9nAWGHH1gCcu1I+Yua/xvb7e
         Ebj+qRZDuvjHZh2wRwpcAeCsHa6hk/cOXdQYbSVamcUu92XsgPGc4/6KGS3mtmFlyIDP
         NOgM2fXHPCYc4B+QXDeOmYyc1AuONA0v3EDleYCr/JMw1+jVBb0NvshnKTrI3eRLg2/E
         3O2ImhbHSSf+WBKznHgN4JDZ3zhvi+LMg7BaUrWa+PRm/RcZFb+JxH+Uzn4/vGK+bnjv
         HJAw==
X-Gm-Message-State: AOAM531lE/MYB/yZbpqszrBRmQRgysKQyFy9XAKChjydol782zF2h+QA
        8ca8iE0MnNYsQFa3oRZFPfA=
X-Google-Smtp-Source: ABdhPJzOHbcqanaUB7vu+NkRGFob1olS+0rFhLJ7VvKMpUy48w72wrxk5GU6bLPRqjocjiKH0jFtmg==
X-Received: by 2002:a17:906:705:: with SMTP id y5mr36419497ejb.428.1609061325403;
        Sun, 27 Dec 2020 01:28:45 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id c16sm9905934ejk.91.2020.12.27.01.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Dec 2020 01:28:44 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Leo Yan <leo.yan@linaro.org>,
        Thomas Backlund <tmb@mageia.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        Tor Jeremiassen <tor@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 2/2] perf cs-etm: Move definition of 'traceid_list' global variable from header file
Date:   Sun, 27 Dec 2020 10:27:45 +0100
Message-Id: <20201227092745.447945-3-carnil@debian.org>
X-Mailer: git-send-email 2.30.0.rc2
In-Reply-To: <20201227092745.447945-1-carnil@debian.org>
References: <20201227092745.447945-1-carnil@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

commit 168200b6d6ea0cb5765943ec5da5b8149701f36a upstream.

The variable 'traceid_list' is defined in the header file cs-etm.h,
if multiple C files include cs-etm.h the compiler might complaint for
multiple definition of 'traceid_list'.

To fix multiple definition error, move the definition of 'traceid_list'
into cs-etm.c.

Fixes: cd8bfd8c973e ("perf tools: Add processing of coresight metadata")
Reported-by: Thomas Backlund <tmb@mageia.org>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Tested-by: Mike Leach <mike.leach@linaro.org>
Tested-by: Thomas Backlund <tmb@mageia.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: Tor Jeremiassen <tor@ti.com>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lore.kernel.org/lkml/20200505133642.4756-1-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
---
 tools/perf/util/cs-etm.c | 3 +++
 tools/perf/util/cs-etm.h | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 5cde3956e19a..3275b8dc9344 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -87,6 +87,9 @@ struct cs_etm_queue {
 	struct cs_etm_packet *packet;
 };
 
+/* RB tree for quick conversion between traceID and metadata pointers */
+static struct intlist *traceid_list;
+
 static int cs_etm__update_queues(struct cs_etm_auxtrace *etm);
 static int cs_etm__process_timeless_queues(struct cs_etm_auxtrace *etm,
 					   pid_t tid, u64 time_);
diff --git a/tools/perf/util/cs-etm.h b/tools/perf/util/cs-etm.h
index fb5fc6538b7f..97c3152f5bfd 100644
--- a/tools/perf/util/cs-etm.h
+++ b/tools/perf/util/cs-etm.h
@@ -53,9 +53,6 @@ enum {
 	CS_ETMV4_PRIV_MAX,
 };
 
-/* RB tree for quick conversion between traceID and metadata pointers */
-struct intlist *traceid_list;
-
 #define KiB(x) ((x) * 1024)
 #define MiB(x) ((x) * 1024 * 1024)
 
-- 
2.30.0.rc2

