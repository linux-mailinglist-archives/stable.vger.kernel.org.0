Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B75461E9A4
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 04:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiKGDbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 22:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbiKGDbk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 22:31:40 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE251DF4D
        for <stable@vger.kernel.org>; Sun,  6 Nov 2022 19:31:38 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id p12so4440356plq.4
        for <stable@vger.kernel.org>; Sun, 06 Nov 2022 19:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=czrfw6zGMNqQokKkTKz9bsRdwo0W+o1G6oGlRZsSGc0=;
        b=ZyVMHo5+aBgoVD+dwght5ynvpKfVcgxqS+A7UJXaRSrZ57BXzMET9Cz0Hyk0rkJW+N
         lv/kEYz/SXtZ9/wvTGpSbLaM54f8PSdvwyl5ZIok2Li2vdEAdYoXKJ8IhvjbHp9lwiLj
         ftOT8lIf/KeQVNIoum8CuCpFajthTOq44oktTPOc8k7uHpgCnwB7EcDrpcF7vVCtqFHa
         IejjAwkdondAr1rQcITTh0vfuY2ka3w71qnNn+DnmwNS8E/aL8Od14/nQ32B3ausdyzT
         tgeXXAHmJEBSrE0eMqKEZRrUx5OsSWHlLahYD3k/AQAQxnhxtLWOkfHtvG8OP/7XzVcL
         k4Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=czrfw6zGMNqQokKkTKz9bsRdwo0W+o1G6oGlRZsSGc0=;
        b=L91l6EKMHL+ROmYcs00oTiPBbHJuFXhMFJqOWhXtQpy6o2vevMecHqA+7PbfvW20R/
         PM8CXG/qyjFTnn65AtFFy9Eed+Ndqaro7z9gEm1B+uKdv8NOfom842Vc0H7GhmpTp6QA
         1YGbN0GsHRRLGbPEv9aT2DqR7FRYvuw0jGHy5LaExBjtZe3SHoiLTf+ybJCSO+4CK41W
         UqGhRrJqDJ0jLYPPYph2H4FXhDDXFjkBz/9B1JsYLcgCSGErk8URW88bA89Wu+HWOv4X
         6Tmdz+NWUyiqqhnDNdajFoZLxYinxwzhJiHKyjh6dRciDFH+YPPS9vKrtw/w7ZwP37N9
         7/1A==
X-Gm-Message-State: ACrzQf1tvx5lBQ1HJOTUkA6jfHKpkM3Vz6IYV6E9k4XZJiswwyhB3MdB
        qjUJntR2azVaDgC84i1Z0VEeLg==
X-Google-Smtp-Source: AMsMyM7DnNDS/xcv/8ZDummhAPLhoq1NEJ6vTp7Cfnjuk52fKhzO1+4jyPaj2IRAL8hGp+0bD45Fzg==
X-Received: by 2002:a17:90a:12c4:b0:213:fbf0:319a with SMTP id b4-20020a17090a12c400b00213fbf0319amr35375398pjg.65.1667791898468;
        Sun, 06 Nov 2022 19:31:38 -0800 (PST)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.251])
        by smtp.gmail.com with ESMTPSA id ci11-20020a17090afc8b00b0020de216d0f7sm3179114pjb.18.2022.11.06.19.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 19:31:37 -0800 (PST)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     dvyukov@google.com, jgg@nvidia.com, willy@infradead.org,
        akinobu.mita@gmail.com
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Subject: [PATCH] mm: fix unexpected changes to {failslab|fail_page_alloc}.attr
Date:   Mon,  7 Nov 2022 11:31:09 +0800
Message-Id: <20221107033109.59709-1-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <CACT4Y+Zc21Aj+5KjeTEsvOysJGHRYDSKgu_+_xN1LUYfG_H0sg@mail.gmail.com>
References: <CACT4Y+Zc21Aj+5KjeTEsvOysJGHRYDSKgu_+_xN1LUYfG_H0sg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we specify __GFP_NOWARN, we only expect that no warnings
will be issued for current caller. But in the __should_failslab()
and __should_fail_alloc_page(), the local GFP flags alter the
global {failslab|fail_page_alloc}.attr, which is persistent and
shared by all tasks. This is not what we expected, let's fix it.

Cc: stable@vger.kernel.org
Fixes: 3f913fc5f974 ("mm: fix missing handler for __GFP_NOWARN")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/fault-inject.h |  7 +++++--
 lib/fault-inject.c           | 14 +++++++++-----
 mm/failslab.c                |  6 ++++--
 mm/page_alloc.c              |  6 ++++--
 4 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index 9f6e25467844..444236dadcf0 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -20,7 +20,6 @@ struct fault_attr {
 	atomic_t space;
 	unsigned long verbose;
 	bool task_filter;
-	bool no_warn;
 	unsigned long stacktrace_depth;
 	unsigned long require_start;
 	unsigned long require_end;
@@ -32,6 +31,10 @@ struct fault_attr {
 	struct dentry *dname;
 };
 
+enum fault_flags {
+	FAULT_NOWARN =	1 << 0,
+};
+
 #define FAULT_ATTR_INITIALIZER {					\
 		.interval = 1,						\
 		.times = ATOMIC_INIT(1),				\
@@ -40,11 +43,11 @@ struct fault_attr {
 		.ratelimit_state = RATELIMIT_STATE_INIT_DISABLED,	\
 		.verbose = 2,						\
 		.dname = NULL,						\
-		.no_warn = false,					\
 	}
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
 int setup_fault_attr(struct fault_attr *attr, char *str);
+bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags);
 bool should_fail(struct fault_attr *attr, ssize_t size);
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index 4b8fafce415c..5971f7c3e49e 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -41,9 +41,6 @@ EXPORT_SYMBOL_GPL(setup_fault_attr);
 
 static void fail_dump(struct fault_attr *attr)
 {
-	if (attr->no_warn)
-		return;
-
 	if (attr->verbose > 0 && __ratelimit(&attr->ratelimit_state)) {
 		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure.\n"
 		       "name %pd, interval %lu, probability %lu, "
@@ -103,7 +100,7 @@ static inline bool fail_stacktrace(struct fault_attr *attr)
  * http://www.nongnu.org/failmalloc/
  */
 
-bool should_fail(struct fault_attr *attr, ssize_t size)
+bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags)
 {
 	bool stack_checked = false;
 
@@ -152,13 +149,20 @@ bool should_fail(struct fault_attr *attr, ssize_t size)
 		return false;
 
 fail:
-	fail_dump(attr);
+	if (!(flags & FAULT_NOWARN))
+		fail_dump(attr);
 
 	if (atomic_read(&attr->times) != -1)
 		atomic_dec_not_zero(&attr->times);
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(should_fail_ex);
+
+bool should_fail(struct fault_attr *attr, ssize_t size)
+{
+	return should_fail_ex(attr, size, 0);
+}
 EXPORT_SYMBOL_GPL(should_fail);
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
diff --git a/mm/failslab.c b/mm/failslab.c
index 58df9789f1d2..fc046f26606c 100644
--- a/mm/failslab.c
+++ b/mm/failslab.c
@@ -16,6 +16,8 @@ static struct {
 
 bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
 {
+	int flags = 0;
+
 	/* No fault-injection for bootstrap cache */
 	if (unlikely(s == kmem_cache))
 		return false;
@@ -31,9 +33,9 @@ bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
 		return false;
 
 	if (gfpflags & __GFP_NOWARN)
-		failslab.attr.no_warn = true;
+		flags |= FAULT_NOWARN;
 
-	return should_fail(&failslab.attr, s->object_size);
+	return should_fail_ex(&failslab.attr, s->object_size, flags);
 }
 
 static int __init setup_failslab(char *str)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7192ded44ad0..e537d3a950a4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3902,6 +3902,8 @@ __setup("fail_page_alloc=", setup_fail_page_alloc);
 
 static bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
+	int flags = 0;
+
 	if (order < fail_page_alloc.min_order)
 		return false;
 	if (gfp_mask & __GFP_NOFAIL)
@@ -3913,9 +3915,9 @@ static bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 		return false;
 
 	if (gfp_mask & __GFP_NOWARN)
-		fail_page_alloc.attr.no_warn = true;
+		flags |= FAULT_NOWARN;
 
-	return should_fail(&fail_page_alloc.attr, 1 << order);
+	return should_fail_ex(&fail_page_alloc.attr, 1 << order, flags);
 }
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-- 
2.20.1

