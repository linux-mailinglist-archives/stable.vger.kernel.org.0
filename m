Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA03320A163
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 16:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405406AbgFYO4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 10:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405638AbgFYOyB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 10:54:01 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6837B20857;
        Thu, 25 Jun 2020 14:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593096840;
        bh=TW+Rzv/5bj7ZqH/8wlBjBiEZRvkqyHOy+vOyeLWDsfE=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:
         In-Reply-To:References:From;
        b=dKNcYZMcBa6+wcCJY++xw+Xq3CWJtPLEeQdeHaA4K15Xv1dIfGxkZpKZvXRktbk2R
         EnqfavdqWgq8Ic9lSfVxTNRvY+9yHhyWy1K8TIA/WWa7x/fuxH/ToB1XTRr/31Gnkp
         7MQKU3MH/Y6XZscKRk1ZkjVRex7h3APGZzxYiqb4=
Date:   Thu, 25 Jun 2020 14:53:59 +0000
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
Subject: Re: [PATCH v7 01/17] drm/i915: Fix sha_text population code
In-Reply-To: <20200623155907.22961-2-sean@poorly.run>
References: <20200623155907.22961-2-sean@poorly.run>
Message-Id: <20200625145400.6837B20857@mail.kernel.org>
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
    65833c463886f ("drm/i915/hdcp: conversion to struct drm_device based logging macros.")
    667944ad77f19 ("drm/i915/hdcp: use intel_de_*() functions for register access")
    692059318c0fc ("drm/i915/hdcp: Enable HDCP 1.4 and 2.2 on Gen12+")

v4.19.129: Failed to apply! Possible dependencies:
    04707f9716363 ("drm/i915: Initialize HDCP2.2")
    09d56393c1d8d ("drm/i915: hdcp1.4 CP_IRQ handling and SW encryption tracking")
    2f80d7bd8d93c ("drm/i915: drop all drmP.h includes")
    33b7f3ee6e008 ("drm/i915: Add CRTC output format YCBCR 4:2:0")
    340a44bef2342 ("drm/i915/icl: program MG_DP_MODE")
    342ac601df642 ("drm/i915: hdcp_check_link only on CP_IRQ")
    47658556da857 ("drm/i915/dp: Do not grab crtc modeset lock in intel_dp_detect()")
    667944ad77f19 ("drm/i915/hdcp: use intel_de_*() functions for register access")
    668b6c176c33f ("drm/i915: Add YCBCR 4:2:0/4:4:4 support for LSPCON")
    7b610f1fbed2a ("drm/i915/dp: Add DSC params and DSC config to intel_crtc_state")
    9055aac76589c ("drm/i915: MEI interface implementation")
    9844bc87cb7a5 ("drm/i915/dp: Fix duplication of DEVICE_SERVICE_IRQ handling")
    bdc93fe0eb82f ("drm/i915/debugfs: hdcp capability of a sink")
    cbfa8ac835cb4 ("drm/i915/dp: Kill intel_dp->detect_done flag")
    d3dacc70797b8 ("drm/i915: wrapping all hdcp var into intel_hdcp")
    d5acd97f55711 ("drm/i915/dp: Use a local variable for intel_encoder *")
    d78aa650670d2 ("drm: Add drm/drm_util.h header file")
    de25eb7f3075f ("drm/i915: introduce dp_to_i915() helper")
    f106d1005ac72 ("drm/i915: Pullout the bksv read and validation")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
