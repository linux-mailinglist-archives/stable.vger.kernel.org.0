Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D151B30BA
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 21:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgDUT4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 15:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgDUT4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 15:56:08 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 875B720747;
        Tue, 21 Apr 2020 19:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587498967;
        bh=yQvGK8tMgwZYWkYoCKOnL1qo8aBsLOdaXuuKxxFLwbo=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=VnwV50TAbim7HbyXFE/HY+KAHSLYREj1KxxrcUkzzezow333HcLz11NUyI2Wvo3rL
         MbScaioSOW7uhfsdaleGIw1nqQKtk8NbHsIO7f+fraoqtFx3HN4AmyLuzjHJvqC8nC
         bm37JNCnhpfHXF0wm4tPWdMPJOWMQCvEc/0bVuZ8=
Date:   Tue, 21 Apr 2020 19:56:06 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] agp/intel: Reinforce the barrier after GTT updates
In-Reply-To: <20200410083535.25464-1-chris@chris-wilson.co.uk>
References: <20200410083535.25464-1-chris@chris-wilson.co.uk>
Message-Id: <20200421195607.875B720747@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 983d308cb8f6 ("agp/intel: Serialise after GTT updates").

The bot has tested the following trees: v5.6.5, v5.5.18, v5.4.33, v4.19.116, v4.14.176, v4.9.219, v4.4.219.

v5.6.5: Build OK!
v5.5.18: Build OK!
v5.4.33: Build OK!
v4.19.116: Build OK!
v4.14.176: Build OK!
v4.9.219: Build OK!
v4.4.219: Failed to apply! Possible dependencies:
    09cfcb456941 ("drm/i915: Split out load time HW initialization")
    0a9d2bed5557 ("drm/i915/skl: Making DC6 entry is the last call in suspend flow.")
    1f814daca43a ("drm/i915: add support for checking if we hold an RPM reference")
    2f693e28b8df ("drm/i915: Make turning on/off PW1 and Misc I/O part of the init/fini sequences")
    399bb5b6db02 ("drm/i915: Move allocation of various workqueues earlier during init")
    414b7999b8be ("drm/i915/gen9: Remove csr.state, csr_lock and related code.")
    5bab6f60cb4d ("drm/i915: Serialise updates to GGTT with access through GGTT on Braswell")
    62106b4f6b91 ("drm/i915: Rename dev_priv->gtt to dev_priv->ggtt")
    73dfc227ff5c ("drm/i915/skl: init/uninit display core as part of the HW power domain state")
    9c5308ea1cd4 ("drm/i915/skl: Refuse to load outdated dmc firmware")
    ad5c3d3ffbb2 ("drm/i915: Move MCHBAR setup earlier during init")
    b6e7d894c3d2 ("drm/i915/skl: Store and print the DMC firmware version we load")
    bc87229f323e ("drm/i915/skl: enable PC9/10 power states during suspend-to-idle")
    c140330b5e6b ("drm/i915: Move Braswell stop_machine GGTT insertion workaround")
    c73666f394fc ("drm/i915/skl: If needed sanitize bios programmed cdclk")
    d507d73578ef ("drm/i915/gtt: Clean up GGTT probing code")
    d6473f566417 ("drm/i915: Add support for mapping an object page by page")
    ebae38d061df ("drm/i915/gen9: csr_init after runtime pm enable")
    f4448375467d ("drm/i915/gen9: Use dev_priv in csr functions")
    f514c2d84285 ("drm/i915/gen9: flush DMC fw loading work during system suspend")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
