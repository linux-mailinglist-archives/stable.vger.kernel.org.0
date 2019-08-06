Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9292483019
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 12:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731093AbfHFKzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 06:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731006AbfHFKzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 06:55:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E4692054F;
        Tue,  6 Aug 2019 10:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565088903;
        bh=1JLTPpfpkPsqwSWrtotrOkeGqj0j+IBBMzsscXAmtE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wvEGbIxhNadQsLLAHlAEdyO1dalgt7IsDGyqS5dUC2ckk5y2FqHLujgmFZaL+ReSB
         T5sjR86if2cn3Gre0veQONg+aw+ZFdg0iKpVQCziI9Dd5h9zlEhjAlIlEuVhy0k7z3
         WsKdHSAvl8De1y9oDgWPEXnfWEAS5nJ4Y73Y+fBc=
Date:   Tue, 6 Aug 2019 12:55:01 +0200
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
Subject: Re: [PATCH 5.2 000/131] 5.2.7-stable review
Message-ID: <20190806105501.GB15070@kroah.com>
References: <20190805124951.453337465@linuxfoundation.org>
 <CA+G9fYsbLHkmg8en+WJ00pO-TO+z7ZQXprNP4CAc+_cgC_koGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsbLHkmg8en+WJ00pO-TO+z7ZQXprNP4CAc+_cgC_koGA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 11:47:49AM +0530, Naresh Kamboju wrote:
> On Mon, 5 Aug 2019 at 18:50, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.2.7 release.
> > There are 131 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.7-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
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
