Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31FD3B14B2
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 09:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhFWHhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 03:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229916AbhFWHhB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 03:37:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A3AD60FDA;
        Wed, 23 Jun 2021 07:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624433683;
        bh=zVp16Al2ZaNe9A+v+foD48Mk+8GUKP4jIZTczxSQGmk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iDDXW91vE9Qx57L7b5haWZvIM9DzXJRBIBWRkH886SUQGTDNQq3gblzxcUXIs+5Wx
         8QOvDnekrwdP7sMvav6Kw/GXmVf+XE+w0FdlxC6SFRBfLAdZ0CWglSAcO/awEHEmmx
         dStYpmF9h1pI35K1nJNtUtvTZo4jV5mXoddxp4IE=
Date:   Wed, 23 Jun 2021 09:34:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kefeng Wang <wangkefeng.wang@huawei.com>
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        catalin.marinas@arm.com, will@kernel.org,
        akpm@linux-foundation.org, guohanjun@huawei.com,
        sudeep.holla@arm.com, song.bao.hua@hisilicon.com, ardb@kernel.org,
        anshuman.khandual@arm.com, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Li Huafei <lihuafei1@huawei.com>
Subject: Re: [PATCH stable v5.10 0/7] arm64: Default to 32-bit wide ZONE_DMA
Message-ID: <YNLkDJ8zHGRZ5iG8@kroah.com>
References: <9bc396116372de5b538d71d8f9ae9c3259f1002e.camel@suse.de>
 <YEDr/lYZHew88/Ip@kroah.com>
 <827b317d7f5da6e048806922098291faacdb19f9.camel@suse.de>
 <YETwL6QGWFyJTAzk@kroah.com>
 <604597E3.5000605@huawei.com>
 <YEX1OcbVNSqwwusF@kroah.com>
 <31cd8432-2466-555d-7617-ae48cbcd4244@huawei.com>
 <8b0a4f25-0803-9341-f3a4-277d16802295@huawei.com>
 <YNLe4CGtOgVvTOMN@kroah.com>
 <e47df0fd-0ddd-408b-2972-1b6d0a786f00@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e47df0fd-0ddd-408b-2972-1b6d0a786f00@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23, 2021 at 03:25:10PM +0800, Kefeng Wang wrote:
> 
> 
> On 2021/6/23 15:12, Greg KH wrote:
> > On Wed, Jun 23, 2021 at 02:59:59PM +0800, Kefeng Wang wrote:
> > > Hi Greg,
> > > 
> > > There are two more patches about the ZONE_DMA[32] changes,
> > 
> > What ZONE_DMA changes?
> 
> See the subject, [PATCH stable v5.10 0/7] arm64: Default to 32-bit wide
> ZONE_DMA, We asked the ARM64 ZONE_DMA change backport before, link[1]

The subject doesn't help much, sorry, what commit does this refer to?
What happened to it?  Was it accepted or rejected?

> > > especially the
> > > second one, both them need be backported, thanks.
> > 
> > Backported to where?
> 
> stable 5.10

Why?

> > > 791ab8b2e3db - arm64: Ignore any DMA offsets in the max_zone_phys()
> > > calculation
> > > 2687275a5843 - arm64: Force NO_BLOCK_MAPPINGS if crashkernel reservation is
> > > required
> > 
> > Have you tried these patches?  Where do they need to be applied to?
> 
> Yes, we tested it, without them, especially the second one, we will
> meet crash when using kexec boot, also there is discussion in [2]
> and [3] from Catalin.

These [] do not seem to be links :(

thanks,

greg k-h
