Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803593B5DE2
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 14:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhF1MXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 08:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232833AbhF1MXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 08:23:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE11B61C71;
        Mon, 28 Jun 2021 12:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624882835;
        bh=6cdreBLVgjghdzCciD1FBErG4l5EHwHP75JwktByTos=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uCjOOqh01WD2E5WKSTLTPvnfnMGUeHKpShFmj0wPfUdUIAKN47H2xAk+5FS1ey4Sq
         OJUSHa48pQeSwkrLBwxH8aVrsbFTa9BMEYT43AS3f9A4g/sRpe9QYucvpOrRJGvf11
         PrAyu6GocsqDa1k9CxtmRo5HCi1xzqfh4NIpV6J0=
Date:   Mon, 28 Jun 2021 14:20:33 +0200
From:   'Greg KH' <gregkh@linuxfoundation.org>
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     'Bumyong Lee' <bumyong.lee@samsung.com>,
        'Christoph Hellwig' <hch@lst.de>,
        'Dominique MARTINET' <dominique.martinet@atmark-techno.com>,
        'Horia =?utf-8?Q?Geant=C4=83'?= <horia.geanta@nxp.com>,
        stable@vger.kernel.org,
        'Konrad Rzeszutek Wilk' <konrad.wilk@oracle.com>
Subject: Re: [PATCH] swiotlb: manipulate orig_addr when tlb_addr has offset
Message-ID: <YNm+kfvc/BnPkIpy@kroah.com>
References: <16246131632380@kroah.com>
 <CGME20210628065823epcas2p19305f8b888a7fc0e883ec51db61e3bae@epcas2p1.samsung.com>
 <513700442.21624870682149.JavaMail.epsvc@epcpadp4>
 <YNmQ9ZmZS658Rxfi@kroah.com>
 <1891546521.01624872602204.JavaMail.epsvc@epcpadp3>
 <YNmYE5aHvQBYn6cr@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNmYE5aHvQBYn6cr@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 11:36:19AM +0200, 'Greg KH' wrote:
> On Mon, Jun 28, 2021 at 06:25:28PM +0900, Chanho Park wrote:
> > > > commit 5f89468e2f060031cd89fd4287298e0eaf246bf6 upstream.
> > > > (Backported as different form due to absence of below patch series
> > > > https://lore.kernel.org/linux-iommu/20210301074436.919889-1-hch@lst.de/)
> > > 
> > > What stable kernel(s) is this for?
> > 
> > Hmm. I sent this with "--in-reply-to" option of git send-email with your
> > e-mail's message-id but it didn't work well.
> 
> That does not work when the message you are sending in-reply-to is no
> longer in the recipient's message box :)
> 
> > This is for linux-5.12.y tree.
> 
> Great, thanks.
> 
> > > And did you send the same patch twice?
> > 
> > No. Unfortunately, they're different due to swiotlb patches. I backported
> > the patch to each kernel versions respectively.
> 
> What is the "other" patch for?

Looks like 5.10.y.  Both now queued up, thanks.

greg k-h
