Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA2B1B3006
	for <lists+stable@lfdr.de>; Sun, 15 Sep 2019 14:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbfIOM62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Sep 2019 08:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbfIOM61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Sep 2019 08:58:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49CC521479;
        Sun, 15 Sep 2019 12:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568552307;
        bh=RzIxKkF9QaaNt1GjSKEtyMLCwfADtyW3l/O9MaHgMDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pleBkKK9WNJsT7QxDvau3kvgbr9uR9KbIMX8bHSUTaAi6YbTEQ45ULu3GDxFu5Bki
         JpWt+JkIEUz55rFKWb5FmE27qFqnL6Ph6p+61IGhbJhgd1Jr66Sg2jS0L8MNDEggQL
         RHyz+DF1I702AWYD1eNUd5JFuykSxqbXdUqdnb5M=
Date:   Sun, 15 Sep 2019 14:58:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH 4.9 00/14] 4.9.193-stable review
Message-ID: <20190915125824.GA528036@kroah.com>
References: <20190913130440.264749443@linuxfoundation.org>
 <aefa6832-073e-493c-8576-5b2f06e714fb@roeck-us.net>
 <20190914083126.GA523517@kroah.com>
 <353c2b75-290e-c796-4cc6-88681936210f@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <353c2b75-290e-c796-4cc6-88681936210f@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 14, 2019 at 05:49:32PM -0700, Guenter Roeck wrote:
> Hi Greg,
> 
> On 9/14/19 1:31 AM, Greg Kroah-Hartman wrote:
> > On Sat, Sep 14, 2019 at 01:28:39AM -0700, Guenter Roeck wrote:
> > > On 9/13/19 6:06 AM, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.9.193 release.
> > > > There are 14 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> > > > Anything received after that time might be too late.
> > > > 
> > > 
> > > Is it really only me seeing this ?
> > > 
> > > drivers/vhost/vhost.c: In function 'translate_desc':
> > > include/linux/compiler.h:549:38: error: call to '__compiletime_assert_1879' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
> > > 
> > > i386:allyesconfig, mips:allmodconfig and others, everywhere including
> > > mainline. Culprit is commit a89db445fbd7f1 ("vhost: block speculation
> > > of translated descriptors").
> > 
> > Nope, I just got another report of this on 5.2.y.  Problem is also in
> > Linus's tree :(
> > 
> 
> Please apply upstream commit 0d4a3f2abbef ("Revert "vhost: block speculation
> of translated descriptors") to v4.9.y-queue and later to fix the build problems.
> Or maybe just drop the offending commit from the stable release queues.

I'm just going to drop the offending commit from everywhere and push out
new -rcs in a bit...

thanks,

greg k-h
