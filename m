Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6407F2D2773
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 10:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgLHJYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 04:24:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgLHJYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 04:24:30 -0500
Date:   Tue, 8 Dec 2020 10:24:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607419430;
        bh=mZVy2pRIiyr7mLTIx6XBmnVNxKXAmuJ8ic/WhcvBWe0=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=TLQa13cbNAMva21QmYWyu1U3mjEHlZk4HGf5buD5E+aD1kkvFaVhIWSe6tRoAXGXC
         MPyiVypgpOcjmCr9/uARUPvNkz6FiOscSb5dDkiAuyMoCeEhWNmpTQocEXlRyImpXA
         kYGhbRP6FAwusHlDBcpRU34Nk3wHwnF79gfa+hoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/32] 4.19.162-rc1 review
Message-ID: <X89GaniY7R8LhjTO@kroah.com>
References: <20201206111555.787862631@linuxfoundation.org>
 <20201207083042.GA26438@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207083042.GA26438@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 09:30:42AM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.162 release.
> > There are 32 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
> > Anything received after that time might be too late.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.19.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing this one and letting me know.

greg k-h
