Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 665CA144C78
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 08:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgAVHaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 02:30:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgAVHaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 02:30:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E67F12253D;
        Wed, 22 Jan 2020 07:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579678219;
        bh=mdjvY/D3t5M2VuvoFixNzVNfAg5eB6e8yImCam3pR/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xR0nyhGxvcIUhFOVdxfCwDtt+01pFwo7ttopRCjA6uj7yjQj1ymGNAABODFFdL/76
         OUZJeCyOrARoguo6MQXfyFxiVDX/m3aXtLNjwuAwRPWucGe9xqrc19z9/N0fQxmzUc
         vWsowea0AWVFuVWKiH33PmNTdyuC7PXDt5RlH6d0=
Date:   Wed, 22 Jan 2020 08:30:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sushma Kalakota <sushmax.kalakota@intel.com>
Cc:     stable@vger.kernel.org,
        Jonathan Derrick <jonathan.derrick@intel.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [BACKPORT v4.19 0/3] Fixes for nv50/gf100 under VMD
Message-ID: <20200122073016.GA2072535@kroah.com>
References: <20200121202828.16590-1-sushmax.kalakota@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121202828.16590-1-sushmax.kalakota@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 21, 2020 at 01:28:25PM -0700, Sushma Kalakota wrote:
> This fix is a case where a nv50 or gf100 graphics card is used on a VMD
> Domain (or other memory restricted domain) that results in a
> null-pointer dereference.
> 
> One of the original fixes was already backported:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.19.y&id=5744fd7fa1d164a8fcbb1a65def927cab84c9a68
> 
> Sushma Kalakota (3):
>   drm/nouveau/bar/nv50: check bar1 vmm return value
>   drm/nouveau/bar/gf100: ensure BAR is mapped
>   drm/nouveau/mmu: qualify vmm during dtor
> 
>  drivers/gpu/drm/nouveau/nvkm/subdev/bar/gf100.c | 2 ++
>  drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c  | 2 ++
>  drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c   | 2 +-
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 

All now queued up, thanks!

greg k-h
