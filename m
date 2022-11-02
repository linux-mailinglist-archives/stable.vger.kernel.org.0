Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FD7616E13
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 20:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiKBTze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 15:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiKBTzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 15:55:32 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77461036
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 12:55:31 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id bt19-20020a17090af01300b00213c7cd1083so4742839pjb.8
        for <stable@vger.kernel.org>; Wed, 02 Nov 2022 12:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nbdp27tsxp2ibpbU0lVoSCLA2OCXdLvEI7ZLDNEzxpg=;
        b=Y05NAnRqcdu94M8xftt53yInGq2qp3Mxb+n5zy4TGfMJdifv1ITs+NlPuGChcm0dKx
         fgw1u4CpK061pmB4QwDM+NSM83khrLuz+jBzmynO2Sx6EIc1+iScgIUAFraj/sivUwv0
         jn9kEKcFRetpK1xliFQh/mRY5TK1tetQSpzyIp7TuCpDp/KX0/XHtxDUXIg09aB9qcEL
         +iJ6OYu9Tg2tnVHyaaUbSKxrkfthnSLBp9kzFwv20Z05/RJkciZlss3omm0OZqOfY94u
         xzi2xkgPm3W0jlXLjTcpGd3dP3WZScZtQTQUMm/b8KIRg9zubkLqK2P8HmS4SDmamyI2
         3V5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nbdp27tsxp2ibpbU0lVoSCLA2OCXdLvEI7ZLDNEzxpg=;
        b=q50216Zgua3D2/jr4clqbSmQb+pXKHNQVwzSSAey9oBiQMg4FuHJ6xqBq4tivzi3op
         kInLP+zjuov2QUc5Zs0mrPQa89aMZl/uUHExbPVxLUL+CNXnxDyXvbduAhkPAOImDH0V
         kVPzqL4FNVKUgkDZDFXpcElgfWIiCYEoVPL/qz71yYvn5ZMlc2ivflzIm+mVqVoGwnn0
         OIvi2MBxiCoUmXHSRLsUixLQiAjiCX+FQRqc9YaTT7hw1LsfLfc6FDhFxfEec6oLSzkr
         BJRvb4a28sYExnVkeJFs9iHVZMgSZfl2MbQo75Hibfx9cbhLWyxgl+VDhJ1mVcUnXlFx
         IWyw==
X-Gm-Message-State: ACrzQf196TOfaRuR1kHPDvG1V/pqYShuQJQYKofnxSsLe5SoyMmABYn/
        XN6wDYlZdlEYM759Jar6o6Ts1ttHJiuk9hXDLg2wEV6igSDDRV1GqmxYU5+QVj4ey6hwv9sZi9u
        yvUDfbO/7P57AwKve4vf4Fqe7QzNN06kKyax6FiQ4JVq0QGx4JOvm3nx6QOvdMe5c87QyfN03rm
        DgS5Lx2M0=
X-Google-Smtp-Source: AMsMyM75dXg2pw7bvyOQI9D/LkrR22tHhv77rViti3gaOBfBmKIOF0LjywKPLEs3unq/IxtlPggDL2qkOrlyDerNHV82yQ==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a05:6a00:1582:b0:56d:4bc6:68c7 with
 SMTP id u2-20020a056a00158200b0056d4bc668c7mr20364747pfk.31.1667418931329;
 Wed, 02 Nov 2022 12:55:31 -0700 (PDT)
Date:   Wed,  2 Nov 2022 19:55:02 +0000
In-Reply-To: <20221102195502.844256-1-meenashanmugam@google.com>
Mime-Version: 1.0
References: <20221102195502.844256-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102195502.844256-2-meenashanmugam@google.com>
Subject: [PATCH 5.4 1/1] tcp/udp: Fix memory leak in ipv6_renew_options().
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, kuniyu@amazon.com,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Meena Shanmugam <meenashanmugam@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 3c52c6bb831f6335c176a0fc7214e26f43adbd11 upstream.

syzbot reported a memory leak [0] related to IPV6_ADDRFORM.

The scenario is that while one thread is converting an IPv6 socket into
IPv4 with IPV6_ADDRFORM, another thread calls do_ipv6_setsockopt() and
allocates memory to inet6_sk(sk)->XXX after conversion.

Then, the converted sk with (tcp|udp)_prot never frees the IPv6 resources,
which inet6_destroy_sock() should have cleaned up.

setsockopt(IPV6_ADDRFORM)                 setsockopt(IPV6_DSTOPTS)
+-----------------------+                 +----------------------+
- do_ipv6_setsockopt(sk, ...)
  - sockopt_lock_sock(sk)                 - do_ipv6_setsockopt(sk, ...)
    - lock_sock(sk)                         ^._ called via tcpv6_prot
  - WRITE_ONCE(sk->sk_prot, &tcp_prot)          before WRITE_ONCE()
  - xchg(&np->opt, NULL)
  - txopt_put(opt)
  - sockopt_release_sock(sk)
    - release_sock(sk)                      - sockopt_lock_sock(sk)
                                              - lock_sock(sk)
                                            - ipv6_set_opt_hdr(sk, ...)
                                              - ipv6_update_options(sk, opt)
                                                - xchg(&inet6_sk(sk)->opt, opt)
                                                  ^._ opt is never freed.

                                            - sockopt_release_sock(sk)
                                              - release_sock(sk)

Since IPV6_DSTOPTS allocates options under lock_sock(), we can avoid this
memory leak by testing whether sk_family is changed by IPV6_ADDRFORM after
acquiring the lock.

This issue exists from the initial commit between IPV6_ADDRFORM and
IPV6_PKTOPTIONS.

[0]:
BUG: memory leak
unreferenced object 0xffff888009ab9f80 (size 96):
  comm "syz-executor583", pid 328, jiffies 4294916198 (age 13.034s)
  hex dump (first 32 bytes):
    01 00 00 00 48 00 00 00 08 00 00 00 00 00 00 00  ....H...........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002ee98ae1>] kmalloc include/linux/slab.h:605 [inline]
    [<000000002ee98ae1>] sock_kmalloc+0xb3/0x100 net/core/sock.c:2566
    [<0000000065d7b698>] ipv6_renew_options+0x21e/0x10b0 net/ipv6/exthdrs.c:1318
    [<00000000a8c756d7>] ipv6_set_opt_hdr net/ipv6/ipv6_sockglue.c:354 [inline]
    [<00000000a8c756d7>] do_ipv6_setsockopt.constprop.0+0x28b7/0x4350 net/ipv6/ipv6_sockglue.c:668
    [<000000002854d204>] ipv6_setsockopt+0xdf/0x190 net/ipv6/ipv6_sockglue.c:1021
    [<00000000e69fdcf8>] tcp_setsockopt+0x13b/0x2620 net/ipv4/tcp.c:3789
    [<0000000090da4b9b>] __sys_setsockopt+0x239/0x620 net/socket.c:2252
    [<00000000b10d192f>] __do_sys_setsockopt net/socket.c:2263 [inline]
    [<00000000b10d192f>] __se_sys_setsockopt net/socket.c:2260 [inline]
    [<00000000b10d192f>] __x64_sys_setsockopt+0xbe/0x160 net/socket.c:2260
    [<000000000a80d7aa>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<000000000a80d7aa>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
    [<000000004562b5c6>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Meena Shanmugam <meenashanmugam@google.com>
---
 net/ipv6/ipv6_sockglue.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 5352c7e68c42..1d7fad8269e6 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -164,6 +164,12 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		rtnl_lock();
 	lock_sock(sk);
 
+	/* Another thread has converted the socket into IPv4 with
+	 * IPV6_ADDRFORM concurrently.
+	 */
+	if (unlikely(sk->sk_family != AF_INET6))
+		goto unlock;
+
 	switch (optname) {
 
 	case IPV6_ADDRFORM:
@@ -924,6 +930,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		break;
 	}
 
+unlock:
 	release_sock(sk);
 	if (needs_rtnl)
 		rtnl_unlock();
-- 
2.38.1.273.g43a17bfeac-goog

