Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769D6127713
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 09:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfLTIUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 03:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbfLTIUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 03:20:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F4BD24679;
        Fri, 20 Dec 2019 08:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576830054;
        bh=B6sxBCqmNa67NKuCWahxkcEJvk3lT7JUBCMqAb13n8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XyTKPxB1OIguO+od8hkIYCtSb/B4fYYUVFLPsELYj6UoeUTcFm8a0dbbZceFrZzzZ
         P7rUcI0Ud/R9HHUsRUVfkTk72Q9kTiGLI4be7jhtZlOe51vfGsZ366DGY6SyjqTNiE
         GnsWwDblGwV/7zxlFRSPfJofr/Id6IIx++LwaoVY=
Date:   Fri, 20 Dec 2019 09:20:51 +0100
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
Subject: Re: [PATCH 5.4 00/80] 5.4.6-stable review
Message-ID: <20191220082051.GA2253558@kroah.com>
References: <20191219183031.278083125@linuxfoundation.org>
 <CA+G9fYtsFr-tmw5jAfYgrrjzo794YaouEBXXj1fE_UH3U9MaxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtsFr-tmw5jAfYgrrjzo794YaouEBXXj1fE_UH3U9MaxQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 20, 2019 at 12:52:56PM +0530, Naresh Kamboju wrote:
> On Fri, 20 Dec 2019 at 00:24, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.6 release.
> > There are 80 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.6-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Wonderful, thanks for testing all of these and letting me know.

greg k-h
