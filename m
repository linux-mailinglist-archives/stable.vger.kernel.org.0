Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEBE2FCEBE
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 12:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730915AbhATLCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 06:02:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733219AbhATKis (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 05:38:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED7D723331;
        Wed, 20 Jan 2021 10:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611139049;
        bh=MGKH7qdxy9aee3zqS3a6MU5OoLLGRbtBX4Epi41Tj8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w/keroAh6AOrwfDLh9j6IdhWIVoUWnK7RoBsJa3BPYPOGxeZSk8FkQaRE9tyAnWpo
         UEKNIhTr8DXU8rDT+MucyrnfKUXX8jgx9k7lcWrQxCC9AhQOj5zQmqd2nJ6Lwv9IEL
         sd1e9udeUv+qtwT2cVpUDIiFb8m4p/IT94zkP0QM=
Date:   Wed, 20 Jan 2021 11:37:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 000/152] 5.10.9-rc1 review
Message-ID: <YAgH5pn4PJY9LwFg@kroah.com>
References: <20210118113352.764293297@linuxfoundation.org>
 <CA+G9fYuvDpuK7Nt=eGeyBtOgwLZJOSBniONfc3YqqknC3FFp1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuvDpuK7Nt=eGeyBtOgwLZJOSBniONfc3YqqknC3FFp1A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 18, 2021 at 11:42:59PM +0530, Naresh Kamboju wrote:
> On Mon, 18 Jan 2021 at 17:12, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.9 release.
> > There are 152 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 20 Jan 2021 11:33:23 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.9-rc1.gz
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

Thanks for testing these and letting me know.

greg k-h
