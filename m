Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9C3478EA9
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 15:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237630AbhLQO60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 09:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234609AbhLQO6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 09:58:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FBCC061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 06:58:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5835E621A5
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 14:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31462C36AE8;
        Fri, 17 Dec 2021 14:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639753104;
        bh=mmIjp1mG0rCSX/vtG98tmKX7hzFEGSSjLRl1+4uEctA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VNF4HII/KtXVW9WhwVUQdUHDJbV8GVX7XOyScsXVrfM4ZhX0hKlWLH/5N9Qw2ZURN
         P9YL1s21ch92BwiiIZYFZ367jk4xDvw2hm/RPuGZKY1Cy9ByMBMzNsi/b/N/Lug5DF
         rrynSZ6uH7mLF2lsd+z5ixyrb3U3Ld3S6B5KmKTs=
Date:   Fri, 17 Dec 2021 15:58:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     rodrigo.vivi@intel.com, stable@vger.kernel.org,
        stanislav.lisovskiy@intel.com
Subject: Re: FAILED: patch "[PATCH] drm/i915/hdmi: Turn DP++ TMDS output
 buffers back on in" failed to apply to 5.15-stable tree
Message-ID: <YbyljtkEByBin1Yz@kroah.com>
References: <1637668322209209@kroah.com>
 <YbpW3h6JoZBra+aM@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YbpW3h6JoZBra+aM@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 10:58:06PM +0200, Ville Syrjälä wrote:
> On Tue, Nov 23, 2021 at 12:52:02PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Looks like cherry-picking
> commit 7ceb751b6159 ("drm/i915/hdmi: convert intel_hdmi_to_dev to intel_hdmi_to_i915")
> should solve the conflict with this one.

That worked, thanks!

greg k-h
