Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AF04983BA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbiAXPon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:44:43 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43473 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231203AbiAXPom (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:44:42 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3C9775C0150;
        Mon, 24 Jan 2022 10:44:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 24 Jan 2022 10:44:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; bh=1ZCWDiwfW4eZaQgzswxbn2ITUkdxZP/Tl6+E1E
        76Oeo=; b=EifoxRRlDc+Lh2/MYMwuTbYHSRtjPgZNDVJg4cU96LLNR9Vp91Gbgl
        uB/U1mVoEdb88U954Xir/8BeuIv1r/C0+ksHdihGZOnxE+JuFZ8S63ElP8AXmbu0
        /N6EEsA2HgDhVKggURtE9jOyumZyzTfdB2W8z/WXqX7WNBd5FqltTuIMRgOfG9vu
        mvLYqYZll/qBtnYDKBCK/d/DZWlYrXHd1QxNBmbInV748XcRrgMu6JW6AQP/Nj1I
        UPuxzz85FF0PgwGjg65ECkGgbekOoIlJog7UGxMLxz3DSBHXtSTvxhp9M7wZpMcY
        2DzZW1u+GWkZzGY/zjVI0L6rLVkD3xwQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=1ZCWDiwfW4eZaQgzs
        wxbn2ITUkdxZP/Tl6+E1E76Oeo=; b=OYKf8zsgbMJcwtEhJ97gtKO1LaWdYpvVe
        qbKnQRwGziXYP4EYrGt09g56Hrqk1UJu25JmyoTtHYlVoZ94y6sO5LW1sUO/2wm7
        devXvdJztPRhdZiT35Xcn38K1PHDJXTmnBEwuNCdtPjRBhDLzgG2Ex/13FIc19Ve
        vmbP1ifZOO+ezprmd2javO7TS4F63A4VIcuNz2FjKcGmimPzNth3+wBwjUQ+KXiE
        qdykS/1AkC0M4he7tQywwzt2Exp5oRVtv59WxrUAXlRDtfvko25y8vGEVHCHK8Pf
        FrNn0YUqK0VAENyyhy3JRGRTy71R9YvZEpFNyC4AoSCsMrOxJLFFQ==
X-ME-Sender: <xms:acnuYeVjca6yguHb6e_wwQCmz1HMO2aodhdRb7Ag9ACMl-O3hbx-uA>
    <xme:acnuYaliGRs9-44dpZDBk8r1CN6Vl008vORuVt6_Bk6cnBZcScyev8KKq1-XM4Ule
    tlR3zT8RdxKkg>
X-ME-Received: <xmr:acnuYSYwn9E1U-Sw9UxtleBXE9F4G-FX13Tb7NN6IdSKk7I6kgARN3c6jOLsX4J4WELY6BK983azy7akf23ceonrsuEHtYzr>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrvdeigdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:acnuYVUQ9eEKebNkxLdXKZOtYDmHYC6X7wykoe3hqlTlJltV5PzxAw>
    <xmx:acnuYYkWpGI9epingw_Dpm3cTsAgPK_U8gRvmKDHVUISYzF7P7m-cw>
    <xmx:acnuYadKT4GMFpaUN2OTFMQNkiw0BdR5-s-r9lGeAQLc_vfQNTWFgQ>
    <xmx:asnuYWaMw_wvkocB9VezBelZe0QQ-J7TlPl8Fmjsa2_iM4ub1f8S3w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Jan 2022 10:44:41 -0500 (EST)
Date:   Mon, 24 Jan 2022 16:44:38 +0100
From:   Greg KH <greg@kroah.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4.14,4.19 1/2] fuse: fix bad inode
Message-ID: <Ye7JZuBUQVn4O0yO@kroah.com>
References: <Ye7C/r2HAXqKeg/7@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye7C/r2HAXqKeg/7@decadent.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 04:17:18PM +0100, Ben Hutchings wrote:
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
> [bwh: Backported to 4.19:
>  - Drop changes in fuse_dir_fsync(), fuse_readahead(), fuse_evict_inode()
>  - In fuse_get_link(), return ERR_PTR(-EIO) for bad inodes
>  - Convert some additional calls to is_bad_inode()
>  - Adjust filename, context]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Both now queued up, thanks!

greg k-h
