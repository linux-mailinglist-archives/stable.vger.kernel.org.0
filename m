Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9F7200879
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 14:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731946AbgFSMP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 08:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731561AbgFSMPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 08:15:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 325EA206F1;
        Fri, 19 Jun 2020 12:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592568922;
        bh=iKfxUtSwfd8GJpO99b5yhP64C7C5hJbsS373MWyrUdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tdecBttIc0E8AErtGptd2Xk1AwSnrVYA+jHJQiTwotVJfhMykUFA7cc//yS3HJQ4e
         6OmzQxzFCv8x+ugdHJjgptzLtEIlwEgkYrgMNbuiqHar6mzSaAoDnfnzo3ujLzMJPu
         O2tep7g8y8U01DScBLqzs+24Tr38NvIeXy2iWKgU=
Date:   Fri, 19 Jun 2020 14:15:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Monakov <amonakov@ispras.ru>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "x86/amd_nb: Add AMD family 17h model 60h PCI IDs" has
 been added to the 5.7-stable tree
Message-ID: <20200619121519.GA966797@kroah.com>
References: <20200618211421.CDE7820890@mail.kernel.org>
 <alpine.LNX.2.20.13.2006191051350.31660@monopod.intra.ispras.ru>
 <20200619083502.GC473790@kroah.com>
 <alpine.LNX.2.20.13.2006191155380.21166@monopod.intra.ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.20.13.2006191155380.21166@monopod.intra.ispras.ru>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 11:59:34AM +0300, Alexander Monakov wrote:
> 
> 
> On Fri, 19 Jun 2020, Greg KH wrote:
> 
> > On Fri, Jun 19, 2020 at 10:56:42AM +0300, Alexander Monakov wrote:
> > > On Thu, 18 Jun 2020, Sasha Levin wrote:
> > > 
> > > > This is a note to let you know that I've just added the patch titled
> > > > 
> > > >     x86/amd_nb: Add AMD family 17h model 60h PCI IDs
> > > > 
> > > > to the 5.7-stable tree which can be found at:
> > > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > > > 
> > > > The filename of the patch is:
> > > >      x86-amd_nb-add-amd-family-17h-model-60h-pci-ids.patch
> > > > and it can be found in the queue-5.7 subdirectory.
> > > > 
> > > > If you, or anyone else, feels it should not be added to the stable tree,
> > > > please let <stable@vger.kernel.org> know about it.
> > > 
> > > It's not good to pick this patch alone into stable. Either all 3 patches
> > > from https://lore.kernel.org/lkml/20200510204842.2603-1-amonakov@ispras.ru/
> > > should be taken, or none of those.
> > > 
> > > In particular, the edac module will warn on load without the third patch.
> > > 
> > > Likewise for 5.4-stable (should I send a separate mail for that?)
> > 
> > What are the git commit ids that should be applied that are not?
> 
> 279f0b3a4b8066 ("hwmon: (k10temp) Add AMD family 17h model 60h PCI match")
> 
> b6bea24d41519e ("EDAC/amd64: Add AMD family 17h model 60h PCI IDs")

Thanks, all now queued up!

greg k-h
