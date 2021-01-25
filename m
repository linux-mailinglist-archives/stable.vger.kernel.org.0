Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84913032DC
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbhAZEjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:39:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729412AbhAYO0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 09:26:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D1002228A;
        Mon, 25 Jan 2021 14:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611584724;
        bh=Nh0hwKfWuuovNjFuNV1OJrKe8tPMi30Xe/6U1+0epYo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NBi82+G0eQXXvThxyrUpm5lWq+C2YFGflcx2mTBkGyAt3XAlKVGGXd1lGmvf/M+BR
         sqOUjvWVFbag5dIlZhKyHozBx/C9tBDr4Pvo65vzafbdCwItk2eql9vG878EvGCoiK
         mtF4crFhPNK9uFUNKNPrNQF9NqcE+Zafqm1tcrWE=
Date:   Mon, 25 Jan 2021 15:25:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH stable-5.10] drm/i915: Only enable DFP 4:4:4->4:2:0
 conversion when outputting YCbCr 4:4:4
Message-ID: <YA7U0gT/mqE76sBP@kroah.com>
References: <161149524220215@kroah.com>
 <20210125132711.27101-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210125132711.27101-1-ville.syrjala@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 03:27:11PM +0200, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> commit 1c4995b0a576d24bb7ead991fb037c8b47ab6e32 upstream.
> 
> Let's not enable the 4:4:4->4:2:0 conversion bit in the DFP unless we're
> actually outputting YCbCr 4:4:4. It would appear some protocol
> converters blindy consult this bit even when the source is outputting
> RGB, resulting in a visual mess.
> 
> Cc: <stable@vger.kernel.org> # 0e634efd858e: drm/i915: s/intel_dp_sink_dpms/intel_dp_set_power/
> Cc: stable@vger.kernel.org
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2914
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20210111164111.13302-1-ville.syrjala@linux.intel.com
> Fixes: 181567aa9f0d ("drm/i915: Do YCbCr 444->420 conversion via DP protocol converters")
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
> (cherry picked from commit 3170a21f7059c4660c469f59bf529f372a57da5f)
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20210118154355.24453-1-ville.syrjala@linux.intel.com
> (cherry picked from commit 1c4995b0a576d24bb7ead991fb037c8b47ab6e32)
> ---
> Note the extra depdendency on commit 0e634efd858e
> ("drm/i915: s/intel_dp_sink_dpms/intel_dp_set_power/").

Thanks for this, now queued up.

greg k-h
