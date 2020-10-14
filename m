Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E05028DE0B
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 11:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgJNJ4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 05:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728278AbgJNJ4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 05:56:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7394220757;
        Wed, 14 Oct 2020 09:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602669396;
        bh=uDQnhwR/Qfb99XLFXCJBVKQs59msiCid2wzKgJkU7Gc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=StdvoVnswZYuj/PJ8+76Kjfg5W3WyyscfllOKXE/GLpuWMOmmWqC0cuVIWiZFEzr7
         PLitShp64HS9CcERXtam82ZZrwjq5Jy8rzDqMA14aePW43gj9AfmKq8akZoFfv5hNW
         HUcH0wt4LINmvXZndm2P2MOVXbU9j7M8ODMbIQt8=
Date:   Wed, 14 Oct 2020 11:57:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.8 000/124] 5.8.15-rc1 review
Message-ID: <20201014095711.GC3599360@kroah.com>
References: <20201012133146.834528783@linuxfoundation.org>
 <CA+G9fYsTcM-iAwno8ur3teBzakVE1EaBJ7F7FmDD7Hhewxb=vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsTcM-iAwno8ur3teBzakVE1EaBJ7F7FmDD7Hhewxb=vQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 13, 2020 at 11:14:36AM +0530, Naresh Kamboju wrote:
> On Mon, 12 Oct 2020 at 19:15, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.8.15 release.
> > There are 124 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 14 Oct 2020 13:31:22 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.15-rc1.gz
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

Thanks for testing them all.

greg k-h
