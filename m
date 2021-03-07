Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891D4330064
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 12:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhCGLhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 06:37:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230155AbhCGLhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 06:37:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 445E664E40;
        Sun,  7 Mar 2021 11:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615117056;
        bh=aFiFsi6ZCYNCNHXCjqZOMxbk8+mJyhc0p4yM4WOYk+w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vxZGgVrl7s0Cnuwr211ySN3J8YCmoIADiWuNyeviyz4cq+pBdvNBld8DXAjjoR9lf
         wFHQUVMSDACw1IpjEacgt4+gutS/Lv3ZEOcv4adscyb8NfTTEE6yH0XVGdWsbQ8796
         CS3Sagh+l90Klt/0DCLF+o8oxsgvPwfcQ6YXpssI=
Date:   Sun, 7 Mar 2021 12:37:34 +0100
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
Subject: Re: [PATCH 5.11 000/104] 5.11.4-rc1 review
Message-ID: <YES6/mv/ju9oR1bM@kroah.com>
References: <20210305120903.166929741@linuxfoundation.org>
 <CA+G9fYvu8RgxGFwr3J4W5NjZLkukYh1SM6-_+2-1dot13Y2s6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvu8RgxGFwr3J4W5NjZLkukYh1SM6-_+2-1dot13Y2s6w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 07, 2021 at 07:46:06AM +0530, Naresh Kamboju wrote:
> On Fri, 5 Mar 2021 at 17:55, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.11.4 release.
> > There are 104 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.4-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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

thanks for testing them all and helping with the tty regression.

greg k-h
