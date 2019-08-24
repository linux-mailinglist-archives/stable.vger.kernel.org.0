Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 042259BF2E
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 20:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfHXSPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 14:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbfHXSPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Aug 2019 14:15:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD08120850;
        Sat, 24 Aug 2019 18:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566670501;
        bh=Fm7mi79kuXFlu72u/nRxTV19zZ5AlnR6aNUqjUPwWsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CghipgIeEWZGzBVJHSETbVTbw+rMp7qZc6UoaMN7/X1iButo6oRnWIucOjQGpQ3yk
         i3+/XdleCjQH8TcCObshDeZM4BIdwMV62w1Znu+lFKkG8wNxfFP8AlFehrPdkFRr2F
         87lS+D2crbHjb/nmZcwkkIUwlu6ZxYzpxDb4cJrM=
Date:   Sat, 24 Aug 2019 20:14:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/78] 4.4.190-stable review
Message-ID: <20190824181458.GB10804@kroah.com>
References: <20190822171832.012773482@linuxfoundation.org>
 <25b2dca3-0cda-e88d-97a3-229e98cce0f6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25b2dca3-0cda-e88d-97a3-229e98cce0f6@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 24, 2019 at 12:03:07PM -0600, shuah wrote:
> On 8/22/19 11:18 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.190 release.
> > There are 78 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 24 Aug 2019 05:18:13 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.190-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
