Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEC7478EA1
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 15:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237652AbhLQO40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 09:56:26 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:49545 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234609AbhLQO40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 09:56:26 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id C54943201EA8;
        Fri, 17 Dec 2021 09:56:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 17 Dec 2021 09:56:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=uWdbuu7/zAxioolr7xAyIcvJl7f
        t2nWZebfQdaeVQgM=; b=qTyIVfTTuCKwH6l/RtdsRYhh3fnDFTl3QPIZVdW8Ul2
        Wgs3CoS7uOLhMP8VD6l+PdLQGUMLD4ZpbzpAIEENDftY79s/AHXdeBTLWmc0gKIK
        hqz+BPFoXiFLU5OPaNe4Ow/0IYW5ImxROdf2FBOULsP8cp6N6+CMwdXyCLwnnRzm
        AbYGpfc69CJTCUC9cLrVk0c9vFnVaSDzr02teeNCZ2eT2gAYrkv0tIjb9V22kvGK
        5uiAfj7DZsJwBQ1NV0jlCNk8HdEhp//wAPnXxMCfooQEnuvb8pIiwsT8CnmAuN2f
        muELjq2+1u4Et2xOluBg6QFFiS5L/vkaoOWI8x3W/Lw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uWdbuu
        7/zAxioolr7xAyIcvJl7ft2nWZebfQdaeVQgM=; b=GS+AoKvCZdAHon+Y+NBM4l
        zBWeo2CCgFCZ8ozv1EiSmqLC05P1RJDQ6qgIOBonW6/zdvMghxa/5nJGaQggCtt/
        +XIcZcu0HzqsANUx7quJJO7+DSwGd6RbO6LZk5y1rfqpVeqNj+l0KCcGztDpu7ff
        AKLQzUjsHgNqA3r3y/NWsloTwgQgSNuztD+xth2C9vLXHs6ke3dVUlctk3fvpQIH
        QgvaevPneSu+PvJGf3rHBtDJ6l7wAZ00dhLCz0tsqGcgvER3SmEz2P6Icagl1e/C
        fKKxI6oR4ATijz00ZLuvIutOZeLQZfLebwHoueuktfix7ArR5mzMATLJzvsWrwHQ
        ==
X-ME-Sender: <xms:GKW8YRDCaVTC5rP-8GU73DHcg8bQhRpKaP-ZE3jdF6smUYLlYbN4OA>
    <xme:GKW8YfgcGAQgmDhVub3BzaNrug6oZAW_zHpqZGo66ynbvOundOEgpaCyMsrGfe8ph
    980AN7z1q184w>
X-ME-Received: <xmr:GKW8Ycl9SyS3qOPO-nc1rDMVvS9eeqJhJtCzlfwqwEOD_ABemeUqNK3mE-Ab4GkzL-t35I6FiFoHhJmr7dbTkBvoaL2xGQAW>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrleeigdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:GKW8YbyQVs8WHIBUt1xbmrEsaG4ynJLPiLjFEqW9XjSZLwZHKsB40g>
    <xmx:GKW8YWRMeL8UOK3FncxlMMF-hn74n_WIfZWpEcGV4LHQhFbM9kbewQ>
    <xmx:GKW8Yeb68D_1TWKTobksf4p2omVZ3ayXjipgtZ47RRrXPP9HTJiKaA>
    <xmx:GKW8YVHLC90QWDhTrBQ_D591XFWi7s90PtGJFYWyAFgbEZ5ZQc8Pbg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Dec 2021 09:56:23 -0500 (EST)
Date:   Fri, 17 Dec 2021 15:56:21 +0100
From:   Greg KH <greg@kroah.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH stable-5.15.y 0/4] backport test case btrfs/216 fixes
Message-ID: <YbylFav0uyKztfKX@kroah.com>
References: <cover.1639658429.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1639658429.git.anand.jain@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 16, 2021 at 09:04:09PM +0800, Anand Jain wrote:
> In an attempt to make all the fstests test cases pass on stable-5.15.y,
> backport fixes for the test case btrfs/216.
> 
> Anand Jain (4):
>   btrfs: convert latest_bdev type to btrfs_device and rename
>   btrfs: use latest_dev in btrfs_show_devname
>   btrfs: update latest_dev when we create a sprout device
>   btrfs: remove stale comment about the btrfs_show_devname
> 
>  fs/btrfs/disk-io.c   |  6 +++---
>  fs/btrfs/extent_io.c |  2 +-
>  fs/btrfs/inode.c     |  2 +-
>  fs/btrfs/super.c     | 26 ++++++--------------------
>  fs/btrfs/volumes.c   | 19 +++++++------------
>  fs/btrfs/volumes.h   |  6 +++++-
>  6 files changed, 23 insertions(+), 38 deletions(-)
> 
> -- 
> 2.33.1
> 

Now queued up, thanks.

greg k-h
