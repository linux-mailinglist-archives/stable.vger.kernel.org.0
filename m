Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C623A29A4E1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 07:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391881AbgJ0Gtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 02:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729265AbgJ0Gtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 02:49:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56E3B20B1F;
        Tue, 27 Oct 2020 06:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603781371;
        bh=mC9vO0dxC2iwBHUgA32C+X17h0ZN7BMvlr+FQ0VVYZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fxIWQVFrgjaP9oHckLR7UotxVbhf0uHGo5ba6h6QmPIb4dTEa+mb9Yx6VLkgmAbUG
         +9QhhpO5oLfN2iY17IaLCbCv9LVpC1mDv2FuTu/u94/61LjPnL7szyif04a8G/Ebe3
         1crIdCqFwu5zYmWlLW2jh/Z5FN3E6zPJOc55EW54=
Date:   Tue, 27 Oct 2020 07:49:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH linux-5.9 1/1] net: netfilter: fix KASAN:
 slab-out-of-bounds Read in nft_flow_rule_create
Message-ID: <20201027064927.GA211164@kroah.com>
References: <20201019172532.3906-1-saeed.mirzamohammadi@oracle.com>
 <20201020115047.GA15628@salvia>
 <28C74722-8F35-4397-B567-FA5BCF525891@oracle.com>
 <3BE1A64B-7104-4220-BAD1-870338A33B15@oracle.com>
 <566D38F7-7C99-40F4-A948-03F2F0439BBB@oracle.com>
 <20201027062111.GD206502@kroah.com>
 <20201027064226.GA15770@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027064226.GA15770@breakpoint.cc>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 07:42:26AM +0100, Florian Westphal wrote:
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> [ Trimming CC ]
> 
> > On Sun, Oct 25, 2020 at 04:31:57PM -0700, Saeed Mirzamohammadi wrote:
> > > Adding stable.
> > 
> > What did that do?
> 
> Its a request to pick up
> 
> commit 31cc578ae2de19c748af06d859019dced68e325d
> Author: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> Date:   Tue Oct 20 13:41:36 2020 +0200
> 
>     netfilter: nftables_offload: KASAN slab-out-of-bounds Read in nft_flow_rule_create
> 
> Which lacks a Fixes tag.  Should have been:
> 
> Fixes: c9626a2cbdb20e2 ("netfilter: nf_tables: add hardware offload support")
> (v5.3+)
> 
> Hope that makes things clearer.

That makes it much more obvious and clearer, thank you.  Saeed, please
be more explicit in the future.

thanks,

greg k-h
