Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B1A30E6D6
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 00:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbhBCXLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 18:11:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233490AbhBCXEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 18:04:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7403364F67;
        Wed,  3 Feb 2021 23:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612393428;
        bh=br1Xcdh2MB66CoaDTVm++F0wkeqE45/LuM+4bawNwFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qer+V0YVFTbm8qUF+koo0P4vliBPt+Oe9aEK7+Wp7tw8kBV/xX7M8U+il6qa9jSYQ
         fHJAEqxBrCp3NVj9PadqJ6hKlriieOPiFInXaAR4gddbVa2cqE8YFMGqY5er9OO8PC
         UuusTIFMZhF/EPe4w9knUr/GHFuiGean4aQ5QdFk=
Date:   Thu, 4 Feb 2021 00:03:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/142] 5.10.13-rc1 review
Message-ID: <YBsr0s/NDMLjzVVr@kroah.com>
References: <20210202132957.692094111@linuxfoundation.org>
 <d4f37799-496c-1571-d4c4-86daf34c24b5@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4f37799-496c-1571-d4c4-86daf34c24b5@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 03, 2021 at 08:38:09AM -0700, Shuah Khan wrote:
> On 2/2/21 6:36 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.13 release.
> > There are 142 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.13-rc1.gz
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

Thanks for testing these and letting me know.

greg k-h
