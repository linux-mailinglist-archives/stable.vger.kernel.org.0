Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60120263533
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 20:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgIISAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 14:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgIISA1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 14:00:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A408B21D46;
        Wed,  9 Sep 2020 18:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599674427;
        bh=DOoeeveQ0VVxlLlCresq8YojZcwhQfJRmwWG5zSLuGg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M1q8qW/vg1zJJuFBbGYcAIjxf2ZRs8UV/CV86yVYc6HybFmi8FZUaiaghemU8umk3
         t2L804MJhHcZhZa/dJ4tjsonnPJogiW9MpI1RMn42yRROc4BKJcXAE88oJ40pbPbAs
         fLq1erl/PaG9DeTrhWssNqZ1do2nkeiBnRhO1eNY=
Date:   Wed, 9 Sep 2020 20:00:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.8 000/186] 5.8.8-rc1 review
Message-ID: <20200909180036.GB1003763@kroah.com>
References: <20200908152241.646390211@linuxfoundation.org>
 <CA+G9fYsUF_7qVThy7Q-HcSs19_VsGnqCJCYTcpJmwdx0oBpO0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsUF_7qVThy7Q-HcSs19_VsGnqCJCYTcpJmwdx0oBpO0g@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 09, 2020 at 11:18:57AM +0530, Naresh Kamboju wrote:
> On Tue, 8 Sep 2020 at 21:05, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.8.8 release.
> > There are 186 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.8-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
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

Thanks for testing them all and letting me konw.

greg k-h
