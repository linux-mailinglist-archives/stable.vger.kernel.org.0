Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A902182080
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 19:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbgCKSP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 14:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730658AbgCKSP1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 14:15:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 083602072F;
        Wed, 11 Mar 2020 18:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583950527;
        bh=qVnTUmwaw3eIEhnPfTvHAYO6M3YaHZaBIpQs4wqzAWQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CCocb2IKP53zCaJ75N3+biBomRipITtld1g3RnKeCI064GmGrZYTBPCrfbWkKdcKw
         UArW4LWACdlk4P+jlBaYhtW3EA/xkhMvUdO+CqxEgQrKcu7ltdBseQoCBbkB3NYOeq
         R91KQa7MsrcxjX+ljKseaLrnGNArpYedzELUzk+0=
Date:   Wed, 11 Mar 2020 19:15:24 +0100
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
Subject: Re: [PATCH 5.5 000/189] 5.5.9-stable review
Message-ID: <20200311181524.GE3970258@kroah.com>
References: <20200310123639.608886314@linuxfoundation.org>
 <CA+G9fYt0W2P4WaEg=KSziBtDA6riTATdp-eS6QM4Ft4LzAoUOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYt0W2P4WaEg=KSziBtDA6riTATdp-eS6QM4Ft4LzAoUOA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 01:43:19PM +0530, Naresh Kamboju wrote:
> On Tue, 10 Mar 2020 at 18:27, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.5.9 release.
> > There are 189 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 12 Mar 2020 12:34:10 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.9-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
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
