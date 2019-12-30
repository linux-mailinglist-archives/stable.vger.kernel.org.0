Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D359312D2C2
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 18:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfL3RfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 12:35:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbfL3RfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Dec 2019 12:35:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6E84206DB;
        Mon, 30 Dec 2019 17:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577727309;
        bh=DNIHEwTzKQMR+/BqGXzilYZBBoagRC50oVuvJJO+oJw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sk4Eig8P9r+8hsVKzopf1lvkiEHzMWvfNA44gGly2mm/a4q4I+3GRKnb7aMHo4L4O
         V+m0vBF2Hc1k3dmkO8BfGaJExjkkbVWFJwW3IMfODC5JWXSO80lr4RdqZw00TLmtMY
         /HXdlxyZyWFC8Wby7nBiHlTtIe1hoHS6BAVb+iaE=
Date:   Mon, 30 Dec 2019 18:35:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/219] 4.19.92-stable review
Message-ID: <20191230173506.GB1350143@kroah.com>
References: <20191229162508.458551679@linuxfoundation.org>
 <20191230171959.GC12958@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191230171959.GC12958@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 30, 2019 at 09:19:59AM -0800, Guenter Roeck wrote:
> On Sun, Dec 29, 2019 at 06:16:42PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.92 release.
> > There are 219 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 31 Dec 2019 16:17:25 +0000.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 156 pass: 141 fail: 15
> Failed builds:
> 	i386:tools/perf
> 	<all mips>
> 	x86_64:tools/perf
> Qemu test results:
> 	total: 381 pass: 316 fail: 65
> Failed tests:
> 	<all mips>
> 	<all ppc64_book3s_defconfig>
> 
> perf as with v4.14.y.
> 
> arch/mips/kernel/syscall.c:40:10: fatal error: asm/sync.h: No such file or directory

Ah, will go drop the offending patch and push out a -rc2 with both of
these issues fixed.

> arch/powerpc/include/asm/spinlock.h:56:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’
> and similar errors.
> 
> The powerpc build problem is inherited from mainline and has not been fixed
> there as far as I can see. I guess that makes 4.19.y bug-for-bug "compatible"
> with mainline in that regard.

bug compatible is fun :(

greg k-h
