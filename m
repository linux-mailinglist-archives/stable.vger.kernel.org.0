Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF22443F8F
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 10:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhKCJtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 05:49:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhKCJtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 05:49:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9A916113B;
        Wed,  3 Nov 2021 09:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635932823;
        bh=PImn9tJjEorTxkfmh5n4/OzBaONsJv8WVMEmOHSHzNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zOJ9Tw6xgKJz0S5K2me8JjFXVAjwl1HaY5I8TxLohN3V7Z7MB2nvaF0Al4Ufvx3u/
         Hbo/wMe3duMlhDvhkpAB0RCPwEkdoOT+2blyEzX4YH0ANt6SDeTA9Pp1baOMS//EXK
         C/u4OOY7QZCcYNYCHlA/KITf10kcrjXGd5EEiVo8=
Date:   Wed, 3 Nov 2021 10:46:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Jos=E9?= Roberto de Souza <jose.souza@intel.com>
Cc:     stable@vger.kernel.org, jani.nikula@intel.com,
        Yakui Zhao <yakui.zhao@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>
Subject: Re: [PATCH] drm/i915: Remove memory frequency calculation
Message-ID: <YYJaklqD9XAj16Lw@kroah.com>
References: <1635599150237240@kroah.com>
 <20211101183230.89060-1-jose.souza@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211101183230.89060-1-jose.souza@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 01, 2021 at 11:32:30AM -0700, José Roberto de Souza wrote:
> This memory frequency calculated is only used to check if it is zero,
> what is not useful as it will never actually be zero.
> 
> Also the calculation is wrong, we should be checking other bit to
> select the appropriate frequency multiplier while this code is stuck
> with a fixed multiplier.
> 
> So here dropping it as whole.
> 
> v2:
> - Also remove memory frequency calculation for gen9 LP platforms
> 
> Cc: <stable@vger.kernel.org> # 5.14-stable
> Cc: Yakui Zhao <yakui.zhao@intel.com>
> Cc: Matt Roper <matthew.d.roper@intel.com>
> Fixes: 5d0c938ec9cc ("drm/i915/gen11+: Only load DRAM information from pcode")
> Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
> Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20211013010046.91858-1-jose.souza@intel.com
> (cherry picked from commit 83f52364b15265aec47d07e02b0fbf4093ab8554)

There is no such commit in Linus's tree.

What commit is this that is being backported?

confused,

greg k-h
