Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A47E12F592
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 09:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgACIiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 03:38:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgACIiV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 03:38:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFD8122314;
        Fri,  3 Jan 2020 08:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578040701;
        bh=63q4wtYcTN4pYASfvrCQ7vgqOyOjRrhkYeZ0ec+82MY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GRnyjTC7PY/95qEriIeCOWhR6+3IiIgzHquXfcNVb34I6+UB8ceugip+1GQ9yZGgc
         6k9HozSBF3hbEvySlWXhAxF+51CimVPiPvViQRReJt0MfcqMXa33K3sL+DAfLpsdZX
         7yhoO96Z4V2G29w7a/GW1QFs3bMdDvMrHL84FfBA=
Date:   Fri, 3 Jan 2020 09:38:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/91] 4.14.162-stable review
Message-ID: <20200103083819.GC831558@kroah.com>
References: <20200102220356.856162165@linuxfoundation.org>
 <20200102230518.GA1087@roeck-us.net>
 <20200103001639.GK16372@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103001639.GK16372@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 07:16:39PM -0500, Sasha Levin wrote:
> On Thu, Jan 02, 2020 at 03:05:18PM -0800, Guenter Roeck wrote:
> > On Thu, Jan 02, 2020 at 11:06:42PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.14.162 release.
> > > There are 91 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sat, 04 Jan 2020 22:01:54 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > drivers/pci/switch/switchtec.c: In function 'ioctl_event_summary':
> > drivers/pci/switch/switchtec.c:901:18: error: implicit declaration of function 'readq'; did you mean 'readl'?
> > 
> > The problem also affects v4.19.y. Seen with various 32-bit builds,
> > including i386:allmodconfig and arm:allmodconfig.
> > 
> > The backport replaces ioread64 with readq, which may not have been
> > such a good idea.
> 
> Indeed. I'll drop it for now, thanks!

I've pushed out -rc2 versions with this patch removed now.

thanks,

greg k-h
