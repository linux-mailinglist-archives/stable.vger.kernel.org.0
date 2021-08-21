Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3673F3A71
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 13:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbhHULts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Aug 2021 07:49:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhHULtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Aug 2021 07:49:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5264761183;
        Sat, 21 Aug 2021 11:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629546547;
        bh=pCyemwyr5YxUh8+nz3TfpkhBT3ai6sFzgMN7v6TQPOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wOsVAvtOeVvUD2bPuSvxlWZHmDEbbsyB6GKL54IEvr3x4m1+Y3AS/hGewia7sd83z
         eUY3uorQWNEgx4OlMTg6ochAUxwIXV9u9RpGoYhDQRZr1BosIFq5Dqp3GqmQx/cxxO
         xOSN6lYyWFLnR/pRGMdrTR0IRI7DKlWMdLZtvmvw=
Date:   Sat, 21 Aug 2021 13:49:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fei Li <fei1.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        yu1.wang@intel.com, shuox.liu@gmail.com
Subject: Re: [PATCH 0/3] Introduce some interfaces for ACRN hypervisor HSM
Message-ID: <YSDoL7Tu6yL0ldhG@kroah.com>
References: <20210820060306.10682-1-fei1.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820060306.10682-1-fei1.li@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 02:03:03PM +0800, Fei Li wrote:
> Add some new interfaces for ACRN hypervisor HSM driver:
>   - MMIO device passthrough
>   - virtual device creating/destroying
>   - platform information fetching from the hypervisor
> 
> Shuo Liu (3):
>   virt: acrn: Introduce interfaces for MMIO device passthrough
>   virt: acrn: Introduce interfaces for virtual device
>     creating/destroying
>   virt: acrn: Introduce interface to fetch platform info from the
>     hypervisor
> 
>  drivers/virt/acrn/hsm.c       | 102 ++++++++++++++++++++++++++++++
>  drivers/virt/acrn/hypercall.h |  64 +++++++++++++++++++
>  include/uapi/linux/acrn.h     | 114 ++++++++++++++++++++++++++++++++++
>  3 files changed, 280 insertions(+)
> 
> 
> base-commit: 7c60610d476766e128cc4284bb6349732cbd6606
> -- 
> 2.25.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
