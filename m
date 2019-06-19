Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D99F94B664
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 12:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731440AbfFSKoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 06:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbfFSKoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 06:44:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 982872147A;
        Wed, 19 Jun 2019 10:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560941043;
        bh=M/k0nQhz8LkeCh1Dwe+5NVhKYN4yxN+K87ayZLGfYCc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dh/1xgSDlKl15b7R8xfyWpIHVKVzxTlD6bCyopEOyPe8YWZAu9JYdKSco+Sgo9GL3
         u+OUWKYTNBcUK5NnMZnaPc+hf2ZZoQBn9i4fHG6phr1tTKrVIlqznbArWoIRS/IXDM
         MO/uBeZaxeLaJ08INUELgi7JiRFtD65Dahj8849Q=
Date:   Wed, 19 Jun 2019 12:44:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.1 000/115] 5.1.12-stable review
Message-ID: <20190619104400.GA3150@kroah.com>
References: <20190617210759.929316339@linuxfoundation.org>
 <CA+G9fYsUmFrTDHJfS=1vYVfv4BVRZ0AByEOHV6toidAxWuDqDg@mail.gmail.com>
 <20190618133502.GA5416@kroah.com>
 <CA+G9fYsDG94ZjpchTqD80vioNBUdoUXH_k-tBM0L8YumefYO-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsDG94ZjpchTqD80vioNBUdoUXH_k-tBM0L8YumefYO-w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 19, 2019 at 10:10:12AM +0530, Naresh Kamboju wrote:
> On Tue, 18 Jun 2019 at 19:05, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jun 18, 2019 at 06:04:25PM +0530, Naresh Kamboju wrote:
> > > On Tue, 18 Jun 2019 at 02:50, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.1.12 release.
> > > > There are 115 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Wed 19 Jun 2019 09:06:21 PM UTC.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.12-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > Results from Linaro’s test farm.
> > > No regressions on arm64, arm, x86_64, and i386.
> > >
> > > NOTE:
> > > kernel/workqueue.c:3030 __flush_work+0x2c2/0x2d0
> > > Kernel warning is been fixed by below patch.
> > >
> > > > John Fastabend <john.fastabend@gmail.com>
> > > >     bpf: sockmap, only stop/flush strp if it was enabled at some point
> >
> > What is the git commit id for this patch?
> 
>      Upstream commit 014894360ec95abe868e94416b3dd6569f6e2c0c

Ah, it's been fixed, not that a fix is needed to be backported, sorry
for the confusion.

greg k-h
