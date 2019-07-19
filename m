Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F244E6D7E7
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 02:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfGSApc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 20:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfGSApb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 20:45:31 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FB382173B;
        Fri, 19 Jul 2019 00:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563497130;
        bh=f+FCiwMTxTR3LwJ72Yd6Y80QgOqMnV4ta98udR3z5QE=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=KwYbp3NRuaNghfAzrMgxfxv8bdomCbII3nJpeiUjBn0Ah+vu9CpkPsjtSoCr16FOf
         0sJqOkQ5pu/rRnJFXlxnX84YHeGLAVzebk0goOYU5Ux9p97w5Kh98hBmcAzVxIfmTm
         T/9i5PLlJ9mkOxUnkxAsmyJTIrLW9yuYg0/LYYLU=
Date:   Fri, 19 Jul 2019 00:45:29 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Flush extra hard after writing relocations through the GTT
In-Reply-To: <20190718195650.20635-1-chris@chris-wilson.co.uk>
References: <20190718195650.20635-1-chris@chris-wilson.co.uk>
Message-Id: <20190719004530.5FB382173B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.2.1, v5.1.18, v4.19.59, v4.14.133, v4.9.185, v4.4.185.

v5.2.1: Failed to apply! Possible dependencies:
    Unable to calculate

v5.1.18: Failed to apply! Possible dependencies:
    Unable to calculate

v4.19.59: Failed to apply! Possible dependencies:
    Unable to calculate

v4.14.133: Failed to apply! Possible dependencies:
    3bd4073524fa ("drm/i915: Consolidate get_fence with pin_fence")
    465c403cb508 ("drm/i915: introduce simple gemfs")
    66df1014efba ("drm/i915: Keep a small stash of preallocated WC pages")
    7393b7ee3a9c ("drm/i915/debugfs: include some gtt page size metrics")
    73ebd503034c ("drm/i915: make mappable struct resource centric")
    7789422665f5 ("drm/i915: make dsm struct resource centric")
    82ad6443a55e ("drm/i915/gtt: Rename i915_hw_ppgtt base member")
    969b0950a188 ("drm/i915: Add interface to reserve fence registers for vGPU")
    a65adaf8a834 ("drm/i915: Track user GTT faulting per-vma")
    b1ace60107e6 ("drm/i915: give stolen_usable_size a more suitable home")
    b7128ef125b4 ("drm/i915: prefer resource_size_t for everything stolen")
    da1dd0dbe024 ("drm/i915: Make the report about a bogus stolen reserved area an error")
    db7fb60593e4 ("drm/i915: Check if the stolen memory "reserved" area is enabled or not")
    e91ef99b9543 ("drm/i915/selftests: Remember to create the fake preempt context")
    f773568b6ff8 ("drm/i915: nuke the duplicated stolen discovery")

v4.9.185: Failed to apply! Possible dependencies:
    04d348ae3f0a ("drm/i915/gvt: vGPU display virtualization")
    12d14cc43b34 ("drm/i915/gvt: Introduce a framework for tracking HW registers.")
    28a60dee2ce6 ("drm/i915/gvt: vGPU HW resource management")
    3f728236c516 ("drm/i915/gvt: trace stub")
    4c7d62c6b8a2 ("drm/i915: Markup GEM API with lockdep asserts")
    4d60c5fd3f87 ("drm/i915/gvt: vGPU PCI configuration space virtualization")
    579cea5f30f2 ("drm/i915/gvt: golden virtual HW state management")
    650bc63568e4 ("drm/i915: Amalgamate execbuffer parameter structures")
    718659a63054 ("drm/i915: Rename some warts in the VMA API")
    82d375d1b568 ("drm/i915/gvt: Introduce basic vGPU life cycle management")
    8453d674ae7e ("drm/i915/gvt: vGPU execlist virtualization")
    c8fe6a6811a7 ("drm/i915/gvt: vGPU interrupt virtualization.")
    e39c5add3221 ("drm/i915/gvt: vGPU MMIO virtualization")
    e473405783c0 ("drm/i915/gvt: vGPU workload scheduler")
    e95433c73a11 ("drm/i915: Rearrange i915_wait_request() accounting with callers")

v4.4.185: Failed to apply! Possible dependencies:
    033908aed5a5 ("drm/i915: mark GEM object pages dirty when mapped & written by the CPU")
    058d88c4330f ("drm/i915: Track pinned VMA")
    09cfcb456941 ("drm/i915: Split out load time HW initialization")
    0a9d2bed5557 ("drm/i915/skl: Making DC6 entry is the last call in suspend flow.")
    188c1ab7769d ("drm/i915: Add struct_mutex locking for debugs/i915_gem_framebuffer")
    1f814daca43a ("drm/i915: add support for checking if we hold an RPM reference")
    31a39207f04a ("drm/i915: Cache kmap between relocations")
    399bb5b6db02 ("drm/i915: Move allocation of various workqueues earlier during init")
    414b7999b8be ("drm/i915/gen9: Remove csr.state, csr_lock and related code.")
    506a8e87d8d2 ("drm/i915: Add soft-pinning API for execbuffer")
    62106b4f6b91 ("drm/i915: Rename dev_priv->gtt to dev_priv->ggtt")
    72e96d6450c0 ("drm/i915: Refer to GGTT {,VM} consistently")
    73dfc227ff5c ("drm/i915/skl: init/uninit display core as part of the HW power domain state")
    8da32727ac0e ("drm/i915: Remove i915_gem_obj_size")
    934acce3c069 ("drm/i915: Avoid writing relocs with addresses in non-canonical form")
    9e2793f6e4e2 ("drm/i915: compile-time consistency check on __EXEC_OBJECT flags")
    ad5c3d3ffbb2 ("drm/i915: Move MCHBAR setup earlier during init")
    bc87229f323e ("drm/i915/skl: enable PC9/10 power states during suspend-to-idle")
    be12a86b46e8 ("drm/i915: Show pin mapped status in describe_obj")
    d50415cc6c83 ("drm/i915: Refactor execbuffer relocation writing")
    f514c2d84285 ("drm/i915/gen9: flush DMC fw loading work during system suspend")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
