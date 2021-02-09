Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89F1314BE4
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 10:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhBIJji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 04:39:38 -0500
Received: from verein.lst.de ([213.95.11.211]:45736 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230264AbhBIJhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 04:37:25 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3634268B02; Tue,  9 Feb 2021 10:36:42 +0100 (CET)
Date:   Tue, 9 Feb 2021 10:36:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     obayashi.yoshimasa@socionext.com, sumit.garg@linaro.org,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, daniel.thompson@linaro.org
Subject: Re: DMA direct mapping fix for 5.4 and earlier stable branches
Message-ID: <20210209093642.GA1006@lst.de>
References: <CAFA6WYNazCmYN20irLdNV+2vcv5dqR+grvaY-FA7q2WOBMs__g@mail.gmail.com> <YCIym62vHfbG+dWf@kroah.com> <CAFA6WYM+xJ0YDKenWFPMHrTz4gLWatnog84wyk31Xy2dTiT2RA@mail.gmail.com> <YCJCDZGa1Dhqv6Ni@kroah.com> <27bbe35deacb4ca49f31307f4ed551b5@SOC-EX02V.e01.socionext.com> <YCJUgKDNVjJ4dUqM@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCJUgKDNVjJ4dUqM@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 10:23:12AM +0100, Greg KH wrote:
> >   From the view point of ZeroCopy using DMABUF, is 5.4 not 
> > mature enough, and is 5.10 enough mature ?
> >   This is the most important point for judging migration.
> 
> How do you judge "mature"?
> 
> And again, if a feature isn't present in a specific kernel version, why
> would you think that it would be a viable solution for you to use?

I'm pretty sure dma_get_sgtable has been around much longer and was
supposed to work, but only really did work properly for arm32, and
for platforms with coherent DMA.  I bet he is using non-coherent arm64,
and it would be broken for other drivers there as well if people did
test them, which they apparently so far did not.
