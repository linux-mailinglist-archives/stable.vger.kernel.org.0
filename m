Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D74C316111
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 09:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBJIbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 03:31:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229898AbhBJIbZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 03:31:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0BC164E3E;
        Wed, 10 Feb 2021 08:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612945844;
        bh=7ZZCOTgRDxVsXVVtqxr74vdJ3JxIVr8+H5dXNUCt1s0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=moDmIzGiTnTEHWGPzwHW5MBy7n1aiaRv/wuKl6aomySyh6NCxJEN6BxL+tAja3RBf
         R1KPRJyMdh8zpazlWSgLOXoafcmQV9U8M7rVJ8A6cobZUIvMhiLIOKqVCss3KruLXh
         5bv/fYsdacrGuGkADXa/z3+DFL0Kw8j+w3jZzr3E=
Date:   Wed, 10 Feb 2021 09:30:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Davidson Francis <davidsondfgl@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/120] 5.10.15-rc1 review
Message-ID: <YCOZsmx4FUwW1zaj@kroah.com>
References: <20210208145818.395353822@linuxfoundation.org>
 <20210208202207.GA6005@theldus.codes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208202207.GA6005@theldus.codes>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 05:22:07PM -0300, Davidson Francis wrote:
> On Mon, Feb 08, 2021 at 03:59:47PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.15 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Compiled and boot tested for x86_64, no dmesg regressions found.
> 
> Tested-by: Davidson Francis <davidsondfgl@gmail.com>

Thanks for testing!

greg k-h
