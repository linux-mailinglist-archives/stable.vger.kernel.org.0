Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82143F4BA9
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfKHMeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:34:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbfKHMeV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:34:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87788222C6;
        Fri,  8 Nov 2019 12:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216459;
        bh=Tp/mJy2ordfJXjH1/nl11N6dP2U17R3lP2KncOqlLPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QS7A4MHMADPPwdCjCQFnF8fFONxKv97OJOn0wTV8ACdb+uNUtyjKOlsHcfi86ISMP
         yIyYFFbzsqE3Kaf70NDdBj6RZit0Cw8APFlApq4X8fgjTRveyoacuQFmxAw+kl1vU6
         oreciYK+/wFP4uC73oZmBr9e6utaWeRDH+WH4oMw=
Date:   Fri, 8 Nov 2019 13:34:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 204/205] s390/qeth: limit csum offload
 erratum to L3 devices
Message-ID: <20191108123416.GA732985@kroah.com>
References: <20191108113752.12502-1-sashal@kernel.org>
 <20191108113752.12502-204-sashal@kernel.org>
 <2e4553d6-de1f-bb61-33e4-10a5c23f0aa7@linux.ibm.com>
 <20191108120025.GM4787@sasha-vm>
 <4d8f1938-af6e-7e0e-4085-2f7c53390b2d@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8f1938-af6e-7e0e-4085-2f7c53390b2d@linux.ibm.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 08, 2019 at 01:16:26PM +0100, Julian Wiedmann wrote:
> On 08.11.19 13:00, Sasha Levin wrote:
> > On Fri, Nov 08, 2019 at 12:50:24PM +0100, Julian Wiedmann wrote:
> >> On 08.11.19 12:37, Sasha Levin wrote:
> >>> From: Julian Wiedmann <jwi@linux.ibm.com>
> >>>
> >>> [ Upstream commit f231dc9dbd789b0f98a15941e3cebedb4ad72ad5 ]
> >>>
> >>> Combined L3+L4 csum offload is only required for some L3 HW. So for
> >>> L2 devices, don't offload the IP header csum calculation.
> >>>
> >>
> >> NACK, this has no relevance for stable.
> > 
> > Sure, I'll drop it.
> > 
> > Do you have an idea why the centos and ubuntu folks might have
> > backported this commit into their kernels?
> > 
> 
> No clue, I trust they have their own reasons.
> 

I cant see centos backporting anything unless they were asked to do so.
And this really looks like a "bugfix" to me, why isn't this relevant for
any older kernel versions?

thanks,

greg k-h
