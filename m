Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F3C1C0C61
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 04:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgEACz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 22:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgEACz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 22:55:29 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF48A2186A;
        Fri,  1 May 2020 02:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588301729;
        bh=WU43e9vRsWcB16VKIzlY/JCt6jGPT0q84MHrfdH5oag=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:
         In-Reply-To:References:From;
        b=0kXGwJoUL4M2gfpNoQMWl0Rv6fsP9O6RYdRbo5dCNECRswIMPEJu4wg3N/BISrs7J
         6Vh3/R3oPdPxfvCgCYGEEKr476vgF60N6euNhmc/VhkzAnzm/y4YlgS8tMe1ElL8Ve
         H1GVMaQHRWaYdnEfLHkPoY9UOqlkSk8SfZ6gZfU4=
Date:   Fri, 01 May 2020 02:55:28 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sean Paul <sean@poorly.run>
To:     Sean Paul <seanpaul@chromium.org>
To:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Cc:     juston.li@intel.com, ramalingam.c@intel.com
Cc:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Ramalingam C <ramalingam.c@intel.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Sean Paul <seanpaul@chromium.org>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc:     Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v6 02/16] drm/i915: Clear the repeater bit on HDCP disable
In-Reply-To: <20200429195502.39919-3-sean@poorly.run>
References: <20200429195502.39919-3-sean@poorly.run>
Message-Id: <20200501025528.BF48A2186A@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: ee5e5e7a5e0f ("drm/i915: Add HDCP framework + base implementation").

The bot has tested the following trees: v5.6.7, v5.4.35, v4.19.118.

v5.6.7: Build failed! Errors:
    drivers/gpu/drm/i915/display/intel_hdcp.c:780:2: error: implicit declaration of function ‘intel_de_write’; did you mean ‘intel_sbi_write’? [-Werror=implicit-function-declaration]
    drivers/gpu/drm/i915/display/intel_hdcp.c:781:10: error: implicit declaration of function ‘intel_de_read’; did you mean ‘intel_sbi_read’? [-Werror=implicit-function-declaration]

v5.4.35: Failed to apply! Possible dependencies:
    692059318c0f ("drm/i915/hdcp: Enable HDCP 1.4 and 2.2 on Gen12+")

v4.19.118: Failed to apply! Possible dependencies:
    0e39037b3165 ("drm/i915: Cache the error string")
    16e4dd0342a8 ("drm/i915: Markup paired operations on wakerefs")
    39e2f501c1b4 ("drm/i915: Split struct intel_context definition to its own header")
    408bd9178666 ("drm/i915: extract intel_hdcp.h from intel_drv.h")
    52c0fdb25c7c ("drm/i915: Replace global breadcrumbs with per-context interrupt tracking")
    538ef96b9dae ("drm/i915/gem: Track the rpm wakerefs")
    692059318c0f ("drm/i915/hdcp: Enable HDCP 1.4 and 2.2 on Gen12+")
    6b048706f407 ("drm/i915: Forcibly flush unwanted requests in drop-caches")
    87f1ef225242 ("drm/i915: Record the sseu configuration per-context & engine")
    95fd94a645f7 ("drm/i915: avoid rebuilding i915_gpu_error.o on version string updates")
    c0a6aa7ec2c3 ("drm/i915: Show actual alongside requested frequency in debugfs/i915_rps_boost_info")
    c2400ec3b6d1 ("drm/i915: add Makefile magic for testing headers are self-contained")
    c44301fce614 ("drm/i915: Allow control of PSR at runtime through debugfs, v6")
    e0516e83640e ("drm/i915: Move sandybride pcode access to intel_sideband.c")
    e1ef734eaec5 ("drm/i915: make intel_frontbuffer.h self-contained")
    e6154e4cb8b0 ("drm/i915: Skip the ERR_PTR error state")
    eb8d0f5af4ec ("drm/i915: Remove GPU reset dependence on struct_mutex")
    fb6f0b64e455 ("drm/i915: Prevent machine hang from Broxton's vtd w/a and error capture")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
