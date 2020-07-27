Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A72222FB54
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 23:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgG0VYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 17:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbgG0VYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 17:24:45 -0400
Received: from localhost (unknown [13.85.75.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6300320809;
        Mon, 27 Jul 2020 21:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595885084;
        bh=iZs/YNdw8Qu+Yk7iYYu8kLcOVP0Gfdc/QojMyHdgvC0=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=FQuXrMUdM2g5+U5CphrPkQNG49cMF5W8a7Euj3BuP0HaYDu/lyNYtq1A5cs1SKV9G
         l/dNYzpfUs2yJLmEUtsE+32mdJMbxFVAJHoHqkOzxN2LleQbMZVD49hNwukty8BxOg
         EZNPynY4H49QsIU9+Nb7fvfb4Dqjw8Akj1ECNTvk=
Date:   Mon, 27 Jul 2020 21:24:43 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org
Cc:     CQ Tang <cq.tang@intel.com>
Cc:     Daniel Vetter <daniel.vetter@intel.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 3/3] drm/i915/gem: Serialise debugfs i915_gem_objects with ctx->mutex
In-Reply-To: <20200723172119.17649-3-chris@chris-wilson.co.uk>
References: <20200723172119.17649-3-chris@chris-wilson.co.uk>
Message-Id: <20200727212444.6300320809@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.10, v5.4.53, v4.19.134, v4.14.189, v4.9.231, v4.4.231.

v5.7.10: Build OK!
v5.4.53: Failed to apply! Possible dependencies:
    061489c65ff5 ("drm/i915/dsb: single register write function for DSB.")
    11988e393813 ("drm/i915/execlists: Try rearranging breadcrumb flush")
    2850748ef876 ("drm/i915: Pull i915_vma_pin under the vm->mutex")
    5a90606df7cb ("drm/i915: Replace obj->pin_global with obj->frontbuffer")
    67f3b58f3bac ("drm/i915/dsb: DSB context creation.")
    8a9a982767b7 ("drm/i915: use a separate context for gpu relocs")
    a4e7ccdac38e ("drm/i915: Move context management under GEM")
    b27a96ad72fd ("drm/i915/dsb: Indexed register write function for DSB.")
    bb120e1171a9 ("drm/i915: Show the logical context ring state on dumping")
    c210e85b8f33 ("drm/i915/tgl: Extend MI_SEMAPHORE_WAIT")
    d19d71fc2b15 ("drm/i915: Mark i915_request.timeline as a volatile, rcu pointer")
    e8f6b4952ec5 ("drm/i915/execlists: Flush the post-sync breadcrumb write harder")

v4.19.134: Failed to apply! Possible dependencies:
    0258404f9d38 ("drm/i915: start moving runtime device info to a separate struct")
    026844460743 ("drm/i915: Remove intel_context.active_link")
    07d805721938 ("drm/i915: Introduce intel_runtime_pm_disable to pair intel_runtime_pm_enable")
    13f1bfd3b332 ("drm/i915: Make object/vma allocation caches global")
    1c71bc565cdb ("drm/i915/perf: simplify configure all context function")
    2cc8376fd350 ("drm/i915: rename dev_priv info to __info to avoid usage")
    2cd9a689e97b ("drm/i915: Refactor intel_display_set_init_power() logic")
    37d7c9cc2eb6 ("drm/i915: Check engine->default_state mapping on module load")
    55ac5a1614f9 ("drm/i915: Attach the pci match data to the device upon creation")
    666424abfb86 ("drm/i915/execlists: Use coherent writes into the context image")
    6dfc4a8f134f ("drm/i915: Verify power domains after enabling them")
    722f3de39e03 ("i915/oa: Simplify updating contexts")
    900ccf30f9e1 ("drm/i915: Only force GGTT coherency w/a on required chipsets")
    c4d52feb2c46 ("drm/i915: Move over to intel_context_lookup()")
    f6e8aa387171 ("drm/i915: Report the number of closed vma held by each context in debugfs")
    fa9f668141f4 ("drm/i915: Export intel_context_instance()")

v4.14.189: Failed to apply! Possible dependencies:
    3bd4073524fa ("drm/i915: Consolidate get_fence with pin_fence")
    465c403cb508 ("drm/i915: introduce simple gemfs")
    66df1014efba ("drm/i915: Keep a small stash of preallocated WC pages")
    67b48040255b ("drm/i915: Assert that the handle->vma lut is empty on object close")
    73ebd503034c ("drm/i915: make mappable struct resource centric")
    7789422665f5 ("drm/i915: make dsm struct resource centric")
    82ad6443a55e ("drm/i915/gtt: Rename i915_hw_ppgtt base member")
    969b0950a188 ("drm/i915: Add interface to reserve fence registers for vGPU")
    a65adaf8a834 ("drm/i915: Track user GTT faulting per-vma")
    b4563f595ed4 ("drm/i915: Pin fence for iomap")
    e91ef99b9543 ("drm/i915/selftests: Remember to create the fake preempt context")
    f6e8aa387171 ("drm/i915: Report the number of closed vma held by each context in debugfs")
    f773568b6ff8 ("drm/i915: nuke the duplicated stolen discovery")

v4.9.231: Failed to apply! Possible dependencies:
    0e70447605f4 ("drm/i915: Move common code out of i915_gpu_error.c")
    1b36595ffb35 ("drm/i915: Show RING registers through debugfs")
    28a60dee2ce6 ("drm/i915/gvt: vGPU HW resource management")
    3b3f1650b1ca ("drm/i915: Allocate intel_engine_cs structure only for the enabled engines")
    82ad6443a55e ("drm/i915/gtt: Rename i915_hw_ppgtt base member")
    85fd4f58d7ef ("drm/i915: Mark all non-vma being inserted into the address spaces")
    9c870d03674f ("drm/i915: Use RPM as the barrier for controlling user mmap access")
    bb6dc8d96b68 ("drm/i915: Implement pread without struct-mutex")
    d636951ec01b ("drm/i915: Cleanup instdone collection")
    e007b19d7ba7 ("drm/i915: Use the MRU stack search after evicting")
    f6e8aa387171 ("drm/i915: Report the number of closed vma held by each context in debugfs")
    f9e613728090 ("drm/i915: Try to print INSTDONE bits for all slice/subslice")

v4.4.231: Failed to apply! Possible dependencies:
    1b683729e7ac ("drm/i915: Remove redundant check in i915_gem_obj_to_vma")
    1c7f4bca5a6f ("drm/i915: Rename vma->*_list to *_link for consistency")
    3272db53136f ("drm/i915: Combine all i915_vma bitfields into a single set of flags")
    596c5923197b ("drm/i915: Reduce the pointer dance of i915_is_ggtt()")
    c1a415e261aa ("drm/i915: Disable shrinker for non-swapped backed objects")
    d0710abbcd88 ("drm/i915: Set the map-and-fenceable flag for preallocated objects")
    f6e8aa387171 ("drm/i915: Report the number of closed vma held by each context in debugfs")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
