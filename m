Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F528652912
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 23:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiLTWbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 17:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbiLTWbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 17:31:45 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A131C931;
        Tue, 20 Dec 2022 14:31:43 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id u7so5528861plq.11;
        Tue, 20 Dec 2022 14:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=U5Pe07mEzVE78EvLTCD6fYM83lCIt58BET379Vpv3LY=;
        b=lBmDibocl83YZZUlii4qBcmZIL6kJHoMdaPxxevMX/AMm7ohl8MRB/WRDsgspNmm1m
         IzyOwftrVlNRB4tE9MYO5wMYlNmFa5ExN9SQ76W9ZXT2s2fTkO4jWtToNuVBCmwzaO4z
         XWYneZWgqKA57oOeCNdqudLQ5doMieYnTGrFTJMT9wZhdGacEPYQ4fdXXP4L8FfKab2/
         wTfl4XG+plwSe7Q7cRwVfcBjdeGF8vgZIdGi7tVxbCQMyVbNaxYCLXurftJqQkNtfLOi
         6mSUHQKLMZKD7zVyv+MRhdmfcR4iHepny1M0aK7svv45n8Ui5oGxayQ6rK2xhtAozrjd
         p8eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U5Pe07mEzVE78EvLTCD6fYM83lCIt58BET379Vpv3LY=;
        b=BG6c0h2PTnSzT1sjLy48AvnMMjWKfJIHCdYn37OYGhQFyEKxx1/De8pDISL6QtnzNw
         waajJK4NcpZIMloYfX8v025SWaXq0HyHU+dmsyi2oLHO2DrKujDA0bfaKUyiaQArsTzG
         +XemE4HUpnA2/viWqmoh3qcCBFmYUVtaZMeOzWjmULzY3FNGPJnHjY67sW8TvnIr33oZ
         HrUymNGCjsMDmKgA9s/qAXakvLr4gLK4m/cd7L7FJ6mM6ccisfT9mDZlbDq8SST+fpfe
         d67qOsA2DyfmRVg/D0XLLUpKenJ1WagoEK9eLSsI+7c6GUpEw+TpDRt1YQXhLLJOHPGh
         2ZcA==
X-Gm-Message-State: ANoB5pkedZaczw1G5zzhQUbIcENzXWJ0AAIMjG0AtQvOJhxmdDgNUV3O
        LGvAlRGbO6Ib3E9rLg8wiVDDD/tLn0k=
X-Google-Smtp-Source: AA0mqf5LuRIdIk4PYrZKXumJjG3QgBVNkkjlDKnDo121XGrjUdZSDjk44in+fEvN8zigBudZ7CUGSA==
X-Received: by 2002:a17:902:f602:b0:187:4920:3a3c with SMTP id n2-20020a170902f60200b0018749203a3cmr51067334plg.33.1671575503283;
        Tue, 20 Dec 2022 14:31:43 -0800 (PST)
Received: from youngsil.svl.corp.google.com ([2620:15c:2d4:203:68c4:de54:581a:ee2])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902684f00b00182d25a1e4bsm9825160pln.259.2022.12.20.14.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 14:31:42 -0800 (PST)
Sender: Namhyung Kim <namhyung@gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KP Singh <kpsingh@kernel.org>, stable@vger.kernel.org,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH RESEND] perf/core: Call LSM hook after copying perf_event_attr
Date:   Tue, 20 Dec 2022 14:31:40 -0800
Message-Id: <20221220223140.4020470-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It passes the attr struct to the security_perf_event_open() but it's
not initialized yet.

Fixes: da97e18458fb ("perf_event: Add support for LSM and SELinux checks")
Cc: stable@vger.kernel.org
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/events/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 65e20c5c3c44..5d7193d3ffef 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12293,12 +12293,12 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
 
-	/* Do we allow access to perf_event_open(2) ? */
-	err = security_perf_event_open(&attr, PERF_SECURITY_OPEN);
+	err = perf_copy_attr(attr_uptr, &attr);
 	if (err)
 		return err;
 
-	err = perf_copy_attr(attr_uptr, &attr);
+	/* Do we allow access to perf_event_open(2) ? */
+	err = security_perf_event_open(&attr, PERF_SECURITY_OPEN);
 	if (err)
 		return err;
 
-- 
2.39.0.314.g84b9a713c41-goog

