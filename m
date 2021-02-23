Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551F0322AF3
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 13:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhBWM63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 07:58:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232712AbhBWM6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 07:58:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D7F464E2E;
        Tue, 23 Feb 2021 12:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614085061;
        bh=ZseM0b90aQMAl/ywk3ouugnAGfY3mB/PyVXZ1qRtGvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LSfiihM41R39FDFrHMvjHm5BLspLgwAxdRpIc8W89tnp8Q/sAyLd98Mqj0CetCLFV
         XjgU3HqdLaQFsb5Rvagtm0j17PctIH/md3Rw8lnXhE0oitj1g3j6mD97Ftuc3y32CO
         Byp2k6SAdJ45x0HSpk6zcchqideeLcfZ8Xpduy6o=
Date:   Tue, 23 Feb 2021 13:57:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.11 00/12] 5.11.1-rc1 review
Message-ID: <YDT7wu53G+1CkLEh@kroah.com>
References: <20210222121013.586597942@linuxfoundation.org>
 <CA+G9fYvky9VTyPeOqnDBsNzP_to-+uCisCpLTiUoJTCUtsPvfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvky9VTyPeOqnDBsNzP_to-+uCisCpLTiUoJTCUtsPvfg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 01:10:19AM +0530, Naresh Kamboju wrote:
> On Mon, 22 Feb 2021 at 17:43, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.11.1 release.
> > There are 12 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.1-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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

Thanks for testing them all and letting me know.

greg k-h
