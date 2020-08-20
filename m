Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA4124C541
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 20:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgHTSZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 14:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgHTSZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 14:25:20 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 336AA204FD;
        Thu, 20 Aug 2020 18:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597947918;
        bh=HD+6B26pOM3xOHTkv4x7zLa79Thbsh5pJUjBsUjrp/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2apTTtZszk/WzWxBLqb/GueTDxRXME6bRh6QcMCrNyO3oVk9djn5GlimeaQC41dpa
         Zw62S5Yh/2y87P89CE4SeNzYO72SecBzL6gocrBJJDApjxzjILh0IFlfiQJAu2HQ5o
         nDFntFlLqzJpbcftsqC+BSodnlGcJY19CIVjW39g=
Date:   Thu, 20 Aug 2020 11:25:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LTP List <ltp@lists.linux.it>,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
Subject: Re: [PATCH 5.8 000/232] 5.8.3-rc1 review
Message-ID: <20200820182516.GA49496@sol.localdomain>
References: <20200820091612.692383444@linuxfoundation.org>
 <CA+G9fYtebf78TH-XpqArunHc1L6s9mHdLEbpY1EY9tSyDjp=sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtebf78TH-XpqArunHc1L6s9mHdLEbpY1EY9tSyDjp=sg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 08:57:57PM +0530, Naresh Kamboju wrote:
> On Thu, 20 Aug 2020 at 14:55, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.8.3 release.
> > There are 232 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.3-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> > Herbert Xu <herbert@gondor.apana.org.au>
> >     crypto: af_alg - Fix regression on empty requests
> 
> Results from Linaro’s test farm.
> Regressions detected.
> 
>   ltp-crypto-tests:
>     * af_alg02
>   ltp-cve-tests:
>     * cve-2017-17805
> 
> af_alg02.c:52: BROK: Timed out while reading from request socket.
> We are running the LTP 20200515 tag released test suite.
>  https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/crypto/af_alg02.c
> 
> Summary
> ------------------------------------------------------------------------
> 
> kernel: 5.8.3-rc1
> git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> git branch: linux-5.8.y
> git commit: 201fff807310ce10485bcff294d47be95f3769eb
> git describe: v5.8.2-233-g201fff807310
> Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/build/v5.8.2-233-g201fff807310
> 
> Regressions (compared to build v5.8.2)
> ------------------------------------------------------------------------
> 
> x15:
>   ltp-crypto-tests:
>     * af_alg02
> 
>   ltp-cve-tests:
>     * cve-2017-17805
> 

Looks like this test is still "broken" because it assumes behavior that isn't
clearly specified, as previously discussed at
https://lkml.kernel.org/r/20200702033221.GA19367@gondor.apana.org.au.

I sent out LTP patches to fix it:
https://lkml.kernel.org/linux-crypto/20200820181918.404758-1-ebiggers@kernel.org/T/#u

- Eric
