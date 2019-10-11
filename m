Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46FCFD39A0
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 08:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfJKGtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 02:49:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbfJKGtG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 02:49:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64372214E0;
        Fri, 11 Oct 2019 06:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570776545;
        bh=bAHtRvXypvSVkY6XkMbFlPpQZA1BGvhri/C4fzRMZ6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z0kC9CiSEd5ZJgZtFaUcMkFtSev8p36gCBeoYWC4GQUNB+DFoEpc2soKKAGp/w+Ns
         wVZAKiHFK28jl0Rtn8HC5RA1U5OuyPaiEsAzu/7BR3iId/oVZOQT73uL7a5OrNuyz5
         ViqZoIbn3YMkqqNKpR1CenuQRHSsVvgSWkQ/QCyk=
Date:   Fri, 11 Oct 2019 08:49:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/148] 5.3.6-stable review
Message-ID: <20191011064903.GD1064179@kroah.com>
References: <20191010083609.660878383@linuxfoundation.org>
 <e72a6562-bc33-643a-ae28-705256fb5b3d@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e72a6562-bc33-643a-ae28-705256fb5b3d@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 03:19:54PM -0700, Guenter Roeck wrote:
> On 10/10/19 1:34 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.6 release.
> > There are 148 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 158 fail: 0
> Qemu test results:
> 	total: 391 pass: 391 fail: 0

Great!  Hopefully 4.14 now works for you, and thanks for testing all of
these.

greg k-h
