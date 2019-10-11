Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B576D41FC
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 16:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbfJKOBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 10:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbfJKOBI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 10:01:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7AFF20640;
        Fri, 11 Oct 2019 14:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570802468;
        bh=t9/O7zaiB/c1wXAfYIz1GbBGj/mCFCn6JDKlAAphRB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ISHTT+QtS2wdWQSmJVyksZPp3VDvO9jz9PmQhgKriiYNZzRDEh2VPDFKC1fbOH8aL
         xUyFZ2YOT5l6a7YGGx0rK/sbeIkT3QWcVv0zWcvBa8yQGjr3zDyjXtqD0eLKuaYALh
         uCYyJLz3f8a+xgnHTYtwPkWgtnb6Bk2rB59vtyqk=
Date:   Fri, 11 Oct 2019 16:01:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/61] 4.14.149-stable review
Message-ID: <20191011140105.GA1236002@kroah.com>
References: <20191010083449.500442342@linuxfoundation.org>
 <ce4b3f10-eafd-1169-9240-fb3891279c2a@roeck-us.net>
 <20191011042945.GB939089@kroah.com>
 <fde4b241-2932-c543-d540-cc89f2b1eac0@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fde4b241-2932-c543-d540-cc89f2b1eac0@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 06:14:59AM -0700, Guenter Roeck wrote:
> On 10/10/19 9:29 PM, Greg Kroah-Hartman wrote:
> > On Thu, Oct 10, 2019 at 10:12:26AM -0700, Guenter Roeck wrote:
> > > On 10/10/19 1:36 AM, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.14.149 release.
> > > > There are 61 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
> > > > Anything received after that time might be too late.
> > > > 
> > > 
> > > Preliminary.
> > > 
> > > I see several mips build failures.
> > > 
> > > arch/mips/kernel/proc.c: In function 'show_cpuinfo':
> > > arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaration of function '__ase'
> > 
> > Thanks, will go drop the lone mips patch that I think is causing this
> > problem.
> > 
> 
> Looks like it did. For v4.14.148-61-g6f45e0e87a75:
> 
> Build results:
> 	total: 172 pass: 172 fail: 0
> Qemu test results:
> 	total: 372 pass: 372 fail: 0

Great!  Thanks for running this and letting me know.

greg k-h
