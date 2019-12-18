Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED021249CB
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 15:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfLROfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 09:35:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbfLROfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 09:35:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB326218AC;
        Wed, 18 Dec 2019 14:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576679705;
        bh=a853z8YunYyVMRiQmu0Vi5eC2vYvgzYAS3MEJDKbuvI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RPx8Wf7+qkzCJAccQvu+s343jR/vrGR/b3G44JcTwGekbT7IzTvVEx2FBwXC83GA7
         WuL6NEoOJOOqewB43G/cfGkYNuIKx7+aYbL7H9tXpzPOPjhhpT2q6FDQWjsp4PM04k
         iBQ9Qe1lhLIpH+gjeVId/FGeHebQdeYpQtSb7FPQ=
Date:   Wed, 18 Dec 2019 15:35:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/37] 5.4.5-stable review
Message-ID: <20191218143503.GB259271@kroah.com>
References: <20191217200721.741054904@linuxfoundation.org>
 <CA+G9fYur78nMLo8=PkcTJ5LP+UY54RH9cTDmk9m2RR0h+4Mqug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYur78nMLo8=PkcTJ5LP+UY54RH9cTDmk9m2RR0h+4Mqug@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 07:52:16PM +0530, Naresh Kamboju wrote:
> On Wed, 18 Dec 2019 at 01:40, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.5 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 19 Dec 2019 20:06:21 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.5-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

great, thanks for testing these and letting me know.

greg k-h
