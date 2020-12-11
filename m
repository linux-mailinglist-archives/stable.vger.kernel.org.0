Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F6B2D7898
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436956AbgLKPA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:00:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436851AbgLKPAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 10:00:22 -0500
Date:   Fri, 11 Dec 2020 15:23:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607696543;
        bh=kTgUO/76cO/BiV2Tcy9gjCrKJFvLy7VC+BhBptOj0Xc=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=cgD8jMyu3lAopP/L2NlsxU8R2XTowTWNI0+/sekw08vY2CRR1b79xrIiDdPK+ZHg5
         NVySbWa/uZCUyYzBwiI8AQL4ohvmcvaTf7DO4ne50hEwSPrUT8/JYONeUT0AgEbb7e
         bStYyR4wHSVOZJyU41w56lfhGDyEF8mxT0aOqxtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.9 00/75] 5.9.14-rc1 review
Message-ID: <X9OA5CEY6lXc1LcZ@kroah.com>
References: <20201210142606.074509102@linuxfoundation.org>
 <f7f39893-de51-9962-db18-303ca60e57bd@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7f39893-de51-9962-db18-303ca60e57bd@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 02:20:53PM -0700, Shuah Khan wrote:
> On 12/10/20 7:26 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.14 release.
> > There are 75 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.14-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
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

thanks for testing them all and letting me know.

greg k-h
