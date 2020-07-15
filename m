Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF71220D19
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 14:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbgGOMjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 08:39:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728975AbgGOMjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 08:39:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71CDA20658;
        Wed, 15 Jul 2020 12:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594816785;
        bh=fLtpqQQ1vTct0NAohkfk+DM+rpihJlpQUOZbauAYrxU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jbNu8mJXIqqm6ux5vjwll0ARmb5a1yn4l62fpR7A7mLsQzz+Z8VZ+Dux2MhmaYBSM
         pRrAeUH+No2kXc5Lm9TwccKcBuENKSrX0cUvnnSBg5NmK61ibcx1YAnEQ/v9+XKd/m
         IWOCN0wMHrc87W8cCgniFksv5vDpgL/vbIAHbhME=
Date:   Wed, 15 Jul 2020 14:39:40 +0200
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
Subject: Re: [PATCH 4.19 00/58] 4.19.133-rc1 review
Message-ID: <20200715123940.GD3134677@kroah.com>
References: <20200714184056.149119318@linuxfoundation.org>
 <CA+G9fYuicrgx6sPfovfzMX4W31HPE=LbxXtBKB5M-M+2sz+sXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuicrgx6sPfovfzMX4W31HPE=LbxXtBKB5M-M+2sz+sXA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 15, 2020 at 03:11:15PM +0530, Naresh Kamboju wrote:
> On Wed, 15 Jul 2020 at 00:16, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.133 release.
> > There are 58 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 16 Jul 2020 18:40:38 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.133-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me know.

greg k-h
