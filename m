Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E4A253076
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbgHZNxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730415AbgHZNxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:53:49 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C173722B49;
        Wed, 26 Aug 2020 13:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598450028;
        bh=eZsJDL9SLroB/bPNsmyrnqiBAWweo2HTBUEPozHxy3I=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:
         In-Reply-To:References:From;
        b=uaSreD/5m9CgL7AfiWQkpRS6pYn5IvN7G6X1xubxR2PQ2NfNaKmSuaHvOqXOXxvrX
         MKXuGTZMs0EhOFoTG1Ozxr1wFBUA4Loivh/tATkCM9EEIrz1ALXAMrf11+rs+Sx5mk
         CNaTKRFle+/dSiaTuld6rB+11nXV/NSmqLh2Cvds=
Date:   Wed, 26 Aug 2020 13:53:47 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sean Paul <sean@poorly.run>
To:     Sean Paul <seanpaul@chromium.org>
To:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Cc:     ville.syrjala@linux.intel.com, daniel.vetter@ffwll.ch
Cc:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Ramalingam C <ramalingam.c@intel.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Sean Paul <seanpaul@chromium.org>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc:     Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v8 01/17] drm/i915: Fix sha_text population code
In-Reply-To: <20200818153910.27894-2-sean@poorly.run>
References: <20200818153910.27894-2-sean@poorly.run>
Message-Id: <20200826135347.C173722B49@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: ee5e5e7a5e0f ("drm/i915: Add HDCP framework + base implementation").

The bot has tested the following trees: v5.8.2, v5.7.16, v5.4.59, v4.19.140.

v5.8.2: Build OK!
v5.7.16: Build OK!
v5.4.59: Failed to apply! Possible dependencies:
    65833c463886 ("drm/i915/hdcp: conversion to struct drm_device based logging macros.")
    667944ad77f1 ("drm/i915/hdcp: use intel_de_*() functions for register access")
    692059318c0f ("drm/i915/hdcp: Enable HDCP 1.4 and 2.2 on Gen12+")

v4.19.140: Failed to apply! Possible dependencies:
    09d7e46b97c6 ("drm/i915: Pull VM lists under the VM mutex.")
    16e4dd0342a8 ("drm/i915: Markup paired operations on wakerefs")
    1d455f8de8e8 ("drm/i915: rename intel_drv.h to display/intel_display_types.h")
    27fec1f9734d ("drm/i915: extract intel_dp.h from intel_drv.h")
    39e2f501c1b4 ("drm/i915: Split struct intel_context definition to its own header")
    480cd6dd9287 ("drm/i915/selftests: Track evict objects explicitly")
    499197dc1696 ("drm/i915: Stop tracking MRU activity on VMA")
    528cbd17ceff ("drm/i915: Move vma lookup to its own lock")
    531747b8200a ("drm/i915/dvo: rename dvo.h to intel_dvo_dev.h and make self-contained")
    64d6c500a384 ("drm/i915: Generalise GPU activity tracking")
    667944ad77f1 ("drm/i915/hdcp: use intel_de_*() functions for register access")
    692059318c0f ("drm/i915/hdcp: Enable HDCP 1.4 and 2.2 on Gen12+")
    71fc448c1aaf ("drm/i915/selftests: Make evict tolerant of foreign objects")
    a037121c3c7f ("drm/i915: Mark up debugfs with rpm wakeref tracking")
    c2400ec3b6d1 ("drm/i915: add Makefile magic for testing headers are self-contained")
    d2ee2e8afeea ("drm/i915: extract intel_crt.h from intel_drv.h")
    d4225a535b3b ("drm/i915: Syntatic sugar for using intel_runtime_pm")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
