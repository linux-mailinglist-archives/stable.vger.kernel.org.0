Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9113752C285
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 20:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241492AbiERSka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 14:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241440AbiERSk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 14:40:26 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60031DF664
        for <stable@vger.kernel.org>; Wed, 18 May 2022 11:40:23 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id h13-20020a170902f70d00b0015f4cc5d19aso1292146plo.18
        for <stable@vger.kernel.org>; Wed, 18 May 2022 11:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gP4Q8X67UbKka3WeqW3mNbIGLQ/1tYInvWHQhzo+oN0=;
        b=VmcZpy3iViSoauB7FCVHO5bzRkkPms0FhMNjGDJk3kApdk6OVA8/8tz4Kf7W1vlpVZ
         15SJ9FS2Z1DQdIUbM8ZWc472gfkkpTxQ9A6wQrbPWzl4AZPDihuapf7zu2xWmXsuGBdI
         A5yPyyEwV9m9aA8gVJOTiLtXdNltj8k8WAZP6lTEZY+LlsrY0UVYeLB2E/0Pyv6uj6Tp
         tQMHYfLMsLZyINraydVswPvVti0W+0F/HT0gXhMbYku3Ebt4+irbgWEGTIJ1JGX7CMJt
         gR8RkC1z0G2gCT1GMl+DT3pyWw+H+jO/EMDhD7P2ib7tCaIDmsIx+Wg58pyn6Mux51DA
         IBOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gP4Q8X67UbKka3WeqW3mNbIGLQ/1tYInvWHQhzo+oN0=;
        b=t8yAZ5k30sUBAuM8+B7HR9JrgUk5AF4t+Hf9EkhlmTNxlmFhKYRFUqA+EJsqHlgF3R
         LNYy5nEigFt2Lyn0QcH6eDBKp1OpZ85pPCEo4ZtfZ0W8v3JnUR+RZq4PGQRzWglvp2X5
         lMSue9/faEwZbHkpYtLYPzQpjmfqYljPdSHbLiutHtA+Lj+pSVJodUCLC6Op4obj6ocK
         kItlkfzD1zgq6VYEwXLa6DYIMLm3/qsvKdXK7/emlEH8tXhPJqPXm07cRLjbT1YCVBiT
         rzVLKwJWN4DnInreSdu78O+nQ0dI6W4xJTOdXqw1M71UVltYgW4nM6fc8mx5OJf4/SM6
         ZMDQ==
X-Gm-Message-State: AOAM530xvLrVYGHL/5bkGa8Z9FxHC9jsZObLyK37We9qIYLxFHmmIco9
        miar5QQhRCH38fY/F9i+27XrbNw8Qx3ksJfipD1I/G/5pc6+t5WFMafpZ92ELpSJo5tR+vdAiot
        LjiRQpA9LcIMaOZ/yQPTzhF5SbDHLPYHhrzydr7leyRPBpBtrzaYzq68GfnkH+O0UNlbDUAwb+0
        isTQH/FK0=
X-Google-Smtp-Source: ABdhPJw7Iz+b5Pf8BiKBf+QCffjvZuTNqK7PLqOI2249/ro8DhcKT+IKQpS1gRy6JsqAqqDpuZHufKNlcH7xFZNqzTAqsw==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a17:90b:1c87:b0:1ca:f4e:4fbe with
 SMTP id oo7-20020a17090b1c8700b001ca0f4e4fbemr1369876pjb.159.1652899222940;
 Wed, 18 May 2022 11:40:22 -0700 (PDT)
Date:   Wed, 18 May 2022 18:40:09 +0000
In-Reply-To: <20220518184011.789699-1-meenashanmugam@google.com>
Message-Id: <20220518184011.789699-3-meenashanmugam@google.com>
Mime-Version: 1.0
References: <20220518184011.789699-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 5.4 2/4] SUNRPC: Prevent immediate close+reconnect
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, trond.myklebust@hammerspace.com,
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

commit 3be232f11a3cc9b0ef0795e39fa11bdb8e422a06 upstream.

If we have already set up the socket and are waiting for it to connect,
then don't immediately close and retry.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Meena Shanmugam <meenashanmugam@google.com>
---
 net/sunrpc/xprt.c     | 3 ++-
 net/sunrpc/xprtsock.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index a7dedc12c982..68d08dcba018 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -722,7 +722,8 @@ EXPORT_SYMBOL_GPL(xprt_disconnect_done);
  */
 static void xprt_schedule_autoclose_locked(struct rpc_xprt *xprt)
 {
-	set_bit(XPRT_CLOSE_WAIT, &xprt->state);
+	if (test_and_set_bit(XPRT_CLOSE_WAIT, &xprt->state))
+		return;
 	if (test_and_set_bit(XPRT_LOCKED, &xprt->state) == 0)
 		queue_work(xprtiod_workqueue, &xprt->task_cleanup);
 	else if (xprt->snd_task && !test_bit(XPRT_SND_IS_COOKIE, &xprt->state))
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 43bc02dea80c..49ba817f4fb6 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2469,7 +2469,7 @@ static void xs_connect(struct rpc_xprt *xprt, struct rpc_task *task)
 
 	WARN_ON_ONCE(!xprt_lock_connect(xprt, task, transport));
 
-	if (transport->sock != NULL) {
+	if (transport->sock != NULL && !xprt_connecting(xprt)) {
 		dprintk("RPC:       xs_connect delayed xprt %p for %lu "
 				"seconds\n",
 				xprt, xprt->reestablish_timeout / HZ);
-- 
2.36.1.124.g0e6072fb45-goog

