Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D338F1E186F
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 02:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgEZAX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 20:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbgEZAX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 May 2020 20:23:58 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA7B620657;
        Tue, 26 May 2020 00:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590452638;
        bh=145r9XeforWYT14us2CYb61fohkEWDdbKnHo/QYQRdk=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=wjhUA7kcd0yOymHDaU9VeDjZenYqqL3IV+VOJiga9o3RvGtkLI+0fPDMyqiQAwegQ
         BC/hqjTU409ECGY3W/kbgIXd3dRkWupXWUTQkylRItrB+gdlMorjhVeqMvu8liKUBN
         4MDsFbT+VYJ5p74B37XMsBHtLF1sdkGApo96Ush4=
Date:   Tue, 26 May 2020 00:23:57 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/4] drm/i915/gt: Do not schedule normal requests immediately along virtual
In-Reply-To: <20200525202901.32244-1-chris@chris-wilson.co.uk>
References: <20200525202901.32244-1-chris@chris-wilson.co.uk>
Message-Id: <20200526002357.EA7B620657@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 6d06779e8672 ("drm/i915: Load balancing across a virtual engine").

The bot has tested the following trees: v5.6.14, v5.4.42.

v5.6.14: Build OK!
v5.4.42: Failed to apply! Possible dependencies:
    0b718ba1e884 ("drm/i915/gtt: Downgrade Cherryview back to aliasing-ppgtt")
    0f100b70487a ("drm/i915: Push the use-semaphore marker onto the intel_context")
    2e0986a58cc4 ("drm/i915/gem: Cancel contexts when hangchecking is disabled")
    4a3174152147 ("drm/i915/gem: Refine occupancy test in kill_context()")
    5bf05dc58d65 ("drm/i915/tgl: Register state context definition for Gen12")
    7dc56af5260e ("drm/i915/selftests: Verify the LRC register layout between init and HW")
    8f8b1171e1a5 ("drm/i915/perf: Wean ourselves off dev_priv")
    9cd20ef7803c ("drm/i915/perf: allow holding preemption on filtered ctx")
    9f3ccd40acf4 ("drm/i915: Drop GEM context as a direct link from i915_request")
    a0e047156cde ("drm/i915/gem: Make context persistence optional")
    cdb736fa8b8b ("drm/i915: Use engine relative LRIs on context setup")
    eaef5b3c4113 ("drm/i915: Refactor instdone loops on new subslice functions")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
