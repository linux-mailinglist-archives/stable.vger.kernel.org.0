Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4476522C28E
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 11:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgGXJrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 05:47:18 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:58199 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726114AbgGXJrS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jul 2020 05:47:18 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 13583CC1;
        Fri, 24 Jul 2020 05:47:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 24 Jul 2020 05:47:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=vDWGH6eWsUd/YnN0zWWBM27Irbj
        5lY4lQRZBYu5So58=; b=KVf9e4GzPYptdUxAfUFJye71eR1j1Aag/GzDFDvrWsp
        hqHgxcP0bauxUB1eE8Ypm9sii35Xt+3rgmlRw1jCnVy3wdsinIoIuH7MuLJeBFpt
        pr0tNiqr3n85r7dICrWzqc3JAozAk4MoyStuYAfGFjlmaOp4tlmUSAEPoik6gs1m
        7IUn4mNH/3gVhFuyYvYyAVz2EqIefi7oh4q/Hqt5uvLWGNYRyBJYXrkv0Agn+Lyq
        LZ+g2SB306wze8JuhxxJPEIgGX/5tRUKAxWZ9WlONED4w7Uxwfg8/XGG7ba05IYP
        34pUGmWsHRmNAmvmEpcGzziK6wcTdk3tP6XK+/rK/pw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vDWGH6
        eWsUd/YnN0zWWBM27Irbj5lY4lQRZBYu5So58=; b=XeCEfwtgA/rPX6ZPNHcyTW
        8VrC4X3oDfOb7VQHuCrlJysTISv+YKuxtjqP3DY3Z6/ruyyaZrFRnZ1/Clx5g1F8
        Dvw5ZH5FQ9NA92wZbPHUxojbb+7LCNKtxTwdFOMUovH9Y2XP+5AKTUy5dbyyXklY
        L4hvwXDDk6uMHNmCpGqJeJ2sYQxKohBg6Gwm56nJ7gVe+atIFBywduoOHfjNrlf/
        gj6VRgK89hUQszpGjc7jzYL2p81W3KV0Pj1k/eeMjCq/63vgzDmF05WWKUIQasRv
        e9TifN0sLuz6YwUSoLGaSmvPcgVYST6Ig0k3P0ECHaRrV7gmbYLF3rVqiGN2hpkw
        ==
X-ME-Sender: <xms:JK4aXxG76OJGOTuonIOJ8YegYjiqzqOm5qdH0hY32IDDh84Av0g9Hg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrheefgddvtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:JK4aX2UIyy4JGfYR_1dJ-ptjBs1rWm2hMSyjt8H2NujPxnVdfa3ksA>
    <xmx:JK4aXzKpeaDm3qPGHk6Cy9hqn1GvL6t15s1NhoIXN-hXroex6KpSqg>
    <xmx:JK4aX3FiyzxiUbdnqNj_lRZP-4tvqDJai9opbddjmIdr8Gxe88lHMA>
    <xmx:JK4aX4f6S-rfagp-vfCvIBSkBp41OWgppQuDZjyTmrDzOXgTRjh8uA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 444483060067;
        Fri, 24 Jul 2020 05:47:16 -0400 (EDT)
Date:   Fri, 24 Jul 2020 11:47:19 +0200
From:   Greg KH <greg@kroah.com>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] btrfs: reloc: clear DEAD_RELOC_TREE bit for orphan roots
 to prevent runaway balance
Message-ID: <20200724094719.GC4176508@kroah.com>
References: <20200724014640.20784-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724014640.20784-1-wqu@suse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 24, 2020 at 09:46:40AM +0800, Qu Wenruo wrote:
> commit 1dae7e0e58b484eaa43d530f211098fdeeb0f404 upstream.
> 
> [BUG]
> There are several reported runaway balance, that balance is flooding the
> log with "found X extents" where the X never changes.
> 
> [CAUSE]
> Commit d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after
> merge_reloc_roots") introduced BTRFS_ROOT_DEAD_RELOC_TREE bit to
> indicate that one subvolume has finished its tree blocks swap with its
> reloc tree.
> 
> However if balance is canceled or hits ENOSPC halfway, we didn't clear
> the BTRFS_ROOT_DEAD_RELOC_TREE bit, leaving that bit hanging forever
> until unmount.
> 
> Any subvolume root with that bit, would cause backref cache to skip this
> tree block, as it has finished its tree block swap.  This would cause
> all tree blocks of that root be ignored by balance, leading to runaway
> balance.
> 
> [FIX]
> Fix the problem by also clearing the BTRFS_ROOT_DEAD_RELOC_TREE bit for
> the original subvolume of orphan reloc root.
> 
> Add an umount check for the stale bit still set.
> 
> Fixes: d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots")
> Cc: <stable@vger.kernel.org> # 5.7.x
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/disk-io.c    | 1 +
>  fs/btrfs/relocation.c | 2 ++
>  2 files changed, 3 insertions(+)

Thanks for the backports, all now queued up.

greg k-h
