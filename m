Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2DD31610D
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 09:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhBJIbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 03:31:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhBJIaz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 03:30:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D78B064E42;
        Wed, 10 Feb 2021 08:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612945814;
        bh=39O3oCdme31u0psNcPGZsqQrogDwAmd5wyIKdbrQ3xg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2sSKv9atWJupN9idT1tMFxSz2eEprJEeb/hDGe7FTRRLSjSEzQVlORWjZyCr59D2N
         /qeaWEaDg1dJcji6burFqssXB3Oij2JtQ6FEBTRbIU9aT/gruu48pbB2phT3MBq11Z
         KKB6rAbb9fmFsEcoWtRYHRrh0DZIS4oS4lx/cHbM=
Date:   Wed, 10 Feb 2021 09:30:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ross Schmidt <ross.schm.dev@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/120] 5.10.15-rc1 review
Message-ID: <YCOZk/L8gvEjV8qm@kroah.com>
References: <20210208145818.395353822@linuxfoundation.org>
 <20210210012816.GC5618@book>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210012816.GC5618@book>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 07:28:16PM -0600, Ross Schmidt wrote:
> On Mon, Feb 08, 2021 at 03:59:47PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.15 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> 
> Compiled and booted with no regressions on x86_64.
> 
> Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>

Thanks for testing and letting me know.

greg k-h
