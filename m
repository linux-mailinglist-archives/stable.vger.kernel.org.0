Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A78FCB9C63
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 07:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfIUFGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 01:06:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbfIUFGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Sep 2019 01:06:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F26AF2054F;
        Sat, 21 Sep 2019 05:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569042371;
        bh=YF3Qv8ESbhf9Psy2qnudwd6B64q2W/ztM80hmhTkxqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i3S0t2rIADTH7Wdc5mjCYpsZa/Ob0zPvPzg+KrkjgC8kntsTIWo7h5vuYJBo+HPaF
         gS9bspZrXs02zUmumVkiuRupFoPuzp3+6Wgdv3OFMR7jSadY7UtOXHtcQTXKmtYi0c
         Kh9F0cE1MVhwT2nqLDgzErrtrW1fq7luZKX8c6Zk=
Date:   Sat, 21 Sep 2019 07:06:09 +0200
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
Subject: Re: [PATCH 5.3 00/21] 5.3.1-stable review
Message-ID: <20190921050609.GD991717@kroah.com>
References: <20190919214657.842130855@linuxfoundation.org>
 <CA+G9fYtPMOK8WzhpQTMBZTtz3T9Hzf2aOusFDJF0cr0bKKo6cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtPMOK8WzhpQTMBZTtz3T9Hzf2aOusFDJF0cr0bKKo6cA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 08:11:35PM +0530, Naresh Kamboju wrote:
> On Fri, 20 Sep 2019 at 03:36, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.3.1 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.1-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Nice to see 5.3.0 pass everything :)

Thanks for testing all of these and letting me know.

greg k-h
