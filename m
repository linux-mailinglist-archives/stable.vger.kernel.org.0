Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28DA337B12
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhCKRjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229884AbhCKRjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 12:39:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DF1264F35;
        Thu, 11 Mar 2021 17:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615484340;
        bh=671o4q4CvWKMjD7Jb6jmbRb9iezM2tIZXeqzqG+mTMY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qdQLV9pZ7lxmWb8gppcFff8XQZL/ZOHBpYLidOQ9BDcMwAwDrEembP3jdhJ4sb7cO
         n5F0h3tIXdrUt20RvVKJJ4CSTVWZzf9MS6YzQ2/PqpnW7wdJrL48dIbukxvdE0vhhB
         Gbwd8q+vGKW3NqmZUaxxPz+KjQ1V25zznGwAEteY=
Date:   Thu, 11 Mar 2021 18:38:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.11 00/36] 5.11.6-rc1 review
Message-ID: <YEpVspB8XPGPScME@kroah.com>
References: <20210310132320.510840709@linuxfoundation.org>
 <CA+G9fYt=K-uVJPBvwZUtTUQVe=ZsQLzsFd1QD6SvY6GwV770Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYt=K-uVJPBvwZUtTUQVe=ZsQLzsFd1QD6SvY6GwV770Hg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 11, 2021 at 08:51:27AM +0530, Naresh Kamboju wrote:
> On Wed, 10 Mar 2021 at 18:54, <gregkh@linuxfoundation.org> wrote:
> >
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > This is the start of the stable review cycle for the 5.11.6 release.
> > There are 36 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.6-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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
