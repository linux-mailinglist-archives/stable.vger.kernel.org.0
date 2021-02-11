Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6BE318D39
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 15:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhBKOVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 09:21:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:42506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231977AbhBKOTL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 09:19:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A0C364EAA;
        Thu, 11 Feb 2021 14:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613053109;
        bh=80VxV4qEjUjaTOS07HnYGPxsGNaYJYSKYiOb+g4t7k0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TDRACuUUvJu+s88BF2pJD1cqhXSDSGoFKD58Zd0QG5V9WuBdlTLBy5xDQXb6pnY5x
         p2AsGcQQQ6NQzRynpEroj5i38nafgQnsipZrw0GF8w39fE1IoMJaR6MvliHZpR5BmX
         MoEgF2LtvrOJbou+lZ78ROSw2gEsWNdZ11YmGqQs=
Date:   Thu, 11 Feb 2021 15:18:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Imre Deak <imre.deak@intel.com>
Subject: Re: [PATCH stable-5.10 2/2] drm/i915: Skip vswing programming for TBT
Message-ID: <YCU8szZLx8HtinOV@kroah.com>
References: <16127808794868@kroah.com>
 <20210208175341.8695-1-ville.syrjala@linux.intel.com>
 <20210208175341.8695-2-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210208175341.8695-2-ville.syrjala@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 07:53:41PM +0200, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> commit eaf5bfe37db871031232d2bf2535b6ca92afbad8 upstream.
> 
> In thunderbolt mode the PHY is owned by the thunderbolt controller.
> We are not supposed to touch it. So skip the vswing programming
> as well (we already skipped the other steps not applicable to TBT).
> 
> Touching this stuff could supposedly interfere with the PHY
> programming done by the thunderbolt controller.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20210128155948.13678-1-ville.syrjala@linux.intel.com
> Reviewed-by: Imre Deak <imre.deak@intel.com>
> (cherry picked from commit f8c6b615b921d8a1bcd74870f9105e62b0bceff3)
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> (cherry picked from commit eaf5bfe37db871031232d2bf2535b6ca92afbad8)
> ---
>  drivers/gpu/drm/i915/display/intel_ddi.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Both n ow queued up,t hanks.

greg k-h
