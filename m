Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956253CA4D3
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 19:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbhGOSA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236602AbhGOSA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:00:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A56F161360;
        Thu, 15 Jul 2021 17:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626371853;
        bh=VnSwPuo5dgT6nc0RNSvrNiBIb1oJZim1vfnS9nW+4xg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rqm0D4d00iNMFVAvf+jjUqkH7d/9nWzJ4k9fh9DbGU6dy1Wb+MA0GHztIoZp6Vw+k
         EuMEFxOvsUvFN2S2LGv2Y2zXX8RR0shljO/Es+NKta4AVzRKfo2rLBKgFGa0UM6Dti
         K9jS+0qnAhGStlC37IrZqvrGnkiXaIoJ2tzo4dno=
Date:   Thu, 15 Jul 2021 19:57:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: coresight-tmc-etf.c:477:33: error: 'CORESIGHT_BARRIER_PKT_SIZE'
 undeclared (first use in this function)
Message-ID: <YPB3CrJtAdDmnVF8@kroah.com>
References: <CA+G9fYud=G=NhZdCVrHbadbv2xmeUUmW9vQr_YJqSGBWtNRdfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYud=G=NhZdCVrHbadbv2xmeUUmW9vQr_YJqSGBWtNRdfQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 11:22:52PM +0530, Naresh Kamboju wrote:
> Results from Linaro’s test farm.
> Regression detected on arm and arm64 due to the following patch
> with CONFIG_CORESIGHT=y enabled,
> 
> coresight: tmc-etf: Fix global-out-of-bounds in tmc_update_etf_buffer()
> commit 5fae8a946ac2df879caf3f79a193d4766d00239b upstream.
> 
> Build error:
> ------------
> drivers/hwtracing/coresight/coresight-tmc-etf.c: In function
> 'tmc_update_etf_buffer':
> drivers/hwtracing/coresight/coresight-tmc-etf.c:477:33: error:
> 'CORESIGHT_BARRIER_PKT_SIZE' undeclared (first use in this function)
>   477 |                 if (lost && i < CORESIGHT_BARRIER_PKT_SIZE) {
>       |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ref:
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1427834041#L384
> https://builds.tuxbuild.com/1vMA3olyV9E6Yr1Ix0LWLlXinkv/

I have no idea what tree/branch/queue this report is from :(
