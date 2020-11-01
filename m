Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4322A1DAD
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 12:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgKALwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 06:52:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:42364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgKALwJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 06:52:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A176E2084C;
        Sun,  1 Nov 2020 11:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604231527;
        bh=pGZ5jzL3eWwXkNe3P5k6Mh0rPGBy2qMODhxh6Q+GmMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iq3V6Q4AHKWNJFZZVpZqk45Q4Ad60X16mWhDI33U0ZrbM7W7ThtySKdnV5lHIoVpz
         xCE0RPgp+Aeo+PZRp+wuOGaN/SkckOs+/94ApUO7EQiABHfoBoVVV1N2iluTbBXE2E
         rb9PgeRGUxfJdSPM1bHutX6mshSIUXrvxbqNbs0U=
Date:   Sun, 1 Nov 2020 12:52:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 00/74] 5.9.3-rc1 review
Message-ID: <20201101115250.GA3349581@kroah.com>
References: <20201031113500.031279088@linuxfoundation.org>
 <20201031200915.GC45965@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031200915.GC45965@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 31, 2020 at 01:09:15PM -0700, Guenter Roeck wrote:
> On Sat, Oct 31, 2020 at 12:35:42PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.3 release.
> > There are 74 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 02 Nov 2020 11:34:42 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 426 pass: 426 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing these and letting me know.

greg k-h
