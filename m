Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D8D218AFB
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbgGHPQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729815AbgGHPQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 11:16:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BB40206DF;
        Wed,  8 Jul 2020 15:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594221369;
        bh=LA/sLUBMajQaJFvcAkPqIvFcZLOeXVAk9t5IXw5BZnY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hyK0Tp8YITX0gVDFmpd5U71m61jWFV6yY+hEUlcXOxVK97hL48RJK0PTt6t0ML/tt
         N+kFDWEYJNvnQDjF5mQbEZaRJFyltd4tCKCWcGAjm1Vf8sqGoj8h0G7qsCTvpvMJfN
         Lm1mkwisWRlfyfGiLiBoaWSXe1YlztGu4eJn5GmI=
Date:   Wed, 8 Jul 2020 17:16:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.7 000/112] 5.7.8-rc1 review
Message-ID: <20200708151604.GC710412@kroah.com>
References: <20200707145800.925304888@linuxfoundation.org>
 <CA+G9fYu9bu961J7A3=Pn3-YTwMochWM+rtEkZ74JfQXn52dT3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYu9bu961J7A3=Pn3-YTwMochWM+rtEkZ74JfQXn52dT3g@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 08, 2020 at 10:38:23AM +0530, Naresh Kamboju wrote:
> On Tue, 7 Jul 2020 at 20:55, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.7.8 release.
> > There are 112 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.8-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
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
