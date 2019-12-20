Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A901283CC
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 22:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfLTVVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 16:21:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:53532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727402AbfLTVVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 16:21:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27AF2206DA;
        Fri, 20 Dec 2019 21:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576876881;
        bh=CIEqPd7kMp6U9L+ghSccv4QM7y9fzwm2jYkXKa3iJ0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QIQvw3S4lgHsN3kcZTLi0p4CBiJoVCe2SZOLZcAE3ySblq3tzRSJa62oiqz0RCUOO
         V0kiHUBiGSFaNOvFD+xWg+Yizf2IjGTuYQhdnalYYJU54DI+fFmwBJDRvNg7npxbKT
         zHfLQ+f+hwacCwTriyLDKpYFbfCSP4SM1YGKF+Ew=
Date:   Fri, 20 Dec 2019 22:21:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/80] 5.4.6-stable review
Message-ID: <20191220212118.GA26929@kroah.com>
References: <20191219183031.278083125@linuxfoundation.org>
 <20191220185042.GE26293@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220185042.GE26293@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 20, 2019 at 10:50:42AM -0800, Guenter Roeck wrote:
> On Thu, Dec 19, 2019 at 07:33:52PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.6 release.
> > There are 80 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 158 fail: 0
> Qemu test results:
> 	total: 387 pass: 387 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
