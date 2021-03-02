Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0A832AEED
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbhCCAIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:08:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:51652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1577846AbhCBJ5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 04:57:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3390064F0B;
        Tue,  2 Mar 2021 09:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614679018;
        bh=vEWwVJMiQRTjUe8rmg1yH4IA6xGvkI4PhQEIFb8Y/s4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vh7QmYK/q7sfFih+qxff+adMeVP4WLvQOw8N7pdDRa9syrrFGMxxPC4I0hZT6ktYH
         muvMZqAqvX4D5eeAQVCvAji6IRa/9JQJnVjvbo+HRW6fY4XYtEcZKZH0mDHi3+GsNh
         aSvANAKj+s1IM5kJuLZM9jb+Du0RWbfDA//bc8gs=
Date:   Tue, 2 Mar 2021 10:56:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        LTP List <ltp@lists.linux.it>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH 5.10 000/661] 5.10.20-rc2 review
Message-ID: <YD4L57LQb8Nh/A85@kroah.com>
References: <20210301193642.707301430@linuxfoundation.org>
 <CA+G9fYuK0k0FsnSk4egKOO=B0pV80bjp+f5E-0xPOfbPugQPxg@mail.gmail.com>
 <CA+G9fYsivUPRRQgMXpnA_XdXH8i2wx_DPH70t+6OzHkjOaswrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsivUPRRQgMXpnA_XdXH8i2wx_DPH70t+6OzHkjOaswrg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 03:20:32PM +0530, Naresh Kamboju wrote:
> Hi Greg and Linus,
> 
> On Tue, 2 Mar 2021 at 12:45, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Tue, 2 Mar 2021 at 01:21, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.10.20 release.
> > > There are 661 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 03 Mar 2021 19:34:53 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.20-rc2.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> >
> > Results from Linaro’s test farm.
> > Regressions detected on all devices (arm64, arm, x86_64 and i386).
> >
> > hangup01    1  TFAIL  :  hangup01.c:133: unexpected message 3
> >
> > This failure is specific to stable-rc 5.10 and 5.11.
> > Test PASS on mainline and Linux next kernel.
> >
> 
> I have reverted these two patches and the test case got PASS
> on Linux version 5.10.20-rc2.
> 
> hangup01 1 TPASS : child process exited with status 0
> 
>    Linus Torvalds <torvalds@linux-foundation.org>
>        tty: implement read_iter
> 
>    Linus Torvalds <torvalds@linux-foundation.org>
>        tty: convert tty_ldisc_ops 'read()' function to take a kernel pointer

Odd.

Is 5.12-rc1 also failing with this test as well?

thanks,

greg k-h
