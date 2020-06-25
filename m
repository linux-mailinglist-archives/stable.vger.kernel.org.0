Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CB520A153
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 16:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405552AbgFYOx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 10:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405309AbgFYOx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 10:53:58 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49F55207BB;
        Thu, 25 Jun 2020 14:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593096837;
        bh=U7+SQDks5lFwRHnh9XsMxnE1QJGWKUKs6L/mBeXZQmA=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:
         In-Reply-To:References:From;
        b=XgInBuUQ4NsdqO64ZlmT5nwhs4NuQxilFoh4SmDvYLxPmM+/XZLmrfhJaJP/q2zd4
         7Gk09xIZauIrRr9AYz63cFZxe9LkP45ucwOBmPms0U/4T8L+ajbKA12pL3D5k+aC+X
         lMVhg1M4Tn9pZZJ8l1HZdLyRp15lhZeWJF2nt/qU=
Date:   Thu, 25 Jun 2020 14:53:56 +0000
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
Subject: Re: [PATCH v7 02/17] drm/i915: Clear the repeater bit on HDCP disable
In-Reply-To: <20200623155907.22961-3-sean@poorly.run>
References: <20200623155907.22961-3-sean@poorly.run>
Message-Id: <20200625145357.49F55207BB@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: ee5e5e7a5e0f ("drm/i915: Add HDCP framework + base implementation").

The bot has tested the following trees: v5.7.5, v5.4.48, v4.19.129.

v5.7.5: Build OK!
v5.4.48: Failed to apply! Possible dependencies:
    692059318c0fc ("drm/i915/hdcp: Enable HDCP 1.4 and 2.2 on Gen12+")

v4.19.129: Failed to apply! Possible dependencies:
    0e39037b31655 ("drm/i915: Cache the error string")
    16e4dd0342a80 ("drm/i915: Markup paired operations on wakerefs")
    39e2f501c1b43 ("drm/i915: Split struct intel_context definition to its own header")
    408bd91786665 ("drm/i915: extract intel_hdcp.h from intel_drv.h")
    52c0fdb25c7c9 ("drm/i915: Replace global breadcrumbs with per-context interrupt tracking")
    538ef96b9dae7 ("drm/i915/gem: Track the rpm wakerefs")
    692059318c0fc ("drm/i915/hdcp: Enable HDCP 1.4 and 2.2 on Gen12+")
    6b048706f407f ("drm/i915: Forcibly flush unwanted requests in drop-caches")
    87f1ef225242d ("drm/i915: Record the sseu configuration per-context & engine")
    95fd94a645f75 ("drm/i915: avoid rebuilding i915_gpu_error.o on version string updates")
    c0a6aa7ec2c36 ("drm/i915: Show actual alongside requested frequency in debugfs/i915_rps_boost_info")
    c2400ec3b6d15 ("drm/i915: add Makefile magic for testing headers are self-contained")
    c44301fce6146 ("drm/i915: Allow control of PSR at runtime through debugfs, v6")
    e0516e83640e1 ("drm/i915: Move sandybride pcode access to intel_sideband.c")
    e1ef734eaec54 ("drm/i915: make intel_frontbuffer.h self-contained")
    e6154e4cb8b0d ("drm/i915: Skip the ERR_PTR error state")
    eb8d0f5af4ec2 ("drm/i915: Remove GPU reset dependence on struct_mutex")
    fb6f0b64e455b ("drm/i915: Prevent machine hang from Broxton's vtd w/a and error capture")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
