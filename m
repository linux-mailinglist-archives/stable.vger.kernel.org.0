Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D410720A14F
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 16:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405405AbgFYOx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 10:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405309AbgFYOx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 10:53:56 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E5BB20768;
        Thu, 25 Jun 2020 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593096835;
        bh=NAJKRYY0MQ7KEvPqGjaP5V5F1etD3ZR4WhDtnXRMksQ=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=ZULTOdOw+lIwfbzK99GntpkE+tDiLi6hnWU/FDiQHfOIe/jK+gtqANufcN+QgdWqH
         HkNfPXV/nUuMyJ3BXgqhc/avma24QtsoN13cX/sXGpWl/h2ItWxOyW/VFm0gLD+os4
         iHboANvJx8WzzBlBLARbVwUeMltrmvnSkM0cMHfI=
Date:   Thu, 25 Jun 2020 14:53:54 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Finley Xiao <finley.xiao@rock-chips.com>
To:     xf@rock-chips.com
Cc:     Finley Xiao <finley.xiao@rock-chips.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v1] thermal/drivers/cpufreq_cooling: Fix wrong frequency converted from power
In-Reply-To: <20200623114206.13762-1-finley.xiao@rock-chips.com>
References: <20200623114206.13762-1-finley.xiao@rock-chips.com>
Message-Id: <20200625145355.3E5BB20768@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 349d39dc5739 ("thermal: cpu_cooling: merge frequency and power tables").

The bot has tested the following trees: v5.7.5, v5.4.48, v4.19.129, v4.14.185.

v5.7.5: Build OK!
v5.4.48: Failed to apply! Possible dependencies:
    5a4e5b78956a5 ("thermal: cpu_cooling: Make the power-related code depend on IPA")
    a4e893e802e6a ("thermal: cpu_cooling: Migrate to using the EM framework")

v4.19.129: Failed to apply! Possible dependencies:
    18c49926c4bf4 ("cpufreq: Add QoS requests for userspace constraints")
    2acb9bdae92d0 ("cpufreq: Explain the kobject_put() in cpufreq_policy_alloc()")
    2d8b39a62a5d3 ("ACPI: processor: Avoid NULL pointer dereferences at init time")
    3000ce3c52f8b ("cpufreq: Use per-policy frequency QoS")
    348a2ec5f5a5a ("cpufreq: Reorder and simplify cpufreq_update_policy()")
    4ebe36c94aed9 ("cpufreq: Fix kobject memleak")
    540a375822a40 ("cpufreq: Add cpufreq_cpu_acquire() and cpufreq_cpu_release()")
    5a4e5b78956a5 ("thermal: cpu_cooling: Make the power-related code depend on IPA")
    5c238a8b599f1 ("cpufreq: Auto-register the driver as a thermal cooling device if asked")
    67d874c3b2c69 ("cpufreq: Register notifiers with the PM QoS framework")
    70a59fde6e69d ("cpufreq: Avoid calling cpufreq_verify_current_freq() from handle_update()")
    a0dbb819b84f8 ("cpufreq: Add kerneldoc comments for two core functions")
    a4e893e802e6a ("thermal: cpu_cooling: Migrate to using the EM framework")
    d15ce412737ac ("ACPI: cpufreq: Switch to QoS requests instead of cpufreq notifier")

v4.14.185: Failed to apply! Possible dependencies:
    18c49926c4bf4 ("cpufreq: Add QoS requests for userspace constraints")
    2acb9bdae92d0 ("cpufreq: Explain the kobject_put() in cpufreq_policy_alloc()")
    2d8b39a62a5d3 ("ACPI: processor: Avoid NULL pointer dereferences at init time")
    3000ce3c52f8b ("cpufreq: Use per-policy frequency QoS")
    348a2ec5f5a5a ("cpufreq: Reorder and simplify cpufreq_update_policy()")
    4ebe36c94aed9 ("cpufreq: Fix kobject memleak")
    540a375822a40 ("cpufreq: Add cpufreq_cpu_acquire() and cpufreq_cpu_release()")
    5a4e5b78956a5 ("thermal: cpu_cooling: Make the power-related code depend on IPA")
    5c238a8b599f1 ("cpufreq: Auto-register the driver as a thermal cooling device if asked")
    67d874c3b2c69 ("cpufreq: Register notifiers with the PM QoS framework")
    70a59fde6e69d ("cpufreq: Avoid calling cpufreq_verify_current_freq() from handle_update()")
    a0dbb819b84f8 ("cpufreq: Add kerneldoc comments for two core functions")
    a4e893e802e6a ("thermal: cpu_cooling: Migrate to using the EM framework")
    d15ce412737ac ("ACPI: cpufreq: Switch to QoS requests instead of cpufreq notifier")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
