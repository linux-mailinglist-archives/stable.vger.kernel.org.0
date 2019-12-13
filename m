Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBF511ED3B
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 22:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfLMVs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 16:48:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbfLMVs4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Dec 2019 16:48:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D05492465A;
        Fri, 13 Dec 2019 21:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576273736;
        bh=j3P5NL8NMAppm8b67o21Z+ZJFp08AZZs2i4B35+nU8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k5lZtK2080RQzSKDfrFjdohglq+TjptgO+cLA9T/JxHMBiqNxmytn+ohSf2BGWjUj
         YyF+RnwjZtbvKXeEQ1j9h/BLkg4jew0yCpGzbkKfm2hcQdjnG9tO8pgWftWDTA8oTF
         Htv6996uHt0Q2D6AeMRWaSRPI7VyrEWE1stNeO3o=
Date:   Fri, 13 Dec 2019 17:08:11 +0100
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
Subject: Re: [PATCH 5.4 00/92] 5.4.3-stable review
Message-ID: <20191213160811.GD2632926@kroah.com>
References: <20191211150221.977775294@linuxfoundation.org>
 <20191212100433.GA1470066@kroah.com>
 <CA+G9fYsWs8feJ5uJZ_Jx-SR__zJZHwZhdVPWa+QOGMHVjBBsPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsWs8feJ5uJZ_Jx-SR__zJZHwZhdVPWa+QOGMHVjBBsPw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 13, 2019 at 10:19:43AM +0530, Naresh Kamboju wrote:
> On Thu, 12 Dec 2019 at 15:34, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Dec 11, 2019 at 04:04:51PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.3 release.
> > > There are 92 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.3-rc1.gz
> > > or in the git tree and branch at:
> > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> >
> > I have pushed out -rc2 with a number of additional fixes:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.3-rc2.gz
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great, tanks for testing and letting me know.

greg k-h
