Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10A931242E
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 13:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhBGL5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 06:57:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhBGL5d (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Feb 2021 06:57:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08FA360230;
        Sun,  7 Feb 2021 11:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612699012;
        bh=JiqG1IrlgA+mzgVZR03m4oYvhTXQ9B4bZmzaB4hGMUA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sld+97zzjeOa7RC1NKdXX8UupGsMY69Vf0t08+UWF7So/DXdZCHTEzQLY6TMHC8YX
         GbNtQ1s9fRDvNxriP6YrcA0TxVuSKka2l9ZeqpAkbgrXpTUD2JwvG39IK3l/qmiiDA
         fHw91URK+Zw+pvbnoNHYvMwLkDLljdyDfnapC+CM=
Date:   Sun, 7 Feb 2021 12:56:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] virtio-blk: close udev startup race condition as
 default groups
Message-ID: <YB/Vgb4y4Dts0Y2G@kroah.com>
References: <20210207114656.32141-1-jefflexu@linux.alibaba.com>
 <20210207114656.32141-2-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210207114656.32141-2-jefflexu@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 07, 2021 at 07:46:54PM +0800, Jeffle Xu wrote:
> commit fef912bf860e8e7e48a2bfb978a356bba743a8b7 upstream.
> commit e982c4d0a29b1d61fbe7716a8dcf8984936d6730 upstream.
> 
> Similar to commit 9e07f4e24379 ("zram: close udev startup race condition
> as default groups"), this is a merge of [1, 2], since [1] may be too
> large size to be merged into -stable tree.

Why is it too big?

> This issue has been introduced since v2.6.36 by [3].
> 
> [1] fef912bf860e, block: genhd: add 'groups' argument to device_add_disk
> [2] e982c4d0a29b, virtio-blk: modernize sysfs attribute creation
> [3] a5eb9e4ff18a, virtio_blk: Add 'serial' attribute to virtio-blk devices (v2)

What userspace tools are now hitting this issue?  If it's a real
problem, let's take the real commits, right?

Same for the other patches in this series.

thanks,

greg k-h
