Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316F635AC6A
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 11:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbhDJJWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 05:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhDJJWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 05:22:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0E8061165;
        Sat, 10 Apr 2021 09:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618046559;
        bh=Mva2R9sfDrxSBLHtKeHCyUKpiu/qYMRFGt6FRnpcy4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=svMi2dJLI6WCO1Hjff+QH9daKQM0W7rUuKlN7Ndlt1lKf7HDQk2hx4bIdedmtT7RS
         5JGUyNdla2UDXPbD5FOKt+3KLhyEpoHoKCEki7+ny4FqIWJsjJT5VA0A33a8VR+sCE
         0jsBNc6ss3T1ZBqKf1ZMZJLNrb9w5JTFHHnB9JGY=
Date:   Sat, 10 Apr 2021 11:22:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/28] 4.4.265-rc1 review
Message-ID: <YHFuXJT5DOKYnPfA@kroah.com>
References: <20210405085017.012074144@linuxfoundation.org>
 <CA+G9fYtDnYFoRFOnMbhUgydcWXXa_6xFsx_Au7fF3em4=Bkg4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtDnYFoRFOnMbhUgydcWXXa_6xFsx_Au7fF3em4=Bkg4A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 01:18:27PM +0530, Naresh Kamboju wrote:
> On Mon, 5 Apr 2021 at 14:26, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.4.265 release.
> > There are 28 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.265-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 


Thanks for testing all of these and letting me know

greg k-h
