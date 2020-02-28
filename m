Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905E2173B53
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 16:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgB1PYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 10:24:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgB1PYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 10:24:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BAF82469F;
        Fri, 28 Feb 2020 15:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582903489;
        bh=4+SqczEsBgsfMhlVYd4zzJ0T2wKKq4dPwSzCgLBjAoU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=etfId1ClQ1uhrJJcrLHClElIt/KkrZ7/XHIPsZkVdjhLlPVD+cA0NMqr280MD4rHF
         yHjzT0K5ePRXnNUDqH2qr8urGJgRpA2ZAw1SiQkXmkzodjDWdGGFRHamErmMfBveVJ
         jbAUKTwHXdhMIEZLV+c4vQ9x9Kx4hVQDm/m15wec=
Date:   Fri, 28 Feb 2020 16:24:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/237] 4.14.172-stable review
Message-ID: <20200228152447.GC3136847@kroah.com>
References: <20200227132255.285644406@linuxfoundation.org>
 <20200228115942.GB3010957@kroah.com>
 <cc5279d8-5bbd-6fca-6f21-60bea9bf7db9@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc5279d8-5bbd-6fca-6f21-60bea9bf7db9@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 28, 2020 at 06:32:10AM -0800, Guenter Roeck wrote:
> On 2/28/20 3:59 AM, Greg Kroah-Hartman wrote:
> > On Thu, Feb 27, 2020 at 02:33:34PM +0100, Greg Kroah-Hartman wrote:
> >> This is the start of the stable review cycle for the 4.14.172 release.
> >> There are 237 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.172-rc1.gz
> > 
> > -rc2 is out to hopefully resolve some powerpc build issues:
> >  	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.172-rc2.gz
> > 
> For v4.14.171-235-g7184e90f61c3:
> 
> Build results:
> 	total: 172 pass: 172 fail: 0
> Qemu test results:
> 	total: 394 pass: 394 fail: 0

Wonderful, thanks for re-testing two of these and for the original
reports.

greg k-h
