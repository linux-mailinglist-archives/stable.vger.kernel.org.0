Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32E43B5B70
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 11:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhF1Jiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 05:38:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230256AbhF1Jit (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 05:38:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1673261C51;
        Mon, 28 Jun 2021 09:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624872984;
        bh=mCmy0IfWiMHGDfmQqRdOmjvSGyoc8/OzLNFKOWGy+r0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wxen53eYZov9Lq91OxsXg7uF6P4Z1IAiV3ygGa0B8Pd+kcjoqh4r/q/6VhVJG6jxV
         urBFMO1apJiO6KuTGu901rhswDPGXfPsfBoZI43kF22Jh5BZXc20/ziRrRikhNYM2z
         kvga4Y0DtMDlh57mA8pllztvkclkwPbnLHIEcrSY=
Date:   Mon, 28 Jun 2021 11:36:19 +0200
From:   'Greg KH' <gregkh@linuxfoundation.org>
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     'Bumyong Lee' <bumyong.lee@samsung.com>,
        'Christoph Hellwig' <hch@lst.de>,
        'Dominique MARTINET' <dominique.martinet@atmark-techno.com>,
        'Horia =?utf-8?Q?Geant=C4=83'?= <horia.geanta@nxp.com>,
        stable@vger.kernel.org,
        'Konrad Rzeszutek Wilk' <konrad.wilk@oracle.com>
Subject: Re: [PATCH] swiotlb: manipulate orig_addr when tlb_addr has offset
Message-ID: <YNmYE5aHvQBYn6cr@kroah.com>
References: <16246131632380@kroah.com>
 <CGME20210628065823epcas2p19305f8b888a7fc0e883ec51db61e3bae@epcas2p1.samsung.com>
 <513700442.21624870682149.JavaMail.epsvc@epcpadp4>
 <YNmQ9ZmZS658Rxfi@kroah.com>
 <1891546521.01624872602204.JavaMail.epsvc@epcpadp3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1891546521.01624872602204.JavaMail.epsvc@epcpadp3>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 06:25:28PM +0900, Chanho Park wrote:
> > > commit 5f89468e2f060031cd89fd4287298e0eaf246bf6 upstream.
> > > (Backported as different form due to absence of below patch series
> > > https://lore.kernel.org/linux-iommu/20210301074436.919889-1-hch@lst.de/)
> > 
> > What stable kernel(s) is this for?
> 
> Hmm. I sent this with "--in-reply-to" option of git send-email with your
> e-mail's message-id but it didn't work well.

That does not work when the message you are sending in-reply-to is no
longer in the recipient's message box :)

> This is for linux-5.12.y tree.

Great, thanks.

> > And did you send the same patch twice?
> 
> No. Unfortunately, they're different due to swiotlb patches. I backported
> the patch to each kernel versions respectively.

What is the "other" patch for?

greg k-h
