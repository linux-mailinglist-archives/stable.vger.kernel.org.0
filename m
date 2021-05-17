Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC946382590
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 09:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbhEQHoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 03:44:04 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:33421 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231887AbhEQHn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 03:43:58 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 4AF39934;
        Mon, 17 May 2021 03:42:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 May 2021 03:42:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=AVi3YZJc4XkbkDo5VHVbsQ0vX1G
        myxr1eYlRIuWmfs0=; b=oLR/oZnUNT2kjTsElOEfRqFWHUWTjqnRM+fKRnLxAbg
        uGNNXHu4VUJlpeZP0dD/iD4fHXSgT2tol8LirXIo4I/jrslVpNX+DXooBqCAFM3v
        LYd/c4dn59JFDBcdqTgC2igfRw9bldKvv9JArPBnCylPNniJfNylGl1um49tI7ye
        ntE3jsk2+om5aMF0BXXXZiqpET++oFGb73a8Y3vFYbwIA+esioDz5jAKZDNQPHnM
        diCHixj+geDp2DwUap45qoBPW+rBPr6TsFgKt0txvFS49EDJ38gfOH18J2fmHRjd
        +OhHSMKTMkwrULMC9a2nD6ToaIzfe+XIog8D9LZw+/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=AVi3YZ
        Jc4XkbkDo5VHVbsQ0vX1Gmyxr1eYlRIuWmfs0=; b=HUmR1C1hEAuZEfv98s+euy
        tcTCls5bIweqh9qyWG0lWgllmdNgpWpa2/l92AJuSLgZamqanBt1GohnvX7efIAK
        4eWQ4+F1YK7fjI8BFDOxnssg/RIcgcMIjCbAyw4sOfBCs6BWjHmnkIOVOfn16+YL
        RcCT+fDSif09z8DQCU6lCK38YNUKBWqd2P6be4v1v8hwxnnoCvyh+LFrLGRIZmGe
        reV+W40tVCW8CP7y2sJbjlW6FVG0EI4EdSZlCNtYbodGkPHQxSZv575SfCL75j5X
        5nG6E6U1ltA+Dfo/1GVh1hlTz6Xlb2UZYfvH1PYJsoXBVllNBnXDEmTo2SuQZ9HA
        ==
X-ME-Sender: <xms:ZB6iYNEHZi1UlfrghVis3SttCBbg66MjPAQbQHxcwlM4DqajtSD78A>
    <xme:ZB6iYCU2GbraCvk5tZFzCMgvxw_llFDwbT6cTjFK7ppZ8AaJbwTwrG-eE11FVNVRg
    VpMadmlGKLSEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeigedguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ZB6iYPKj3drYqaOz3k5THZCtvSOJ9WZ7GL77KpeGyLhTwTMSZ8Mv1Q>
    <xmx:ZB6iYDGmpZW7lWkts0-LDbc8vjbX7Q3CpKssclMtbdZ8tHznccunWw>
    <xmx:ZB6iYDWNR3qNuurz33RdAbZ5IaMDvAktDG3Pz5AqonEYDOXnolx8Pw>
    <xmx:ZB6iYGOrE4vUUGct57EgCQQeIPMmGI8GThXbwAY4vpFX-iNUpSCL6hAMRXA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 03:42:27 -0400 (EDT)
Date:   Mon, 17 May 2021 09:42:26 +0200
From:   Greg KH <greg@kroah.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Jan Stancek <jstancek@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5.4] iomap: fix sub-page uptodate handling
Message-ID: <YKIeYkw1YjkT4hth@kroah.com>
References: <20210516150328.2881778-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210516150328.2881778-1-willy@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 16, 2021 at 04:03:28PM +0100, Matthew Wilcox (Oracle) wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> commit 1cea335d1db1ce6ab71b3d2f94a807112b738a0f upstream
> 
> bio completions can race when a page spans more than one file system
> block.  Add a spinlock to synchronize marking the page uptodate.
> 
> Fixes: 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O without buffer heads")
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/iomap/buffered-io.c | 34 ++++++++++++++++++++++++----------
>  include/linux/iomap.h  |  1 +
>  2 files changed, 25 insertions(+), 10 deletions(-)

No s-o-b from you as you did the backport?  :(

Anyway, what about a 4.19.y version?

thanks,

greg k-h
