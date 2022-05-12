Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C0352461A
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 08:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiELGtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 02:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbiELGtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 02:49:03 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D33B1F35C3
        for <stable@vger.kernel.org>; Wed, 11 May 2022 23:49:02 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c14so3975596pfn.2
        for <stable@vger.kernel.org>; Wed, 11 May 2022 23:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NiKq6ua4XX0y5OEKxZgT7QhR/sRXIeAAxnJTP1kMuJU=;
        b=L3CwZ+3RZe76bDE7g2JYPL9Nqm310lU6VAoTncvt2A1eM+yB4ei0ij1eQmj/MgnwmX
         QmWXtqD2z5G9rt+gbTQuhRmO1fLRcOpyW1c1Rv1TEwPAayxekUtXRPuO2w3n7FzYq2D6
         abr5mntIdhJydKQSaFQHzjJCRiPxEDZlMxVMs7fZunREwu8x2NAr8lw8VTI6LaJYl77W
         wNP/EziB6eDtBiU1TX82185c6LuXKwBch3vnxE/ZQAzeBqqDn5zZfQaOYeYPlf67TC+m
         EuGoH43Ysey+SRa729Z8v3lpNX2yc5fqmUI67qo6ZbyvSXR08y/GkHXurPgeIkXcaJnZ
         bpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NiKq6ua4XX0y5OEKxZgT7QhR/sRXIeAAxnJTP1kMuJU=;
        b=wz1dMZFoAi2sZT8tlrVUkNsa1V6umEQzTHnl32d2LykTJWmxXHAlOTQ+XEJqHyfEgi
         14nI8SFP69PRMrE9iKFC0jrLkwIxqSyU6dB49+tZmznRpA+ElVNIp6avotdHVT4Cr2Tz
         auTz+A0/c8MEXOBX/cMA4EP+p/mzifqOkp7cK1JWLE4dc9jiz3nmXjo1oHXJ/aDusXW6
         Qwe1k+1e9sjk6hrw0lGRCRAOwzfCfzoIE6edI6Jk51TP6/7ijR1wWvsQmkO3hd1iQY0h
         m1DLW8HyYZTSsg9U13o09id97h7KO3+EqyBk8fAw2HzzGYs6sEFvnCyzSRg/1Vgf13Eu
         SKbQ==
X-Gm-Message-State: AOAM533Kc5AKT2npXRSwUCjSKHvivWyls4Ctodct74N+NaG5F1JOQ+Dp
        xXpnhGsGvXk+B/Sa/9hm64Tcbfd842E=
X-Google-Smtp-Source: ABdhPJw6I9eMLqdCd4BZQ/IUdiQwdBm0DIpWxyPfWsv4W0vfBRSZD7mNbpom5olB/v42nNcOlGvpvg==
X-Received: by 2002:a63:6aca:0:b0:3ab:a56:126a with SMTP id f193-20020a636aca000000b003ab0a56126amr23817669pgc.576.1652338141685;
        Wed, 11 May 2022 23:49:01 -0700 (PDT)
Received: from localhost (subs28-116-206-12-56.three.co.id. [116.206.12.56])
        by smtp.gmail.com with ESMTPSA id y20-20020a17090abd1400b001deb92de665sm1010751pjr.46.2022.05.11.23.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 23:49:00 -0700 (PDT)
Date:   Thu, 12 May 2022 13:48:57 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Meena Shanmugam <meenashanmugam@google.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        trond.myklebust@hammerspace.com,
        Dexter Rivera <riverade@google.com>
Subject: Re: Request to cherry-pick f00432063db1 to 5.10
Message-ID: <Ynyt2bI4dgO2gcFz@debian.me>
References: <CAMdnWFC4+-mEubOVkzaoqC5jnJCwY5hpcQtDnkmgqJ-mY5_GYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMdnWFC4+-mEubOVkzaoqC5jnJCwY5hpcQtDnkmgqJ-mY5_GYg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 07:33:23PM -0700, Meena Shanmugam wrote:
> From: Trond Myklebust <trond.myklebust@hammerspace.com>
> Date: Wed, 16 Mar 2022 19:10:43 -0400
> Subject: [PATCH] SUNRPC: Don't call connect() more than once on a TCP socket
> 
> commit 89f42494f92f448747bd8a7ab1ae8b5d5520577d upstream.
> 
> Avoid socket state races due to repeated calls to ->connect() using the
> same socket. If connect() returns 0 due to the connection having
> completed, but we are in fact in a closing state, then we may leave the
> XPRT_CONNECTING flag set on the transport.
> 
> Reported-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> Fixes: 3be232f11a3c ("SUNRPC: Prevent immediate close+reconnect")
> Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
> [meenashanmugam: Backported to 5.10: Fixed merge conflict in
> xs_tcp_setup_socket]
> Signed-off-by: Meena Shanmugam <meena.shanmugam@google.com>
> ---
>  include/linux/sunrpc/xprtsock.h |  1 +
>  net/sunrpc/xprtsock.c           | 21 +++++++++++----------
>  2 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/sunrpc/xprtsock.h b/include/linux/sunrpc/xprtsock.h
> index 8c2a712cb242..689062afdd61 100644
> --- a/include/linux/sunrpc/xprtsock.h
> +++ b/include/linux/sunrpc/xprtsock.h
> @@ -89,5 +89,6 @@ struct sock_xprt {
>  #define XPRT_SOCK_WAKE_WRITE (5)
>  #define XPRT_SOCK_WAKE_PENDING (6)
>  #define XPRT_SOCK_WAKE_DISCONNECT (7)
> +#define XPRT_SOCK_CONNECT_SENT (8)
> 
>  #endif /* _LINUX_SUNRPC_XPRTSOCK_H */
> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
> index 60c58eb9a456..33a81f9703b1 100644
> --- a/net/sunrpc/xprtsock.c
> +++ b/net/sunrpc/xprtsock.c
> @@ -2260,10 +2260,14 @@ static void xs_tcp_setup_socket(struct
> work_struct *work)
>   struct rpc_xprt *xprt = &transport->xprt;
>   int status = -EIO;
> 
> - if (!sock) {
> - sock = xs_create_sock(xprt, transport,
> - xs_addr(xprt)->sa_family, SOCK_STREAM,
> - IPPROTO_TCP, true);
> + if (xprt_connected(xprt))
> + goto out;
> + if (test_and_clear_bit(XPRT_SOCK_CONNECT_SENT,
> +        &transport->sock_state) ||
> +     !sock) {
> + xs_reset_transport(transport);
> + sock = xs_create_sock(xprt, transport, xs_addr(xprt)->sa_family,
> +       SOCK_STREAM, IPPROTO_TCP, true);
>   if (IS_ERR(sock)) {
>   status = PTR_ERR(sock);
>   goto out;
> @@ -2294,6 +2298,7 @@ static void xs_tcp_setup_socket(struct work_struct *work)
>   break;
>   case 0:
>   case -EINPROGRESS:
> + set_bit(XPRT_SOCK_CONNECT_SENT, &transport->sock_state);
>   case -EALREADY:
>   xprt_unlock_connect(xprt, transport);
>   return;
> @@ -2345,13 +2350,9 @@ static void xs_connect(struct rpc_xprt *xprt,
> struct rpc_task *task)
> 
>   WARN_ON_ONCE(!xprt_lock_connect(xprt, task, transport));
> 
> - if (transport->sock != NULL && !xprt_connecting(xprt)) {
> + if (transport->sock != NULL) {
>   dprintk("RPC:       xs_connect delayed xprt %p for %lu "
> - "seconds\n",
> - xprt, xprt->reestablish_timeout / HZ);
> -
> - /* Start by resetting any existing state */
> - xs_reset_transport(transport);
> + "seconds\n", xprt, xprt->reestablish_timeout / HZ);
> 
>   delay = xprt_reconnect_delay(xprt);
>   xprt_reconnect_backoff(xprt, XS_TCP_INIT_REEST_TO);
> -- 
> 2.36.0.512.ge40c2bad7a-goog

Hi Meena,

The backport above didn't apply due to whitespace mangling (maybe your
mailer?). So I had to manually apply it.

Here's the proper backport:

-- >8 --

From 2ec4a7d1668a53a1f46d3413bdec6ff9cc0458a3 Mon Sep 17 00:00:00 2001
From: Bagas Sanjaya <bagasdotme@gmail.com>
Date: Thu, 12 May 2022 12:53:07 +0700
Subject: [PATCH] SUNRPC: Don't call connect() more than once on a TCP socket

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 89f42494f92f448747bd8a7ab1ae8b5d5520577d upstream.

Avoid socket state races due to repeated calls to ->connect() using the
same socket. If connect() returns 0 due to the connection having
completed, but we are in fact in a closing state, then we may leave the
XPRT_CONNECTING flag set on the transport.

Reported-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Fixes: 3be232f11a3cc9 ("SUNRPC: Prevent immediate close+reconnect")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
[meenashanmugam: Backported to 5.10: Fixed merge conflict in
xs_tcp_setup_socket]
Signed-off-by: Meena Shanmugam <meena.shanmugam@google.com>
[Bagas: Fix patch corruption by manually applying the backport]
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 include/linux/sunrpc/xprtsock.h |  1 +
 net/sunrpc/xprtsock.c           | 22 ++++++++++++----------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/linux/sunrpc/xprtsock.h b/include/linux/sunrpc/xprtsock.h
index 8c2a712cb24202..689062afdd610d 100644
--- a/include/linux/sunrpc/xprtsock.h
+++ b/include/linux/sunrpc/xprtsock.h
@@ -89,5 +89,6 @@ struct sock_xprt {
 #define XPRT_SOCK_WAKE_WRITE	(5)
 #define XPRT_SOCK_WAKE_PENDING	(6)
 #define XPRT_SOCK_WAKE_DISCONNECT	(7)
+#define XPRT_SOCK_CONNECT_SENT	(8)
 
 #endif /* _LINUX_SUNRPC_XPRTSOCK_H */
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 60c58eb9a456f1..c9975a5c769be9 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2260,10 +2260,15 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 	struct rpc_xprt *xprt = &transport->xprt;
 	int status = -EIO;
 
-	if (!sock) {
-		sock = xs_create_sock(xprt, transport,
-				xs_addr(xprt)->sa_family, SOCK_STREAM,
-				IPPROTO_TCP, true);
+	if (xprt_connected(xprt))
+		goto out;
+
+	if (test_and_clear_bit(XPRT_SOCK_CONNECT_SENT),
+	    &transport->sock_state || !sock) {
+		xs_reset_transport(transport);
+		sock = xs_create_sock(xprt, transport, xs_addr(xprt)->sa_family,
+				      SOCK_STREAM, IPPROTO_TCP, true);
+
 		if (IS_ERR(sock)) {
 			status = PTR_ERR(sock);
 			goto out;
@@ -2294,6 +2299,7 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 		break;
 	case 0:
 	case -EINPROGRESS:
+		set_bit(XPRT_SOCK_CONNECT_SENT, &transport->sock_state);
 	case -EALREADY:
 		xprt_unlock_connect(xprt, transport);
 		return;
@@ -2345,13 +2351,9 @@ static void xs_connect(struct rpc_xprt *xprt, struct rpc_task *task)
 
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
An old man doll... just what I always wanted! - Clara

Next time, configure your mailer/MUA to not mangle whitespaces. For sending
patches, it is preferred to use git-send-email(1).

FYI, CC Dexter Rivera since he's also requesting the backport [1].

[1]: https://lore.kernel.org/stable/CAG5dfppH0s-ujBjXyJJ62mGiJRiKz1NOYBPYOx3A1550Z8X7Mg@mail.gmail.com/

-- 
An old man doll... just what I always wanted! - Clara
