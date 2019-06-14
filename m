Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58DF445509
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 08:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbfFNGwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 02:52:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfFNGwm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 02:52:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D89B020851;
        Fri, 14 Jun 2019 06:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560495161;
        bh=R4X8COWC1IjTnrCoyuvTCqVCIcLZQttphX3oh+/aZCc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kmTgm4uaLp/K8o9EZ7PRMk/HOcaQIY7RepsXIwwOikxbRgkdcWXeb9T4UUHkGjsMQ
         u+yAUWJa3cwKRSAf4Go65XfDozHoYJclrhf4hcqmnkain4fA11GHkQiAmp0aOPiSqI
         ILKuKugEUTImd3m2iT51xrt/vl5RihZTqKoZIK7o=
Date:   Fri, 14 Jun 2019 08:52:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiunn Chang <c0d1n61at3@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/155] 5.1.10-stable review
Message-ID: <20190614065238.GA21447@kroah.com>
References: <20190613075652.691765927@linuxfoundation.org>
 <20190613200849.veuc5crfejlcepgh@rYz3n>
 <20190614055040.GD27319@kroah.com>
 <20190614064454.qqvgqsqm6u535qeq@rYz3n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614064454.qqvgqsqm6u535qeq@rYz3n>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 14, 2019 at 01:44:56AM -0500, Jiunn Chang wrote:
> On Fri, Jun 14, 2019 at 07:50:40AM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Jun 13, 2019 at 03:08:49PM -0500, Jiunn Chang wrote:
> > > On Thu, Jun 13, 2019 at 10:31:52AM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.1.10 release.
> > > > There are 155 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sat 15 Jun 2019 07:54:40 AM UTC.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.10-rc1.gz
> > > > or in the git tree and branch at:
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > > -------------
> > > Compiled and booted.  No regressions on x86_64.
> > > 
> > > This is for 5.1.10-rc2 from git --no-pager log --oneline -1.
> > 
> > What do you mean by 'git --no-pager log --oneline -1' ?
> 
> Hello.  I must have missed an email somewhere.  The review request was for 5.1.10-rc1
> but I only had 5.1.10-rc2 from the logs.  Sorry for the confusion.

Ah, thanks, that made sense.  I pushed out a -rc2 because of some missed
patches and dropping one as well.

thanks,

greg k-h
