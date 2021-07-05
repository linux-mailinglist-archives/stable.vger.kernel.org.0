Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8870A3BBCF6
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 14:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhGEMoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 08:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230247AbhGEMoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 08:44:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A79E4613B1;
        Mon,  5 Jul 2021 12:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625488904;
        bh=noq3mCTTwESC4Nxv5J1TF1BVeluE8yJc2357oDbEjv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LSe03/Mey7kCOXEivXWoCpJ/mnTTIZuhzjLCs2Z3aAy/c/ioo45cOV1I71KbIvYmh
         ytSuPXzTncRgagLln0dgoxZaEfa3/jeSju2LFwZS7IdaUDOFX63+IyqfiYGy9M6oLn
         wclBtbaVfOacFoYfZxRJxYZKQZviahkV9rthvke4=
Date:   Mon, 5 Jul 2021 14:41:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Backlund <tmb@iki.fi>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.13 0/2] 5.13.1-rc1 review
Message-ID: <YOL+BC88bdcaIOho@kroah.com>
References: <20210705105656.1512997-1-sashal@kernel.org>
 <4c383f24-5423-e076-12fc-7c6511e34a96@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c383f24-5423-e076-12fc-7c6511e34a96@iki.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 05, 2021 at 03:13:57PM +0300, Thomas Backlund wrote:
> Den 5.7.2021 kl. 13:56, skrev Sasha Levin:
> > 
> > This is the start of the stable review cycle for the 5.13.1 release.
> > There are 2 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 07 Jul 2021 10:49:46 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> >          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.13.y&id2=v5.13
> > or in the git tree and branch at:
> >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> > and the diffstat can be found below.
> > 
> > Thanks,
> > Sasha
> > 
> 
> This one should be added  too:
> 
> From 66d9282523b3228183b14d9f812872dd2620704d Mon Sep 17 00:00:00 2001
> From: Mel Gorman <mgorman@techsingularity.net>
> Date: Mon, 28 Jun 2021 16:02:19 +0100
> Subject: [PATCH] mm/page_alloc: Correct return value of populated elements
> if
>  bulk array is populated
> 
> 
> to unbreak nfs in 5.13 series ...
> 
> the cause and fix is confirmed in several threads both on lkml and stable@

Now queued up, thanks.

greg k-h
