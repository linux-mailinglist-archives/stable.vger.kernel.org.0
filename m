Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99613322FF
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 11:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhCIK11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 05:27:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhCIK0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Mar 2021 05:26:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86DCD6527B;
        Tue,  9 Mar 2021 10:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615285615;
        bh=auKO5HGDnHB6VehnJcnZhO1vO68xDUuBm+zLXacy0bw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D8AEZ/uyIydVdzm5Rhsrw3x0w8aAWABmbdiXrkzsx5u1q82uyFjw9br452/vrELEW
         SIOoW3rjilJoy48Rue+2h28uU4c9UpsEIA8uG8SPeyHSAahpUXDVxP2HjdBMkSwn5a
         YBtUXMXGdrMWNDt1j1Gp06XsvJuvyMeQhwUe64Sk=
Date:   Tue, 9 Mar 2021 11:26:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.11 00/44] 5.11.5-rc1 review
Message-ID: <YEdNbCWafpSCBMhL@kroah.com>
References: <20210308122718.586629218@linuxfoundation.org>
 <CA+G9fYs+sw5R0wE2YmeYpu+9b5tR=VgfFCk3Aw_ey6iDv13RQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYs+sw5R0wE2YmeYpu+9b5tR=VgfFCk3Aw_ey6iDv13RQw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 09, 2021 at 09:52:04AM +0530, Naresh Kamboju wrote:
> On Mon, 8 Mar 2021 at 18:06, <gregkh@linuxfoundation.org> wrote:
> >
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > This is the start of the stable review cycle for the 5.11.5 release.
> > There are 44 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.5-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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

thanks for testing them all and letting me know.

greg k-h
