Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491722807AC
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 21:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732941AbgJATYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 15:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729990AbgJATYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 15:24:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34E5A20848;
        Thu,  1 Oct 2020 19:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601580241;
        bh=XNWoB6K/Z846toJiBjQXJHt/5KlJjbm8IvMsAJtWX0w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yl5fVHIMEL8MErBPzQ8U7QlnBAER7cmk51rt3NFp0pZDoKVjfZKEpc772RnEMPpl+
         80nTvVNiGeUhRewLLhcO9/lMErVj0Gn7ZJ2QxrsaXk7ALUSlZKfc1NPk8oAZn4jM1W
         pLk+ITgGPYEt+t+GE/6f6cFJQCMGElWr6oYXu9PU=
Date:   Thu, 1 Oct 2020 21:24:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.8 00/99] 5.8.13-rc1 review
Message-ID: <20201001192402.GE3873962@kroah.com>
References: <20200929105929.719230296@linuxfoundation.org>
 <CA+G9fYsPwAy-GSD504dt7ooe_ZntZT8esuHvJ8yFdW4tUg-bSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsPwAy-GSD504dt7ooe_ZntZT8esuHvJ8yFdW4tUg-bSQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 30, 2020 at 12:58:53PM +0530, Naresh Kamboju wrote:
> On Tue, 29 Sep 2020 at 17:23, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.8.13 release.
> > There are 99 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.13-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> [Sorry earlier email was in Non-plain text so re-sending]
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing them all and letting me know.

greg k-
