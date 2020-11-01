Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6D22A1DAF
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 12:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgKALwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 06:52:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726499AbgKALwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 06:52:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DC6D206E5;
        Sun,  1 Nov 2020 11:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604231541;
        bh=l+cEN+sHBnTnUYn8mP+ZddldI5H73zcAjG+zjQQ9zKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uy0Ej/XzuyC1YNwUJq7tejIChqCRTmz9SPEQZ5fZnWNmJfwE35DESFCHpl948zTfP
         1Y1UnOAXmlcAvMDDlOdq/uR6iu0GlQjcDVZGK6MnJLzfO8n2EUX1l6T/AWU7zx82yz
         dbk0jAnKUGuifSlvj287myuOgSW+bH7AeZvZRTr8=
Date:   Sun, 1 Nov 2020 12:53:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        LTP List <ltp@lists.linux.it>
Subject: Re: [PATCH 5.9 00/74] 5.9.3-rc1 review
Message-ID: <20201101115304.GB3349581@kroah.com>
References: <20201031113500.031279088@linuxfoundation.org>
 <CA+G9fYshNJgQFZ_oxb4VgSbe2xWym9am6ajpr-SVH_bw4psa1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYshNJgQFZ_oxb4VgSbe2xWym9am6ajpr-SVH_bw4psa1Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 01, 2020 at 12:34:42PM +0530, Naresh Kamboju wrote:
> On Sat, 31 Oct 2020 at 17:17, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.9.3 release.
> > There are 74 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Mon, 02 Nov 2020 11:34:42 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.3-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing all of these and letting me konw.

greg k-h
