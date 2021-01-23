Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2652730162B
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 16:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbhAWPIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 10:08:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbhAWPHu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 10:07:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51EF422B47;
        Sat, 23 Jan 2021 15:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611414429;
        bh=WQ33r4lfW/YMtS6mgkyYK3ORSLvouM/x+lnWam5s2Yc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QapSaK5EhOKexb8b3BxUuQTIo4l0rCxLlslIRbpDAcZiNLyrLos/VXNHYFEj6+Vwp
         ztjnCD73eHYFuFZ5qzB7CWXRMx65AMMu8u5hAdFuqxVDJkuMnMjiJ709ApB/j2xEjr
         LSEgeqlIhqbCMuAlwwo28/KPoQBiD8/lmOGtbdlI=
Date:   Sat, 23 Jan 2021 16:07:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/43] 5.10.10-rc1 review
Message-ID: <YAw7m0c9IvPtOeV8@kroah.com>
References: <20210122135735.652681690@linuxfoundation.org>
 <20210123143601.GE87927@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210123143601.GE87927@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 23, 2021 at 06:36:01AM -0800, Guenter Roeck wrote:
> On Fri, Jan 22, 2021 at 03:12:16PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.10 release.
> > There are 43 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing them all and letting me know.

greg k-h
