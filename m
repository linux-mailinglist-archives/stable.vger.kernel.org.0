Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E5519D696
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403927AbgDCMSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:18:39 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37331 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403845AbgDCMSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:18:39 -0400
Received: by mail-wm1-f65.google.com with SMTP id j19so7458710wmi.2
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bQSVQUznH72WQBKL04U2uoQruvsVD6tJ6h7LJtSHrIo=;
        b=veyEAL64v91MslbK3AzClUmpLp/IS7ZozZ7HttjdXClrfNCOQ+KPVn1qLN+uoPBXYZ
         RSoGJKiVkecLcr5XA41lWf9ee+V9X6mzGeGa4IV7od252JuaRa347p7XquxlOjRTKGRM
         Z5VKnJssWBT/3IrsPddG+0fOuEBXerSUxfq01ktfoDg9Fy2tuJmKEJjkWuT2kmW5Wr2A
         YCWiySyUxCZ+HUfD77utoYsElyD/KdVbCAxHlMWx4vKv9vMAcU9/3KejwFlXy4b+Xm8Y
         Hwj8LxVhW8uhUNFhlcxKGf0g4EQR7jGSvqBkbR4PTaAgLuogFdTjqV3R7FW17FCn8vMI
         xhrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bQSVQUznH72WQBKL04U2uoQruvsVD6tJ6h7LJtSHrIo=;
        b=FREEIBNl/GlWjyzbSFIaUZm8t78C8ZVTCOnm1x9zd2IObY+DSWTmUAIO2F5Spxxya3
         TLUMXN8hd5Z3YDBZwtRkSgA+ArDF0s6iVKHPiyRUit3x/Aty20wA7ImnH4Qi1izJ9LUn
         NlyWMoW98EQoyY3MgSc1OkY7x7FS7fUZSPsBk03fUA+nEnjsPjQ60MEZxiHDN8BC/cy8
         k8DC7sdmIDVBGaPfFVGvGHuMokgrUt97EUwjgc9EZqv/48LG1JMg+EWYSiPmg39RtP3v
         Lc8eilO/CEYGivnI0gmCdi92ukMuDsbANHMEb0QrqKllWTvRRfPz/JEhzzNGvewLp9QL
         vIjA==
X-Gm-Message-State: AGi0PubgRgxIrdZdn8g1ZjScFzm39Py2bDwBFTR6i+Oam2omgPmNjGyI
        IuEg9ATIVIGcB6dVS5PcMWWUYYsE2Os=
X-Google-Smtp-Source: APiQypJRlcCY8V+WXHTfo+nsBY2mr74pmMDeBm0twCW/WbyEFSLdXZPCyPIKdDrtQC2DdKZzBbLH5Q==
X-Received: by 2002:a1c:9ecb:: with SMTP id h194mr8858496wme.49.1585916315934;
        Fri, 03 Apr 2020 05:18:35 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.179])
        by smtp.gmail.com with ESMTPSA id l185sm11377712wml.44.2020.04.03.05.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:18:35 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 11/13] perf/core: Reattach a misplaced comment
Date:   Fri,  3 Apr 2020 13:18:57 +0100
Message-Id: <20200403121859.901838-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200403121859.901838-1-lee.jones@linaro.org>
References: <20200403121859.901838-1-lee.jones@linaro.org>
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

