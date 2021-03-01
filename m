Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAAD4327D3F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbhCAL3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:29:37 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:38579 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233536AbhCAL3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:29:34 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2B3D719413E1;
        Mon,  1 Mar 2021 06:28:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 06:28:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4gdffk
        KhSFcvJPMKxdB0YUAzOMYOrmTsvPTW7NwMpDg=; b=fNNTFhj0yVMAv2quFMbYb1
        JQmHvQd79WHiriRaCKE8yJV+wb64hSPCLnNwaqLge9GUnN9yTNucuGTueboPWpNW
        EqTKWgepQpS+5V1U47ihskqJRwJMMQ2b/cEzepsKHZ9i8vkgmWA0tvTZf8gsCG8M
        +OvQ8f3Bx0gxw+KFBcTQ9CydyBDLVtGjFy1wJFZ4c+S/ZiB5Wq/yu1nirbuTgFwn
        cC05H/+oy+o8BG4xkITIUj7f0r9SjFt4Un7l3pV+iXQQ9KQzs++5Y/BTAYD75DhZ
        AlHN+nNIpLZZIlPmte0tWXaZct/ILS2SU9KLSltMkMPb5llXKjJ9y58DCccnvhQQ
        ==
X-ME-Sender: <xms:xc88YBI6ilnh5LD7PjAbBu-uHfXv0c6X9KKad670jE5Gw17jeZho2Q>
    <xme:xc88YEDMy49SM8WUJE09e2mMM4AD9Pp8PM5WBUbuJxwn_mQ8TVZS60UbHnW-KwB15
    kEJ8G8VQi-UVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:xc88YCAKWsGvBjcO8DlC1Fd3HZ2CGS9sWFoMB0FaZjQWe6qugAxpgw>
    <xmx:xc88YOA5kNOgRxmlnuwbEV3Lmm2elxMfjqQMuzz0NEv1CkJ9HLRnFg>
    <xmx:xc88YFqh_XcoxK0KqhOvvyp-09pqPTG1_q2-kn_AwZ7gz5YhnfoEyw>
    <xmx:xc88YDpn3Xc6yXFcEO9Xl9zWoMhcxKpWfW8IbidJNaHPIQPGwRAMOw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DF7A2240065;
        Mon,  1 Mar 2021 06:28:04 -0500 (EST)
Subject: FAILED: patch "[PATCH] rcu: Pull deferred rcuog wake up to rcu_eqs_enter() callers" failed to apply to 4.14-stable tree
To:     frederic@kernel.org, mingo@kernel.org, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:27:57 +0100
Message-ID: <1614598077182173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 54b7429efffc99e845ba9381bee3244f012a06c2 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <frederic@kernel.org>
Date: Mon, 1 Feb 2021 00:05:44 +0100
Subject: [PATCH] rcu: Pull deferred rcuog wake up to rcu_eqs_enter() callers

Deferred wakeup of rcuog kthreads upon RCU idle mode entry is going to
be handled differently whether initiated by idle, user or guest. Prepare
with pulling that control up to rcu_eqs_enter() callers.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-2-frederic@kernel.org

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 40e5e3dd253e..63032e5620b9 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -644,7 +644,6 @@ static noinstr void rcu_eqs_enter(bool user)
 	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, atomic_read(&rdp->dynticks));
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
 	rdp = this_cpu_ptr(&rcu_data);
-	do_nocb_deferred_wakeup(rdp);
 	rcu_prepare_for_idle();
 	rcu_preempt_deferred_qs(current);
 
@@ -672,7 +671,10 @@ static noinstr void rcu_eqs_enter(bool user)
  */
 void rcu_idle_enter(void)
 {
+	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
+
 	lockdep_assert_irqs_disabled();
+	do_nocb_deferred_wakeup(rdp);
 	rcu_eqs_enter(false);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -691,7 +693,14 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
  */
 noinstr void rcu_user_enter(void)
 {
+	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
+
 	lockdep_assert_irqs_disabled();
+
+	instrumentation_begin();
+	do_nocb_deferred_wakeup(rdp);
+	instrumentation_end();
+
 	rcu_eqs_enter(true);
 }
 #endif /* CONFIG_NO_HZ_FULL */

