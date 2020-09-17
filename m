Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BA526DE52
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 16:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgIQOd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:33:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727614AbgIQObv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 10:31:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 888B72220F;
        Thu, 17 Sep 2020 14:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600353097;
        bh=LdFE5Io6qMfxkCqfm2Fsy82VRuye4UzpBFDbnKRZf1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZKLgwNPV6b2VVh7Tm5y70pnJc7jICG8NBgeblrcwqCjR40WVSrUSiDLFTnY+0jRa3
         AxDv3EOnTK3BXaaFz5ueD0tz59B7tV66qr2xO1JrZAxs/7XPR6OH2MEhnE8rDJMvBh
         Dr8UZFoQlLOV9PBv9LnT/9LK3brbGVqKZ4OsTEeM=
Date:   Thu, 17 Sep 2020 16:32:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/177] 5.8.10-rc1 review
Message-ID: <20200917143209.GE3941575@kroah.com>
References: <20200915140653.610388773@linuxfoundation.org>
 <20200916170637.GC93678@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916170637.GC93678@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 10:06:37AM -0700, Guenter Roeck wrote:
> On Tue, Sep 15, 2020 at 04:11:11PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.10 release.
> > There are 177 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing them all and letting me know.

greg k-h
