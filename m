Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3A51A0F76
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 16:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgDGOoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 10:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728943AbgDGOoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 10:44:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE0402072A;
        Tue,  7 Apr 2020 14:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586270641;
        bh=SD+uebUAzfll8Oqs1AVJdlapN1pVJAjbovXELWPmnSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a1x9cnysnp1an3T99/E69k5rYC7LHteIdixzt2o1Mz+UI3/Lxy7uLiMeOM3w1umjU
         9i/s86/FFxEFbnF6J5Moim+p6FjiyCesnkkmBQbxpDF76YKl8yKI3m1c8d92Yd9oVT
         PvB8Nhz6q1euqQVmslEYByWxrQCCM7V+xpqfEgg0=
Date:   Tue, 7 Apr 2020 16:43:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.6 00/29] 5.6.3-rc1 review
Message-ID: <20200407144359.GB877817@kroah.com>
References: <20200407101452.046058399@linuxfoundation.org>
 <CAEUSe7_Je2e_ExLnnwj-SLtSqLyoAPTXqS_WO8yiHneMh46qfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe7_Je2e_ExLnnwj-SLtSqLyoAPTXqS_WO8yiHneMh46qfw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 08:51:15AM -0500, Daniel Díaz wrote:
> Hello!
> 
> On Tue, 7 Apr 2020 at 05:27, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.6.3 release.
> > There are 29 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 09 Apr 2020 10:13:38 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.3-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Perf still fails to build. Can be fixed by picking up 9ff76cea4e9e
> ("perf python: Fix clang detection to strip out options passed in
> $CC").

Thanks for this, now queued up and will be in -rc2.

thanks,

greg k-h
