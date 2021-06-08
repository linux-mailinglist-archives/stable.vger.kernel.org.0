Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922AE39F6FA
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbhFHMnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbhFHMnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:43:32 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5141DC061574;
        Tue,  8 Jun 2021 05:41:25 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id f11so31710723lfq.4;
        Tue, 08 Jun 2021 05:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZnlRWOjvxEIJ/Owy32Fpj0Dl2D1jU6siLQrdLyb7uqE=;
        b=tNkU6JsOfPw6cUysQfJXWSKOe43VbhZ2mJmh/VUQ71Mp9pDAQMNGW5kRv8yYE48Hka
         vCJK+Iha92YpYTra8gzpo4gJnyMhUChlsyiixb2t/LWmJtM8d0azUeoAFy7TWUhOsRQU
         /FGXtzH4yqGUTStQXdza5k0Wy8L9f0x0kYBDTNiY8Jblpz6+Dxy0IFMsXu5WerOgcwU2
         f2RciUTcpEhvxsgu4Zkx2JSzFvv4MsBsqe6Z1o3PCVZVkDeR6O0ClVA3SPMYQA9xTWNB
         UuCvfHQukh2X8lJR7m7TuW6rKDWJ0al+d0sb+wW43rszwFX2XyslzS/34F09iiZLnUFk
         niXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZnlRWOjvxEIJ/Owy32Fpj0Dl2D1jU6siLQrdLyb7uqE=;
        b=WEfIXyCc/3JNU3EPG68DkII/gtxLPtBYjgE4HBGPqQj9sa9D+YTYN/ALFg+ECdr9Iy
         Y6bR6yky1Ej/jO6DjniUbpTC0fyrOk28eTNgg7I0CVoZkMvby8mMQH3GIJxV85Nix1NH
         X8x7MtUXEFR35PyMd82JJG4o6QDW4SBNu+Ro4SD0ryeZqCTQF/hytC8s/EQTnjDjkJaG
         Np8OGAXpfndmlyhhSf/ub3uP0XnNCBsE1CPNOHedTm4+ku6M7w4CDnGv4oPOfv3DOgOo
         +mlh61UcSY860DnkMDDLGHGIFoVliAfImHx6TDBpvpUSnrV5qnUEiW4V/QZnD4L2evC6
         DeWA==
X-Gm-Message-State: AOAM533j8VmutLrCJpyflknGs/oItbPd/OP0VrPLcyCQ3L753UpfLA8u
        ap1WCSdiSY+GfrC5dnrXoKc=
X-Google-Smtp-Source: ABdhPJxicGL8Wax33HtBi/zasM7f9/S9XuejKNKXx0gROw6O58khkF6rEIaWgV+k96gPKAIJ6pT4tQ==
X-Received: by 2002:ac2:596a:: with SMTP id h10mr14451605lfp.360.1623156083291;
        Tue, 08 Jun 2021 05:41:23 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id t13sm2246443lji.19.2021.06.08.05.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 05:41:23 -0700 (PDT)
Date:   Tue, 8 Jun 2021 15:41:20 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net,
        syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com,
        <stable-commits@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Patch "net: kcm: fix memory leak in kcm_sendmsg" has been added
 to the 5.10-stable tree
Message-ID: <20210608154120.2e3f67d0@gmail.com>
In-Reply-To: <1623155518245194@kroah.com>
References: <1623155518245194@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Jun 2021 14:31:58 +0200
<gregkh@linuxfoundation.org> wrote:

> 
> This is a note to let you know that I've just added the patch titled
> 
>     net: kcm: fix memory leak in kcm_sendmsg
> 
> to the 5.10-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      net-kcm-fix-memory-leak-in-kcm_sendmsg.patch
> and it can be found in the queue-5.10 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable
> tree, please let <stable@vger.kernel.org> know about it.
> 
> 
> From c47cc304990a2813995b1a92bbc11d0bb9a19ea9 Mon Sep 17 00:00:00 2001
> From: Pavel Skripkin <paskripkin@gmail.com>
> Date: Wed, 2 Jun 2021 22:26:40 +0300
> Subject: net: kcm: fix memory leak in kcm_sendmsg
> 
> From: Pavel Skripkin <paskripkin@gmail.com>
> 
> commit c47cc304990a2813995b1a92bbc11d0bb9a19ea9 upstream.
> 
> Syzbot reported memory leak in kcm_sendmsg()[1].
> The problem was in non-freed frag_list in case of error.
> 
> In the while loop:
> 
> 	if (head == skb)
> 		skb_shinfo(head)->frag_list = tskb;
> 	else
> 		skb->next = tskb;
> 
> frag_list filled with skbs, but nothing was freeing them.
> 
> backtrace:
>   [<0000000094c02615>] __alloc_skb+0x5e/0x250 net/core/skbuff.c:198
>   [<00000000e5386cbd>] alloc_skb include/linux/skbuff.h:1083 [inline]
>   [<00000000e5386cbd>] kcm_sendmsg+0x3b6/0xa50 net/kcm/kcmsock.c:967
> [1] [<00000000f1613a8a>] sock_sendmsg_nosec net/socket.c:652 [inline]
>   [<00000000f1613a8a>] sock_sendmsg+0x4c/0x60 net/socket.c:672
> 
> Reported-and-tested-by:
> syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com Fixes:
> ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module") Cc:
> stable@vger.kernel.org Signed-off-by: Pavel Skripkin
> <paskripkin@gmail.com> Signed-off-by: David S. Miller
> <davem@davemloft.net> Signed-off-by: Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> ---
>  net/kcm/kcmsock.c |    5 +++++
>  1 file changed, 5 insertions(+)

Hi, Greg!

I CCed stable. This patch is broken and I've already sent a revert for
this.

https://git.kernel.org/netdev/net/c/a47c397bb29f

Please, don't add this to stable trees. Im sorry




With regards,
Pavel Skripkin
