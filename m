Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1962F105F6
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 09:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbfEAHzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 03:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfEAHzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 May 2019 03:55:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A8AF21734;
        Wed,  1 May 2019 07:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556697345;
        bh=WC1bIwRlxzYE5RROYcpq7LebU6grfcy0BSWsUHT2/O0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ycdJ+e93TuBfsFboghCszsF1KaH7jjaJUsa3TacbAzX93dCIoQpa848kUQeVemHmw
         GpiclVFAsmH3fEr5j5U1dNpLqbzOt39qU/sW/BsHMOPTy8lfSjNM+LbzThytQ9hHD0
         N7T6TC+YZqwD8zsd5b4csOV2I/F/gJize7MyOUUM=
Date:   Wed, 1 May 2019 09:55:42 +0200
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
Subject: Re: [PATCH 5.0 00/89] 5.0.11-stable review
Message-ID: <20190501075542.GB15344@kroah.com>
References: <20190430113609.741196396@linuxfoundation.org>
 <CA+G9fYtBzC=OuuUvteiS_bBpudTE=Hhc+-Qe-xCtpfpky65Frg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtBzC=OuuUvteiS_bBpudTE=Hhc+-Qe-xCtpfpky65Frg@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 01, 2019 at 11:51:54AM +0530, Naresh Kamboju wrote:
> On Tue, 30 Apr 2019 at 17:18, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.0.11 release.
> > There are 89 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu 02 May 2019 11:35:03 AM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.11-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me know.

greg k-h
