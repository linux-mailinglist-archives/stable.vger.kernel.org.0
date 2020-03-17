Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B148A189174
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 23:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgCQWa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 18:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbgCQWaZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 18:30:25 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9C932073E;
        Tue, 17 Mar 2020 22:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584484225;
        bh=UikcPXzKIi3FqCpext+x38VLcTWWZqV5+lnLEXHxy8g=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:
         Cc:Cc:Subject:In-Reply-To:References:From;
        b=qm3pZ04W3fXIEVnkfZjpafq14GsKMbLCxkWGJB4FDLI6NqwmbidA1mnyWRv7RDP8P
         gjsAgiar3DNSlEIK8tKp+oJsX1sWG6ISZL1SBcsmSFpE4P1XWqdVgqXR/Lzby/G/ee
         VWO3PBXwgD5lMTreF8cCvFESjunKEP6duC291wuE=
Date:   Tue, 17 Mar 2020 22:30:24 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Kim Phillips <kim.phillips@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>
Cc:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Ingo Molnar <mingo@kernel.org>
Cc:     Ingo Molnar <mingo@redhat.com>
Cc:     Jiri Olsa <jolsa@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>
Cc:     Michael Petlan <mpetlan@redhat.com>
Cc:     Namhyung Kim <namhyung@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org
Cc:     x86@kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/3 RESEND] perf/amd/uncore: Replace manual sampling check with CAP_NO_INTERRUPT flag
In-Reply-To: <20200311191323.13124-1-kim.phillips@amd.com>
References: <20200311191323.13124-1-kim.phillips@amd.com>
Message-Id: <20200317223024.D9C932073E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: c43ca5091a37 ("perf/x86/amd: Add support for AMD NB and L2I "uncore" counters").

The bot has tested the following trees: v5.5.9, v5.4.25, v4.19.109, v4.14.173, v4.9.216, v4.4.216.

v5.5.9: Build OK!
v5.4.25: Build OK!
v4.19.109: Failed to apply! Possible dependencies:
    88dbe3c94e27 ("perf/core, arch/x86: Strengthen exclusion checks with PERF_PMU_CAP_NO_EXCLUDE")

v4.14.173: Failed to apply! Possible dependencies:
    88dbe3c94e27 ("perf/core, arch/x86: Strengthen exclusion checks with PERF_PMU_CAP_NO_EXCLUDE")

v4.9.216: Failed to apply! Possible dependencies:
    1650dfd1a9bc ("x86/events, drivers/amd/iommu: Prepare for multiple IOMMUs support")
    25df39f2cfd0 ("x86/events/amd/iommu: Enable support for multiple IOMMUs")
    51686546304f ("x86/events/amd/iommu: Fix sysfs perf attribute groups")
    6aad0c626905 ("x86/events/amd/iommu: Clean up bitwise operations")
    88dbe3c94e27 ("perf/core, arch/x86: Strengthen exclusion checks with PERF_PMU_CAP_NO_EXCLUDE")
    cf25f904ef75 ("x86/events/amd/iommu: Add IOMMU-specific hw_perf_event struct")
    f5863a00e73c ("x86/events/amd/iommu.c: Modify functions to query max banks and counters")
    f9573e53f123 ("x86/events/amd/iommu: Declare pr_fmt() format")

v4.4.216: Failed to apply! Possible dependencies:
    1229735b290d ("perf/x86/intel/uncore: Make code more readable")
    1a246b9f58c6 ("perf/x86/intel/uncore: Convert to hotplug state machine")
    31d50c551e30 ("perf/x86/amd/uncore: Do not register a task ctx for uncore PMUs")
    4f089678d071 ("perf/x86/intel/uncore: Fix error handling")
    5485592c1795 ("perf/x86/intel/uncore: Make PCI and MSR uncore independent")
    77af0037de0a ("perf/x86/intel/uncore: Add Knights Landing uncore PMU support")
    7d762e49c211 ("perf/x86/amd/uncore: Prevent use after free")
    83f8ebd2eb45 ("perf/x86/intel/uncore: Add sanity checks for PCI dev package id")
    96b2bd3866a0 ("perf/x86/amd/uncore: Convert to hotplug state machine")
    a46195f1782e ("perf/x86/intel/uncore: Clean up hardware on exit")
    a83f4c00dd6a ("perf/x86/amd/uncore: Rename 'L2' to 'LLC'")
    cf6d445f6897 ("perf/x86/uncore: Track packages, not per CPU data")
    ffeda0038032 ("perf/x86/intel/uncore: Simplify error rollback")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
