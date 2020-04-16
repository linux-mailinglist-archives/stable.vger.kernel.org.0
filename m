Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582F21AB5AE
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 03:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732823AbgDPB6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 21:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730838AbgDPB6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 21:58:11 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FB92206D9;
        Thu, 16 Apr 2020 01:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587002290;
        bh=n9v2t+jS50Mdp8hCrcY2vT5+ZulrOPyL/XWFAzODD+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MI4vW6YAsQL6UcxVnItB3Da9rgYMiapV2R57hcbsYrvPpFVcXaS4wAkjrFeBYmxOX
         1YzuKppF/ZsuH8qaDQA3jD7Ic7qIeQkiybrV2hAfIBOl0P6K+deh7Kwj0FXwsJKCbb
         3t/nbwQtHPYNj6y8GPEp2eFhsL9tgXFVkT5tFass=
Date:   Wed, 15 Apr 2020 21:58:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     duwe@lst.de, Laurent.pinchart@ideasonboard.com,
        a.hajda@samsung.com, daniel.vetter@ffwll.ch,
        jernej.skrabec@siol.net, jonas@kwiboo.se, narmstrong@baylibre.com,
        stable@vger.kernel.org, treding@nvidia.com, tzimmermann@suse.de
Subject: Re: FAILED: patch "[PATCH] drm/bridge: analogix-anx78xx: Fix
 drm_dp_link helper removal" failed to apply to 5.5-stable tree
Message-ID: <20200416015809.GW1068@sasha-vm>
References: <158695023362255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158695023362255@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:30:33PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 3e138a63d6674a4567a018a31e467567c40b14d5 Mon Sep 17 00:00:00 2001
>From: Torsten Duwe <duwe@lst.de>
>Date: Tue, 18 Feb 2020 16:57:44 +0100
>Subject: [PATCH] drm/bridge: analogix-anx78xx: Fix drm_dp_link helper removal
>
>drm_dp_link_rate_to_bw_code and ...bw_code_to_link_rate simply divide by
>and multiply with 27000, respectively. Avoid an overflow in the u8 dpcd[0]
>and the multiply+divide alltogether.
>
>Signed-off-by: Torsten Duwe <duwe@lst.de>
>Fixes: ff1e8fb68ea0 ("drm/bridge: analogix-anx78xx: Avoid drm_dp_link helpers")
>Cc: Thierry Reding <treding@nvidia.com>
>Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
>Cc: Andrzej Hajda <a.hajda@samsung.com>
>Cc: Neil Armstrong <narmstrong@baylibre.com>
>Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
>Cc: Jonas Karlman <jonas@kwiboo.se>
>Cc: Jernej Skrabec <jernej.skrabec@siol.net>
>Cc: <stable@vger.kernel.org> # v5.5+
>Reviewed-by: Thierry Reding <treding@nvidia.com>
>Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>Link: https://patchwork.freedesktop.org/patch/msgid/20200218155744.9675368BE1@verein.lst.de

Different filename in 5.4, fixed and queued up.

-- 
Thanks,
Sasha
