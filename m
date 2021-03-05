Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851BB32E27A
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 07:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhCEGr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 01:47:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhCEGr4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 01:47:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD0DC64FEB;
        Fri,  5 Mar 2021 06:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614926876;
        bh=gDm4oKzFgdEEWhz0D0B1lf6H4HghZokzmT+6gXlQGsw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q5Ji9lD8LwXlb8AzbSa9VAasizVxmPTx9DN9/9JCbnsbPYT9CRjVfxXZB6rLozAQR
         CGrKPS0qnsXeK6T4tvZiUAa1ZnbkKvsxEeb7iRk7cxZKxed1NVX85M4QKXhVchCu0+
         qXVrEVMA4NaAf0485wfzBy8De0OvXtOnlujzNf4k=
Date:   Fri, 5 Mar 2021 07:47:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org, snitzer@redhat.com
Subject: Re: [PATCH 4.4.y 0/2] dm: device capability check fixes
Message-ID: <YEHUGd2VpUpbU4Pn@kroah.com>
References: <161460624611368@kroah.com>
 <20210305063051.51030-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305063051.51030-1-jefflexu@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 02:30:49PM +0800, Jeffle Xu wrote:
> - patch 1 is from upstream
> - patch 2 is to fix the code specific to 4.4 (has been removed in upstream)
> 
> Jeffle Xu (2):
>   dm table: fix iterate_devices based device capability checks
>   dm table: fix no_sg_merge iterate_devices based device capability
>     checks

Why only 4.4.y for these?  What about all of the missing kernels in the
middle (4.9, 4.14, 4.19, 5.4)?  I can't apply fixes to one older branch
and ignore others, as someone might upgrade and have a regression.

Please provide fixes for those other trees too, and then I will be glad
to merge these.

thanks,

greg k-h
