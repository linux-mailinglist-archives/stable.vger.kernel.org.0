Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2950818DE65
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 08:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgCUHKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 03:10:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728039AbgCUHKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 03:10:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCE5220739;
        Sat, 21 Mar 2020 07:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584774648;
        bh=sOJK0rPQNZ78piRrxJpQxGazANn6wKgyzGMgF4iQ/io=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=whftUBIhf0YKfixIvCQpFRl78ltp55lTovsepYay9NXZxRptMSX4C401zwShoO4Z4
         Wnvh2tnEmMCi879TZyGXcWOwUnGxNCX3pGiBqHEP+Jxjy6j7Zkuej2pT4JHaMDt6wA
         Pit7p5oeWRECIxtiidxpIP5dDGzFC990iQUq0fJ4=
Date:   Sat, 21 Mar 2020 08:10:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 5.5 00/64] 5.5.11-rc2 review
Message-ID: <20200321071046.GC850676@kroah.com>
References: <20200319150225.148464084@linuxfoundation.org>
 <CA+G9fYvOQ=oibqFZ=zffqj-c5mcjW2Bew2rVHg=FPs2mHxb_ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvOQ=oibqFZ=zffqj-c5mcjW2Bew2rVHg=FPs2mHxb_ug@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 20, 2020 at 12:16:11PM +0530, Naresh Kamboju wrote:
> On Thu, 19 Mar 2020 at 20:34, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.5.11 release.
> > There are 64 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 21 Mar 2020 15:02:02 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.11-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> NOTE:
> The arm64 dragonboard-410c and arm beagleboard x15 device running
> stable rc 4.19.112-rc1, 5.4.27-rc1 and 5.5.11-rc2 kernel popping up
> the following messages on console log continuously. [Ref]
> 
> [   15.737765] mmc1: unspecified timeout for CMD6 - use generic
> [   16.754248] mmc1: unspecified timeout for CMD6 - use generic
> [   16.842071] mmc1: unspecified timeout for CMD6 - use generic
> ...
> [  977.126652] mmc1: unspecified timeout for CMD6 - use generic
> [  985.449798] mmc1: unspecified timeout for CMD6 - use generic

That should have been resolved by now :(

