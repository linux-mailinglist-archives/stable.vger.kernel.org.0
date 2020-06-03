Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866241ECABC
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 09:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgFCHnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 03:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgFCHni (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 03:43:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD1902077D;
        Wed,  3 Jun 2020 07:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591170218;
        bh=r2fETOSP87iuiX1h7PmTs45RGfgsbQrXJaA6BDFmRYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dIgO7fVwWAMUVirlCim/ubtuawUbYNrwoHabkbRtDaXznnLOQ8nacfc0YkljOUBIH
         FXVo4h2NOzGASoWho+ul20OonlH/nznDdV8K4k7e4YBowW6ARZd5PvJGwWNy4MK5yM
         eqQ5JBPLlGempp7OIfmfcSwaG9MgrGwZqOLj1zME=
Date:   Wed, 3 Jun 2020 09:43:36 +0200
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
Subject: Re: [PATCH 4.9 00/55] 4.9.226-rc3 review
Message-ID: <20200603074336.GD612108@kroah.com>
References: <20200602181325.420361863@linuxfoundation.org>
 <CA+G9fYsU+pP971z2sOjyJbW3jiiTa=TK+GJTCZ+-TF36krCepw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsU+pP971z2sOjyJbW3jiiTa=TK+GJTCZ+-TF36krCepw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 03, 2020 at 11:42:48AM +0530, Naresh Kamboju wrote:
> On Tue, 2 Jun 2020 at 23:44, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.9.226 release.
> > There are 55 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 04 Jun 2020 18:12:28 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.226-rc3.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Lots of releases to test!  Thanks for doing all of these and letting me
know.

greg k-h
