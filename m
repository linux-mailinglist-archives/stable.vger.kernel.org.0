Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430752F9281
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 14:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbhAQNWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 08:22:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729015AbhAQNWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 08:22:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2076622226;
        Sun, 17 Jan 2021 13:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610889681;
        bh=+RPSHZQ/3BVUW2VHQrT12/+5sCDqqg0hngEkzWCBuRA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=udcUSBxW5KWYjfbP6CZIBqYdOZofaeZwx85rLCFn1A0fas4/9OI/1wmISO0pscXET
         QK0wb7M1HC/IwlYU2VsHTD0yZAoaL+r4qszt0ATo013RIYbxzdn1o9ShYvd5mZCDYL
         kPrsS0CIq1pABw9lNIoBWGzPmzhOgFrHBXd5XBnI=
Date:   Sun, 17 Jan 2021 14:21:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 000/103] 5.10.8-rc1 review
Message-ID: <YAQ5z9W5ykXJQ903@kroah.com>
References: <20210115122006.047132306@linuxfoundation.org>
 <CA+G9fYt4ptQmnqu_kYh2kpA-hPfRarzg8CdCJMeaxRf_CyGu9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYt4ptQmnqu_kYh2kpA-hPfRarzg8CdCJMeaxRf_CyGu9A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 16, 2021 at 09:39:28AM +0530, Naresh Kamboju wrote:
> On Fri, 15 Jan 2021 at 18:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.8 release.
> > There are 103 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.8-rc1.gz
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

Thanks for testing them all and letting me know.

greg k-h
