Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D1F6152B4
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 21:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiKAUGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 16:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAUGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 16:06:02 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0401C93C
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 13:05:59 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id o7-20020a170902d4c700b001868cdac9adso10867133plg.13
        for <stable@vger.kernel.org>; Tue, 01 Nov 2022 13:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r1iPIHP7mZcdSUCR2ACaARCaJHaLQkVWe4fuzzX1mGQ=;
        b=IxsVHVjMX+Y0d8W8lAw4Tc937nUl3/L6Y3UVEgxfddPievce9Iww26wVJhb/DCmKFk
         Ta+7vlHiTfD9JTPoNZNbBO/nK1xoiXUvWlVldGvdkwNs/RXQdgJuR1U1stPHBrPcEW8n
         MDemKbijZQrWP6dSyGsJ1+ONmMy2d1wRSX97aKoDnEHmXq112xJM7LBGUvbvPk9VGKd+
         PGUT3kzJ1t7ANF6IYWxkFfJE36FQIHvrah858Gnh6RKkw+UcHfes4N9L40gxdHC2k9tR
         n/6S6OCcrOrNIY3BxHXTYMNqqRItEOYA4WEdfhu47e7F7zldjyXTa1DE1rvk86fgplKb
         OWvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r1iPIHP7mZcdSUCR2ACaARCaJHaLQkVWe4fuzzX1mGQ=;
        b=CovgwK+t4mbHthI61rGkUH6WcPPF7Q5H/TGb7T4crGUmrtb/wC8UytNUBff6aPQhsx
         HMGHBn7xckSfTrS6IJz/BB4MEqnQUj09IpJ/z/fqAbjeRCInR9zvmrLmw/3mMAvXBlnX
         YrEhROzw9775CNp/nhh+Lbv3n2w5SoNs02awlzCg4h4gKPgQoaIRB7tGG7Dm8H6ZFcmr
         bEyQjPcPxzSn7xmVt4Kc6QH4HrEwdL8+eWT8wGIzHOAPd61vN1Z9BPJNN8fZIdW2dNAF
         as0WQfQaeTtCHDQUA8RhUfuWV1ZdSw+pkDyTimQ9hxtzDk0IOsESZtt8O+gqhk3wP8JK
         Yhzg==
X-Gm-Message-State: ACrzQf1CYC4l8sOi8OE8AwbGFHqQAvg0Ad2FOe6VgxtU4dQ2rkGsI2N7
        0gjbOsFQ2ch0H46or1PgIeGdGpMIEuCO6NfU0J78nRFxwPKDRkV1Yln5pOBS0pifdsxw878OyC8
        H5HK9JImlLc2qMf8ARN5mzgsRtC974+/P84b5o8C3mn8gVNIdQVhuflWPsTu6jCkzfDV5S249P2
        USqfJFaTY=
X-Google-Smtp-Source: AMsMyM63Ywz9kEBCxQgmSiAwnc63WmLJO8OIyglm5dAp3mEpYN+ISwfsI/u9rFCEQkcV3r7FX7Kr80yBqlCVblr6TJ+7zw==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a05:6a00:218a:b0:56d:1bb6:af4f with
 SMTP id h10-20020a056a00218a00b0056d1bb6af4fmr18997907pfi.11.1667333158816;
 Tue, 01 Nov 2022 13:05:58 -0700 (PDT)
Date:   Tue,  1 Nov 2022 20:05:05 +0000
In-Reply-To: <20221101200505.291406-1-meenashanmugam@google.com>
Mime-Version: 1.0
References: <20221101200505.291406-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221101200505.291406-2-meenashanmugam@google.com>
Subject: [PATCH 6.0 1/1] tcp/udp: Fix memory leak in ipv6_renew_options().
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
index e0dcc7a193df..b61066ac8648 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -419,6 +419,12 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
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
@@ -994,6 +1000,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		break;
 	}
 
+unlock:
 	release_sock(sk);
 	if (needs_rtnl)
 		rtnl_unlock();
-- 
2.38.1.273.g43a17bfeac-goog

