Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F42D3CAC3A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243491AbhGOTbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245070AbhGOTX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:23:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20E75613E0;
        Thu, 15 Jul 2021 19:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376862;
        bh=WvuKGYn2z8mdibJOy1+/vqOwVPVooZvc93CaNuyVYFs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N+MotIG5KGE1cIsGcd8cdAx/RuS+u+9TBiLF8UvSQV0JFXz7sDWPDARNF0e550mtb
         kq0ODfl1EvXRP3UQiV86tgqWGLubsdCUm0Fs9QBUddB5oHyRdR9u27syNpfCqZ4JRM
         Sq+p6RP0qHflEA98lt0G6PyPiNH+SUGw4V6O8ULI=
Date:   Thu, 15 Jul 2021 20:55:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: coresight-tmc-etf.c:477:33: error: 'CORESIGHT_BARRIER_PKT_SIZE'
 undeclared (first use in this function)
Message-ID: <YPCEktj5sLa/zMuw@kroah.com>
References: <CA+G9fYud=G=NhZdCVrHbadbv2xmeUUmW9vQr_YJqSGBWtNRdfQ@mail.gmail.com>
 <YPB3CrJtAdDmnVF8@kroah.com>
 <CA+G9fYuGv1XS9bQdjpT3ONdFjvc2G-etJX+VbV-ZKfePHtt5NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuGv1XS9bQdjpT3ONdFjvc2G-etJX+VbV-ZKfePHtt5NA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 11:59:58PM +0530, Naresh Kamboju wrote:
> On Thu, 15 Jul 2021 at 23:27, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Jul 15, 2021 at 11:22:52PM +0530, Naresh Kamboju wrote:
> > > Results from Linaro’s test farm.
> > > Regression detected on arm and arm64 due to the following patch
> > > with CONFIG_CORESIGHT=y enabled,
> > >
> > > coresight: tmc-etf: Fix global-out-of-bounds in tmc_update_etf_buffer()
> > > commit 5fae8a946ac2df879caf3f79a193d4766d00239b upstream.
> > >
> > > Build error:
> > > ------------
> > > drivers/hwtracing/coresight/coresight-tmc-etf.c: In function
> > > 'tmc_update_etf_buffer':
> > > drivers/hwtracing/coresight/coresight-tmc-etf.c:477:33: error:
> > > 'CORESIGHT_BARRIER_PKT_SIZE' undeclared (first use in this function)
> > >   477 |                 if (lost && i < CORESIGHT_BARRIER_PKT_SIZE) {
> > >       |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > > ref:
> > > https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1427834041#L384
> > > https://builds.tuxbuild.com/1vMA3olyV9E6Yr1Ix0LWLlXinkv/
> >
> > I have no idea what tree/branch/queue this report is from :(
> 
> Sorry,
> stable-rc 4.14.240-rc1.

Thanks, now fixed by dropping the offending patch.

greg k-h
