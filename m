Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7676B3058FE
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 11:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbhA0K7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 05:59:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236276AbhA0K5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 05:57:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C4D22076D;
        Wed, 27 Jan 2021 10:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611744984;
        bh=ZKTW8gU3jiRPRbEEF3iQJp3X2qckwuCZGY84MYAe2e8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PJvKdRRyWvkw781a8Deb5aArB4vz4p51gqHlewKw9orH7Q3VlZo7lgo33sQdNmo6B
         JH8LT6ltyoeX2vPOsN85FufNxFHAzzyw7sViYAlenvTR9h4UPkp7xOkSqSNWacceG6
         fXM+/zlOMXV9wmBnrExxSGUsAuXxIa1GRNPCDG6w=
Date:   Wed, 27 Jan 2021 11:56:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 000/203] 5.10.11-rc2 review
Message-ID: <YBFG1u0WId5k1J0l@kroah.com>
References: <20210126094313.589480033@linuxfoundation.org>
 <CA+G9fYvWxoK=hOdvVUcB1n7Nk5vmWdh-4GzyaaFFyRijHLrnyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvWxoK=hOdvVUcB1n7Nk5vmWdh-4GzyaaFFyRijHLrnyA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 11:16:43PM +0530, Naresh Kamboju wrote:
> On Tue, 26 Jan 2021 at 15:33, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.11 release.
> > There are 203 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 28 Jan 2021 09:42:40 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.11-rc2.gz
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

Great, thanks for testing and letting me know.

greg k-h
