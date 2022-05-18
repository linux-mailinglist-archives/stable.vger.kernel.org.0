Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB4452C27E
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 20:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241280AbiERSkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 14:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241442AbiERSkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 14:40:21 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8D1219C3C
        for <stable@vger.kernel.org>; Wed, 18 May 2022 11:40:20 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e18-20020a170902ef5200b0016153d857a6so1298884plx.5
        for <stable@vger.kernel.org>; Wed, 18 May 2022 11:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WbnHWDFwkzF1nH+9rKz8c4upemDF2LmXMXvz56kytCo=;
        b=hAWCnztYcLE9PDvmDD9D8sF/T5UllxTr1a5457xRjSGpTWotOgOSpLUgR64Rft6w4q
         ClxdZU1tdLl2uFvHM9tp1ADgp6il4fMjUv739vOQcvvAFwyVbPPEuXKysiKHYhOf9Q8s
         K28xZA+N7CRwNpNBrUpKZ2dhLXAilJE1N4lT4sZt50ArN3pOP8eA7p29szzJB5AIzHPp
         h0AKodo1iw24eNMbUZ0B2AGbeES8irQIWWOiXbp/chvANbKovJJlcrzI00jl1nYtt5lB
         GEN+bm1vVz6vLB30gQFBKxC3+cZGU3SziXwMyy+hjOMEQHhnS9NA7Px8dg7WUYgGWH71
         e0wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WbnHWDFwkzF1nH+9rKz8c4upemDF2LmXMXvz56kytCo=;
        b=XPPDOq9U70o72f8Pq8TCOxS2WcJpec60gDew/rMgqW3iSy5x3w07xrZSskDVAKBFaf
         xOvLqYfwDqKkEtDz6MaDVMvf36akjEh2hLMJmlARuRhA96F+8l3fVTrW28KsPHXY7Xic
         xEy7HOA+VAtKNKCEblcFrZ4rHmsO16L4TKgCTp8VrfBJh1cNJDJ0KPnatDl7t2q9WUBy
         /vSkBm442kbG073rJwwrSmXvmkUwyMrW/kew6KgDGE+eb0aRg+4n+nuUUW8pKZx7pQhP
         0ojgqR3mU0VkKR/BCNPcjdOk6bgr06R9/VtHHHQGeC8yR/enU/GC/bQZ50Qnxj6l92wY
         mcRg==
X-Gm-Message-State: AOAM531IQ6zNyXgAUFMH3JQCbTWD4KuUNM8sDFsyNZznxbt5q93EhJpK
        LQYwo1t1Lce/7/zkA6CXKMv34bGWYnWyCp8iHKYg64bEaypqpoXLGz+R2hb8gKR5DiRsQE5tbH0
        dDnS1KU34NnxWdzvQ/h5WldXFmD40oWBfPfynaDmE7YD2qm1rtV5ypnC1tYMXNscSIbWAfTvRaX
        HL/MsVp/8=
X-Google-Smtp-Source: ABdhPJwe7AS6PmkuZ3DQLdlQVgLx0TU6c+rObfKvZSPWgEOALnpr922DzCW2UY4Pws3Xycn4tsL8XnLJBxMKQmDOZzv/2A==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a17:902:9a92:b0:161:4e50:3b80 with
 SMTP id w18-20020a1709029a9200b001614e503b80mr868972plp.149.1652899220044;
 Wed, 18 May 2022 11:40:20 -0700 (PDT)
Date:   Wed, 18 May 2022 18:40:08 +0000
In-Reply-To: <20220518184011.789699-1-meenashanmugam@google.com>
Message-Id: <20220518184011.789699-2-meenashanmugam@google.com>
Mime-Version: 1.0
References: <20220518184011.789699-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 5.4 1/4] SUNRPC: Clean up scheduling of autoclose
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, trond.myklebust@hammerspace.com,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Meena Shanmugam <meenashanmugam@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit e26d9972720e2484f44cdd94ca4e31cc372ed2ed upstream.

Consolidate duplicated code in xprt_force_disconnect() and
xprt_conditional_disconnect().

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Meena Shanmugam <meenashanmugam@google.com>
---
 net/sunrpc/xprt.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 8ac579778e48..a7dedc12c982 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -717,21 +717,29 @@ void xprt_disconnect_done(struct rpc_xprt *xprt)
 EXPORT_SYMBOL_GPL(xprt_disconnect_done);
 
 /**
- * xprt_force_disconnect - force a transport to disconnect
+ * xprt_schedule_autoclose_locked - Try to schedule an autoclose RPC call
  * @xprt: transport to disconnect
- *
  */
-void xprt_force_disconnect(struct rpc_xprt *xprt)
+static void xprt_schedule_autoclose_locked(struct rpc_xprt *xprt)
 {
-	/* Don't race with the test_bit() in xprt_clear_locked() */
-	spin_lock(&xprt->transport_lock);
 	set_bit(XPRT_CLOSE_WAIT, &xprt->state);
-	/* Try to schedule an autoclose RPC call */
 	if (test_and_set_bit(XPRT_LOCKED, &xprt->state) == 0)
 		queue_work(xprtiod_workqueue, &xprt->task_cleanup);
 	else if (xprt->snd_task && !test_bit(XPRT_SND_IS_COOKIE, &xprt->state))
 		rpc_wake_up_queued_task_set_status(&xprt->pending,
 						   xprt->snd_task, -ENOTCONN);
+}
+
+/**
+ * xprt_force_disconnect - force a transport to disconnect
+ * @xprt: transport to disconnect
+ *
+ */
+void xprt_force_disconnect(struct rpc_xprt *xprt)
+{
+	/* Don't race with the test_bit() in xprt_clear_locked() */
+	spin_lock(&xprt->transport_lock);
+	xprt_schedule_autoclose_locked(xprt);
 	spin_unlock(&xprt->transport_lock);
 }
 EXPORT_SYMBOL_GPL(xprt_force_disconnect);
@@ -771,11 +779,7 @@ void xprt_conditional_disconnect(struct rpc_xprt *xprt, unsigned int cookie)
 		goto out;
 	if (test_bit(XPRT_CLOSING, &xprt->state))
 		goto out;
-	set_bit(XPRT_CLOSE_WAIT, &xprt->state);
-	/* Try to schedule an autoclose RPC call */
-	if (test_and_set_bit(XPRT_LOCKED, &xprt->state) == 0)
-		queue_work(xprtiod_workqueue, &xprt->task_cleanup);
-	xprt_wake_pending_tasks(xprt, -EAGAIN);
+	xprt_schedule_autoclose_locked(xprt);
 out:
 	spin_unlock(&xprt->transport_lock);
 }
-- 
2.36.1.124.g0e6072fb45-goog

