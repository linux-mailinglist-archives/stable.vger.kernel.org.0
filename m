Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8E952C290
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 20:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241486AbiERSkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 14:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241489AbiERSka (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 14:40:30 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7847321AABA
        for <stable@vger.kernel.org>; Wed, 18 May 2022 11:40:29 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id e185-20020a6369c2000000b003d822d1900eso1532596pgc.19
        for <stable@vger.kernel.org>; Wed, 18 May 2022 11:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1fcfP3AJnjUUEeu4wBF5/uFPBZ/a2i5N444XtDySbME=;
        b=HnIS/56f1/Z7MwSnuB7phw4nUFU7sGOIlHQjr4x+8LiTJvPvzPHRNXlJKbuiLWiJlX
         CZPfCVwxH2J98n1CCihQ/hUSvGMQRTf9yRivHN29p/kMxthmBIPze+JLydOsonDsrXwD
         gjSBr0zkM4/33D8yRxGo6ghZBero1kJA35JZjqoH5WowhXDal23OowOdjnfIGlwzHnD4
         Z4h1F69b7sHXkx/+gaVv/tHupCXO0RDYmmTQrXkWroEGr9dDZ7anj+06T4V1TzK8VK2+
         WCS2qK2FbfUqpDM3N1y59ZGxMuIIytibBYk+CICFW1Q9mCUO/3zvkVYFdyiSF9pGeLMt
         CQ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1fcfP3AJnjUUEeu4wBF5/uFPBZ/a2i5N444XtDySbME=;
        b=sPdkDqA8MlHwFZpD5uGR/z+2VoPoiXtc30qCkoAJbZ0JPwPhs551Xfc+ocbwh7V+bU
         tUcaCVHOTEKWbrSOF2CyeefL8K/uFFPtnI8jRCwnaUPMdBOtqIObKVoEXM+oBueh/Zcl
         KMwXSwNRpKMZph8YG4//kZt4WwZWguVvyXQh2rS64Rjij5YBpTIWjx6Oc1TacJhn0lJH
         bxW6yplK03VIfvTTEjOkS2WLOLaAph/BYBcxLIw/dhT9GHfWzmkgHmL7JQ9G2vH76wbF
         6vE0FowTp5m+WKcBQH8gIl7LiBjctVwokNi6xt3nvMh8pNLb/ItXe5CGAwQpP4uigzei
         Jmkg==
X-Gm-Message-State: AOAM530awwX3PVG1I6x/Jt7AuSVDzCD5QGsBJwGKZLIBIttbskB7xsuA
        7bXAFfjQUQ20/5hDixwSkWLGRL3kwaiXy/65FnZIuaADHYhtadYRqcf5SuC64yKPiFZ66k/taeW
        0LwKCEAu4ASjpWB8DsfniLxcgE5Lqz6Y/MaBWvJ/AZRUtkD74SsEFXPdkkjoXD/wEGFLcGWFqOb
        tAvFaWOQM=
X-Google-Smtp-Source: ABdhPJzDFudEIXP/xzPKhdgkVq/4FaC4dTe+DIzyIsV5Oda+ftQAku4DUkhOGdx+ZFh3crFXOfibD7Mj2sU8EN0KypiOZQ==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a17:90b:1897:b0:1df:a48e:86cc with
 SMTP id mn23-20020a17090b189700b001dfa48e86ccmr782468pjb.53.1652899228806;
 Wed, 18 May 2022 11:40:28 -0700 (PDT)
Date:   Wed, 18 May 2022 18:40:11 +0000
In-Reply-To: <20220518184011.789699-1-meenashanmugam@google.com>
Message-Id: <20220518184011.789699-5-meenashanmugam@google.com>
Mime-Version: 1.0
References: <20220518184011.789699-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 5.4 4/4] SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, trond.myklebust@hammerspace.com,
        Felix Fu <foyjog@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
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

commit f00432063db1a0db484e85193eccc6845435b80e upstream.

We must ensure that all sockets are closed before we call xprt_free()
and release the reference to the net namespace. The problem is that
calling fput() will defer closing the socket until delayed_fput() gets
called.
Let's fix the situation by allowing rpciod and the transport teardown
code (which runs on the system wq) to call __fput_sync(), and directly
close the socket.

Reported-by: Felix Fu <foyjog@gmail.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Fixes: a73881c96d73 ("SUNRPC: Fix an Oops in udp_poll()")
Cc: stable@vger.kernel.org # 5.1.x: 3be232f11a3c: SUNRPC: Prevent immediate close+reconnect
Cc: stable@vger.kernel.org # 5.1.x: 89f42494f92f: SUNRPC: Don't call connect() more than once on a TCP socket
Cc: stable@vger.kernel.org # 5.1.x
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
[meenashanmugam: Fix merge conflict in xprt_connect]
Signed-off-by: Meena Shanmugam <meenashanmugam@google.com>
---
 fs/file_table.c       |  1 +
 net/sunrpc/xprt.c     |  5 +----
 net/sunrpc/xprtsock.c | 16 +++++++++++++---
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 30d55c9a1744..70e8fb68a171 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -375,6 +375,7 @@ void __fput_sync(struct file *file)
 }
 
 EXPORT_SYMBOL(fput);
+EXPORT_SYMBOL(__fput_sync);
 
 void __init files_init(void)
 {
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 68d08dcba018..94ae95c57f78 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -868,10 +868,7 @@ void xprt_connect(struct rpc_task *task)
 	if (!xprt_lock_write(xprt, task))
 		return;
 
-	if (test_and_clear_bit(XPRT_CLOSE_WAIT, &xprt->state))
-		xprt->ops->close(xprt);
-
-	if (!xprt_connected(xprt)) {
+	if (!xprt_connected(xprt) && !test_bit(XPRT_CLOSE_WAIT, &xprt->state)) {
 		task->tk_rqstp->rq_connect_cookie = xprt->connect_cookie;
 		rpc_sleep_on_timeout(&xprt->pending, task, NULL,
 				xprt_request_timeout(task->tk_rqstp));
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 29e9c54a89d3..81f0e03b71b6 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -989,7 +989,7 @@ static int xs_local_send_request(struct rpc_rqst *req)
 
 	/* Close the stream if the previous transmission was incomplete */
 	if (xs_send_request_was_aborted(transport, req)) {
-		xs_close(xprt);
+		xprt_force_disconnect(xprt);
 		return -ENOTCONN;
 	}
 
@@ -1027,7 +1027,7 @@ static int xs_local_send_request(struct rpc_rqst *req)
 			-status);
 		/* fall through */
 	case -EPIPE:
-		xs_close(xprt);
+		xprt_force_disconnect(xprt);
 		status = -ENOTCONN;
 	}
 
@@ -1303,6 +1303,16 @@ static void xs_reset_transport(struct sock_xprt *transport)
 
 	if (sk == NULL)
 		return;
+	/*
+	 * Make sure we're calling this in a context from which it is safe
+	 * to call __fput_sync(). In practice that means rpciod and the
+	 * system workqueue.
+	 */
+	if (!(current->flags & PF_WQ_WORKER)) {
+		WARN_ON_ONCE(1);
+		set_bit(XPRT_CLOSE_WAIT, &xprt->state);
+		return;
+	}
 
 	if (atomic_read(&transport->xprt.swapper))
 		sk_clear_memalloc(sk);
@@ -1326,7 +1336,7 @@ static void xs_reset_transport(struct sock_xprt *transport)
 	mutex_unlock(&transport->recv_mutex);
 
 	trace_rpc_socket_close(xprt, sock);
-	fput(filp);
+	__fput_sync(filp);
 
 	xprt_disconnect_done(xprt);
 }
-- 
2.36.1.124.g0e6072fb45-goog

