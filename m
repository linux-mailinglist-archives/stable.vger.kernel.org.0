Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF863095D5
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 15:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhA3OOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 09:14:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231794AbhA3ONf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 09:13:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87FDD61481;
        Sat, 30 Jan 2021 14:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612015975;
        bh=hVEmCIBYztt4d9c8Ji4GMgpVSOWgA1bgN+6q05pwWRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2YxpHTKFi2xkcC9iBy7A/VdtqF/5z+1Ul/KdYp9IR9kunProRPxfxCmoI43TwxGUZ
         Gs+hzz1OtAEPd3RRImA+mFk0+7DIC+iRb7MTPnyzjn/QviZ6InftwdxRuUdeZ0VGLK
         nl2VlEvylHXzpTigGrFJu2zGb2jKSlNfta8hQPeA=
Date:   Sat, 30 Jan 2021 15:12:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4.9 00/30] 4.9.254-rc1 review
Message-ID: <YBVpZMtp0NWDaNca@kroah.com>
References: <20210129105910.583037839@linuxfoundation.org>
 <7002f2eaccbe4822ace69408bdf67448@HQMAIL105.nvidia.com>
 <f39129e5-6d38-6c33-f31e-cf15e4c0399d@nvidia.com>
 <YBVIlENhvmBEndsU@kroah.com>
 <1f078011-6a83-1954-7a37-56ca6cbc633f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f078011-6a83-1954-7a37-56ca6cbc633f@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 30, 2021 at 01:52:25PM +0000, Jon Hunter wrote:
> 
> On 30/01/2021 11:52, Greg Kroah-Hartman wrote:
> 
> ...
> 
> > vger.kernel.org has been having some problems for the past few days in
> > sending messages out, which is why they wouldn't show up in lore as well
> > if they never get sent from the server.
> > 
> > I can add you as a direct cc: to the -rc announcements if you want me
> > to, to prevent this type of thing.  Just let me know if you, or anyone
> > else, wants on them.
> 
> 
> Yes if you could add me to cc list that would be great.

Now added:
	https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=2be9ba73cf0f6c3926f0d4caea60bb1feb141547

thanks,

greg k-h
