Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E03D253074
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730441AbgHZNxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730308AbgHZNxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:53:43 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3CEE208E4;
        Wed, 26 Aug 2020 13:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598450023;
        bh=Rj4Ua/+GZI4fqLHD2x5UsMtOLBJ1hsOVZa5hnctYvXk=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=wp1Nst1+/AVkTr5PSUD6v1NNBjuTXKMfixcQY5ZAIZQN54oGlmvBaCcxh+rhkUMp+
         7m9w+Mo8YrNs0ZdFXLejvVa27ZwwtAyRdUV3ATUOWsbxbjXWyLd0cNWrn5L6Di3cgE
         AMWI1h3rE2W7t6o34hi+LU4ypJ3D/KgVPufUX9p4=
Date:   Wed, 26 Aug 2020 13:53:42 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 3/3] drm/i915/gem: Always test execution status on closing the context
In-Reply-To: <20200812223621.22292-3-chris@chris-wilson.co.uk>
References: <20200812223621.22292-3-chris@chris-wilson.co.uk>
Message-Id: <20200826135342.E3CEE208E4@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 9a40bddd47ca ("drm/i915/gt: Expose heartbeat interval via sysfs").

The bot has tested the following trees: v5.8.2, v5.7.16.

v5.8.2: Failed to apply! Possible dependencies:
    1b90e4a43b74 ("drm/i915/selftests: Enable selftesting of busy-stats")
    2d3879950f8a ("drm/i915: Add psr_safest_params")
    4fe13f28d66a ("drm/i915/selftests: Add tests for timeslicing virtual engines")
    67a64e51ba92 ("drm/i915/selftests: Refactor sibling selection")
    8a25c4be583d ("drm/i915/params: switch to device specific parameters")
    9199c070cdde ("drm/i915/selftests: Exercise far preemption rollbacks")
    ad6586850b6d ("drm/i915/selftests: Change priority overflow detection")
    d4b02a4c613e ("drm/i915/selftests: Trim execlists runtime")
    f4bb45f72734 ("drm/i915: Trim set_timer_ms() intervals")

v5.7.16: Failed to apply! Possible dependencies:
    0c1abaa7fbfb ("drm: Constify adjusted_mode a bit")
    13ea6db2cf24 ("drm/i915/edp: Ignore short pulse when panel powered off")
    3dfd8d710419 ("drm/i915/display: use struct drm_device based logging")
    81b55ef1f47b ("drm/i915: drop a bunch of superfluous inlines")
    8a25c4be583d ("drm/i915/params: switch to device specific parameters")
    af67009c1439 ("drm/i915/dp: use struct drm_device based logging")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
