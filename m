Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1D62218E9
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 02:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGPA1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 20:27:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727833AbgGPA1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 20:27:37 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 575B22072E;
        Thu, 16 Jul 2020 00:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594859256;
        bh=oSaYgjsR7WCqaMplPFHVreVXgOuBrajY9wLoEU5PPcE=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=YuyvpdY3hsFYsFHTy5aLdT0n+Mc2hc4HIa6m823Yo6nozjFea1GgRE/thFBX1ZWRX
         0ED726n1WwtlnYtE+NjGNNA5VkP0KZel8owyPbqHLO7nzwzw3QXfqp699u9pIoVKQj
         ZQiZ0iS1IDgLLpMUjQRt6Xsn8fukERPPUbjIMzII=
Date:   Thu, 16 Jul 2020 00:27:35 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Vincent Guittot <vincent.guittot@linaro.org>
To:     mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com
Cc:     valentin.schneider@arm.com
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3] sched/fair: handle case of task_h_load() returning 0
In-Reply-To: <20200710152426.16981-1-vincent.guittot@linaro.org>
References: <20200710152426.16981-1-vincent.guittot@linaro.org>
Message-Id: <20200716002736.575B22072E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.4+

The bot has tested the following trees: v5.7.8, v5.4.51, v4.19.132, v4.14.188, v4.9.230, v4.4.230.

v5.7.8: Build OK!
v5.4.51: Failed to apply! Possible dependencies:
    0b0695f2b34a4 ("sched/fair: Rework load_balance()")
    490ba971d8b49 ("sched/fair: Clean up asym packing")
    a349834703010 ("sched/fair: Rename sg_lb_stats::sum_nr_running to sum_h_nr_running")
    fcf0553db6f4c ("sched/fair: Remove meaningless imbalance calculation")

v4.19.132: Failed to apply! Possible dependencies:
    0b0695f2b34a4 ("sched/fair: Rework load_balance()")
    1c1b8a7b03ef5 ("sched/fair: Replace source_load() & target_load() with weighted_cpuload()")
    3b1baa6496e6b ("sched/fair: Add 'group_misfit_task' load-balance type")
    4ad3831a9d4af ("sched/fair: Don't move tasks to lower capacity CPUs unless necessary")
    575638d1047eb ("sched/core: Change root_domain->overload type to int")
    630246a06ae2a ("sched/fair: Clean-up update_sg_lb_stats parameters")
    6aa140fa45089 ("sched/topology: Reference the Energy Model of CPUs when available")
    757ffdd705ee9 ("sched/fair: Set rq->rd->overload when misfit")
    a3df067974c52 ("sched/fair: Rename weighted_cpuload() to cpu_runnable_load()")
    cad68e552e777 ("sched/fair: Consider misfit tasks when load-balancing")
    dbbad719449e0 ("sched/fair: Change 'prefer_sibling' type to bool")
    e90c8fe15a3bf ("sched/fair: Wrap rq->rd->overload accesses with READ/WRITE_ONCE()")
    fdf5f315d5cfa ("sched/fair: Disable LB_BIAS by default")

v4.14.188: Failed to apply! Possible dependencies:
    0b0695f2b34a4 ("sched/fair: Rework load_balance()")
    1c1b8a7b03ef5 ("sched/fair: Replace source_load() & target_load() with weighted_cpuload()")
    2a2f5d4e44ed1 ("sched/fair: Rewrite cfs_rq->removed_*avg")
    3b1baa6496e6b ("sched/fair: Add 'group_misfit_task' load-balance type")
    7f65ea42eb00b ("sched/fair: Add util_est on top of PELT")
    97fb7a0a8944b ("sched: Clean up and harmonize the coding style of the scheduler code base")
    a3df067974c52 ("sched/fair: Rename weighted_cpuload() to cpu_runnable_load()")
    cad68e552e777 ("sched/fair: Consider misfit tasks when load-balancing")
    d18be45dbfef2 ("sched/cpufreq: Split utilization signals")
    d4edd662ac165 ("sched/cpufreq: Use the DEADLINE utilization signal")
    f01415fdbfe83 ("sched/fair: Use 'unsigned long' for utilization, consistently")

v4.9.230: Failed to apply! Possible dependencies:
    3b1baa6496e6b ("sched/fair: Add 'group_misfit_task' load-balance type")
    4eb5aaa3af8a5 ("sched/headers: Prepare for new header dependencies before moving code to <linux/sched/autogroup.h>")
    4f17722c7256a ("sched/headers: Prepare for new header dependencies before moving code to <linux/sched/loadavg.h>")
    555570d744f81 ("sched/clock: Update static_key usage")
    5eca1c10cbaa9 ("sched/headers: Clean up <linux/sched.h>")
    6e84f31522f93 ("sched/headers: Prepare for new header dependencies before moving code to <linux/sched/mm.h>")
    7f65ea42eb00b ("sched/fair: Add util_est on top of PELT")
    983de5f97169a ("firmware: tegra: Add BPMP support")
    9881b024b7d76 ("sched/clock: Delay switching sched_clock to stable")
    acb04058de494 ("sched/clock: Fix hotplug crash")
    ae7e81c077d60 ("sched/headers: Prepare for new header dependencies before moving code to <uapi/linux/sched/types.h>")
    b52992c06c902 ("drm/i915: Support asynchronous waits on struct fence from i915_gem_request")
    ca791d7f42563 ("firmware: tegra: Add IVC library")
    e601757102cfd ("sched/headers: Prepare for new header dependencies before moving code to <linux/sched/clock.h>")
    ea8b1c4a6019f ("drivers: psci: PSCI checker module")
    ee6a3d19f15b9 ("sched/headers: Remove the <linux/topology.h> include from <linux/sched.h>")
    fd7712337ff09 ("sched/headers: Prepare to remove the <linux/gfp.h> include from <linux/sched.h>")

v4.4.230: Failed to apply! Possible dependencies:
    051f263098a90 ("IB/mlx5: Add driver cross-channel support")
    146d2f1af3245 ("IB/mlx5: Allocate a Transport Domain for each ucontext")
    2811ba51b0495 ("IB/mlx5: Add RoCE fields to Address Vector")
    37aa5c36aa70c ("IB/mlx5: Add UARs write-combining and non-cached mapping")
    3b1baa6496e6b ("sched/fair: Add 'group_misfit_task' load-balance type")
    3cca26069a4b7 ("IB/mlx5: Support IB device's callbacks for adding/deleting GIDs")
    3f89a643eb295 ("IB/mlx5: Extend query_device/port to support RoCE")
    5eca1c10cbaa9 ("sched/headers: Clean up <linux/sched.h>")
    6e84f31522f93 ("sched/headers: Prepare for new header dependencies before moving code to <linux/sched/mm.h>")
    7c2344c3bbf97 ("IB/mlx5: Implements disassociate_ucontext API")
    7f65ea42eb00b ("sched/fair: Add util_est on top of PELT")
    a8c21a5451d83 ("drm/etnaviv: add initial etnaviv DRM driver")
    a9709d6874d55 ("vhost: convert pre sorted vhost memory array to interval tree")
    b368d7cb8ceb7 ("IB/mlx5: Add hca_core_clock_offset to udata in init_ucontext")
    cfb5e088e26ae ("IB/mlx5: Add CQE version 1 support to user QPs and SRQs")
    d69e3bcf79764 ("IB/mlx5: Mmap the HCA's core clock register to user-space")
    ebd61f68e1c79 ("IB/mlx5: Support IB device's callback for getting the link layer")
    ee6a3d19f15b9 ("sched/headers: Remove the <linux/topology.h> include from <linux/sched.h>")
    fc24fc5e9530a ("IB/mlx5: Support IB device's callback for getting its netdev")
    fd7712337ff09 ("sched/headers: Prepare to remove the <linux/gfp.h> include from <linux/sched.h>")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
