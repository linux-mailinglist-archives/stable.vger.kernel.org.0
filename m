Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2272C2F06A2
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 12:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbhAJLaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 06:30:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbhAJLaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Jan 2021 06:30:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E31E2333E;
        Sun, 10 Jan 2021 11:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610278182;
        bh=DabFuEl8DGFdRGfIoM997m7DFRcSUalGk+Rn9gHXdbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XHbcEtgCWLAH/3OtKf8NQtzH2ZCO+wGfa3FJ6vVfQvBeWBWLB+OgpoL51umBPIy7j
         cJ4ohY753yaiDt6F0yt7yW9Sw1NXsGRdHR3vxfJQhg1CKEwM08SWbisx5a1WHC/x7R
         sitSCfThN30LPeq4HH5MJgCjiIMRqpTXr0cpuHHI=
Date:   Sun, 10 Jan 2021 12:30:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 00/20] 5.10.6-rc1 review
Message-ID: <X/rlb5eIH82FLiWT@kroah.com>
References: <20210107143052.392839477@linuxfoundation.org>
 <CA+G9fYv9tTkAUk-0+y1r5ug=w3Ma-CPgg7nEF4ZoRKEs1pe1fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYv9tTkAUk-0+y1r5ug=w3Ma-CPgg7nEF4ZoRKEs1pe1fQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 08, 2021 at 07:32:54AM +0530, Naresh Kamboju wrote:
> On Thu, 7 Jan 2021 at 20:03, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.6 release.
> > There are 20 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.6-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Great, thansk for letting me know.

greg k-h
