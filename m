Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2B232D1AE
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 12:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbhCDLXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 06:23:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:42310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236682AbhCDLXJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 06:23:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7552964E89;
        Thu,  4 Mar 2021 11:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614856948;
        bh=66PVh23xqYrT9713Kz/6lSpeWD37Ayis4kZMfkybk2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mC4OWMAN5SGjnvwurNTI34uR/zkeY1Rxd6Zf/Jv7fMutissa9AkmREcDA6B5a3wbe
         JeAYvAsf2J0vRl/zqGG4wmzQ+Dib2+X/2njet8L6QIgtFE1LnQf1d0Sedw2oiIwJO4
         kwC8zd7VReVdKaa5na6eD69EfyhQxrhmGpICg4OA=
Date:   Thu, 4 Mar 2021 12:22:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/774] 5.11.3-rc2 review
Message-ID: <YEDC8hugz6niEC0u@kroah.com>
References: <20210301193729.179652916@linuxfoundation.org>
 <664d3da1-9961-1a02-3f22-3f01fc7948b3@linuxfoundation.org>
 <959e7456-f7f2-2d0b-0154-d3978191d3a3@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <959e7456-f7f2-2d0b-0154-d3978191d3a3@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 02:25:16PM -0700, Shuah Khan wrote:
> On 3/1/21 2:23 PM, Shuah Khan wrote:
> > On 3/1/21 12:38 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.11.3 release.
> > > There are 774 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 03 Mar 2021 19:35:23 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.3-rc2.gz
> > > 
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > linux-5.11.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > 
> > Compiled and booted on my test system. No dmesg regressions.
> > 
> 
> Just a note that the drm issues are sorted out and it is all good.
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>
> 

Great, glad to hear it's working now.

greg k-h
