Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7DE33036D
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 18:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhCGRrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 12:47:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230516AbhCGRrv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 12:47:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F1DC64DE4;
        Sun,  7 Mar 2021 17:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615139271;
        bh=X9ZICFTVUWzZQfgOZGaQJI/dmApG7ttu6AciY08zep0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1SRmA3+jxQYOwCBHYVUEThJu3rOodIigTtYlLfkvayoeU9efyqK32Q2ouN4ob/6ma
         cpczQ0Y+IfN+tLsoHICpvivms1z6O5wqli2agcNAq/5XjUlNw+bdE5rJndtkOwh8kH
         VduX95ojDO0if3XeFkMfFO5cw5FRYTYxGhJUFO6c=
Date:   Sun, 7 Mar 2021 18:47:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Chris.Paterson2@renesas.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/102] 5.10.21-rc1 review
Message-ID: <YEURxE02KkuUYDTN@kroah.com>
References: <20210305120903.276489876@linuxfoundation.org>
 <20210305221030.GB27686@amd>
 <20210307171824.GA22500@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210307171824.GA22500@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 07, 2021 at 06:18:25PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > This is the start of the stable review cycle for the 5.10.21 release.
> > > There are 102 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > Here situation is similar to 4.4
> > 
> > [   27.349919] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=CVE-2017-5715 RESULT=fail>
> > Received signal: <TESTCASE> TEST_CASE_ID=CVE-2017-5715 RESULT=fail
> > 
> > So I see some kind of failure, and this time I suspect real kernel
> > problem.
> > 
> > https://lava.ciplatform.org/scheduler/job/171825
> > 
> > 4.19 has similar problem:
> > 
> > https://lava.ciplatform.org/scheduler/job/171812
> > 
> > Again, Ccing Chris, but it looks like something is wrong there.
> 
> It went away after I reran the tests, and the old tests failed due to
> timeout. So it looks like server with qemu was overloaded or something
> like that. There are still failures, but they are "boards not
> available" kind, so not a kernel problem.
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for tracking this down and letting me know.

greg k-h
