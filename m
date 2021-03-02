Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CB232B273
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343831AbhCCAx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1835360AbhCBTDh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 14:03:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CD2264F0A;
        Tue,  2 Mar 2021 19:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614711774;
        bh=f5vC2O2U/SsBgPYcbbJQVVH23nHk8egizekeNnBm79c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TBLDZscAs6DOos3gVH4pl7v48GTgnYz0wFTmzv5FmJ+yvKFDazS00mA6mh3ZZHMqP
         DBPbclF0LLC8sh5SShx93pY0m/XpgYSwPP5reQIcIgE8JPp2GXfdbuI+OCo0S7Niqi
         jwRHSIOmNTdO7rlfUNuzBbhFI6ZR1zX9ZlpH/ttg=
Date:   Tue, 2 Mar 2021 20:02:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/93] 4.4.259-rc1 review
Message-ID: <YD6L3IdZWKTafkFr@kroah.com>
References: <20210301161006.881950696@linuxfoundation.org>
 <99109388-1f32-6355-ccd2-08d3f268effa@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99109388-1f32-6355-ccd2-08d3f268effa@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 10:40:35AM -0800, Guenter Roeck wrote:
> On 3/1/21 8:12 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.259 release.
> > There are 93 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 03 Mar 2021 16:09:49 +0000.
> > Anything received after that time might be too late.
> > 
> 
> 
> Building nios2:allnoconfig ... failed
> --------------
> Error log:
> arch/nios2/kernel/sys_nios2.c: In function 'sys_cacheflush':
> arch/nios2/kernel/sys_nios2.c:38:6: error: implicit declaration of function 'mmap_read_lock_killable'; did you mean 'mutex_lock_killable'?
> 
> 
> This problem affects all nios2 builds in v4.4.y ... v5.4.y.

Ugh, thanks, will go drop that patch from all of those queues now,
thanks.

greg k-h
