Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C532D316110
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 09:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbhBJIbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 03:31:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhBJIbP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 03:31:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2555160C3D;
        Wed, 10 Feb 2021 08:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612945834;
        bh=49VXyq3Gg90xHtJzLLsFYe1VeqIBGxRHbgkRxxMdo1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CG7GQiUdovGR3QuWSfvn0hM8p/4YxRV4vCoVe47hM8dXih18ziWF51DSvc05An7m+
         YAJU35hMaziQqAom5/p7sUvRIHSoeojOKbKUDlQgovfqLzXexkMVZ/m//K7KWWymp6
         BH6y5oB2W7Zb4rVL2LirFTFKg5QFfJu1HK5KQb0c=
Date:   Wed, 10 Feb 2021 09:30:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 000/120] 5.10.15-rc1 review
Message-ID: <YCOZqHBLBD8kV84Z@kroah.com>
References: <20210208145818.395353822@linuxfoundation.org>
 <CA+G9fYu5OOQmbogVtH7ASif06AZdizHM_4LRRMkOGDYDg5Dnbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYu5OOQmbogVtH7ASif06AZdizHM_4LRRMkOGDYDg5Dnbw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 07:42:34PM +0530, Naresh Kamboju wrote:
> On Mon, 8 Feb 2021 at 20:44, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.15 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.15-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 

Thanks for testing them all and letting me know.

greg k-h
