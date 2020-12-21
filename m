Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101932DFC16
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 13:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgLUM7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 07:59:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726507AbgLUM7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Dec 2020 07:59:20 -0500
Date:   Mon, 21 Dec 2020 13:59:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608555519;
        bh=B+opbUmO16bKXLVbyzkVXAwhZV6EmBEIelvVztU/764=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=rdVpdNhm5mDleClJ+1Q81TTsnr1CUUnn+62MhAH80efshNZqElNccaJiK7ulMS9NA
         2R8OpTxLUcZfQl+QrDFF2bOX6U7yp7+r1+6Dz3LYP7MpgEmqvo+7sQt7pHQvVYdgYN
         qQGiWG1VryoVc/oSCXbVH+KOt5nChaxMDA8Y3RvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 00/16] 5.10.2-rc1 review
Message-ID: <X+CcS39c6kNisGJD@kroah.com>
References: <20201219125339.066340030@linuxfoundation.org>
 <CA+G9fYs_Dsb6hsHqna5S6VmBN8A-8YruVMFyNFfy7fxauosZ3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYs_Dsb6hsHqna5S6VmBN8A-8YruVMFyNFfy7fxauosZ3A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 20, 2020 at 08:47:08AM +0530, Naresh Kamboju wrote:
> On Sat, 19 Dec 2020 at 18:26, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.2 release.
> > There are 16 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Mon, 21 Dec 2020 12:53:29 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.2-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

Thanks for testing these and letting me know.

greg k-h
