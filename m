Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6A430DBAF
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbhBCNrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbhBCNrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:47:19 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B80C061793
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:45:56 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id v15so24397205wrx.4
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=glWvH/zooJaB8ZiuMmx31xOhEvfCDlYHDJ12kc3zNv8=;
        b=Byh7hCJ492o3cP67xLLIhIfoTJ2xYP/Dq7GPABZ/uil50mqHQgIHLztQZ8r3RqNSRL
         MHoU6/2hEU15UfexMQYPa46DVeftzD69Xt3kjIXMRGtO/32VQQOWJxTvXpIqrECOpxFL
         qNVvsmHrgjFhBBrGnOjDYvsdS3zX3HNQh+97jNAw9HRJ9kdhzKmGEpB/AqcCMZDecWEB
         48qaQCUmRyIEsNhihg+BrG1Lt8fnHEbKl72SEiZzss/gy6Hm0aMklmcJU1+6GxTJKWrz
         0BrIEMxh0ls5YEKBD1hvmykaVnlWJpE7matPG50KRzy5+DxLXdskSBjUQEW6DmwWsezP
         BzQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=glWvH/zooJaB8ZiuMmx31xOhEvfCDlYHDJ12kc3zNv8=;
        b=Rw+XVOu5i8Ctpc7r+AAYb8gvfD3ylKT4dnxEhheaj1wCrwG+QHJ/WuWUrhcSXXhylN
         BGWhIQPi1Dzk27PZCP/dDq9nqBEVA21rXiXWRJESI7+eMO6Mow1o8sFzGr8B5fHV6e8g
         6AUfYoPh6CNr+I0eIDSG776zuuQn7Oev+I3gz3eiCzN51Hw1Ug9VvRuI22kdnh8LVX7Q
         +oJRTAE3VTYmhUHboaOx3zdnivOHS7fyOk8CD+/Wpgd2UVB3zZ4C56dZJHgfOVKlQpzj
         8KMZKXSMSpr3XtuJx/pNhFHD9lMI9WAAyPWicMja5cL5X2rqDmVmcvQudquMXyncVbBk
         XI+A==
X-Gm-Message-State: AOAM532xpXbiErYgCUcNwzUBoHrfQsotFXB/m8/6LwhvGUewW3zTjj5Q
        xFxM/QrfEImLcJKFMfrzDeugby6Zh1uHNw==
X-Google-Smtp-Source: ABdhPJyiOhMAcCVTZSpEe0tjMYfZJsqJ2qm4FpTeh+PSPwN5d5Rucz1hQFbrhilScztrci6IptGpJw==
X-Received: by 2002:adf:ff91:: with SMTP id j17mr3502622wrr.377.1612359955005;
        Wed, 03 Feb 2021 05:45:55 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id r124sm2867900wmr.16.2021.02.03.05.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:45:54 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/10] rtmutex: Remove unused argument from rt_mutex_proxy_unlock()
Date:   Wed,  3 Feb 2021 13:45:36 +0000
Message-Id: <20210203134539.2583943-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203134539.2583943-1-lee.jones@linaro.org>
References: <20210203134539.2583943-1-lee.jones@linaro.org>
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
index 391a85dcd46c2..40b9ba24bd9a0 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -883,7 +883,7 @@ static void put_pi_state(struct futex_pi_state *pi_state)
 		list_del_init(&pi_state->list);
 		raw_spin_unlock_irq(&pi_state->owner->pi_lock);
 
-		rt_mutex_proxy_unlock(&pi_state->pi_mutex, pi_state->owner);
+		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
 	}
 
 	if (current->pi_state_cache)
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index d295821ed4cc8..6ff4156b3929e 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1696,8 +1696,7 @@ void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
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
index 09991287491d1..bea5d677fe343 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -102,8 +102,7 @@ enum rtmutex_chainwalk {
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

