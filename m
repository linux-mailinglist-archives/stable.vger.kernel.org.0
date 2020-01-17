Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A89EB140C76
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 15:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgAQO3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 09:29:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbgAQO3L (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 09:29:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75DD32072B;
        Fri, 17 Jan 2020 14:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579271350;
        bh=mdYoHBoChECLZVOrbyQxNM5gR9MHiyxQWeVaJGvV+eI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1GucAfNVVFZVYXkGoROhV0mu6CN8QABzqkbKj2RMh7pY3ZlJwxP/wQEGD6g73sokw
         +na4KtYtdYHqlT0V8gNnA8xxIemtRi10gtez9iVn9RbNluzDS/SbSTMD+LZZIqEOwv
         fGo/zVgX5mGyWZDHdutyazENAkKYJn99UHPrbpuo=
Date:   Fri, 17 Jan 2020 15:29:08 +0100
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
Subject: Re: [PATCH 5.4 000/203] 5.4.13-stable review
Message-ID: <20200117142908.GA1880047@kroah.com>
References: <20200116231745.218684830@linuxfoundation.org>
 <CA+G9fYvRAU-4xF_Kxrz6A39HvX8020joox_rUtgb=ATq2czDOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvRAU-4xF_Kxrz6A39HvX8020joox_rUtgb=ATq2czDOg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 07:50:10PM +0530, Naresh Kamboju wrote:
> On Fri, 17 Jan 2020 at 04:49, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.13 release.
> > There are 203 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 18 Jan 2020 23:16:00 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.13-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me know.

greg k-h
