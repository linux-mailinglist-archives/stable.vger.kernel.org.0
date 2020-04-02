Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35FB719C9E1
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389486AbgDBTSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35903 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389536AbgDBTSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:22 -0400
Received: by mail-wm1-f68.google.com with SMTP id d202so4983209wmd.1
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=H8TKdBw3f0Ygwont/5PH+7xx0o5j66FUGiSbWGoh3Eg=;
        b=q7NGjyzPxWN6MqVvc/+EExel1CjhWaYgvXITDkTFw3TSl036PTmut/h+sztxNHakJJ
         N3Xe+uB7unZjarPBW7gqRm/ATEPa7Siu50cT+nyKJ5lOc+Rqa+s57Qd6ogegUSgbM4Y7
         iUHUXRWzcDCiO8FNPy1wvrpWWAjB5evEvMB6eG7D89Krp5B6xw1uSrAExyEccGDTffwq
         iCLNbQ8vXSy4Tj8Aeoem7rsnUERi418/cLEQwg2A4dxn2LvCJ7HCHrgjvVHWFMM2VhTX
         K0nBNt8+lDpEuB8jhlsDdpCNp+fu6hyzRDZIGjVgIim/cAMzuD7Umm85I0J/pb6iwLkJ
         +Y+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H8TKdBw3f0Ygwont/5PH+7xx0o5j66FUGiSbWGoh3Eg=;
        b=DRfTFtpYh8PwHoqOfzMy95d5NGPVEXl0W9n4FP9Mspjv6POE26r26m2bBI0d1TWndf
         YNWuu6tjMd/EXM0dQS9IUZu6e5bepKIeHqPIwIhgIkG6V2F0V4Ni1FCav465A/Z4PljF
         d1Tr6aYrE2sn+tt5bIXllA954F0n4D2b7c3iMuuIGv3K/ErdlVFxNz/GYUJM2+rdmKfd
         45pLgNgOMipqe8CzpdA9n28lNSrHoaihaXafkBDZBbjNxts9vf30mnun8SoD1W5444EH
         bxFQQr6A+gKiasMBygKmVKytWQS+8bmxMhqtWfT0QmjmXG96eFFjT9h27KDHcAL1gpsc
         wgTQ==
X-Gm-Message-State: AGi0Puar5yx7nDGNfdS98LsVkEKtbUyLaCOhjIB3wqxm6L9U3fipQUn3
        A5y0i5UjuJs05EPDYNG5jKGYcBgSbpyFrQ==
X-Google-Smtp-Source: APiQypI0Du0UO+GC58itqex8Sz41W0gvwxBq5KT4Wna/y3c720KABEMSBDngHESAeZEmPLHiAgqrpg==
X-Received: by 2002:a1c:ab44:: with SMTP id u65mr4978234wme.45.1585855100542;
        Thu, 02 Apr 2020 12:18:20 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:19 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 18/20] perf/core: Reattach a misplaced comment
Date:   Thu,  2 Apr 2020 20:18:54 +0100
Message-Id: <20200402191856.789622-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
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
index a7014f854e67b..e61ada5574ffc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8727,10 +8727,6 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	struct perf_event *event;
 	int err;
 
-	/*
-	 * Get the target context (task or percpu):
-	 */
-
 	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
 				 overflow_handler, context, -1);
 	if (IS_ERR(event)) {
@@ -8741,6 +8737,9 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	/* Mark owner so we could distinguish it from user events. */
 	event->owner = EVENT_OWNER_KERNEL;
 
+	/*
+	 * Get the target context (task or percpu):
+	 */
 	ctx = find_get_context(event->pmu, task, event);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
-- 
2.25.1

