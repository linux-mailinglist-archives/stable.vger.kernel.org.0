Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BE231AB79
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 14:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhBMM7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 07:59:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229787AbhBMM7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Feb 2021 07:59:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A423364E3F;
        Sat, 13 Feb 2021 12:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613221133;
        bh=0d84AhS5d4Or34quXVEwdsNxpU0pv843mwZPKPh3XPg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=On+LIsLzINmy3LpmBTTFWTfOhuumwQIXi0OdpTVTmKPcGiA9jtH3ctfpCre5tmXMv
         nEGO/mLFLUs0pfKxRb2PkHpP0PxOdQRtv4vIIq+KcVhL0UZblz9ad6OPUJvE1grm+E
         7s54xhuN5w+PbBIRMUhQx1/oDR5TE3eukF+NKypk=
Date:   Sat, 13 Feb 2021 13:58:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 00/54] 5.10.16-rc1 review
Message-ID: <YCfNCpBfEsLGKTVZ@kroah.com>
References: <20210211150152.885701259@linuxfoundation.org>
 <CA+G9fYub55vxyF97HoVX58S9aUOQvNDoespFrAMKMffd0owzCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYub55vxyF97HoVX58S9aUOQvNDoespFrAMKMffd0owzCA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 08:46:36AM +0530, Naresh Kamboju wrote:
> On Thu, 11 Feb 2021 at 20:35, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.16 release.
> > There are 54 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.16-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing them all and letting me know.

greg k-h
