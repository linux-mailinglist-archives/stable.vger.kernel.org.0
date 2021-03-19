Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1423D3418C6
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 10:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhCSJuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 05:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229638AbhCSJuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 05:50:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94A4164E21;
        Fri, 19 Mar 2021 09:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616147417;
        bh=AudmcrZ4iWij8+n4rRH4DvbxKKVng0MvM9pOE1QukHU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y4syOnKG94UBExlerMC9rAdeT+nAYskg9JBI2q60exkKYHmQeXPo2Ag90VkMbiiYY
         /P/PDqalqwgOdY4uHW+w5zv+twk5ezFadIZYZyEXmUX4fV/agmclV30PUUU8hnasDY
         HZP/dfQMu+xA+k2S5yz5V1z2El7JnEBQu04Mf0dY=
Date:   Fri, 19 Mar 2021 10:50:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.11 000/306] 5.11.7-rc1 review
Message-ID: <YFRz1gophehyHi3Z@kroah.com>
References: <20210315135507.611436477@linuxfoundation.org>
 <CA+G9fYtRqGK2QUWCMQ8W0awGxykCYFMRCXYud9yKHkR3_jooQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtRqGK2QUWCMQ8W0awGxykCYFMRCXYud9yKHkR3_jooQg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 10:45:40AM +0530, Naresh Kamboju wrote:
> On Mon, 15 Mar 2021 at 19:27, <gregkh@linuxfoundation.org> wrote:
> >
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > This is the start of the stable review cycle for the 5.11.7 release.
> > There are 306 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 17 Mar 2021 13:54:26 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.7-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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

Thanks for testing them all and letting me know.

greg k-h
