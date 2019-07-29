Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B33C792BF
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 20:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfG2SBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 14:01:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbfG2SBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 14:01:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39EB3206BA;
        Mon, 29 Jul 2019 18:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564423299;
        bh=52c1nW5heDpTP/El9Iy9uFqcvw8UtHQKUJlSWaFumJw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uw8bJEadKbmw1AuUSVvPa5d6fMyhSN92qJ3owhe6SX7jhpWeOjYUiKxmSfuJ00Z7t
         FdbCH8ag48dBX8ddhDtTkPC2TCmKb+u/VU/UiZIplDeAFJB0UxecxnntWK90MtxRH6
         vHuH4SLvxrpy0DouUQ4ZJfitGBswhLEPvuBvLzxM=
Date:   Mon, 29 Jul 2019 20:01:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Wagner <wagi@monom.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH 4.4 0/2] vmstat backports
Message-ID: <20190729180137.GA3471@kroah.com>
References: <20190729154046.8824-1-wagi@monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729154046.8824-1-wagi@monom.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 05:40:44PM +0200, Daniel Wagner wrote:
> Hi Greg,
> 
> Second attempt on this topic [1]:
> 
> """
> Upstream commmit 0eb77e988032 ("vmstat: make vmstat_updater deferrable
> again and shut down on idle") was back ported in v4.4.178
> (bdf3c006b9a2). For -rt we definitely need the bugfix f01f17d3705b
> ("mm, vmstat: make quiet_vmstat lighter") as well.
> 
> Since the offending patch was back ported to v4.4 stable only, the
> other stable branches don't need an update (offending patch and bug
> fix are already in).
> """
> 
> Though I missed a dependency as Jon noted[2]. The missing patch is
> 587198ba5206 ("vmstat: Remove BUG_ON from vmstat_update"). I've tested
> this on a Tegra K1 one board which exposed the bug. With this should
> be fine.
> 
> While at it, I looked on all relevant changes for
> vmstat_updated(). These two patches are the only relevant changes
> which are missing. It seems almost all changes from mainline have made
> it back to v4.
> 
> Could you please queue the above patches for v4.4.y?
> 
> Thanks,
> Daniel
> 
> [1] https://lore.kernel.org/stable/20190513061237.4915-1-wagi@monom.org
> [2] https://lore.kernel.org/stable/f32de22f-c928-2eaa-ee3f-d2b26c184dd4@nvidia.com
> 
> 
> Christoph Lameter (1):
>   vmstat: Remove BUG_ON from vmstat_update
> 
> Michal Hocko (1):
>   mm, vmstat: make quiet_vmstat lighter
> 
>  mm/vmstat.c | 80 +++++++++++++++++++++++++++++++----------------------
>  1 file changed, 47 insertions(+), 33 deletions(-)

Now queued up.

greg k-h
