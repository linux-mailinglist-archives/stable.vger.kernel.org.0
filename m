Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC392FA496
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393468AbhARPZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:25:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393461AbhARPYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 10:24:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 164C4223DB;
        Mon, 18 Jan 2021 15:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610983450;
        bh=QBruoSABUanWWPthuJQu3hsuFkNo/ecD83CfL8U3YWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KlKTe71U9p2ZZs3WKNnzYIBshtge89AYQVfO+fACnVDwmmgITXFSXqtPvd/3s9tlX
         7yzz1wXujeiEY1yWBerErjkGtYgi6D9RiPIaW7/kcpu4uZVVPFfmD4sOVoAs8sCTar
         f07LzjTPwX6ZGngW7hLdSklMj3276cN8F7/rXpHs=
Date:   Mon, 18 Jan 2021 16:24:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 4.19 00/43] 4.19.169-rc1 review
Message-ID: <YAWoGJ3j/Bz30SzV@kroah.com>
References: <20210118113334.966227881@linuxfoundation.org>
 <CA+G9fYsVb-4L65-YjNxVhGWeQySQAQVyQGudDtbmzfZq4g4vFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsVb-4L65-YjNxVhGWeQySQAQVyQGudDtbmzfZq4g4vFA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 18, 2021 at 08:10:26PM +0530, Naresh Kamboju wrote:
> On Mon, 18 Jan 2021 at 17:06, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.169 release.
> > There are 43 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 20 Jan 2021 11:33:23 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.169-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> MIPS: cavium_octeon_defconfig and nlm_xlp_defconfig builds breaks
> due to this patch.
> 
> > Al Viro <viro@zeniv.linux.org.uk>
> >     MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Thanks, now dropped from here and 5.4.y.  Will push out a -rc2 for both
of these now...

greg k-h
