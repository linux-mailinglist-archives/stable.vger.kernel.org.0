Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21493222F5
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 01:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhBWALF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 19:11:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230135AbhBWALF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 19:11:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B29F064E4D;
        Tue, 23 Feb 2021 00:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614039024;
        bh=ww2mfcAB+JE3IriRx+9asqPmLIAPsKaCJ8eDjOZaLhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyf5q5JGJxw2x7OIVX3a4AlR16G2tF1mfJlZZvXFAvvvzPRdZamaApEA7rbJfUa4K
         wzo6WIUHot2HPR465LUH5tNyCG3SqXw1aJjSkPdf0drCHeT+YopQ54HmHAvwj3VZTW
         c+hUn0rLMz7A9znamUetlXl+5XI6rfPykGdIlI879Kco2+O86vCEIKdL0VtpfrJnaV
         5OGbEZ+kNLlVFyIMGn54oHNBdmajJZt+qMxo4H+235xY2deZf0k8wElLEJX9uDx/Vy
         k/upHWDN8HkFmH5txaxjAt0wah7Iz8BQk8fUdDcXYza+t44whSuAGHMOyLD6lrN42u
         tRn2P36gWeAdQ==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 03/13] rcu/nocb: Remove stale comment above rcu_segcblist_offload()
Date:   Tue, 23 Feb 2021 01:10:01 +0100
Message-Id: <20210223001011.127063-4-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223001011.127063-1-frederic@kernel.org>
References: <20210223001011.127063-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Remove stale comment claiming that the cblist must be empty before
changing the offloading state. This applied when the offloaded state was
defined exclusively on boot.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
---
 kernel/rcu/rcu_segcblist.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/rcu/rcu_segcblist.c b/kernel/rcu/rcu_segcblist.c
index 7f181c9675f7..aaa111237b60 100644
--- a/kernel/rcu/rcu_segcblist.c
+++ b/kernel/rcu/rcu_segcblist.c
@@ -261,8 +261,7 @@ void rcu_segcblist_disable(struct rcu_segcblist *rsclp)
 }
 
 /*
- * Mark the specified rcu_segcblist structure as offloaded.  This
- * structure must be empty.
+ * Mark the specified rcu_segcblist structure as offloaded.
  */
 void rcu_segcblist_offload(struct rcu_segcblist *rsclp, bool offload)
 {
-- 
2.25.1

