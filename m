Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B95714998F
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 08:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgAZHnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 02:43:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgAZHnI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Jan 2020 02:43:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 926202071E;
        Sun, 26 Jan 2020 07:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580024588;
        bh=LfTDTUDIlv2YB6QLFR+J6HG2NbpQzDB0LA8IaynKGS8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RMhtK/S6IcVuUVWoEqFF7LN3f9lMsdnVJwiH6DqUJEr1Xr4uIggzRQzLXuuDbgUrs
         VM0PHtf2zbxFL95XBZirMTkTZyOoq3Yg3p9wtSP/WnCQgSGPzUnBkCDwRpvi416izR
         n3fmA/J563Ttt+VapRz8IBxzle8jrwhZGjDZORT4=
Date:   Sat, 25 Jan 2020 14:52:31 +0100
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
Subject: Re: [PATCH 5.4 000/102] 5.4.15-stable review
Message-ID: <20200125135231.GB3519301@kroah.com>
References: <20200124092806.004582306@linuxfoundation.org>
 <CA+G9fYtCQv-eW3y0ySDmazcCDNXHfLuTcCXWj8kj3y0W_HWyVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtCQv-eW3y0ySDmazcCDNXHfLuTcCXWj8kj3y0W_HWyVg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 25, 2020 at 03:52:52PM +0530, Naresh Kamboju wrote:
> On Fri, 24 Jan 2020 at 15:04, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.15 release.
> > There are 102 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.15-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> rc2 test results report.
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me know.

greg k-h
