Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2C312D2E5
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 18:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfL3RmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 12:42:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbfL3RmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Dec 2019 12:42:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07AF42053B;
        Mon, 30 Dec 2019 17:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577727728;
        bh=+L9iltHTb/Gp2ISCb+Dj579lysK6GNKZQgsoMzjPZvw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dTOvJmjJYMiiKi9zr+OZeCWpDPjaImriTF9AOfxaBkq9O3QZLsJENQKeWtCDslMSS
         xnphgHNytqKoA/kzVSXoU4Das8e6JCVSo6dOJLa0Q8aj359wxdprErBjsMJEt0zEaQ
         9NwEOw9+plUdSuSRfAv99nixlk+G76Xr1lqV+hWY=
Date:   Mon, 30 Dec 2019 18:42:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/434] 5.4.7-stable review
Message-ID: <20191230174206.GA1418134@kroah.com>
References: <20191229172702.393141737@linuxfoundation.org>
 <20191230172253.GD12958@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191230172253.GD12958@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 30, 2019 at 09:22:53AM -0800, Guenter Roeck wrote:
> On Sun, Dec 29, 2019 at 06:20:53PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.7 release.
> > There are 434 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 31 Dec 2019 17:25:52 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 145 fail: 13
> Failed builds:
> 	<all mips>
> Qemu test results:
> 	total: 385 pass: 320 fail: 65
> Failed tests:
> 	<all mips>
> 	<all ppc64_book3s_defconfig>
> 
> mips and ppc64 failures are as with v4.19.y.

thanks, will go fix and push out a -rc2

greg k-h
