Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9478B452D1E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 09:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhKPIvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 03:51:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232161AbhKPIvu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 03:51:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEAA561101;
        Tue, 16 Nov 2021 08:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637052533;
        bh=egbGIYFi4v7cS2x4F9uQ5GOy67VTqb9Lor5GYwZqQg0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RIT3UCz6MSHfBlhXrQ1JxWe6CFiGH/GMV0/KGuFuM9tIeE+clcqeCI+sZmwgKr0uL
         oYmGz2WtAodo028GvwCXbXHmOuZ/atP2MNrAEoG/GIwX6ML2thkSXXyAg1cGvCKMlu
         WxpKH1vT5dlBTuwszq1poSFjXpdoLai39CW0Ljg8=
Date:   Tue, 16 Nov 2021 09:48:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Anders Roxell <anders.roxell@linaro.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/917] 5.15.3-rc1 review
Message-ID: <YZNwcylQcKVlZDlO@kroah.com>
References: <20211115165428.722074685@linuxfoundation.org>
 <CA+G9fYtFOnKQ4=3-4rUTfVM-fPno1KyTga1ZAFA2OoqNvcnAUg@mail.gmail.com>
 <CA+G9fYuF1F-9TAwgR9ik_qjFqQvp324FJwFJbYForA_iRexZjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuF1F-9TAwgR9ik_qjFqQvp324FJwFJbYForA_iRexZjg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 02:09:44PM +0530, Naresh Kamboju wrote:
> On Tue, 16 Nov 2021 at 12:06, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Tue, 16 Nov 2021 at 00:03, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.15.3 release.
> > > There are 917 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> >
> 
> Regression found on arm64 juno-r2 / qemu.
> Following kernel crash reported on stable-rc 5.15.
> 
> Anders bisected this kernel crash and found the first bad commit,
> 
> Herbert Xu <herbert@gondor.apana.org.au>
>    crypto: api - Fix built-in testing dependency failures

Is this also an issue on 5.16-rc1?

thanks,

greg k-h
