Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D2F405824
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354379AbhIINrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:47:09 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:46271 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376536AbhIINkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 09:40:36 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id A738432003D3;
        Thu,  9 Sep 2021 09:39:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 09 Sep 2021 09:39:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=41Udo73aOdvDOjD4k8iPY3mPwcC
        C3oWIAmkjSaZ5Igc=; b=DVDclqBG3LQvs3D8DYSXqXyq72ZNjP93z+9Be/kFRre
        +gDU7WoCiN/ewNJDvwpI+EntP06bCo+enyKwsbivbpP5/jrVoQh8lE+fzvxJxrnV
        Lx5EqoPxSl4ZwOglhgGJTCbIZtyg3bwSSHG3xQYCDWUZjVo7VUpDNDIhDFiJXKGa
        6ip1egldwFc76CmQnu2wf+UcPQ6AeOFoebCD7mn4hfYSRDEwON2mjV55s+xBQaAG
        GYdoGOGaE8UUyUZUZQ5AsRj0ZVoM4x3FGwLIx1UqcNihyHq3N5Sn97PqHh7CAFMm
        BMfqk77IzobeYG+9le5VMVgGSutztktC+AYwOJZFNfg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=41Udo7
        3aOdvDOjD4k8iPY3mPwcCC3oWIAmkjSaZ5Igc=; b=j0mip+y4fn7Xr3vJPpA8Hq
        qbq0AvCKJ+c2MrOfvJpL2WUe/Hp508+uyP6tRCfyWKt4OK2TuM+rGBrowUPQrnGy
        a8b++H92+un4byKd3t1JoDsudiuHwtyH33xPb1nJHQpzW4PmsfZTKu+1XEuaBu7t
        jhklAdzzDcVZ0kVYEd/AygaMWC9nRe4JPrMy+uujgZNAVDpxXp0u/V4ALqPziEzn
        aEOIer7ZxCJQDH+vGRwwP7DfdsTpmZ6205TNJ1FvMKbHir2rkIUcSGTBYly5QLQ7
        z5iTA57xHRYAbwz0IVZKmXTBcJUlYD9FNkzNxOWFepjWWojDwEVcVgjfv3lyo+CA
        ==
X-ME-Sender: <xms:hw46YS3TdP4B5kX1pqp-uI2e0TLK7lQfIKiK4d7HbDvbrTKNmGqnRw>
    <xme:hw46YVF06kh6u_U4O7s5jqdA5hweODVe3pHiOirWnHYLdoFrTD5tqtvcfWyAZiRxN
    CtQMlhLRWKmoA>
X-ME-Received: <xmr:hw46Ya6kYCAc83Qswcw17W-XM5NBBTD4fhhapI0T2_wYdtfUdNtf3mbyGtNIff_xYK_9lMMwjULAZCWzXr_-DKlihQeo6VKp>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudefledgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:hw46YT3eZZas-M23SZ0HaVnRlDz7vvNWficzUdcANVaJKdk50vekEw>
    <xmx:hw46YVEyipHBdbzVUDU7ja2pUYQ1MQRndXIBqYZt0akI-o3icwsBzA>
    <xmx:hw46Yc_OnkLJuWNDeysFTr33evEA2O9hUclPVrOKuD50OJv9b_o6lg>
    <xmx:hw46YaTYkOkQaS3QwUhL9y6qYaUuGdpPHACeOBIy-wTG-WCnBAVBWQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Sep 2021 09:39:18 -0400 (EDT)
Date:   Thu, 9 Sep 2021 15:39:15 +0200
From:   Greg KH <greg@kroah.com>
To:     David Sterba <dsterba@suse.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 5.4, 4.19, 4.14] Revert "btrfs: compression: don't
 try to compress if we don't have enough pages"
Message-ID: <YToOg6MhWOb3Iw/f@kroah.com>
References: <20210909124750.29238-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909124750.29238-1-dsterba@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 02:47:50PM +0200, David Sterba wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> commit 4e9655763b82a91e4c341835bb504a2b1590f984 upstream.
> 
> This reverts commit f2165627319ffd33a6217275e5690b1ab5c45763.
> 
> [BUG]
> It's no longer possible to create compressed inline extent after commit
> f2165627319f ("btrfs: compression: don't try to compress if we don't
> have enough pages").
> 
> [CAUSE]
> For compression code, there are several possible reasons we have a range
> that needs to be compressed while it's no more than one page.
> 
> - Compressed inline write
>   The data is always smaller than one sector and the test lacks the
>   condition to properly recognize a non-inline extent.
> 
> - Compressed subpage write
>   For the incoming subpage compressed write support, we require page
>   alignment of the delalloc range.
>   And for 64K page size, we can compress just one page into smaller
>   sectors.
> 
> For those reasons, the requirement for the data to be more than one page
> is not correct, and is already causing regression for compressed inline
> data writeback.  The idea of skipping one page to avoid wasting CPU time
> could be revisited in the future.
> 
> [FIX]
> Fix it by reverting the offending commit.
> 
> Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
> Link: https://lore.kernel.org/linux-btrfs/afa2742.c084f5d6.17b6b08dffc@tnonline.net
> Fixes: f2165627319f ("btrfs: compression: don't try to compress if we don't have enough pages")
> CC: stable@vger.kernel.org # 4.4+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 29552d4f6845..33b8fedab6c6 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -543,7 +543,7 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
>  	 * inode has not been flagged as nocompress.  This flag can
>  	 * change at any time if we discover bad compression ratios.
>  	 */
> -	if (nr_pages > 1 && inode_need_compress(inode, start, end)) {
> +	if (inode_need_compress(inode, start, end)) {
>  		WARN_ON(pages);
>  		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
>  		if (!pages) {
> -- 
> 2.33.0
> 

All now queued up, thanks.

greg k-h
