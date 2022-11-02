Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B6C616DEE
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 20:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiKBTnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 15:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiKBTnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 15:43:23 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B401D2D5
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 12:43:22 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id x18-20020a170902ec9200b001869f20da7eso13074365plg.10
        for <stable@vger.kernel.org>; Wed, 02 Nov 2022 12:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eTjKBVn1sT/oUsH+Sf+q15q8+4MC/icGJfc6Gr5ql/s=;
        b=pbukQk8zNkQqoHVmPufou8f33TZ1tI7/5CZuvqzB+YEIFF6EQHBGZXbbpyKJtdkY5G
         qBlwTgyzloINcVaJbtErwtlvTQOXy4+I3DDsS3n5vTfHVR/xogmGKhtsEUZwOf1W/gsu
         Ds5WXINrO+Cr/vWTw1Z4mVkK2fIJjFVNoIhH5Vib+MI+KbXE16Q8lFpW9hYbUkVIAg5J
         /cAXyjDnDs1x4X/4XeUJlv7Wll//yPfoA+kd/rzEE8wertpo6httnj9CQJuAXbSIVZOx
         3mqAQyMukMzzlDx7mtL8jsZchBr+ljeHpTTsOy6A1eNutDEyeoeetp1GLBghpRxBPobD
         Wbgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eTjKBVn1sT/oUsH+Sf+q15q8+4MC/icGJfc6Gr5ql/s=;
        b=LjUoJko+23VIMKU83SqCOPM8mAq4113Zzm5kySNnChpV99hLcH+ESuX59nAUzCtSo3
         Y7QHs1PYGJciBNXzd8A1680eP5U6OT84uUOoyy+yXcNnuSQiEOm6UBF0mCqQKwZkcnJy
         hc4nsZTYlTvFQ1o2uJevQLXJvkar331I0Aga4Z575s8q7TaicQ7jY2nWJ864EvrERWaU
         aKTliEIUBSG+9r2qa1QpRRzvKELvOFSyr10SzfJz+I7xCl4WKLbJJdtrl2RF52kWT+6s
         m3HEDKrCt3AIJAGJzNRCCixdtNnHjkrHVVOgVzC7e5Z1xuRzsRPKKL0P2uWvCTaI8i4K
         zq/w==
X-Gm-Message-State: ACrzQf19p30zWbA8gnvOe38Ij7HHEmaqx3ol1cWYfv5YrVROorFsLMFZ
        A1wmLJ4PGMXqQEVVF1YImp+BOWTx3QuQKlQ8OckD9bg52ZfXQ/WBawUJjJWCwng4AsfBI7pUHNG
        yL8qqVKjFgDwXlMTK88xyudgTbplTW5L7+5wFUsZ3DsK5+mTE6Q0SLGV3KrtBeLmNuQbQcmkxHd
        /uGIo86M4=
X-Google-Smtp-Source: AMsMyM4IZcV5mgxxZcNKB/0wKFxMdO2TYkj11Faw2Cta6r6G3/PvCFSXFg1c/Ss+ozx4Lz3wnGAZ6lvqkQenVx0wrchKsA==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a17:902:6542:b0:172:95d8:a777 with
 SMTP id d2-20020a170902654200b0017295d8a777mr26250392pln.61.1667418201528;
 Wed, 02 Nov 2022 12:43:21 -0700 (PDT)
Date:   Wed,  2 Nov 2022 19:43:13 +0000
In-Reply-To: <20221102194313.840129-1-meenashanmugam@google.com>
Mime-Version: 1.0
References: <20221102194313.840129-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102194313.840129-2-meenashanmugam@google.com>
Subject: [PATCH 5.10 1/1] tcp/udp: Fix memory leak in ipv6_renew_options().
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
index 6fa118bf40cd..2017257cb278 100644
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

