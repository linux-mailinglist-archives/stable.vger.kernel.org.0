Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC432D7872
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406453AbgLKPA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:00:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436889AbgLKPAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 10:00:22 -0500
Date:   Fri, 11 Dec 2020 15:22:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607696511;
        bh=2HIAIQhlG/wT9bumBESnx8SU4yR2bS8TgfIjeo4UklU=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ty0K3IGKorNWL/6CRErqkSmbWYR8KYJuS6SYgNy5pG4In1Y3VRmWIqlRtugJ5S2Xn
         OBKxwu+3KTfMTpSEysDgfcBssSPtgWFF5nkVmTX1ivlLnH87lTPL4DHbrkJrluGCuZ
         UZpv1KECyk/GRF9fpoZR+F1UmkEA79+1TJ1GcJ1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.9 00/75] 5.9.14-rc1 review
Message-ID: <X9OAwzb3cbkg2OBj@kroah.com>
References: <20201210142606.074509102@linuxfoundation.org>
 <CA+G9fYv-gar22WM8sdTSTmnda8+4ysyR2Lbdk0vFBwk2Hp2qGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYv-gar22WM8sdTSTmnda8+4ysyR2Lbdk0vFBwk2Hp2qGg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 11, 2020 at 11:01:31AM +0530, Naresh Kamboju wrote:
> On Thu, 10 Dec 2020 at 20:08, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.9.14 release.
> > There are 75 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.14-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
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

Thanks for testing them all and letting me know.

greg k-h
