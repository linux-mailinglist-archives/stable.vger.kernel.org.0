Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026E82F39EA
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 20:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436518AbhALTTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 14:19:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbhALTTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 14:19:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF6CE23120;
        Tue, 12 Jan 2021 19:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610479108;
        bh=j+NrB49r/EwEZV0l9MwoEvcgoUvDaK5lalQiyttqMrk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uIfzE65IfMNdktt7pYqbmgxjXKJJelm73wasUWLszTahF2og/cUCjtw7EfVAM95Xb
         P7USErPnghp2t5XUY7jshx/CUZD3u7DB+7leJwpHqVoQ+dB8GOst955Ouw8wU6DV46
         VOoOU9cu1pFEyrRva46dc2A+N+NXWffRUI4f5Nn0=
Date:   Tue, 12 Jan 2021 20:19:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 000/144] 5.10.7-rc2 review
Message-ID: <X/32SXdZayDKya+1@kroah.com>
References: <20210111161510.602817176@linuxfoundation.org>
 <CA+G9fYsYyW+eC3oBJeV+cT6WSuagxwo2qFjdzF7YbXinumJxEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsYyW+eC3oBJeV+cT6WSuagxwo2qFjdzF7YbXinumJxEA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 12:21:39PM +0530, Naresh Kamboju wrote:
> On Mon, 11 Jan 2021 at 21:44, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.7 release.
> > There are 144 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 13 Jan 2021 16:14:43 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.7-rc2.gz
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

Thanks for testing all of these and letting me know.

greg k-h
