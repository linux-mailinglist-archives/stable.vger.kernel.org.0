Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D81B52C293
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 20:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241440AbiERSkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 14:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241486AbiERSk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 14:40:28 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7907A219C3A
        for <stable@vger.kernel.org>; Wed, 18 May 2022 11:40:26 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id a18-20020a631a52000000b003f27e4b38d9so1532568pgm.16
        for <stable@vger.kernel.org>; Wed, 18 May 2022 11:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BtljDGIYMSt7stTIG7fyq80+VzfiQmBQrqRRi/gbS3o=;
        b=kmDYGaReJd/KXo7Ezw5Uf9VlhE7LDB9oYIgPc83VYtC5ZIRwgjqyH6tCuF5MFzKnat
         yo7vujiln1iHREzpc9X6JPEr9XxnyEIQbuf5ubEz0bNZ7QUaCQojj/RoUUcF6hLnq4MH
         8EPtehIK9pkSTaf64TGMTISCBtqBrW+LgeBjOFgEqZBkUscaKffTaQ+kNC+L8EwYgw62
         lD21q0R12ird0H90PxhElCcSQNmIQXDAgteeWT6XRUPrdF7u9vmaV2A23untGY9PFvBL
         mvgkp5bJh9JHFeMquVbFgnM5SEyO5arZnu0zaaO7v6q+xaEnIr+RBpOl414wRZf6bZWw
         tdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BtljDGIYMSt7stTIG7fyq80+VzfiQmBQrqRRi/gbS3o=;
        b=IX2SlewE3O4KlKaZunkecn/psXGzn47c/lUHiG+dZpPRQ/+jPw9U4wNM3HWiJwpKlI
         Jeepv3jFR0otjFwU28fWOIMzdHdPTdb6FoaWfbhO/R/x8a40AYao3h+rVgvvzp6T8Ncq
         m6Wbj+FUVSdkwxH7ZqQYpTN1CHVVVohAgk1lWkZAwRYrFLfY2fJG0vtMEGpEAqxczbG1
         AtD2tcD3gyWXQhXC8wH8HDVrJq0H0XQrRdLCT/BNcwY0W3q1h8MiRu1r9LURUrLLk5nv
         W6UdFJSJphX+JwRAAvG8U46miflI09kmI9orjKZr/VJwE8UTtXz4Dvm6NQXL2vqJiE77
         APhg==
X-Gm-Message-State: AOAM531P+RBjN0oXdz0rgCJK2Alz0SS/xjMltdIJS0JGY1hT74FCSrZ3
        bHDT4UQRLKSpmkwgWvAFq9IYF8r22KbnWo4i+b+o3OmNY2xd7mbc2svWuCRHawAD8Zhl9aUjq0x
        w/hwFL0p9a1kuzYFOSh9kN7RN5qmQi0VK57aODt6fQ0TtrW3uc79dZQBv4RdowJferFJN4E7f4b
        pBC2fl/uM=
X-Google-Smtp-Source: ABdhPJy169vdkhNfxZjcn3G9Ubk+jRPcg7IxZjmNIHCoySwtsH125ZwqRa0GJZNEc1w1a8ic4wDypWHzZTBwUetlt2wrxQ==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a17:903:2281:b0:15e:95f7:37d1 with
 SMTP id b1-20020a170903228100b0015e95f737d1mr752700plh.18.1652899225770; Wed,
 18 May 2022 11:40:25 -0700 (PDT)
Date:   Wed, 18 May 2022 18:40:10 +0000
In-Reply-To: <20220518184011.789699-1-meenashanmugam@google.com>
Message-Id: <20220518184011.789699-4-meenashanmugam@google.com>
Mime-Version: 1.0
References: <20220518184011.789699-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 5.4 3/4] SUNRPC: Don't call connect() more than once on a TCP socket
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, trond.myklebust@hammerspace.com,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
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

commit 89f42494f92f448747bd8a7ab1ae8b5d5520577d upstream.

Avoid socket state races due to repeated calls to ->connect() using the
same socket. If connect() returns 0 due to the connection having
completed, but we are in fact in a closing state, then we may leave the
XPRT_CONNECTING flag set on the transport.

Reported-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Fixes: 3be232f11a3c ("SUNRPC: Prevent immediate close+reconnect")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
[meenashanmugam: Fix merge conflict in xs_tcp_setup_socket]
Signed-off-by: Meena Shanmugam <meenashanmugam@google.com>
---
 Added fallthrough which I missed in 5.10 patch.

 include/linux/sunrpc/xprtsock.h |  1 +
 net/sunrpc/xprtsock.c           | 22 ++++++++++++----------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/linux/sunrpc/xprtsock.h b/include/linux/sunrpc/xprtsock.h
index a940de03808d..46deca97e806 100644
--- a/include/linux/sunrpc/xprtsock.h
+++ b/include/linux/sunrpc/xprtsock.h
@@ -90,6 +90,7 @@ struct sock_xprt {
 #define XPRT_SOCK_WAKE_WRITE	(5)
 #define XPRT_SOCK_WAKE_PENDING	(6)
 #define XPRT_SOCK_WAKE_DISCONNECT	(7)
+#define XPRT_SOCK_CONNECT_SENT	(8)
 
 #endif /* __KERNEL__ */
 
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 49ba817f4fb6..29e9c54a89d3 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2384,10 +2384,14 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 	struct rpc_xprt *xprt = &transport->xprt;
 	int status = -EIO;
 
-	if (!sock) {
-		sock = xs_create_sock(xprt, transport,
-				xs_addr(xprt)->sa_family, SOCK_STREAM,
-				IPPROTO_TCP, true);
+	if (xprt_connected(xprt))
+		goto out;
+	if (test_and_clear_bit(XPRT_SOCK_CONNECT_SENT,
+			       &transport->sock_state) ||
+	    !sock) {
+		xs_reset_transport(transport);
+		sock = xs_create_sock(xprt, transport, xs_addr(xprt)->sa_family,
+				      SOCK_STREAM, IPPROTO_TCP, true);
 		if (IS_ERR(sock)) {
 			status = PTR_ERR(sock);
 			goto out;
@@ -2418,6 +2422,8 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 		break;
 	case 0:
 	case -EINPROGRESS:
+		set_bit(XPRT_SOCK_CONNECT_SENT, &transport->sock_state);
+		fallthrough;
 	case -EALREADY:
 		xprt_unlock_connect(xprt, transport);
 		return;
@@ -2469,13 +2475,9 @@ static void xs_connect(struct rpc_xprt *xprt, struct rpc_task *task)
 
 	WARN_ON_ONCE(!xprt_lock_connect(xprt, task, transport));
 
-	if (transport->sock != NULL && !xprt_connecting(xprt)) {
+	if (transport->sock != NULL) {
 		dprintk("RPC:       xs_connect delayed xprt %p for %lu "
-				"seconds\n",
-				xprt, xprt->reestablish_timeout / HZ);
-
-		/* Start by resetting any existing state */
-		xs_reset_transport(transport);
+			"seconds\n", xprt, xprt->reestablish_timeout / HZ);
 
 		delay = xprt_reconnect_delay(xprt);
 		xprt_reconnect_backoff(xprt, XS_TCP_INIT_REEST_TO);
-- 
2.36.1.124.g0e6072fb45-goog

