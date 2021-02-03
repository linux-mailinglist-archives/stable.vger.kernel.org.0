Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F31D30E6DC
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 00:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhBCXMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 18:12:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233117AbhBCXEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 18:04:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1258664F4D;
        Wed,  3 Feb 2021 23:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612393419;
        bh=oGWk5RtAJl4jD3kmDRU3egDA275E0aU7jLToQZIeUkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rWTMSjqHylYETETu+JSjDCTjhELkRMxmGPdJcjHauQ2Xr+Tjh1vXySIbyB5GLzIEH
         jbIl96PBSS3S5WTrObZd/B84dkeYp1dmEX5BuwuQnqtsfLGCAhawjFJYUHpV/e/aO2
         WG7O0ERgZ4XGnZhmfOLyegR40R5wXBFJR7FoKkfM=
Date:   Thu, 4 Feb 2021 00:03:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 000/142] 5.10.13-rc1 review
Message-ID: <YBsryeEEW3XsMwym@kroah.com>
References: <20210202132957.692094111@linuxfoundation.org>
 <CA+G9fYt2uhMnUT-PjHXs=5FQdTLycBoZb1znu3zpN-kvY+cKKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYt2uhMnUT-PjHXs=5FQdTLycBoZb1znu3zpN-kvY+cKKA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 03, 2021 at 08:35:15AM +0530, Naresh Kamboju wrote:
> On Tue, 2 Feb 2021 at 19:10, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.13 release.
> > There are 142 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.13-rc1.gz
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

Thanks for all the testing!

greg k-h
