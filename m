Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620AC33E9E
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 07:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfFDFvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 01:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbfFDFvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 01:51:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CAB72064A;
        Tue,  4 Jun 2019 05:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559627474;
        bh=MZ/T0KzmW/Y34HTA2wVPesvs1LL6IuJhwpkiHnmR2Es=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v9I01p8Ar25LMKov0M7TenBhL0/YtI46pVID2gfdzYQdCEKRv9kiokrKYTpPmwgZP
         +jSwKa3WmENWJaieac/xHqcLjqSUKITz4WuZJY1bdnKA16mb/JkfQwCDtSzGzWlJjy
         +ppy2DKp/MjYq5LXJ2Wk3rw/EBBei+VFQoyfJU1c=
Date:   Tue, 4 Jun 2019 07:51:12 +0200
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
Subject: Re: [PATCH 5.1 00/40] 5.1.7-stable review
Message-ID: <20190604055112.GE16504@kroah.com>
References: <20190603090522.617635820@linuxfoundation.org>
 <CA+G9fYtDyv34JNgrT0gw7NbJXWC2p8F3_zHJUjYGiSE4kefK6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtDyv34JNgrT0gw7NbJXWC2p8F3_zHJUjYGiSE4kefK6A@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 01:03:21AM +0530, Naresh Kamboju wrote:
> On Mon, 3 Jun 2019 at 14:44, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.1.7 release.
> > There are 40 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed 05 Jun 2019 09:04:46 AM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.7-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great, thanks for testing these and letting me know.

greg k-h
