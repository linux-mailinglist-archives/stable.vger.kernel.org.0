Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DADB267A69
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 14:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgILMr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 08:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgILMot (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Sep 2020 08:44:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA6CC21D6C;
        Sat, 12 Sep 2020 12:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599914689;
        bh=h+QA2lg9HV169lQ05QXx9CdT4YxXk7qhI87aQkMVwIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E/zy553p6Tvy/6ZL8a23U5kDikEyDazAJ605eSG93Gtm89wKB6X3PsozSDaDela3T
         Jfe3OI5GzESVdfxUMyPeA/5spHTCabZzGekHYfihi03zg7Xh4QKWODRzV3yMM8GY36
         /dW4xFAFv6XdvcnTse9C90zh9rMTzeq7HWW/ZMWQ=
Date:   Sat, 12 Sep 2020 14:44:52 +0200
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
Subject: Re: [PATCH 5.8 00/16] 5.8.9-rc1 review
Message-ID: <20200912124452.GD539446@kroah.com>
References: <20200911122459.585735377@linuxfoundation.org>
 <CA+G9fYsg+g_4B=6ritrWuZKFHJadnmAOjppjBt1nAGQGrdty2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsg+g_4B=6ritrWuZKFHJadnmAOjppjBt1nAGQGrdty2g@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 12, 2020 at 12:57:38PM +0530, Naresh Kamboju wrote:
> On Fri, 11 Sep 2020 at 18:30, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.8.9 release.
> > There are 16 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.9-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
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

Wonderful, thanks for testing them all and letting me know.

greg k-h
