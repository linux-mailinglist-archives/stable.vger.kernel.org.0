Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD4431AB77
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 14:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhBMM7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 07:59:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229744AbhBMM7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Feb 2021 07:59:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D636164E3C;
        Sat, 13 Feb 2021 12:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613221121;
        bh=kTAM6Sj1IKBaIhfhH/Iz++1u6a01lX/REjVbVInBzx0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ksFjBgNVvP+vftnVsUuDcX3RbLXUdYiiBqOG+xitwPDshHdeeJtvncFj5jUBohsd2
         ePxVtap2vf7KAsEqrDtJqloaWbx1iR8mlmXBoBkySRa4xoNbdBMUbseZ6/6dKFaySU
         r69OQrpHAwR6wVrHoALV4I94kgIxw8uNErPaiYt0=
Date:   Sat, 13 Feb 2021 13:58:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/54] 5.10.16-rc1 review
Message-ID: <YCfM/llSa65fhR4m@kroah.com>
References: <20210211150152.885701259@linuxfoundation.org>
 <0825d0d8-0183-9653-dd74-d5921e360bb7@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0825d0d8-0183-9653-dd74-d5921e360bb7@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 09:17:13AM -0700, Shuah Khan wrote:
> On 2/11/21 8:01 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.16 release.
> > There are 54 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.16-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> Note: gdm doesn't start and no response to keyboard and mouse.
> 
> I can ssh in and use the system. I am going debug and update you.
> 5.4.98-rc1 and 4.9.176-rc1 are fine and no such issues.

Did you ever track this down?

thanks,

greg k-h
