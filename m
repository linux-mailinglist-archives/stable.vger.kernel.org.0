Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F5D333C50
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 13:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhCJMMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 07:12:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232408AbhCJMMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 07:12:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB26764FD7;
        Wed, 10 Mar 2021 12:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615378322;
        bh=a45K7nyquRMNP9/bhjGqVKzxXR+qwkQ3zL8+TnRY2uM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kP883TZ+ZtOR+/NatLzkPhjc0DDVSJ2gAcLhmHO0ToLOYl1njgsd2OI/bB9HegDmX
         7rXDtqEV3WnMfJb71sf5L5zyz2eOwKVM04Y5MJ+bUyZt+ourQQEcF0+qoatvjdrO20
         wuD+sPoJ9VlvL2d15Rji26eegQTv5Il4VwNG2i4o=
Date:   Wed, 10 Mar 2021 13:11:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     snitzer@redhat.com, sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 4.19 0/3] dm table: fix iterate_devices based device
Message-ID: <YEi3jw9SGk8sxqu+@kroah.com>
References: <20210309033344.111111-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309033344.111111-1-jefflexu@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 09, 2021 at 11:33:41AM +0800, Jeffle Xu wrote:
> Backport notes are detailed in the corresponding commit log.
> 
> changes since v1:
> - fix build error of patch 1
> - fix upstream commit id of patch 2
> 
> Jeffle Xu (3):
>   dm table: fix iterate_devices based device capability checks
>   dm table: fix DAX iterate_devices based device capability checks
>   dm table: fix zoned iterate_devices based device capability checks
> 
>  drivers/md/dm-table.c | 174 ++++++++++++++++++------------------------
>  1 file changed, 73 insertions(+), 101 deletions(-)

Thanks for all the backports to the different branches.  All are now
queued up.  If I have missed anything, please resend.

thanks,

greg k-h
