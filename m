Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43769309532
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 14:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhA3NCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 08:02:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231569AbhA3NCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 08:02:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A064764E09;
        Sat, 30 Jan 2021 13:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612011686;
        bh=ueuw4cqhCRaVSzDATCy8F7GGdVP19VJ/kUBT5d8dOk4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ggnJtn9HMZkO3/cPU+PV41Q8eCAxPpj8WLTmrKMPL8fkeVJxDxJUc6w1fG9iYOWhk
         SPIWfTj3Bd02RlXFN3jCKrOAcJuFWJfqEWoZpzFcdaqykNIVAA0TySTW0jm4vTy3SC
         muoq5sxaQ6Ika9WNQVZZUBzgEu93W633YCSQbp8M=
Date:   Sat, 30 Jan 2021 14:01:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 00/32] 5.10.12-rc1 review
Message-ID: <YBVYo07BtEioATDE@kroah.com>
References: <20210129105912.628174874@linuxfoundation.org>
 <CA+G9fYsEseDKySENMfSiRMgh-CTefpCtsQsBFbJ6tfmRoBPxwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsEseDKySENMfSiRMgh-CTefpCtsQsBFbJ6tfmRoBPxwA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 29, 2021 at 11:52:04PM +0530, Naresh Kamboju wrote:
> On Fri, 29 Jan 2021 at 16:47, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.12 release.
> > There are 32 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.12-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing these and letting me know.

greg k-h
