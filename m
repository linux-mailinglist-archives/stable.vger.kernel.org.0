Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 613DA19C980
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731689AbgDBTLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:11:41 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43260 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731892AbgDBTLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:11:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id 91so3638153wri.10
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=bQSVQUznH72WQBKL04U2uoQruvsVD6tJ6h7LJtSHrIo=;
        b=kho8ap0JYcgB9oWLy3A7108PGVWxZvJV1ULlUNbQ0QdD5X1gb+a+aP+cfUo+MmGbzM
         ASSqq734wF1sXcv8uymzczG3nt61zBvpb5I7/uhxbRxijDtrZWxChIvWKPI+1peiCxG6
         TDoSJ67rzfbkgDEVnPMwcXCB1j8fLy2d+QDl29AC4mb5LEEx2sUuLk72pUa/LPP8r41U
         YmdpCYYqbB0DoqX7fXOZfOmrXUUIes6yonERyllxXGU95S+ljhXg0kXldfjzK5C4jKMR
         Nb1/Vhcm3iYSBB0VpDY8dL74DZvtoysmoA5gtu7Lo3WjoAUWvAp0zXnzLBe+Bg6KKSpB
         6MUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bQSVQUznH72WQBKL04U2uoQruvsVD6tJ6h7LJtSHrIo=;
        b=W+mtahxXqyXg/VR+B7ZZI3EI0ybyNRMYHog5UQu9zrG0FijHIzjvakWrEmd0/oC7G7
         a3voAJHUaTrnEVrHCNFoxWedbZiYRfIhXqoeRqC1lmRMiTCv2Trj/nyyBMIL1YbzYNfw
         EzI+4u3nabi3l32I1JoiIce3yNyKNODXlC0bRslL45eaBKD7U442NyUDsfLIY/zqe304
         +HgGNVnkDfcuR/bR5BlT1DW9fZNEl+RDu6MH+pfYR209swsSoGyxPLeC5R3Xi3dJm/nI
         GMy44uadOPZGTioGPEdTjYVZrRRlyNJe6hfmblGslT6ecCpsdrVsMWa1XnkFDDe47nxg
         EWIQ==
X-Gm-Message-State: AGi0PuaTvt/25oBru5hi9fDyOaMRHIN7WfvMVTY14xNvv7UjMnQXZ8oi
        o8EBRGqjD5n+J9d3y1cqkRedAKic5wJxAw==
X-Google-Smtp-Source: APiQypIAK03g1fhrjDS3Nm6nMU103S5AUxgPb75DMKDG5HdCIaZPXSPEO/3oHE157riZ+ABBRn3RZw==
X-Received: by 2002:adf:dd86:: with SMTP id x6mr4868672wrl.169.1585854699080;
        Thu, 02 Apr 2020 12:11:39 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id s15sm8442164wrt.16.2020.04.02.12.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:11:38 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 11/14] perf/core: Reattach a misplaced comment
Date:   Thu,  2 Apr 2020 20:12:17 +0100
Message-Id: <20200402191220.787381-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191220.787381-1-lee.jones@linaro.org>
References: <20200402191220.787381-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

[ Upstream commit f25d8ba9e1b204b90fbf55970ea6e68955006068 ]

A comment is in a wrong place in perf_event_create_kernel_counter().
Fix that.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: https://lkml.kernel.org/r/20191030134731.5437-2-alexander.shishkin@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/events/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 8c70ee23fbe91..16f268475e8e4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10954,10 +10954,6 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	struct perf_event *event;
 	int err;
 
-	/*
-	 * Get the target context (task or percpu):
-	 */
-
 	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
 				 overflow_handler, context, -1);
 	if (IS_ERR(event)) {
@@ -10968,6 +10964,9 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	/* Mark owner so we could distinguish it from user events. */
 	event->owner = TASK_TOMBSTONE;
 
+	/*
+	 * Get the target context (task or percpu):
+	 */
 	ctx = find_get_context(event->pmu, task, event);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
-- 
2.25.1

