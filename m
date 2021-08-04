Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A393DFB64
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 08:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbhHDGVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 02:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232618AbhHDGVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 02:21:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABA7560EC0;
        Wed,  4 Aug 2021 06:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628058079;
        bh=15mNVwPUZUnKdrckow9HJOnc4KPgvOEMNmgHx4cAbZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HeHmUCcLuz4CbK9g9lysNY0//odzKqGg6axDLC3d48mGI6Lef68GbJ+GNzGGCeVtu
         Y0tbjbd9hrPp6o967QS2QcFHUJSGjDvk43T8126eYVOCbfm2IcHrbNUmkLPxUM0ASF
         2tTgG3z8l+M76Z6wBBcn3YznuFAvs3oJFgrfJXm0=
Date:   Wed, 4 Aug 2021 08:21:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/67] 5.10.56-rc1 review
Message-ID: <YQox3CvsEz6kW9R+@kroah.com>
References: <20210802134339.023067817@linuxfoundation.org>
 <20210803192607.GA14540@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803192607.GA14540@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 03, 2021 at 09:26:07PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.56 release.
> > There are 67 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Not sure what went wrong, but 50 or so patches disappeared from the queue:
> 
> 48156f3dce81b215b9d6dd524ea34f7e5e029e6b (origin/queue/5.10) btrfs: fix lost inode on log replay after mix of fsync, rename and inode eviction
> 474a423936753742c112e265b5481dddd8c02f33 btrfs: fix race causing unnecessary inode logging during link and rename
> 2fb9fc485825505e31b634b68d4c05e193a224da Revert "drm/i915: Propagate errors on awaiting already signaled fences"
> b1c92988bfcb7aa46bdf8198541f305c9ff2df25 drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"
> 11fe69a17195cf58eff523f26f90de50660d0100 (tag: v5.10.55) Linux 5.10.55
> 984e93b8e20731f83e453dd056f8a3931b4a66e5 ipv6: ip6_finish_output2: set
> sk into newly allocated nskb

Look at commit e87bda470c72 ("move 5.10 patches back into -rc and queued
patches") as an example of what happened here.

The "queue" branches are odd and auto-generated and not all that smart
at times.  Stick to the -rc branches that I announce if you want to be
sure you are testing the proper thing.

thanks,

greg k-h
