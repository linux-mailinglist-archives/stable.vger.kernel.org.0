Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB5461426F
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 01:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiKAAwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 20:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKAAww (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 20:52:52 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9820D1570A
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 17:52:51 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id v1-20020aa78081000000b005636d8a1947so6451349pff.0
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 17:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4O8XNqPPtKQXZ8XyV0ME47rUA7fNUTVYuwJ/H/o+zow=;
        b=KmvcORgQUAKfDnIoVOeWgWPsS4b4YTBp7OY1hupgcXW8gqfamgacwqfpQcx+djC9QU
         4ssbDOAyBGxABOCuo823iDIbd1/cGbEL28oLjT0JS43wadYbex+9mVbWkDHT1khuOpjE
         PUUxB0HUMOQVwbzwE2a/+eRnV1Wa2FiGq/l+dUThChxNiXIdILGI+J1TI/BGQep8VwHr
         9knTmaC7+Bqam7Kl1iFk7IgenOInNItuRqIaTwpg1j4gvo/4XmdywpoNqDcajoGXpMv0
         +J0W4lA+vPjd+p6zkZRgPvfu+kk9dV9O71HgjOQaPdkULOE10eDt2JTzlsGl+6BXMvKn
         Repg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4O8XNqPPtKQXZ8XyV0ME47rUA7fNUTVYuwJ/H/o+zow=;
        b=4GJefcZQkioUt1t2iOOdbFYRQ90pCfBV/NKzCTfO3V0KjS6dT/X6KkUbAL3TBtQRH4
         jajxeneUHyVJELhKrJ9ikCStow8J8oFoMIXLCHelwUBYblqnhTgr2UW1u/qXYcLMRLMl
         Oeed8qGZbDihR+PhJno+w/sIc98AhXGPo5rucgcwUjeqnb+sK3UUjmuPozk5R45mkUbM
         TFKufT/cCekqxkuTyi46EzeBhmDHbWiAzSFj9/epQO3771wUEhcqLOQEeXYg6DIlsuFx
         +5aXdyqFIxcLlYSTkMWNxFCc8tI+xZQmeVivi4ZXqq4rZxdcyOGTff7UJy/r654aqA60
         NIJA==
X-Gm-Message-State: ACrzQf0cHLbr+b1NTOuMuWuoqE/H0XHYqlm7s+m2MZ9PfDc4nrz6LTBs
        YGkzHugWudfD4XeP0CbxVf46f6h7sOS0QGoL5tmLBZ3kda4PKuqZl3WzK3IgHME/N1bpEkWUjIN
        mVNPOW1N8za7rh7TAa7ZDRfJEO9sZSHjyH29KcYdI+ESZabSsJkD7cIWRKhmypAIf2aABXNSGVr
        qoeInL/w8=
X-Google-Smtp-Source: AMsMyM5JM32MtlHl/J/e6AZ3TT4ZOUb0oTpZF0Pc+ay4cqLfYzYloNS6ffnpz6u7CYVu/CnVLNrM1qGfqv3RcyfolN7t9w==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a17:90a:bb08:b0:213:4741:a8b with
 SMTP id u8-20020a17090abb0800b0021347410a8bmr33074pjr.89.1667263971059; Mon,
 31 Oct 2022 17:52:51 -0700 (PDT)
Date:   Tue,  1 Nov 2022 00:52:02 +0000
In-Reply-To: <20221101005202.50231-1-meenashanmugam@google.com>
Mime-Version: 1.0
References: <20221101005202.50231-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221101005202.50231-2-meenashanmugam@google.com>
Subject: [PATCH 5.15 1/1] tcp/udp: Fix memory leak in ipv6_renew_options().
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
index 8a1c78f38508..b24e0e5d55f9 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -417,6 +417,12 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
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
@@ -976,6 +982,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		break;
 	}
 
+unlock:
 	release_sock(sk);
 	if (needs_rtnl)
 		rtnl_unlock();
-- 
2.38.1.273.g43a17bfeac-goog

