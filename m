Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14E2279A98
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 18:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgIZQJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 12:09:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729363AbgIZQJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Sep 2020 12:09:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C213521527;
        Sat, 26 Sep 2020 16:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601136598;
        bh=u/KB1SP47t9hZjSzhHsSzUzcvXDqvX+3ahZRFFCuuPk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IDevnuMZ3lhE5QTO0HE0jTkY9R38oEVyGdtW4vWQNZuxQncHHhQquSwpE4vBaFc9E
         M865TJQjvZnbVg7Z+RJQwHkRLse+PogWU+oGjTO+B0qcarjl/+oDQnrUHdk1LyTIVZ
         iwjvt/R2GnA+w+M11jh3gG4q+BwgZvMaH3RzR6ME=
Date:   Sat, 26 Sep 2020 18:10:10 +0200
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
Subject: Re: [PATCH 5.8 00/56] 5.8.12-rc1 review
Message-ID: <20200926161010.GB3361615@kroah.com>
References: <20200925124727.878494124@linuxfoundation.org>
 <CA+G9fYs2XFPxTApCcZz5x6cr3GM8uNYE77O=Md-W4QtQ7PRR_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYs2XFPxTApCcZz5x6cr3GM8uNYE77O=Md-W4QtQ7PRR_g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 26, 2020 at 12:02:42AM +0530, Naresh Kamboju wrote:
> On Fri, 25 Sep 2020 at 18:18, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.8.12 release.
> > There are 56 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.12-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing all of these and letting me know.

greg k-h
