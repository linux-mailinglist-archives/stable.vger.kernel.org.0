Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C3A641DB7
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 16:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiLDPop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 10:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiLDPoo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 10:44:44 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762A760E3
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 07:44:43 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 241B05C00C1;
        Sun,  4 Dec 2022 10:44:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 04 Dec 2022 10:44:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1670168681; x=1670255081; bh=lzsivO5//s
        QN9scAH9OkdjR39fr7JoJEpQdmVLiTjIo=; b=nCZyzlN9lVnE0D+NDuoN3rwbN4
        LJxhEvg7SHt80KI8IkLLp5WXahlUv5kCOBBhL0BDn7LoYl7HB4WmYD/u5626K02t
        wqWmokPmF/Zt53Cqcdj0yZWsW6PeIZ+CH13musoZyo25xOIlT6c71XU7CF20XLT8
        w8uEaeVMDRaR1kzZvPMBrR1W/acx7JNhfkLQ9B7n5gsmtyZUH6UPBrlBvG+NRuJM
        Or2qOIvP8+wT3l7eEGm6xxNd6swToswB+dNCan+Cf6M5RT7FsdRvdohKhHU6ky0p
        651VaaDeSgI1vTk2PH92zgPvHQEYP6GMgRKJKWQOAFwo+zBP+Y8FGADWJanQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1670168681; x=1670255081; bh=lzsivO5//sQN9scAH9OkdjR39fr7
        JoJEpQdmVLiTjIo=; b=T/gZ/A3ER9nbsrx4K94e8xg5/fUdfBQaYdafI9MXjitf
        CQCw+b/WZzLZ5lSdcV9k6nWAJFjPqzIPRIk17fD4AgjIPTU6iQE2S0icLYRwHTqh
        KnOPkfVyNxTNPpKp6cacEN+/yuUpyoKCcuQCmn0qP5kH203NZPolJF1bZEkbmBmj
        Ln0AEZxRL2w7GB7tNv++FIC7rr5TisXJg/yr3olb2KfGCZRZVM1XLB756bbUhpjL
        Yqrd0fMpeMvtGqHgI7kpmXIXEsv6AKIceDTh/6Sp7BQRaTaWEX74lJU7DODINa3w
        H8CFLcrLBLkuVciYW1nVeM/RfsSf9iZnQC1NERybhg==
X-ME-Sender: <xms:aMCMY_cPZz0l13LQWFKdPmpAHEWq_SHHks22MeYmO9lROwmscHe1Wg>
    <xme:aMCMY1PS4-6KzHLP-GVckaehevglrrMyIENmb8QBDHEj3O1OtZLbzxwzyl1C3a9se
    T_o_LGFhw3P0A>
X-ME-Received: <xmr:aMCMY4h32zuvV8zKdf1AQ1FxQeenQTAlSZ3I1lLjsjjyJH2AJDw-2slA7YrlVCQvD4_ST2FHds_5UJ1j86r_UA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvgdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:aMCMYw-BGRD0NArGAopYtuu5rM1vjtmS7gS9HdDGetmWnaHs_f25MA>
    <xmx:aMCMY7sx5_z6V3ikyyugW_cR9P_xwH7QaSQfB2sDcgyhOKSIogXAiQ>
    <xmx:aMCMY_HKaOgCWgrgmrUHQb5mE5ZriAIZscPqe3L5EyBKRZeutdkVzg>
    <xmx:acCMYxBS90pDjJmTUCX7D_Ca_WjJj9euCvH7JJaCmFXzp9R46yuvng>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 4 Dec 2022 10:44:40 -0500 (EST)
Date:   Sun, 4 Dec 2022 16:44:35 +0100
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 4.14 1/1] tcp/udp: Fix memory leak in
 ipv6_renew_options().
Message-ID: <Y4zAY2w5ErR1CKMd@kroah.com>
References: <20221124094226.2537476-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124094226.2537476-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 24, 2022 at 11:42:26AM +0200, Ovidiu Panait wrote:
> From: Kuniyuki Iwashima <kuniyu@amazon.com>
> 
> commit 3c52c6bb831f6335c176a0fc7214e26f43adbd11 upstream.
> 
> syzbot reported a memory leak [0] related to IPV6_ADDRFORM.
> 
> The scenario is that while one thread is converting an IPv6 socket into
> IPv4 with IPV6_ADDRFORM, another thread calls do_ipv6_setsockopt() and
> allocates memory to inet6_sk(sk)->XXX after conversion.
> 
> Then, the converted sk with (tcp|udp)_prot never frees the IPv6 resources,
> which inet6_destroy_sock() should have cleaned up.
> 
> setsockopt(IPV6_ADDRFORM)                 setsockopt(IPV6_DSTOPTS)
> +-----------------------+                 +----------------------+
> - do_ipv6_setsockopt(sk, ...)
>   - sockopt_lock_sock(sk)                 - do_ipv6_setsockopt(sk, ...)
>     - lock_sock(sk)                         ^._ called via tcpv6_prot
>   - WRITE_ONCE(sk->sk_prot, &tcp_prot)          before WRITE_ONCE()
>   - xchg(&np->opt, NULL)
>   - txopt_put(opt)
>   - sockopt_release_sock(sk)
>     - release_sock(sk)                      - sockopt_lock_sock(sk)
>                                               - lock_sock(sk)
>                                             - ipv6_set_opt_hdr(sk, ...)
>                                               - ipv6_update_options(sk, opt)
>                                                 - xchg(&inet6_sk(sk)->opt, opt)
>                                                   ^._ opt is never freed.
> 
>                                             - sockopt_release_sock(sk)
>                                               - release_sock(sk)
> 
> Since IPV6_DSTOPTS allocates options under lock_sock(), we can avoid this
> memory leak by testing whether sk_family is changed by IPV6_ADDRFORM after
> acquiring the lock.
> 
> This issue exists from the initial commit between IPV6_ADDRFORM and
> IPV6_PKTOPTIONS.
> 
> [0]:
> BUG: memory leak
> unreferenced object 0xffff888009ab9f80 (size 96):
>   comm "syz-executor583", pid 328, jiffies 4294916198 (age 13.034s)
>   hex dump (first 32 bytes):
>     01 00 00 00 48 00 00 00 08 00 00 00 00 00 00 00  ....H...........
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<000000002ee98ae1>] kmalloc include/linux/slab.h:605 [inline]
>     [<000000002ee98ae1>] sock_kmalloc+0xb3/0x100 net/core/sock.c:2566
>     [<0000000065d7b698>] ipv6_renew_options+0x21e/0x10b0 net/ipv6/exthdrs.c:1318
>     [<00000000a8c756d7>] ipv6_set_opt_hdr net/ipv6/ipv6_sockglue.c:354 [inline]
>     [<00000000a8c756d7>] do_ipv6_setsockopt.constprop.0+0x28b7/0x4350 net/ipv6/ipv6_sockglue.c:668
>     [<000000002854d204>] ipv6_setsockopt+0xdf/0x190 net/ipv6/ipv6_sockglue.c:1021
>     [<00000000e69fdcf8>] tcp_setsockopt+0x13b/0x2620 net/ipv4/tcp.c:3789
>     [<0000000090da4b9b>] __sys_setsockopt+0x239/0x620 net/socket.c:2252
>     [<00000000b10d192f>] __do_sys_setsockopt net/socket.c:2263 [inline]
>     [<00000000b10d192f>] __se_sys_setsockopt net/socket.c:2260 [inline]
>     [<00000000b10d192f>] __x64_sys_setsockopt+0xbe/0x160 net/socket.c:2260
>     [<000000000a80d7aa>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     [<000000000a80d7aa>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
>     [<000000004562b5c6>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>  net/ipv6/ipv6_sockglue.c | 7 +++++++
>  1 file changed, 7 insertions(+)

All now queued up, thanks.

greg k-h
