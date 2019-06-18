Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FF64A250
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 15:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbfFRNfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 09:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727584AbfFRNfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jun 2019 09:35:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4184B2085A;
        Tue, 18 Jun 2019 13:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560864905;
        bh=LfDIusApwnD9DgCP5+CwGDN+aRi7wKCcbdDOmRSvwjw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ef/t2lHewy0vT4DZgwqkZZ4p5C2hdQNUrEeh+/eL5ei5oaKn0RdOaetURRFExqO0Q
         PzbQi6l4i/qraVhPWmCL2QRwdViXvAp+izBgbe6F25+PMaozlUiW8Vf2Evg8C++Vzj
         PSKEXMngtP4cbWNMSc8k4YBEMDkz0DuHqIj0kIFs=
Date:   Tue, 18 Jun 2019 15:35:02 +0200
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
Message-ID: <20190618133502.GA5416@kroah.com>
References: <20190617210759.929316339@linuxfoundation.org>
 <CA+G9fYsUmFrTDHJfS=1vYVfv4BVRZ0AByEOHV6toidAxWuDqDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsUmFrTDHJfS=1vYVfv4BVRZ0AByEOHV6toidAxWuDqDg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 18, 2019 at 06:04:25PM +0530, Naresh Kamboju wrote:
> On Tue, 18 Jun 2019 at 02:50, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.1.12 release.
> > There are 115 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed 19 Jun 2019 09:06:21 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.12-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> NOTE:
> kernel/workqueue.c:3030 __flush_work+0x2c2/0x2d0
> Kernel warning is been fixed by below patch.
> 
> > John Fastabend <john.fastabend@gmail.com>
> >     bpf: sockmap, only stop/flush strp if it was enabled at some point

What is the git commit id for this patch?

thanks,

greg k-h
