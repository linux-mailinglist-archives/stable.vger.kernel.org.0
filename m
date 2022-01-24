Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1D849827E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239178AbiAXOfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:35:20 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34707 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239199AbiAXOfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 09:35:13 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 38D135C007D;
        Mon, 24 Jan 2022 09:35:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 24 Jan 2022 09:35:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; bh=war2YE1/B1wcRN9SpOHYJDXGF0nYSU1crBq6TA
        jfaXw=; b=CFkR52qjnTV0zkbQKaqAfFcLrn509RZUKKPHbRx+fnzHAWNu1tqr/2
        BUNORX1lDWgznW4yCi2uAgN7eIyD/mMKqkjqBMR9AoAJcmXMVL+Q+e7cd+GDF679
        2jsaZOMOBOK6Zx2W1NgJkx2ELH7enUWiYiuO9TLvr+KKE8Yolzb4qOYdJ9JHeUyb
        0EzqnuldEbnQff1mOCcXTDrJdcagPrgo+Czh2QO4wZpYgsTwTCHPTN26ajOuAoYR
        jkC2rhTXSXwHfqoreTB27XfQztX15B85NohIRI6ACZf2eDsIVKv4//IrxXl08wrN
        eIlU6o8S1Y++THzqJqWqUjhxlfJR0W2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=war2YE1/B1wcRN9Sp
        OHYJDXGF0nYSU1crBq6TAjfaXw=; b=eo+EAHz8bZENZhZvXhuWhDHMp9wYcd171
        536viihHgin8qmidQQRQZn5xDVCbaXNud2VkXCB5cnpmNTB+6t5YOUSf0kwl07tw
        QOZz616Lm9f1/dREeGqQojaj53pE+4QfKl95OOVeABZw3oIUiHX+f849BmAd88oL
        LZ6p6Z02HnIzmso5E+cD390NlBlnyKXH7A+6PF4/0wLAqVKA2qd1akzOw3iYiNaf
        c6p8/5UFn9BYzlHbSZeeLQpOvu7RwTXYQBpmNqhk26c5a+ZLQJ4EzdckIbmf4sd7
        Pxn9kyTrLbfu9qpuM23ufW3spVnknn0RCjlN3V9PfOA6Q41kqGPjQ==
X-ME-Sender: <xms:H7nuYZhc05TpqxPOPFvSWAriKP36hzxgayq4k54ISsxb0qGjVHytQg>
    <xme:H7nuYeAYRbdIda7yU4Xh_qG_crZl23wbi60amVbj9iYTRAgAu5kAizX0E4K28I3xj
    fvOqxnkMK9WyQ>
X-ME-Received: <xmr:H7nuYZEvpUII-PrXtYFY1aSKgdyA9bmGqUDzvElIQBBx4aD2wmQq0f7r2kIUES8dTR_ChV8vXgVa3p8S0eXWvdMfjW5-ACGi>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrvdeigdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:H7nuYeTyoKUm3LuiEmBt_DShcShnbBBMflUxdlugWO_JaMXmtnFyWg>
    <xmx:H7nuYWwHNP5uzlJAaapK3t_D09qRkw8iQmI_LwVZrxe__6Y3j--TDA>
    <xmx:H7nuYU7NSPvrOciFOdHmJK2gPWRqnMMk16wK_pR-yjuCj9kS_rG7Ug>
    <xmx:ILnuYdkXsRCaTPjBpq-ml2t34I5eE-3GwS75cR2WJxhzEy4XxB-zqQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Jan 2022 09:35:11 -0500 (EST)
Date:   Mon, 24 Jan 2022 15:35:09 +0100
From:   Greg KH <greg@kroah.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4.9 1/2] fuse: fix bad inode
Message-ID: <Ye65HbfoTqrW3W/r@kroah.com>
References: <Ye6s90hqJXcsvslQ@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye6s90hqJXcsvslQ@decadent.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 02:43:19PM +0100, Ben Hutchings wrote:
> From: Miklos Szeredi <mszeredi@redhat.com>
> 
> commit 5d069dbe8aaf2a197142558b6fb2978189ba3454 upstream.
> 
> Jan Kara's analysis of the syzbot report (edited):
> 
>   The reproducer opens a directory on FUSE filesystem, it then attaches
>   dnotify mark to the open directory.  After that a fuse_do_getattr() call
>   finds that attributes returned by the server are inconsistent, and calls
>   make_bad_inode() which, among other things does:
> 
>           inode->i_mode = S_IFREG;
> 
>   This then confuses dnotify which doesn't tear down its structures
>   properly and eventually crashes.
> 
> Avoid calling make_bad_inode() on a live inode: switch to a private flag on
> the fuse inode.  Also add the test to ops which the bad_inode_ops would
> have caught.
> 
> This bug goes back to the initial merge of fuse in 2.6.14...
> 
> Reported-by: syzbot+f427adf9324b92652ccc@syzkaller.appspotmail.com
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Tested-by: Jan Kara <jack@suse.cz>
> Cc: <stable@vger.kernel.org>
> [bwh: Backported to 4.9:
>  - Drop changes in fuse_dir_fsync(), fuse_readahead(), fuse_evict_inode()
>  - In fuse_get_link(), return ERR_PTR(-EIO) for bad inodes
>  - Convert some additional calls to is_bad_inode()
>  - Adjust filename, context]

I've taken this backport now, thanks!

greg k-h
