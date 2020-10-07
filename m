Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72825285BA3
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 11:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgJGJLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 05:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgJGJLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 05:11:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69CEE204EC;
        Wed,  7 Oct 2020 09:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602061894;
        bh=05AguT2V4/5jkBRacRYItkoyPviRto3KzVERHwaK5pg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OGJdIpOh0KAH1HTdQiymWXc0hLgjNTDOP5xZPwS3VwbHDK7FdA1EQhWXKZQVQsLR0
         fXY18wngTYz/NGgtKiHOgGfYbtRhx4i44CyPGKy4LuTe93BBPurhcSzQUAY5PAz+6l
         uKrRl8k3CsqojAezzZzaLDgY2AM8pgOYBGRB/4kk=
Date:   Wed, 7 Oct 2020 11:12:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.8 00/85] 5.8.14-rc1 review
Message-ID: <20201007091219.GC614379@kroah.com>
References: <20201005142114.732094228@linuxfoundation.org>
 <CA+G9fYuma1oe3GuAjQUtWwqHwshpzZsS-2h0u2R450X-m=mSzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuma1oe3GuAjQUtWwqHwshpzZsS-2h0u2R450X-m=mSzg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 06, 2020 at 10:57:21AM +0530, Naresh Kamboju wrote:
> On Mon, 5 Oct 2020 at 21:01, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.8.14 release.
> > There are 85 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.14-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
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

Thanks for testing all of these and letting me know.

greg k-h
