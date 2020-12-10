Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0382D5AC5
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 13:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgLJMop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 07:44:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgLJMop (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 07:44:45 -0500
Date:   Thu, 10 Dec 2020 13:45:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607604245;
        bh=NrhViBIikdZpdsINVNxsqQwUhGdBa+2ZJGpbT/uYvNE=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=DG1ZvAJ1/A7RpPvmpE+2/N1Tyl79QyIhpBm1ncTj8E2SdhUKdqaLGgbYnsHknTRBF
         f0mxdz29psX7ejPk6EWIh0pldPd0ex6ZI4EzmNcxAWoxjdIIdxiryJvzkgshFfwELf
         JHeRASKA8Lk8KonFFuydhrZVadMlGFzlXrYwMxcg=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Sasha Levin <sashal@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19-stable 4/5] spi: bcm2835aux: Fix use-after-free on
 unbind
Message-ID: <X9IYX/aUVyjmNF/p@kroah.com>
References: <20201208004901.GB587492@ubuntu-m3-large-x86>
 <20201208073241.GA29998@wunner.de>
 <20201208134739.GJ643756@sasha-vm>
 <20201208171145.GA3241@wunner.de>
 <20201208211745.GL643756@sasha-vm>
 <20201209083747.GA7377@wunner.de>
 <X9Cat0z0YBZkXlvv@kroah.com>
 <20201209093818.GA3082@wunner.de>
 <X9Ccm7X1id8Jj9SH@kroah.com>
 <20201210070142.GA20930@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210070142.GA20930@wunner.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 08:01:42AM +0100, Lukas Wunner wrote:
> On Wed, Dec 09, 2020 at 10:44:59AM +0100, Greg KH wrote:
> > On Wed, Dec 09, 2020 at 10:38:18AM +0100, Lukas Wunner wrote:
> > > On Wed, Dec 09, 2020 at 10:36:55AM +0100, Greg KH wrote:
> > > > On Wed, Dec 09, 2020 at 09:37:47AM +0100, Lukas Wunner wrote:
> > > > > Then please apply the series sans bcm2835aux patch and I'll follow up
> > > > > with a two-patch series specifically for that driver.
> > > > 
> > > > Can you just resend the whole series so we know we got it correct?
> > > 
> > > The other patches in the series do not depend on the bcm2835aux patch,
> > > so you can apply them independently.
> > 
> > Ok, so I need to drop this patch from all of the other series you sent
> > out?  You can see how this is getting messy from my side :)
> 
> Is this workflow description still up-to-date?
> 
> http://kroah.com/log/blog/2019/08/14/patch-workflow-with-mutt-2019/
> 
> So you just select all patches in Mutt sans the bcm2835aux one
> and apply them?
> 
> No I don't see how this is getting messy.

The less "special" steps I have to make, the less chance I mess
something up :)

I've queued these up now, please check that I got it right.

thanks,

greg k-h
