Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8057830FA0D
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 18:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbhBDRpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 12:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238370AbhBDRbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 12:31:04 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF5BC0617A7
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 09:29:17 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id b3so4492357wrj.5
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 09:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i0z1K40DidNKxQN3Eytjf2ywiefk/Nm8nOBl77/Mwk0=;
        b=lV28H1muNLxLI1Z7Z6duhKI24U/TSQc60I/6Md+9844vfJekkAqWxEc8EGCF2ddcbb
         0RPxFgj68JmQ3IfsazeH/vs+59gyOe79QmSO6pEVf+DmXy14s3p6k56FVyL/L+k81Kok
         ADvbsLfWOvCN1XS4ZDr4b8jS4gSnXdooIz7kLpeJaeyv38VZo939Grm5zhcnosTzzgs6
         /K0A5wScWOXuOoVBlS2i58xr1kmUKmRIUjfBCwTEy/7Zg/G7uTXU/nrNKL/DW5NIeTLr
         rjoodrCOuavdQh5q6bHn6hiadYVGD8M2oxy3MfngURF60+3sDycAxufoZRDpgL6XuLnR
         +OPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i0z1K40DidNKxQN3Eytjf2ywiefk/Nm8nOBl77/Mwk0=;
        b=NhM+hSRzGasLS/uEJljqpVxN9fN+qtzvRJ0cE5rLO6+T6/9Hk6bzFNF4nzN6Iyu4xF
         AFXIUu35SCVn6Unf1dB51C7jCoc2SziIczIM8gKyTW0oCn3jBZpqTwWGQNLtC9IJF2qd
         ofRfUXtdgY0KwIAqtlW/XhI7YTGMp7AZTW8oqEg/622zifzD0iPohZrmwjmy4mFiu1bB
         UQHD6jRcwuPA0sLTmaCi4opa5JTZZhb08MDGKp6jxD77zpvP1CB62cqnsKAmj8M4mWHj
         52gVOQKb5lBhbeOPIik9fGWmwAKg+4BRjb+2Gponx0pqmUoNdbrOjAzn83IZ1nmjvxun
         yH8g==
X-Gm-Message-State: AOAM531l6PLrFcbSPjg1yoAvKRFQblHotpznCPdi9qacEd+3en1t2etG
        jr7myTveTjmpskeG1e4rw6j5AUW7veULkQ==
X-Google-Smtp-Source: ABdhPJzCUr+VYtO9Ec0r5dcFvZdKSFW49Ljsow2JwE+2IyPg8UC7AfAPAZDEpEBEXcNXWSbteSI2Dg==
X-Received: by 2002:a5d:6a85:: with SMTP id s5mr394962wru.283.1612459755657;
        Thu, 04 Feb 2021 09:29:15 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id j7sm9641334wrp.72.2021.02.04.09.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 09:29:14 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/10] rtmutex: Remove unused argument from rt_mutex_proxy_unlock()
Date:   Thu,  4 Feb 2021 17:29:00 +0000
Message-Id: <20210204172903.2860981-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204172903.2860981-1-lee.jones@linaro.org>
References: <20210204172903.2860981-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 2156ac1934166d6deb6cd0f6ffc4c1076ec63697 ]
Nothing uses the argument. Remove it as preparation to use
pi_state_update_owner().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/futex.c                  | 2 +-
 kernel/locking/rtmutex.c        | 3 +--
 kernel/locking/rtmutex_common.h | 3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 1390ffa874a6b..bf40921ef1200 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -878,7 +878,7 @@ static void free_pi_state(struct futex_pi_state *pi_state)
 		list_del_init(&pi_state->list);
 		raw_spin_unlock_irq(&pi_state->owner->pi_lock);
 
-		rt_mutex_proxy_unlock(&pi_state->pi_mutex, pi_state->owner);
+		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
 	}
 
 	if (current->pi_state_cache)
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 45d3c9aec8533..1c0cb5c3c6ad6 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1662,8 +1662,7 @@ void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
  * No locking. Caller has to do serializing itself
  * Special API call for PI-futex support
  */
-void rt_mutex_proxy_unlock(struct rt_mutex *lock,
-			   struct task_struct *proxy_owner)
+void rt_mutex_proxy_unlock(struct rt_mutex *lock)
 {
 	debug_rt_mutex_proxy_unlock(lock);
 	rt_mutex_set_owner(lock, NULL);
diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_common.h
index ea7310b9ce83a..4584db96265d4 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -101,8 +101,7 @@ enum rtmutex_chainwalk {
 extern struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock);
 extern void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 				       struct task_struct *proxy_owner);
-extern void rt_mutex_proxy_unlock(struct rt_mutex *lock,
-				  struct task_struct *proxy_owner);
+extern void rt_mutex_proxy_unlock(struct rt_mutex *lock);
 extern int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 				     struct rt_mutex_waiter *waiter,
 				     struct task_struct *task);
-- 
2.25.1

