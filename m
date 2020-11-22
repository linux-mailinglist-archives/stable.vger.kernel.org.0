Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E372BC4A2
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 10:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbgKVJSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 04:18:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgKVJSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 04:18:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD72920781;
        Sun, 22 Nov 2020 09:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606036687;
        bh=+bWQqxsu1zLglOF7x4PUSVtVjqT2t77o0Z3m+NYfqnw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c036wVNk6dJU5rk1wpw1tcASQ8PImhFM/AT1Lfvwd9P8XlMPVrBzUTQcC3KMeu9Ut
         cPRh+7GqjuGxof8ZR/eDbc0GrvdmZxEsMYjUUHKHhjo6znakC1B1fGK+u/6Ni5tGLT
         C9SWIHBonxwUTZKk+JOfM4Ef0aGPS8awRO2btJ3k=
Date:   Sun, 22 Nov 2020 10:18:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.9 00/14] 5.9.10-rc1 review
Message-ID: <X7os9tdYmSNXOnPq@kroah.com>
References: <20201120104541.168007611@linuxfoundation.org>
 <CA+G9fYuFoJqZrQJn9bqd1U9YZnr1x+2acsLYCay=99QGGjd6mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuFoJqZrQJn9bqd1U9YZnr1x+2acsLYCay=99QGGjd6mQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 21, 2020 at 04:42:45PM +0530, Naresh Kamboju wrote:
> On Fri, 20 Nov 2020 at 16:39, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.9.10 release.
> > There are 14 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.10-rc1.gz
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
