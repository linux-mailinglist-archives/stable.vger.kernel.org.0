Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A97022FB4A
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 23:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgG0VYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 17:24:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbgG0VYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 17:24:40 -0400
Received: from localhost (unknown [13.85.75.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B969B2173E;
        Mon, 27 Jul 2020 21:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595885079;
        bh=HGGzk78q0Zc7KredqssVjRcpr+bcpGarOh2uSbyGsUI=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=vOMJxw9VedQka+hmCdEq57UJvmTOQ3HxT8S/H2jKbSY3lFyVbOZrhxx1dFRg2jcUv
         ov+8dW39jeXVO+5aRFLU40gC/8hRNXzl2Cgm4g4RN0HhVlLWmgnXnOKUpTKCq/hZNp
         2riRLiOXLf31+g6ONLD7/G8qI2cCcYTwlTkRg1I4=
Date:   Mon, 27 Jul 2020 21:24:39 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org
Cc:     Daniel Vetter <daniel.vetter@intel.com>
Cc:     Gustavo Padovan <gustavo.padovan@collabora.com>
Cc:     CQ Tang <cq.tang@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/3] drm: Restore driver.preclose() for all to use
In-Reply-To: <20200723172119.17649-1-chris@chris-wilson.co.uk>
References: <20200723172119.17649-1-chris@chris-wilson.co.uk>
Message-Id: <20200727212439.B969B2173E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.12+

The bot has tested the following trees: v5.7.10, v5.4.53, v4.19.134, v4.14.189.

v5.7.10: Build OK!
v5.4.53: Build OK!
v4.19.134: Build OK!
v4.14.189: Failed to apply! Possible dependencies:
    112ed2d31a46 ("drm/i915: Move GraphicsTechnology files under gt/")
    1572042a4ab2 ("drm: provide management functions for drm_file")
    7a2c65dd32b1 ("drm: Release filp before global lock")
    7e13ad896484 ("drm: Avoid drm_global_mutex for simple inc/dec of dev->open_count")
    b46a33e271ed ("drm/i915/pmu: Expose a PMU interface for perf queries")
    c2400ec3b6d1 ("drm/i915: add Makefile magic for testing headers are self-contained")
    cc662126b413 ("drm/i915: Introduce DRM_I915_GEM_MMAP_OFFSET")
    e7af3116836f ("drm/i915: Introduce a preempt context")
    f0e4a0639752 ("drm/i915: Move GEM domain management to its own file")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
