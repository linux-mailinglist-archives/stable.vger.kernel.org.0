Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A45F1BF068
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 08:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgD3Gl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 02:41:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgD3Glz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 02:41:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8B5220784;
        Thu, 30 Apr 2020 06:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588228915;
        bh=X8gimk3yFAeK754Nb7O29n9XhkvBxvxg4SjVPsgNc2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=roKlYC4uPUs+R+tqgf43a/hneMSfmZSv4Lfp7+UBTdYwCJzx70fegoc2JrwU5IfVD
         Wz3M4FXcyD/MMWJt14Oga8bAFNgncpHXEnRu0PT/2rdzmA2gMZuxDDjSaoYAkfeRwj
         v4ZvQCeb1CMGGXu02GN/9dRaPbGZAWlo8FvFgA9s=
Date:   Thu, 30 Apr 2020 08:41:53 +0200
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
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Andrei Vagin <avagin@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "X.f. Ren" <xiaofeng.ren@nxp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Kuldeep Singh <kuldeep.singh@nxp.com>
Subject: Re: [PATCH 5.6 000/167] 5.6.8-rc1 review
Message-ID: <20200430064153.GD2377651@kroah.com>
References: <20200428182225.451225420@linuxfoundation.org>
 <CA+G9fYvPhDsaHKJSGfxWLUPmrf_mRx7S3_RdXWmRzbg25SRRoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvPhDsaHKJSGfxWLUPmrf_mRx7S3_RdXWmRzbg25SRRoQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 29, 2020 at 02:38:29PM +0530, Naresh Kamboju wrote:
> On Tue, 28 Apr 2020 at 23:57, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.6.8 release.
> > There are 167 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 30 Apr 2020 18:20:42 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.8-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great, thanks fro testing these and letting me know.

> NOTE:
> This kernel panic seems to be platform specific.
> However, I am sharing a few kernel panic logs here.
> While running LTP cve[1] and  libhugetlbfs[2] test suite on nxp ls2088
> device the kernel panic noticed with different kernel dump
> and unfortunately it is not easily reproducible.
> At this point it is unclear whether this problem
> started happening from this stable rc review or not.
> Because a different type of kernel panic noticed on Linus 's  mainline tree
> (5.7.0-rc2) version kernel while running LTP containers tests.

If you end up narrowing this down to an offending commit, that would be
great.

thanks,

greg k-h
