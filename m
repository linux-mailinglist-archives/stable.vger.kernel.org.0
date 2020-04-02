Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F1C19C9C6
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389043AbgDBTRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:20 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42215 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389016AbgDBTRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:19 -0400
Received: by mail-wr1-f66.google.com with SMTP id h15so5578499wrx.9
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kVocnSgIbgSLGlxXga+KA+rqOMxX+rtO9MvMC4A3b/A=;
        b=SsTFUY9PbhXdiISD/6GDwwsmrOs5nrPWIKPWBJy5hrFlJQ+AqiHl8opBgkkr+oTzRQ
         4sp5cJu5BM20YLV9OzONrIm7M9SKAeUfnZfFlPzze1NNfetAaNe2aFwZwitGGeHFGRFk
         bst8DpDXhh+KY1T8RE2FBRWiPHviJ8csc7ZxdASYoX8vBCT1oU3g4h5fTGOjAReViOWY
         3uD6rRGuAU+5IEl81SMli9KMcVdBlFmX+KCBSxKez7zP4GW+gIztJRIWXsNsWd8d4Z0Y
         ZEwq152SzU4dt0Yh7srjI726+4fhP9BXhbbWc0QvJR75b2dnixON2cVEnVoNXwYD0e+2
         Zoiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kVocnSgIbgSLGlxXga+KA+rqOMxX+rtO9MvMC4A3b/A=;
        b=XKHSylVXvXmfxKv7EURlegs3siumFDyYxyT6h/fN078C9nvdiiW3eOgtWjr48d8gzV
         Kc6k75t7+2AMiCEoK4PQDZgzty5BeduNGd6whGd2eDktU6RI6l4c9DxVsN+1YKEWP3no
         GiaoIWDwrJSePd8w52lm0SchuFQ5aTOKqyaavZkLmM9rM/0ICsR8D2AUfZKU1O8/HwyE
         dHXYFeMi3J0VR5k+mRMwuCxcUO8Ptt/9vTbVCkjayytTXujEqYGq88Gmdta/DYnXlatf
         kYcJDcKbyo28+MNpOngAqbnvccVmaYB1uOmYDZPuRaEc42GkTN7Bh7ZLnRKBxPbOfywY
         XgdA==
X-Gm-Message-State: AGi0PuYDB6oFraCEbZGh/5QscpbtAfrnR6Q6YPngNXBmYDuKoTJJmZyO
        xy93zwIwZzKt9t1LyfB26ntxOSkoU5o1hw==
X-Google-Smtp-Source: APiQypLBZMRUOfZBxSLv0nDwcopSOGT7VlAv076+KYPnsPIAUYGqoC82q7EeZybrve218K2xui+Iyg==
X-Received: by 2002:adf:b31d:: with SMTP id j29mr4899122wrd.218.1585855036165;
        Thu, 02 Apr 2020 12:17:16 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:15 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 21/24] perf/core: Reattach a misplaced comment
Date:   Thu,  2 Apr 2020 20:17:44 +0100
Message-Id: <20200402191747.789097-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
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
index 97b90faceb97f..126fd8a5ca5e5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10109,10 +10109,6 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	struct perf_event *event;
 	int err;
 
-	/*
-	 * Get the target context (task or percpu):
-	 */
-
 	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
 				 overflow_handler, context, -1);
 	if (IS_ERR(event)) {
@@ -10123,6 +10119,9 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
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

