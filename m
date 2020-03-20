Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A44E418CBFE
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 11:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCTKzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 06:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgCTKzS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 06:55:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B36B820739;
        Fri, 20 Mar 2020 10:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584701718;
        bh=LzPRF7DoVrNKXkyG1E1Ei1tvzAqqWFjViJMw82ItyMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eARZ1fuD3zAgPxwkLApSrGBX0K2ZJbujfaf92u19zgJ8yXV5YuRJuWdOxDKSidKaP
         S+M66UbVGD6NoYBbLxc7Q9DquA4qTi7m2bx1OLJ8ler2JJyY2RLe5FSUIR2tNio5TG
         soj7EhMCg3YTB5biGf2Y4knelNaKzELZqkiztSmQ=
Date:   Fri, 20 Mar 2020 11:55:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/60] 5.4.27-rc1 review
Message-ID: <20200320105513.GA450546@kroah.com>
References: <20200319123919.441695203@linuxfoundation.org>
 <bfdce3ef-5fe9-8dab-1695-be3d33727529@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfdce3ef-5fe9-8dab-1695-be3d33727529@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 04:55:20PM -0700, Guenter Roeck wrote:
> On 3/19/20 6:03 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.27 release.
> > There are 60 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 158 fail: 0
> Qemu test results:
> 	total: 427 pass: 425 fail: 2
> Failed tests:
> 	mipsel64:64r6el_defconfig:notests:smp:ide:hd
> 	mipsel64:64r6el_defconfig:notests:smp:ide:cd
> 
> Building mipsel64:64r6el_defconfig:notests:smp:ide:hd ... failed
> ------------
> Error log:
> arch/mips/vdso/vdso.so.dbg.raw: PIC 'jalr t9' calls are not supported
> 
> I was unable to figure out why I only see this problem in v5.4.y.
> The build error is easy to reproduce with gcc 9.2.0 and "64r6el_defconfig".

I've dropped a bunch of mips vdso patches from 5.5 and 5.4 queues now
and will push out new -rcs with those in them to hopefully resolve these
issues.

thanks,

greg k-h
