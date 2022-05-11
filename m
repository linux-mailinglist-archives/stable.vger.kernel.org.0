Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DAB5229EC
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 04:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbiEKCrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 22:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiEKCdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 22:33:36 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2044BAD122
        for <stable@vger.kernel.org>; Tue, 10 May 2022 19:33:35 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id z18so733465iob.5
        for <stable@vger.kernel.org>; Tue, 10 May 2022 19:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=VgUWM24YOAoDEDe6lyTvccl/P1eCIUHp7mNok/BNUdY=;
        b=a7ZOPzRp29cx+0Z24hYIwdEK4RVohurnXXfPEJj4glErrL6HmC0tPzx9UEi5PrxkhD
         h8l0Re+bVWl/fdH2CBz1FLVai/IQL2mcsVzSRh7zraQhe3J8BUQwJ6msCnOO+iavw2Df
         7dpFj5nTIXY/nc5ZzvFBOmnjsqQ7Ng0CdmXxZadvRBMspnQ7YfImsYnqjr206n4uGSBz
         neqwTz6HNyz3EDxNqtUw7DuxEzAQYtdQUKCkDYL+oYugydDdEyY0gAmo3+ZY0O0ZkNjg
         YoKMrsNkErTRXeSSteqrOGkjZebPT3ekCPpvjQ0/l+d04p4CYcFb3t2xcvMvqlPpg5UO
         Klyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=VgUWM24YOAoDEDe6lyTvccl/P1eCIUHp7mNok/BNUdY=;
        b=QUYi73OHB5NrXmjmmRF8mBOt17N+FO/KKSE4Exp/Gjn5JWB7hsT6jpy4f22vcudYDe
         /cuwWe4E2HUTPzkmMBO6leNEcnnUDX3+M749dDXwrsY0PnPyZmTi3k8rfyOMb725LuVX
         5lEVVooeXEEkl8hCn2jjYyGoxopBIEeIzV9M1ovN2r3Q7ETyvY6r7Jgm9ce5yAKsRcii
         xqMTvFXpTD8LHzQdUKU6wtMqIviSRpa5JVpgWE7HNlTHBwNMO8Bo8vi+2+eHhFL1nKq8
         UlQKDgHX/HGpKoISr5nlF7DeDM25NWhS927KC5Y5YL2DgTKm0qhCWAJ0i//NcMW/2hUp
         4Taw==
X-Gm-Message-State: AOAM5323F5Yd2M0xDjPmc4/d2r3lUGgWNehCsm9iuLYVoJM6l220Z+af
        hYE/e0p92nKnO0saZSKwJefELEfu68WGM0vsQbjwFCVoXgdjUQ==
X-Google-Smtp-Source: ABdhPJybR70itmvjXxb/8Eg0pWRx5H3SXUHXRgYZ95CL01msnUya7R9fTdqoiGBS9agtRiwskLBuIkROcaUICXM6+Go=
X-Received: by 2002:a05:6638:24d6:b0:32b:e72d:1a33 with SMTP id
 y22-20020a05663824d600b0032be72d1a33mr8011479jat.226.1652236414310; Tue, 10
 May 2022 19:33:34 -0700 (PDT)
MIME-Version: 1.0
From:   Meena Shanmugam <meenashanmugam@google.com>
Date:   Tue, 10 May 2022 19:33:23 -0700
Message-ID: <CAMdnWFC4+-mEubOVkzaoqC5jnJCwY5hpcQtDnkmgqJ-mY5_GYg@mail.gmail.com>
Subject: Request to cherry-pick f00432063db1 to 5.10
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, trond.myklebust@hammerspace.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

The commit f00432063db1a0db484e85193eccc6845435b80e upstream (SUNRPC:
Ensure we flush any closed sockets before xs_xprt_free()) fixes
CVE-2022-28893, hence good candidate for stable trees.
The above commit depends on 3be232f(SUNRPC: Prevent immediate
close+reconnect)  and  89f4249(SUNRPC: Don't call connect() more than
once on a TCP socket). Commit 3be232f depends on commit
e26d9972720e(SUNRPC: Clean up scheduling of autoclose).

Commits e26d9972720e, 3be232f, f00432063db1 apply cleanly on 5.10
kernel. commit 89f4249 didn't apply cleanly. I have patch for 89f4249
below.

Thanks,
Meena

From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Wed, 16 Mar 2022 19:10:43 -0400
Subject: [PATCH] SUNRPC: Don't call connect() more than once on a TCP socket

commit 89f42494f92f448747bd8a7ab1ae8b5d5520577d upstream.

Avoid socket state races due to repeated calls to ->connect() using the
same socket. If connect() returns 0 due to the connection having
completed, but we are in fact in a closing state, then we may leave the
XPRT_CONNECTING flag set on the transport.

Reported-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Fixes: 3be232f11a3c ("SUNRPC: Prevent immediate close+reconnect")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
[meenashanmugam: Backported to 5.10: Fixed merge conflict in
xs_tcp_setup_socket]
Signed-off-by: Meena Shanmugam <meena.shanmugam@google.com>
---
 include/linux/sunrpc/xprtsock.h |  1 +
 net/sunrpc/xprtsock.c           | 21 +++++++++++----------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/sunrpc/xprtsock.h b/include/linux/sunrpc/xprtsock.h
index 8c2a712cb242..689062afdd61 100644
--- a/include/linux/sunrpc/xprtsock.h
+++ b/include/linux/sunrpc/xprtsock.h
@@ -89,5 +89,6 @@ struct sock_xprt {
 #define XPRT_SOCK_WAKE_WRITE (5)
 #define XPRT_SOCK_WAKE_PENDING (6)
 #define XPRT_SOCK_WAKE_DISCONNECT (7)
+#define XPRT_SOCK_CONNECT_SENT (8)

 #endif /* _LINUX_SUNRPC_XPRTSOCK_H */
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 60c58eb9a456..33a81f9703b1 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2260,10 +2260,14 @@ static void xs_tcp_setup_socket(struct
work_struct *work)
  struct rpc_xprt *xprt = &transport->xprt;
  int status = -EIO;

- if (!sock) {
- sock = xs_create_sock(xprt, transport,
- xs_addr(xprt)->sa_family, SOCK_STREAM,
- IPPROTO_TCP, true);
+ if (xprt_connected(xprt))
+ goto out;
+ if (test_and_clear_bit(XPRT_SOCK_CONNECT_SENT,
+        &transport->sock_state) ||
+     !sock) {
+ xs_reset_transport(transport);
+ sock = xs_create_sock(xprt, transport, xs_addr(xprt)->sa_family,
+       SOCK_STREAM, IPPROTO_TCP, true);
  if (IS_ERR(sock)) {
  status = PTR_ERR(sock);
  goto out;
@@ -2294,6 +2298,7 @@ static void xs_tcp_setup_socket(struct work_struct *work)
  break;
  case 0:
  case -EINPROGRESS:
+ set_bit(XPRT_SOCK_CONNECT_SENT, &transport->sock_state);
  case -EALREADY:
  xprt_unlock_connect(xprt, transport);
  return;
@@ -2345,13 +2350,9 @@ static void xs_connect(struct rpc_xprt *xprt,
struct rpc_task *task)

  WARN_ON_ONCE(!xprt_lock_connect(xprt, task, transport));

- if (transport->sock != NULL && !xprt_connecting(xprt)) {
+ if (transport->sock != NULL) {
  dprintk("RPC:       xs_connect delayed xprt %p for %lu "
- "seconds\n",
- xprt, xprt->reestablish_timeout / HZ);
-
- /* Start by resetting any existing state */
- xs_reset_transport(transport);
+ "seconds\n", xprt, xprt->reestablish_timeout / HZ);

  delay = xprt_reconnect_delay(xprt);
  xprt_reconnect_backoff(xprt, XS_TCP_INIT_REEST_TO);
-- 
2.36.0.512.ge40c2bad7a-goog
