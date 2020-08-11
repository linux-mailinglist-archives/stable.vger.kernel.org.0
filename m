Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DDB241E0D
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 18:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbgHKQUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 12:20:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728797AbgHKQUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 12:20:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2787206B5;
        Tue, 11 Aug 2020 16:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597162801;
        bh=DBTLEgLoShBacLtvTrSjzwCoe7AuHPsP195roGj64sw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rddeRjqVG7gIOrNaU8xh/5TSbZes30GoO60ZrGqoMvPx7dn3iF4csv2R+Snmba446
         8mmOqnuxKDDNvgASr61Us0OzAGKlZXHLPOjVWqplpAeg0YySDYLnu6yg5gvHS5J+QM
         hpkQXafs12kBaT8A/i1tR6qc+pNdI0x4hQ3rt3Zc=
Date:   Tue, 11 Aug 2020 18:20:10 +0200
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
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH 5.8 00/38] 5.8.1-rc1 review
Message-ID: <20200811162010.GC440280@kroah.com>
References: <20200810151803.920113428@linuxfoundation.org>
 <CA+G9fYtzP22nR4vd+GAn+tqy0S38XAa3E9=QfDiSPWHrHeqgsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtzP22nR4vd+GAn+tqy0S38XAa3E9=QfDiSPWHrHeqgsw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 11:59:37AM +0530, Naresh Kamboju wrote:
> On Mon, 10 Aug 2020 at 20:50, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.8.1 release.
> > There are 38 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.1-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me know.

greg k-h
