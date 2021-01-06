Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8D72EC2EC
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 19:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbhAFSEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 13:04:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbhAFSEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 13:04:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66067216C4;
        Wed,  6 Jan 2021 18:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609956200;
        bh=YEmjCkuvqJwXAs/CFcpsZIBub1wETbB3Xxi/z8ZXSgA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SyCAuPdeO3AYDtkKYfMF+9KgP/SNKTYMn8Vfi0SFaI7MEL+khoxLTMu8JErs7SHIP
         wLezrLEBCn2+b0fkeRfYgWm3Ezxrc3yM9+PRHp7ditsSCVJJVSyJCmHL22YTepE8l5
         s7TmF2/wFDK90D+Pc/t9/CVunhkKpmTgBFUzQ1n8=
Date:   Wed, 6 Jan 2021 19:04:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Imre Deak <imre.deak@intel.com>
Cc:     stable@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>
Subject: Re: v5.10 stable backport request
Message-ID: <X/X7umSYEeKCZ0Dw@kroah.com>
References: <20210106175301.GB202232@ideak-desk.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106175301.GB202232@ideak-desk.fi.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 06, 2021 at 07:53:01PM +0200, Imre Deak wrote:
> Stable team, please backport the upstream commit
> 
> 8f329967d596 ("drm/i915/tgl: Fix Combo PHY DPLL fractional divider for 38.4MHz ref clock")
> 
> to the v5.10 stable kernel.

I see no such commit id in Linus's kernel :(
