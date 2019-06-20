Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E84344D037
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 16:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfFTOTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 10:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbfFTOTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 10:19:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D32BE20679;
        Thu, 20 Jun 2019 14:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561040392;
        bh=UIQFS+8RjXlVSGPc93ftsJbN8rEqMUCJfQFD4aLKRZo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oQYk7NdIYXZsDFjMlloCeOVFeFcAB0scplukJJakEdlawyu/peFiXm7vhVLFqajHH
         pGNNwwbuoM6Sv3sZH0l8Y3M0cXOdVHo+I1eECxmFlVTR4eFg0bUhg3jG+6w95NmQc9
         qt+904t5jc3jO4J0sL/cLQQo7zbMPdp/dc4zGPsk=
Date:   Thu, 20 Jun 2019 16:19:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jian-Hong Pan <jian-hong@endlessm.com>
Cc:     stable@vger.kernel.org, linux@endlessm.com, hui.wang@canonical.com,
        Imre Deak <imre.deak@intel.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>
Subject: Re: [PATCH stable-5.1 1/3] drm/i915: Save the old CDCLK atomic state
Message-ID: <20190620141949.GD9832@kroah.com>
References: <20190603100938.5414-1-jian-hong@endlessm.com>
 <20190610060141.5377-2-jian-hong@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190610060141.5377-2-jian-hong@endlessm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 02:01:41PM +0800, Jian-Hong Pan wrote:
> From: Imre Deak <imre.deak@intel.com>
> 
> commit 48d9f87ddd2108663fd866b254e05d422243cc56 upstream.
> 
> The old state will be needed by an upcoming patch to determine if the
> commit increases or decreases CDCLK, so move the old state to the atomic
> state (while keeping the new one in dev_priv). cdclk.logical and
> cdclk.actual in the atomic state isn't used atm anywhere after the
> atomic check phase, so this should be safe.
> 
> v2:
> - Use swap() instead of opencoding it. (Ville)
> 
> Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20190320135439.12201-2-imre.deak@intel.com
> Cc: <stable@vger.kernel.org> # 5.1.x
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> ---
>  drivers/gpu/drm/i915/intel_cdclk.c   | 20 ++++++++++++++++++++
>  drivers/gpu/drm/i915/intel_display.c |  4 ++--
>  drivers/gpu/drm/i915/intel_drv.h     |  1 +
>  3 files changed, 23 insertions(+), 2 deletions(-)

Does not apply against the latest 5.1.y tree.  Can you rebase this
series and resend please?

thanks,

greg k-h
