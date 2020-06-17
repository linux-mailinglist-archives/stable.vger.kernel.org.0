Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246CB1FD2D4
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 18:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgFQQwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 12:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgFQQwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 12:52:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A797220897;
        Wed, 17 Jun 2020 16:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592412723;
        bh=bnwvBWjpK4hCKWm3xfoqftZR+0xJ0AjWXSRXcsN5UFA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vUC6R34B3P4TiFodYviY1/c8Uxff69j4CeVGkbzLVF2xhp4hCSDjFlmUrDej8YCZu
         59syp4sF20N/Vn4rVMvgkFw8+yo/wl/F+p7o618joeVo1JVVYLsF69NktjC4veCtvD
         6FlTW/RNSp3yFseonHCH/wt9w9/r2JNZ7j2u9j88=
Date:   Wed, 17 Jun 2020 18:51:56 +0200
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
Subject: Re: [PATCH 5.7 000/162] 5.7.3-rc2 review
Message-ID: <20200617165156.GB3794995@kroah.com>
References: <20200616172615.453746383@linuxfoundation.org>
 <CA+G9fYsBwdUZtXTqoLJNm=8XPy+Hq4rUbZSmyGg=rLWRdF_j7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsBwdUZtXTqoLJNm=8XPy+Hq4rUbZSmyGg=rLWRdF_j7Q@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 17, 2020 at 12:54:56PM +0530, Naresh Kamboju wrote:
> On Tue, 16 Jun 2020 at 22:57, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.7.3 release.
> > There are 162 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 18 Jun 2020 17:25:43 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.3-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great, thanks for testing and letting me know.

greg k-h
