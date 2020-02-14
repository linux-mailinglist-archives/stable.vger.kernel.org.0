Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D573015F758
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 21:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389199AbgBNUCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 15:02:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389178AbgBNUCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 15:02:06 -0500
Received: from localhost (unknown [12.246.51.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10A6B24649;
        Fri, 14 Feb 2020 20:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581710526;
        bh=kBNuGUCr3OvbDReuEA7mRty8i5XGeQjbop+BKhlCdeg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jlyxF96KYYPyfVxsKhP4tMHMLHp57eEeljZKHZ/mzfz+4Xo7Ff9ItSfkO7nE+x9cp
         J1x1H4uj13i5gh3HCvx5hJas/jbfk+TPXMiNo1yIvZ+s7Q8JapsIuHZ5kBG7wbYfBt
         2CABB1boht5F5LTwIxdiGvyVPg1dYkIhJBP77Qsw=
Date:   Fri, 14 Feb 2020 07:23:06 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/96] 5.4.20-stable review
Message-ID: <20200214152306.GF3959278@kroah.com>
References: <20200213151839.156309910@linuxfoundation.org>
 <20200213222732.GA20637@roeck-us.net>
 <CAMuHMdV0nRPVjRpvVuZBMpaTfQGeMQN-2xrSehDwXOoG=4iATw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdV0nRPVjRpvVuZBMpaTfQGeMQN-2xrSehDwXOoG=4iATw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 08:55:48AM +0100, Geert Uytterhoeven wrote:
> Hi Günter,
> 
> On Thu, Feb 13, 2020 at 11:28 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > On Thu, Feb 13, 2020 at 07:20:07AM -0800, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.20 release.
> > > There are 96 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat, 15 Feb 2020 15:16:40 +0000.
> > > Anything received after that time might be too late.
> > >
> >
> > Build reference: v5.4.19-98-gdfae536f94c2
> > gcc version: powerpc64-linux-gcc (GCC) 9.2.0
> >
> > Building powerpc:defconfig ... failed
> > --------------
> > Error log:
> > drivers/rtc/rtc-ds1307.c:1570:21: error: variable 'regmap_config' has initializer but incomplete type
> >  1570 | static const struct regmap_config regmap_config = {
> >
> > Bisect log below. Looks like the the definition of "not needed"
> > needs an update.
> 
> "not needed" goes together with (or after) "when necessary":
> 578c2b661e2b1b47 ("rtc: Kconfig: select REGMAP_I2C when necessary")

Thanks for that, I'll consider it for the next round of releases.

greg k-h
