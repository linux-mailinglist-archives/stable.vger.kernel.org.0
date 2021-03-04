Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E39932D0FA
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 11:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhCDKkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 05:40:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232867AbhCDKkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 05:40:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D6A064F21;
        Thu,  4 Mar 2021 10:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614854360;
        bh=qiwXoWSxQQetT5stHnS+wlQZg8wN7goKE1xf94evVpI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M8B3MafNeDwWwG0YXoftzdJNFt3Cv69dNBn9bJbWTdLQzISrfY7ITFM3GPRYXXDMQ
         qeFHDRFXZpMUDLJ195Fuz/QNenrTQ7gdAW2Ic3jT3m/c1wMb70l1EfaQLo45xTTph1
         SYfRsXu/I8aZ5dfKmsrFp1+uQBT1CS1nXPuufmlc=
Date:   Thu, 4 Mar 2021 11:39:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/661] 5.10.20-rc2 review
Message-ID: <YEC41X1J2URtvznV@kroah.com>
References: <20210301193642.707301430@linuxfoundation.org>
 <a2483945-2983-54ca-45b0-a617288c6001@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2483945-2983-54ca-45b0-a617288c6001@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 02:43:59PM -0700, Shuah Khan wrote:
> On 3/1/21 12:37 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.20 release.
> > There are 661 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 03 Mar 2021 19:34:53 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.20-rc2.gz
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

Thanks for all the testing and letting me know.

greg k-h
