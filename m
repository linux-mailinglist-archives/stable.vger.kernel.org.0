Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1266BB3889
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 12:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732374AbfIPKqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 06:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:32972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732373AbfIPKqF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 06:46:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBE0421670;
        Mon, 16 Sep 2019 10:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568630764;
        bh=AXw8+RZeBdtERZpVbW8BlA9b3DHynmerk4QaOR0J1VM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jqQZjordVWeTCxGJBNm+DRhanE4743w06mP2IM637pLwopsYqtJ8M74TJ6Pd9Qhhs
         plIKfupzoYSPYcpAdNFK0WmzltqJsMziVtkgplZDOuxknUCZuxoooEVhb28XEPSLBj
         7qqtBDY5ewi1moP4rTpnPkf0+vpIKixfhp7VbiSw=
Date:   Mon, 16 Sep 2019 12:45:50 +0200
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
Subject: Re: [PATCH 4.9 00/14] 4.9.193-stable review
Message-ID: <20190916104550.GA1412477@kroah.com>
References: <20190913130440.264749443@linuxfoundation.org>
 <20190915133553.GD552182@kroah.com>
 <CA+G9fYu5b-zyttOx1Wxu-bi+hopRvYNQ1otS7qujx+xuLrA8xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYu5b-zyttOx1Wxu-bi+hopRvYNQ1otS7qujx+xuLrA8xA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 16, 2019 at 06:44:34AM -0400, Naresh Kamboju wrote:
> On Sun, 15 Sep 2019 at 09:35, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Sep 13, 2019 at 02:06:53PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.9.193 release.
> > > There are 14 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >       https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.193-rc1.gz
> > > or in the git tree and branch at:
> > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> > > and the diffstat can be found below.
> >
> > I have released -rc2 to resolve a reported build issue:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.193-rc2.gz
> 
> -rc2 looks good.
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Wonderful, thanks for testing!

greg k-h
