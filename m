Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE179209FEE
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 15:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404932AbgFYNbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 09:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404872AbgFYNbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 09:31:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A83220781;
        Thu, 25 Jun 2020 13:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593091863;
        bh=PJIItY9t5HIrTGChts+J1Qqv4AMVfFAYrThljuqK0Eg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iSbgbvoK/njmAJiIH3ALRK+e83canROgvoIp9j8xHkqthHcVFBck023+c9ENeGQLE
         61O+U408xGrmv4x0s0F59hvW1GkWbubsSJobmLVTY0Xrb+iWKDEw5Zl2XpJAI0RvBt
         PHsh7n0pHGVfTVismzqAxs/dVHzdGpOkQK29yu64=
Date:   Thu, 25 Jun 2020 15:30:59 +0200
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
Subject: Re: [PATCH 5.7 000/474] 5.7.6-rc2 review
Message-ID: <20200625133059.GB3528477@kroah.com>
References: <20200624055938.609070954@linuxfoundation.org>
 <CA+G9fYv-0e1e-B+yNiTCSWLSG0JpyLcGMcXaHe8CDkp2bs_8AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYv-0e1e-B+yNiTCSWLSG0JpyLcGMcXaHe8CDkp2bs_8AQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 06:57:27PM +0530, Naresh Kamboju wrote:
> On Wed, 24 Jun 2020 at 11:40, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.7.6 release.
> > There are 474 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 26 Jun 2020 05:58:09 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.6-rc2.gz
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

Thanks for testing all of tehse and letting me know.

greg k-h
