Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F6044E7C6
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 14:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbhKLNt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 08:49:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:43942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231553AbhKLNt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 08:49:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B49F360F46;
        Fri, 12 Nov 2021 13:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636724798;
        bh=If+yLx16hBSvgYnFe0fN1smVDPIuVy19acYEmHHmsrk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JyfLGsIPmLsWVUaGCv4KUG+kUfGT4m4UB1jxs6WnjUvrB/PL7no1vIYkx66PF2Pxm
         w3AdYUIPO2MFFGFhpv4Z7PEkckOC413DVUAV8pQBavGOf59Bu1uttoqtL7TMCmOTnC
         ZcFGplOwoZ1jsWNP3EI+U53lK7btuYdANsTaVgm4=
Date:   Fri, 12 Nov 2021 14:46:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/21] 5.10.79-rc1 review
Message-ID: <YY5wO1QeBJYoC8AY@kroah.com>
References: <20211110182002.964190708@linuxfoundation.org>
 <YY0UQAQ54Vq4vC3z@debian>
 <CADVatmPdQzsMk4HSYftUwEQ8PXF5rBVuYN9kp4aOvj7Pd9ds6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmPdQzsMk4HSYftUwEQ8PXF5rBVuYN9kp4aOvj7Pd9ds6w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 07:45:09PM +0000, Sudip Mukherjee wrote:
> On Thu, Nov 11, 2021 at 1:01 PM Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > Hi Greg,
> >
> > On Wed, Nov 10, 2021 at 07:43:46PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.79 release.
> > > There are 21 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> > > Anything received after that time might be too late.
> >
> > systemd-journal-flush.service failed due to a timeout resulting in a very very
> > slow boot on my test laptop. qemu test on openqa failed due to the same problem.
> 
> Build test:
> mips (gcc version 11.2.1 20211104): 63 configs -> no new failure
> arm (gcc version 11.2.1 20211104): 105 configs -> no new failure
> arm64 (gcc version 11.2.1 20211104): 3 configs -> no failure
> x86_64 (gcc version 11.2.1 20211104): 4 configs -> no failure
> 
> Boot test:
> x86_64: Regression mail sent earlier.  Caused by 8615ff6dd1ac ("mm:
> filemap: check if THP has
> hwpoisoned subpage for PMD page fault").
> 
> arm64: Booted on rpi4b (4GB model). No regression. [1]
> 
> [1]. https://openqa.qa.codethink.co.uk/tests/362
> 
> 
> Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

Will go drop the offending patch, thanks.

greg k-h
