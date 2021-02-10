Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7602A316114
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 09:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhBJIb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 03:31:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229935AbhBJIbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 03:31:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EF9B64E45;
        Wed, 10 Feb 2021 08:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612945853;
        bh=RpvfS+94bEPK5TQF+EY0/PcquJURUVGIbuTc6UV7Igs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y7gg0Sq1KQQrBxyG5Ro35N0yew49+FlKrlkziueHBe3SKydEiIIIKkpGd/rmQXi3h
         z84j9i8A3AqdsSPud1xT+zq1zs+VnmdHPjc9rmIXo5ZGCouCpN/I0RoBEqcOot3LJ+
         JA7jl5d7CYh09EqtnLOTGc4VDYxIi08zVO8yScY8=
Date:   Wed, 10 Feb 2021 09:30:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/120] 5.10.15-rc1 review
Message-ID: <YCOZu8y1QONJ7CKB@kroah.com>
References: <20210208145818.395353822@linuxfoundation.org>
 <e17d7d91-a7e5-48c4-a182-276cc5338cdd@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e17d7d91-a7e5-48c4-a182-276cc5338cdd@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 01:01:09PM -0700, Shuah Khan wrote:
> On 2/8/21 7:59 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.15 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.15-rc1.gz
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

Thanks for testing them all and letting me know.

greg k-h
