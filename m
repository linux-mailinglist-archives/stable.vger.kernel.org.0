Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D70B39F6F4
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbhFHMlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbhFHMlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:41:55 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03081C061574;
        Tue,  8 Jun 2021 05:40:02 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id s22so6369691ljg.5;
        Tue, 08 Jun 2021 05:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q6BRjSQxrU+lFCUTCSq1UKcl8FsxNr3/qDZfib2p+fo=;
        b=j4+nKLsBBcdvPXqWkuFse0PeLW3+S2lUmQH/CrDg2steD37W2UiJroSijbnPdNTiDV
         3C30TqSGWwXxDmxWXj41A9bSQxHT5uxICdNPc1tlDMARvblbqusl0cZ95z5SvidWLDlZ
         JQKabeBYro2dn2/q5LcXHmSl6dyoNOmSodyFtHi8H9q9O2rA0kzktMpLh98fFvA89QbR
         k8ERu5NyDlbUCVAl1yhfzl4IvNA/YDrRnU8W5dNaNaGbhQ2y0YUei4hTjqGc6PPZY38B
         v/ooU/Nz5808piH7Tkgsyi5nfU7mkrSdSfyT7rKqe3NsG/TPmNyFrz9ihZiZGCwqvHK7
         0UTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q6BRjSQxrU+lFCUTCSq1UKcl8FsxNr3/qDZfib2p+fo=;
        b=snQ1Ge26YLHeoBHenA/81SymOvfoXQSiBGhXHocNbZhC2e06O9chBmbouzAhz+v3Nc
         WGQzbNSidTbOPow+pH/zVaPw0NXAiStSQDzaPEAXe39u6L6/JNRIE6TpQAfZvi4cv7fA
         O9DcAqN1XJb7qOKdjQceD1DZUw7GZKUULfsc7LH5NeScZFLvrMDHS10Vy+8710Sc3zVy
         AoS0CiHhcy8bprgZxnM/1edbWC9QLfUG8mx4tEggX9K14HrzxhwWp+el+FykJGFK9USi
         1MrNYH6smOVrGJVVpd2FhuKk6rF9oHml29CWhF5M4AQ+WnILZJxn+H6zW0JafLttAURV
         miPA==
X-Gm-Message-State: AOAM532/7WjA24LaPJdLHulbQQKYDTW/ccQz1N/q0/uIykns4Y2N8UF5
        7PoolAYEOuQJtMFJ2QfF5T684ldoubWp6Q==
X-Google-Smtp-Source: ABdhPJzMEUBS1ByKhET0zcIns+A0Qd0H8cmoFqQ8Qhgb7ipjN/LLFO+rNkul/EjlM/X423VLkcXg/w==
X-Received: by 2002:a2e:bf12:: with SMTP id c18mr18276514ljr.407.1623155998898;
        Tue, 08 Jun 2021 05:39:58 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id t13sm2245924lji.19.2021.06.08.05.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 05:39:58 -0700 (PDT)
Date:   Tue, 8 Jun 2021 15:39:56 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net,
        syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com,
        <stable-commits@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Patch "net: kcm: fix memory leak in kcm_sendmsg" has been added
 to the 5.4-stable tree
Message-ID: <20210608153956.09bc7c96@gmail.com>
In-Reply-To: <162315549416253@kroah.com>
References: <162315549416253@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Jun 2021 14:31:34 +0200
<gregkh@linuxfoundation.org> wrote:

> 
> This is a note to let you know that I've just added the patch titled
> 
>     net: kcm: fix memory leak in kcm_sendmsg
> 
> to the 5.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      net-kcm-fix-memory-leak-in-kcm_sendmsg.patch
> and it can be found in the queue-5.4 subdirectory.
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
