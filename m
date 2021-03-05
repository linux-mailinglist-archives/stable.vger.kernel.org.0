Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE0832E3DD
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 09:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCEIpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 03:45:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhCEIor (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 03:44:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4818E64F21;
        Fri,  5 Mar 2021 08:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614933886;
        bh=CSHWMSR4Bg42udNblYkAkw9At0mBE3i1CqyxAuLSkLY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ve7AZovYOicVjH+4dg+Pp9adi5024XNw+odsd8hggR8p3gYDNX5529FkkBsitf/hf
         5uSxWgN+dEdcU/rU4sGEFgyGI8d7m3EzuL78b/QnAjRwQIkzYCSwOwlW8LqbCWqyry
         Mw7aehyhWa4BO07QtVeKTDvYhtmCXMY1UgbbxOa8=
Date:   Fri, 5 Mar 2021 09:44:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org, snitzer@redhat.com
Subject: Re: [PATCH 5.4.y 2/4] dm table: fix partial completion
 iterate_devices based device capability checks
Message-ID: <YEHve5QkPuimNnnY@kroah.com>
References: <161460625264244@kroah.com>
 <20210305065722.73504-1-jefflexu@linux.alibaba.com>
 <20210305065722.73504-3-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305065722.73504-3-jefflexu@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 02:57:20PM +0800, Jeffle Xu wrote:
> Similar to commit a4c8dd9c2d09 ("dm table: fix iterate_devices based
> device capability checks"), fix partial completion capability check and
> invert logic of the corresponding iterate_devices_callout_fn so that all
> devices' partial completion capabilities are properly checked.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> Fixes: 22c11858e800 ("dm: introduce DM_TYPE_NVME_BIO_BASED")
> ---
>  drivers/md/dm-table.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Why isn't this a commit in Linus's tree?  That needs to be really really
explicitly documented here.

thanks,

greg k-h
