Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 900584E06D
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 08:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbfFUGOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 02:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbfFUGOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Jun 2019 02:14:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 756EA2083B;
        Fri, 21 Jun 2019 06:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561097678;
        bh=A3cLXC9IgxeYKMEPSFA14Lxq/Vkdf3l3p5k7jQ5X/18=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fCZhn3CeJk/hX44NfUsHxXgulCDj9D/Dnp3ssvjFWjXZnkfQzZxRbsyfl94fXn5gP
         ByuNbO83sV9gErx3vhZ0ywzzf2RGRDnY5KtM54YazDSWp4nIx48fRJAS+Xfrfp/JCK
         eLEcNTbQTRvIzvU/5jctHuYSG6U9Atm9PgslfObo=
Date:   Fri, 21 Jun 2019 08:14:35 +0200
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
Subject: Re: [PATCH 5.1 00/98] 5.1.13-stable review
Message-ID: <20190621061435.GB28816@kroah.com>
References: <20190620174349.443386789@linuxfoundation.org>
 <CA+G9fYv8M2OPuktEt4N7VPpwOCnLa9F90u6ORAfqshnjZTcc6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYv8M2OPuktEt4N7VPpwOCnLa9F90u6ORAfqshnjZTcc6w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 21, 2019 at 09:25:54AM +0530, Naresh Kamboju wrote:
> On Thu, 20 Jun 2019 at 23:44, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.1.13 release.
> > There are 98 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat 22 Jun 2019 05:42:15 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.13-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Wonderful, thanks for testing all of these and letting me know.

greg k-h
