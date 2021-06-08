Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C34639F702
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbhFHMpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:45:09 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:44657 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbhFHMpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:45:07 -0400
Received: by mail-lj1-f182.google.com with SMTP id d2so22633632ljj.11;
        Tue, 08 Jun 2021 05:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ip7z5WOMRX2vd7oYpWDZHlSLjuUkjWBaHBnS1n1visE=;
        b=bpak4cA1+XuX+bp5hw7UqOcMim8K9Jg2WSapI6WsLj2ylE/4myx9xm39B9SE84cyQo
         mEGvMOuw+QMNdpllgvCR8sigiMJggbjxnfZHtlp1zS89Bpv34N1y3jug6fVDwiu08Teq
         nVicZ8jqQN2/bZY+G5zZ7VbtoumUPzlSKXzsU74lUBFUWdPzqF3Y93eyfnghY1uN8vl9
         kUwIwFv0V23zkPlxbXc/aPmhxKhyQA3/QbyT87eiTzfDP/74pVeVqKhVcE0P+LD+0EBU
         pC/Y6FvuGjzo1iG9dUtqvmdmkO8uhinU4KihRMrD/GeKHj+5bc06zro8Wq+7OD+PpO39
         kKog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ip7z5WOMRX2vd7oYpWDZHlSLjuUkjWBaHBnS1n1visE=;
        b=kBc4+N19SEv4b47m741qZ0lFA8qy/VZvMFI27h0Lexo1IKG0FO7W5ZJCxXBKAfXVvK
         jfOPkdJUpzkHQRcXwTgOCAuMMmba2HhAlEs6XqFcdxmmtvDrcsqn8RTE1MvZSka022xG
         A6QzFj6c4+gThpzWwHdUJ6HsOok+4KKKomr7cHjl57LEACwVo1xDRa97pbbphF+y5Svu
         UmDdATZDqTJXxoA3VeAsVC9DpPbmA/ogzP8r+0HJpS67La9nNzu6+kBLv+HHxD0gdvKQ
         Pd0X80c6e6KXxEc1F5zbkah2wpK0hIDLCovQQVFTqls7SKS8UQIfmxwavLzXVAcbOXnC
         uRfw==
X-Gm-Message-State: AOAM531I3518GHGzVn0WeOh61vdSYsUj4mRNn/hBa6JwynJ7qfmpwq7j
        Vu9DUBcICBIKDWkT1Yi82Sw2FQU5dEb0Zg==
X-Google-Smtp-Source: ABdhPJyQyv7Qqprp0uTCL9mlcq6mviCPvdHRiFfl5ti+GeUCGFF7XaHtCMYQ5wNa7AKKMnt3iNRIYA==
X-Received: by 2002:a2e:5347:: with SMTP id t7mr18153825ljd.464.1623156121479;
        Tue, 08 Jun 2021 05:42:01 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id w24sm1885719lfa.143.2021.06.08.05.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 05:42:01 -0700 (PDT)
Date:   Tue, 8 Jun 2021 15:41:59 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net,
        syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com,
        <stable-commits@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Patch "net: kcm: fix memory leak in kcm_sendmsg" has been added
 to the 5.12-stable tree
Message-ID: <20210608154159.0ddf6bcc@gmail.com>
In-Reply-To: <16231555432043@kroah.com>
References: <16231555432043@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Jun 2021 14:32:23 +0200
<gregkh@linuxfoundation.org> wrote:

> 
> This is a note to let you know that I've just added the patch titled
> 
>     net: kcm: fix memory leak in kcm_sendmsg
> 
> to the 5.12-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      net-kcm-fix-memory-leak-in-kcm_sendmsg.patch
> and it can be found in the queue-5.12 subdirectory.
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
> 

Hi, Greg!

I CCed stable. This patch is broken and I've already sent a revert for
this.

https://git.kernel.org/netdev/net/c/a47c397bb29f

Please, don't add this to stable trees. Im sorry


With regards,
Pavel Skripkin
