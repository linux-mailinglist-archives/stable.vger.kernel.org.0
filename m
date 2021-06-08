Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6AF39F6F1
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbhFHMld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:41:33 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:37763 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbhFHMlc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:41:32 -0400
Received: by mail-lj1-f172.google.com with SMTP id e2so26808929ljk.4;
        Tue, 08 Jun 2021 05:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=piGQTGJQpfVsbTJVmX1XKiQz+3MBqpE3R4eA5C/V3Ro=;
        b=J0Qmnhdo5UoCoD/3RKLAj4cWaz3nJWru4GgGAYmerkwOV1joDIgpJ+BTDJEp/T5IRq
         goWeJYgccwIEeg0f4coAaHgQiC06fSOaQPsWKDHJNXrUSXlQePklicMXhKl1l904h2dJ
         GuKPIUZrwXS4fawS+u2PFtxGfa8YlpjTFMEZq8SfzLn/ry74xpK1w3vi4GQj6ZiD89dJ
         O+9HvcE/GepoAs59qpDk85upgBysV/S6zU7aTzE/bO7m7BjeS065aql57EqkOCBPry62
         ZMtYsdXSzqY5Z4SpGrmCeegKFMIcYNnkwyMhMQO9UzPYY4fzCCQLbJ/BPQM8kH1lil3G
         e2bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=piGQTGJQpfVsbTJVmX1XKiQz+3MBqpE3R4eA5C/V3Ro=;
        b=QEdq7V7Rq3W7/67MbH9G3XVmtY+1KvmMbWt+F8yq/afc3rpNEpkFkcZcSe2CkPrN/J
         aRpBq5jiBnOBO5ImIKNhf+XEufqD5m+jE+cb3h7lmDnhPauF8OAkCT9aQV6tOMKTp0dX
         Y9iVwrnjsjsaeDF7XLi5OkDVdfBE5iwFfcZ0/6e+5X3hGF+zzYls5Ck0ofHfFoxpQK9H
         GgFWqkJIE+u69Djzgtr5FFpxjQaOp9Qcxr8GYHCwLP48GtSRVu7++hx1uN9YHD+RpG36
         DO9LDD150FQlU39XPDqqKk7aus1z0U0ksF0m0F0rjZg34JeLKXhD1ojiIRQjTWNOqkOC
         XpzQ==
X-Gm-Message-State: AOAM531sIJKVS1Fmj/DS1o8JfLRLSAYxfUDMZYEQhziqLiOuIcn9Ig2g
        xvIm4o55ordR4Yw+VYVEL9H/0tdg0oq+lg==
X-Google-Smtp-Source: ABdhPJz0nphN9tTeFCsqBEG1HGzTiA++8zSbWtqL6abwPY5J/qpHAHk2uUspnTg2+dZ8urdOjwp/oA==
X-Received: by 2002:a2e:9252:: with SMTP id v18mr2138690ljg.122.1623155906523;
        Tue, 08 Jun 2021 05:38:26 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id p3sm1892410lfa.116.2021.06.08.05.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 05:38:26 -0700 (PDT)
Date:   Tue, 8 Jun 2021 15:38:24 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net,
        syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com,
        <stable-commits@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Patch "net: kcm: fix memory leak in kcm_sendmsg" has been added
 to the 4.14-stable tree
Message-ID: <20210608153824.17d02c42@gmail.com>
In-Reply-To: <1623155453248188@kroah.com>
References: <1623155453248188@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Jun 2021 14:30:53 +0200
<gregkh@linuxfoundation.org> wrote:

> 
> This is a note to let you know that I've just added the patch titled
> 
>     net: kcm: fix memory leak in kcm_sendmsg
> 
> to the 4.14-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      net-kcm-fix-memory-leak-in-kcm_sendmsg.patch
> and it can be found in the queue-4.14 subdirectory.
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
