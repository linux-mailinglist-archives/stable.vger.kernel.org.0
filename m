Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34AFD15C97E
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 18:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgBMRhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 12:37:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728549AbgBMRhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 12:37:05 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26AC1217F4;
        Thu, 13 Feb 2020 17:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581615424;
        bh=NvPMM5+pK2jHZbOZupTFm51B0iNkac62dZdX7hFIIyg=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=cClXQypHs15SQt1mOZgSR5+KXJitk5TZqSBG2LnH9BOY2s2YBc9bzJ2zxp8vj981e
         Mwx1BudNVlauNiwo6eGxQgNYau+Cej6yV2JvaRy1DKVyYCRh2hXM2oFjNRdJnoB0IY
         34EeCEh+GvWH+8pY3FLBjuUeSRRwF8P4LZWRjvLU=
Date:   Thu, 13 Feb 2020 17:37:03 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jani Nikula <jani.nikula@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     jani.nikula@intel.com, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/i915: Update drm/i915 bug filing URL
In-Reply-To: <20200212160434.6437-2-jani.nikula@intel.com>
References: <20200212160434.6437-2-jani.nikula@intel.com>
Message-Id: <20200213173704.26AC1217F4@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.3, v5.4.19, v4.19.103, v4.14.170, v4.9.213, v4.4.213.

v5.5.3: Build OK!
v5.4.19: Failed to apply! Possible dependencies:
    d30213e533fa ("drm/i915: Fix Kconfig indentation")

v4.19.103: Failed to apply! Possible dependencies:
    0e39037b3165 ("drm/i915: Cache the error string")
    1032a2af93f5 ("drm/i915: use upstream version of header tests")
    16e4dd0342a8 ("drm/i915: Markup paired operations on wakerefs")
    39e2f501c1b4 ("drm/i915: Split struct intel_context definition to its own header")
    52c0fdb25c7c ("drm/i915: Replace global breadcrumbs with per-context interrupt tracking")
    538ef96b9dae ("drm/i915/gem: Track the rpm wakerefs")
    6b048706f407 ("drm/i915: Forcibly flush unwanted requests in drop-caches")
    87f1ef225242 ("drm/i915: Record the sseu configuration per-context & engine")
    95fd94a645f7 ("drm/i915: avoid rebuilding i915_gpu_error.o on version string updates")
    c0a6aa7ec2c3 ("drm/i915: Show actual alongside requested frequency in debugfs/i915_rps_boost_info")
    c2400ec3b6d1 ("drm/i915: add Makefile magic for testing headers are self-contained")
    c44301fce614 ("drm/i915: Allow control of PSR at runtime through debugfs, v6")
    d30213e533fa ("drm/i915: Fix Kconfig indentation")
    e6154e4cb8b0 ("drm/i915: Skip the ERR_PTR error state")
    eb8d0f5af4ec ("drm/i915: Remove GPU reset dependence on struct_mutex")
    fb6f0b64e455 ("drm/i915: Prevent machine hang from Broxton's vtd w/a and error capture")

v4.14.170: Failed to apply! Possible dependencies:
    08dd3e1acc16 ("drm/i915/execlists: Move insert_request()")
    1032a2af93f5 ("drm/i915: use upstream version of header tests")
    27a5f61b377b ("drm/i915: Cancel all ready but queued requests when wedging")
    39e2f501c1b4 ("drm/i915: Split struct intel_context definition to its own header")
    45ec5bc8774b ("drm/i915/guc: Remove obsolete comments and remove unused variable")
    52c0fdb25c7c ("drm/i915: Replace global breadcrumbs with per-context interrupt tracking")
    52d7f16e5543 ("drm/i915: Stop tracking timeline->inflight_seqnos")
    5427f207852d ("drm/i915: Bump wait-times for the final CS interrupt before parking")
    62b5ed1f35d7 ("drm/i915: Fix i915_gem_context.h header")
    6d2cb5aa383b ("drm/i915/execlists: Read the context-status buffer from the HWSP")
    767a983ab255 ("drm/i915/execlists: Read the context-status HEAD from the HWSP")
    85e2fe679e05 ("drm/i915/guc: Submit GuC workitems containing coalesced requests")
    87f1ef225242 ("drm/i915: Record the sseu configuration per-context & engine")
    aba5e278586b ("drm/i915: Add a hook for making the engines idle (parking) and unparking")
    b620e870218e ("drm/i915: Make own struct for execlist items")
    c2400ec3b6d1 ("drm/i915: add Makefile magic for testing headers are self-contained")
    c5d1f5562ea7 ("drm/i915: Include i915_scheduler.h from i915_gem_context.h")
    d30213e533fa ("drm/i915: Fix Kconfig indentation")
    e4d2006f8f04 ("drm/i915: Split out parking from the idle worker for reuse")
    eb8d0f5af4ec ("drm/i915: Remove GPU reset dependence on struct_mutex")
    ff320d6e72ff ("drm/i915: Synchronize irq before parking each engine")

v4.9.213: Failed to apply! Possible dependencies:
    1032a2af93f5 ("drm/i915: use upstream version of header tests")
    1233e2db199d ("drm/i915: Move object backing storage manipulation to its own locking")
    275f039db56f ("drm/i915: Move user fault tracking to a separate list")
    3594a3e21f1f ("drm/i915: Remove superfluous locking around userfault_list")
    3599a91cc8d0 ("drm/i915: Allow shrinking of userptr objects once again")
    39e2f501c1b4 ("drm/i915: Split struct intel_context definition to its own header")
    6095868a271d ("drm/i915: Complete kerneldoc for struct i915_gem_context")
    7093f5ff75ae ("drm/i915: GVT-g driver depends on 64BIT kernel")
    7c108fd8feac ("drm/i915: Move fence cancellation to runtime suspend")
    8baa1f04b9ed ("drm/i915: Update debugfs describe_obj() to show fault-mappable")
    920cf4194954 ("drm/i915: Introduce an internal allocator for disposable private objects")
    96d776345277 ("drm/i915: Use a radixtree for random access to the object's backing storage")
    98a2f411671f ("drm/i915: Allow disabling error capture")
    a4f5ea64f0a8 ("drm/i915: Refactor object page API")
    b42fe9ca0a1e ("drm/i915: Split out i915_vma.c")
    c2400ec3b6d1 ("drm/i915: add Makefile magic for testing headers are self-contained")
    d30213e533fa ("drm/i915: Fix Kconfig indentation")
    f8a7fde45610 ("drm/i915: Defer active reference until required")

v4.4.213: Failed to apply! Possible dependencies:
    0a9d2bed5557 ("drm/i915/skl: Making DC6 entry is the last call in suspend flow.")
    13ae3a0d5b13 ("drm/i915/gen9: simplify DC toggling code")
    414b7999b8be ("drm/i915/gen9: Remove csr.state, csr_lock and related code.")
    443646c7ee27 ("drm/i915/gen9: Add boot parameter for disabling DC6")
    4a76f295bc01 ("drm/i915/skl: don't toggle PW1 and MISC power wells on-demand")
    4deccbb26b4d ("drm/i915/gen9: Always set mask memory up when enabling DC5 or DC6")
    56fcfd6333a8 ("drm/i915: fix the power well ID for always on wells")
    755412e29c77 ("drm/i915: Add an optional selection from i915 of CONFIG_MMU_NOTIFIER")
    9777cca0c4d3 ("drm/i915: Skip capturing an error state if we already have one")
    98a2f411671f ("drm/i915: Allow disabling error capture")
    9c5308ea1cd4 ("drm/i915/skl: Refuse to load outdated dmc firmware")
    9f836f9016ad ("drm/i915/gen9: Turn DC handling into a power well")
    af5fead2d994 ("drm/i915/gen9: move assert_csr_loaded into intel_rpm.c")
    b6e7d894c3d2 ("drm/i915/skl: Store and print the DMC firmware version we load")
    c838d719d625 ("drm/i915: Decouple struct i915_params i915 into i915_params.h")
    e23ceb83e8b5 ("drm/i915: move drmP.h include to i915_drv.h")
    edd993fd1728 ("drm/i915: Remove DDI power domain exclusion SKL_DISPLAY_ALWAYS_ON_POWER_DOMAINS")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks,
Sasha
