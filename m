Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A615301627
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 16:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbhAWPHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 10:07:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbhAWPH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 10:07:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CC2E22AAA;
        Sat, 23 Jan 2021 15:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611414407;
        bh=R8tM6+TqR2edPLdNeqPR6HkO3RfjGrOYzPnjaWOP5V8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IB+FKa9xGn8tXP4e3PVx0qeINZSOA/Cvh2KY5GI5jVK88wHNVA8W4YUz8L1OgoG40
         JMAhCVBD83mckn0F42CUKkSQtlEG3uXn9DBklRwcMuriZ4CS2JEcP36malWvtiYXwC
         aOS/47IksOKZ8eHDB7nTaU19cAU7Q78S+UAHO4ww=
Date:   Sat, 23 Jan 2021 16:06:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 00/43] 5.10.10-rc1 review
Message-ID: <YAw7hOMIbUYxzYrg@kroah.com>
References: <20210122135735.652681690@linuxfoundation.org>
 <CA+G9fYun4MY72zD1SUPRktJdbXsotqi0G-a=cvdAk-8kOo_dwQ@mail.gmail.com>
 <CA+G9fYu-oJMYJxStRiG88xUyb2qNgH64q370b0CTcBW4j3ZtnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYu-oJMYJxStRiG88xUyb2qNgH64q370b0CTcBW4j3ZtnA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 23, 2021 at 12:50:24PM +0530, Naresh Kamboju wrote:
> On Sat, 23 Jan 2021 at 11:14, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Fri, 22 Jan 2021 at 19:49, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.10.10 release.
> > > There are 43 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.10-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Results from Linaro’s test farm.
> > No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing them all and letting me know.

greg k-h
