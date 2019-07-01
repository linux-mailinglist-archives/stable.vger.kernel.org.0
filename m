Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 761E75BF75
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 17:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbfGAPPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 11:15:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730195AbfGAPOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 11:14:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C966020659;
        Mon,  1 Jul 2019 15:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561994079;
        bh=VOzLJ/8gLkrOuthiogtLiz6ET1iM2O7F1FQrtYIaPjU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p6Mz7zxGRZt+hfP9OgXZ5Va1H9+2bV4umh+0bXtEfRPqoY8OHZ6DiVuAQl9/d/Esj
         3k38yoy6JV0E5HHBBrdE0zAblyXrdTvp6Wew1Szy+hiH/NeFwK+rW82lwq237YPQIr
         Ek3SYQCv4iw0CzNJfk+vPgk+J3ZP6T97bJJqhghM=
Date:   Mon, 1 Jul 2019 17:14:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jian-Hong Pan <jian-hong@endlessm.com>
Cc:     stable@vger.kernel.org, Imre Deak <imre.deak@intel.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Abhay Kumar <abhay.kumar@intel.com>, tiwai@suse.de,
        hui.wang@canonical.com, linux@endlessm.com
Subject: Re: [PATCH stable-5.1 v2 0/4] drm/i915: Prevent screen from
 flickering when the CDCLK changes
Message-ID: <20190701151436.GB28557@kroah.com>
References: <20190620141949.GD9832@kroah.com>
 <20190621100716.8032-1-jian-hong@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621100716.8032-1-jian-hong@endlessm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 21, 2019 at 06:07:12PM +0800, Jian-Hong Pan wrote:
> Hi,
> 
> To make it more clearly, I re-send this patch series again.
> 
> To fix "the audio playback does not work anymore after suspend & resume"
> on ASUS E406MA, we need rediffed commit "drm/i915: Force 2*96 MHz cdclk
> on glk/cnl when audio power is enabled".  However, after apply the
> commit "drm/i915: Force 2*96 MHz cdclk on glk/cnl when audio power is
> enabled", it induces the screen to flicker when the CDCLK changes on the
> laptop. [1]
> 
> So, we need these commits to prevent that:
> 
> commit 48d9f87ddd21 drm/i915: Save the old CDCLK atomic state
> commit 2b21dfbeee72 drm/i915: Remove redundant store of logical CDCLK state
> commit 59f9e9cab3a1 drm/i915: Skip modeset for cdclk changes if possible
> 
> This issue is also reconfirmed on the list. [2][3]
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=203623
> [2] https://bugs.freedesktop.org/show_bug.cgi?id=110916
> [3] https://www.spinics.net/lists/stable/msg310910.html

Now queued up, thanks.

greg k-h
