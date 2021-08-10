Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52663E536D
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 08:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237770AbhHJGYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 02:24:35 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40966 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbhHJGYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 02:24:34 -0400
Date:   Tue, 10 Aug 2021 06:24:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628576652;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fnn2uGllU/uDP9M/5maKWBV/knLD9AVUGcT5bladcBk=;
        b=RU69zWxAXIWfVNAEzbwPaiUbKNcdbF3AHIh2bLqp/TbER42JU/yut3IAuh7wtxhC0rAJ75
        n0Eyvn52sO04vNG6jVJXCEkdI+awWYqVHmWAfox3pskd2fV9KTO8byh6Dm+XRj9p9kuiTN
        o4EI9rBwxu3qJKWdiI/TcstCl/Lwnkqpi4Wsnjok5qLpW7u8SqFA76RPdUBSqIGeN9vCd/
        uDOma7XiPmheLR1y94YgLwqWDLu1M1yj4/TGJDuxkF+WmD9HfXT/08F/7OX3b37BA5Ttwv
        gENf3Ge39CkBaz9S9K1uGwADqCfcHIO3Fpfp3qO7Nqsa5MzQCBcgJf5VD2KUpg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628576652;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fnn2uGllU/uDP9M/5maKWBV/knLD9AVUGcT5bladcBk=;
        b=qyYK7gQdLaNbt+9UV38pAAlhYgyqe63fct1EPGJjuQuj9wnlBG6zjF4idiReFEZzvi3JL0
        ZDVc9TF8qGOXw8Dg==
From:   "tip-bot2 for Zhen Lei" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/urgent] locking/rtmutex: Use the correct rtmutex
 debugging config option
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210731123011.4555-1-thunder.leizhen@huawei.com>
References: <20210731123011.4555-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Message-ID: <162857665079.395.8061796683786312705.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/urgent branch of tip:

Commit-ID:     07d25971b220e477eb019fcb520a9f2e3ac966af
Gitweb:        https://git.kernel.org/tip/07d25971b220e477eb019fcb520a9f2e3ac966af
Author:        Zhen Lei <thunder.leizhen@huawei.com>
AuthorDate:    Sat, 31 Jul 2021 20:30:11 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 10 Aug 2021 08:21:52 +02:00

locking/rtmutex: Use the correct rtmutex debugging config option

It's CONFIG_DEBUG_RT_MUTEXES not CONFIG_DEBUG_RT_MUTEX.

Fixes: f7efc4799f81 ("locking/rtmutex: Inline chainwalk depth check")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Boqun Feng <boqun.feng@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210731123011.4555-1-thunder.leizhen@huawei.com

---
 kernel/locking/rtmutex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index b5d9bb5..ad0db32 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -343,7 +343,7 @@ static __always_inline bool
 rt_mutex_cond_detect_deadlock(struct rt_mutex_waiter *waiter,
 			      enum rtmutex_chainwalk chwalk)
 {
-	if (IS_ENABLED(CONFIG_DEBUG_RT_MUTEX))
+	if (IS_ENABLED(CONFIG_DEBUG_RT_MUTEXES))
 		return waiter != NULL;
 	return chwalk == RT_MUTEX_FULL_CHAINWALK;
 }
