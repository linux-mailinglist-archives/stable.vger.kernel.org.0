Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6170739F6EB
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbhFHMjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:39:41 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:46048 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbhFHMjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:39:41 -0400
Received: by mail-lj1-f175.google.com with SMTP id u18so6602327lju.12;
        Tue, 08 Jun 2021 05:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=arwPAMe5OJb415PLRobsrMOpMXnhW0drEKZ/NEFKNz8=;
        b=Uy50cunnuEqZACI/NWFEaBqUpJ8xnEZBAvGBMXArlzVnnqL4HeRfcL5vIXxAo8so67
         YOwrs5MSusjO1TsdKVvql+UAj2aYsXxxN3ZaCledJGJGUFv9u4fzp2zYuDKMmpl3evO3
         WYbNhucv5WmkzshHXKS6nqdzVKr4fXAUm01Uo07TauscGIv08DYzAHpJv8m64g2DwF5Q
         w0laNaqMsz4SzNgojv0GwGOx+4+NKv055VWaud1pYmHcew1HycttbsFQgwGmRuPvG5Gb
         MZlu38Hcagjlw58M1WrLt8h79G0Dv18pnq/CexkonLmKrwOGWGZvNoB0PChIyuMytByH
         KzPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=arwPAMe5OJb415PLRobsrMOpMXnhW0drEKZ/NEFKNz8=;
        b=fDt8pwQQTLdjqoLVNg07HXJLqAucMnHPnwN9J+/DHds0RJ2+s2kxZ/po75Hyxq20j5
         IhHbjBrt+QruvcKjxwRYpZjTjbxi5T2GUgPcu3nOXi4+D5H3qA+nsOpr8piFpkQdAieY
         j6UL09PiGn862o0HAS4Ly5OdENbVRhgY19WaHCF6etU72PajqDI7kbm8ZcFqzGvbQcuq
         aWKQDsYwvms8VwLLQzUgCsda6KYynG6r5oi+sEnspxxVubxKTzE/vLsAvkFUXt9DmFOD
         6jBWUzjfpK5MeHa7sI+H5xlSBCiN6Vgz5NQjFiUsoi5tqlloaiPxkp6evB3EVxbW6Rz0
         sGsQ==
X-Gm-Message-State: AOAM533gsvqB8gmdjtTBay+NT6YjcQJlPV/V87AKmwLMELOy3cWiTodj
        9V6rZuj62ZWaIWV9G4a1rK8rCT35Dk1Pjg==
X-Google-Smtp-Source: ABdhPJw0rM82iYLwwJPx6UHe4l8QaI34/VMIKZANEcsObOfO9nSL7aytR9YHnjEa6XBRn8wv0IhPjg==
X-Received: by 2002:a2e:5047:: with SMTP id v7mr18421002ljd.510.1623155807537;
        Tue, 08 Jun 2021 05:36:47 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id q7sm965847lfu.194.2021.06.08.05.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 05:36:47 -0700 (PDT)
Date:   Tue, 8 Jun 2021 15:36:45 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net,
        syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com,
        <stable-commits@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Patch "net: kcm: fix memory leak in kcm_sendmsg" has been added
 to the 4.19-stable tree
Message-ID: <20210608153645.3e9fe031@gmail.com>
In-Reply-To: <1623155473139159@kroah.com>
References: <1623155473139159@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Jun 2021 14:31:13 +0200
<gregkh@linuxfoundation.org> wrote:

> 
> This is a note to let you know that I've just added the patch titled
> 
>     net: kcm: fix memory leak in kcm_sendmsg
> 
> to the 4.19-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      net-kcm-fix-memory-leak-in-kcm_sendmsg.patch
> and it can be found in the queue-4.19 subdirectory.
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
