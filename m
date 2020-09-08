Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB045261968
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731576AbgIHSNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:13:17 -0400
Received: from a27-18.smtp-out.us-west-2.amazonses.com ([54.240.27.18]:38038
        "EHLO a27-18.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728297AbgIHSNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 14:13:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599588794;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=fxAqMqEj9QgHDZQgpIMxl7ZgmIYndjLFXoSvEpLgFRU=;
        b=NP5fzkagOkgQIJSM5dp0v580tba5/McfKwqVb60g1SPM8gVtbRRMAArKOSnhCfxt
        D9wZyYvcqMXAqkj7aeOy/p+H+aQta+xsYNCSCY3ukE8vib59f7FCQ198ywjNFvJMiPf
        SYPdc4/9z52LoG3tHJKOte3KGZnkcquu+oTAlb1M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599588793;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To:Feedback-ID;
        bh=fxAqMqEj9QgHDZQgpIMxl7ZgmIYndjLFXoSvEpLgFRU=;
        b=TZzRveC912FuCPdbAgy2nZe8p8S6ssTjXcYpv4pT4P1tDQVHvAL3EIUAKamrJJ1P
        3mN5+4Q0VUjXNPuLpv45UvVJdfBvOUv3eE0JNLWaNRrVc1U6t7qhi3VNuQKyk/uGMas
        TiVL+9U3n55SZ1DrePCqDB+1wcMB88TgzKvyOPvg=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5E8C1C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jcrouse@codeaurora.org
Date:   Tue, 8 Sep 2020 18:13:13 +0000
From:   Jordan Crouse <jcrouse@codeaurora.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, stable@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH 1/4] drm/msm: Split the a5xx preemption record
Message-ID: <010101746eebfda9-7719be55-f63b-44c4-9375-e564eeadf775-000000@us-west-2.amazonses.com>
Mail-Followup-To: Sasha Levin <sashal@kernel.org>,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
References: <20200904020313.1810988-2-jcrouse@codeaurora.org>
 <20200906031610.BECF62137B@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200906031610.BECF62137B@mail.kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-SES-Outgoing: 2020.09.08-54.240.27.18
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 06, 2020 at 03:16:10AM +0000, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.8.6, v5.4.62, v4.19.143, v4.14.196, v4.9.235, v4.4.235.
> 
> v5.8.6: Build OK!
> v5.4.62: Build failed! Errors:
>     drivers/gpu/drm/msm/adreno/a5xx_preempt.c:235:21: error: 'MSM_BO_MAP_PRIV' undeclared (first use in this function); did you mean 'MSM_BO_CACHED'?
> 
> v4.19.143: Failed to apply! Possible dependencies:
>     0815d7749a68 ("drm/msm: Add a name field for gem objects")
>     1e29dff00400 ("drm/msm: Add a common function to free kernel buffer objects")
>     64686886bbff ("drm/msm: Replace drm_gem_object_{un/reference} with put, get functions")
>     6a41da17e87d ("drm: msm: Use DRM_DEV_* instead of dev_*")
>     c97ea6a61b5e ("drm: msm: adreno: Use PTR_ERR_OR_ZERO rather than if(IS_ERR(...)) +PTR_ERR")
>     df0dff132905 ("drm/msm/a6xx: Poll for HFI responses")
>     f384d7d514d1 ("drm: Convert to using %pOFn instead of device_node.name")
>     feb085ec8a3d ("drm/msm: dsi: Return errors whan dt parsing fails")
> 
> v4.14.196: Failed to apply! Possible dependencies:
>     b1fc2839d2f9 ("drm/msm: Implement preemption for A5XX targets")
>     cd414f3d9316 ("drm/msm: Move memptrs to msm_gpu")
>     e8f3de96a9d3 ("drm/msm/adreno: split out helper to load fw")
>     eec874ce5ff1 ("drm/msm/adreno: load gpu at probe/bind time")
>     f7de15450e90 ("drm/msm: Add per-instance submit queues")
>     f97decac5f4c ("drm/msm: Support multiple ringbuffers")
> 
> v4.9.235: Failed to apply! Possible dependencies:
>     1cec20f0ea0e ("dma-buf: Restart reservation_object_wait_timeout_rcu() after writes")
>     667ce33e57d0 ("drm/msm: support multiple address spaces")
>     78010cd9736e ("dma-buf/fence: add an lockdep_assert_held()")
>     89d777a57245 ("drm/msm: Remove 'src_clk' from adreno configuration")
>     b1fc2839d2f9 ("drm/msm: Implement preemption for A5XX targets")
>     b5f103ab98c7 ("drm/msm: gpu: Add A5XX target support")
>     f54d1867005c ("dma-buf: Rename struct fence to dma_fence")
>     fb0399819239 ("drm/msm: Add adreno_gpu_write64()")
>     fedf54132d24 ("dma-buf: Restart reservation_object_get_fences_rcu() after writes")
> 
> v4.4.235: Failed to apply! Possible dependencies:
>     01c8f1c44b83 ("mm, dax, gpu: convert vm_insert_mixed to pfn_t")
>     0caeef63e6d2 ("libnvdimm: Add a poison list and export badblocks")
>     0e749e54244e ("dax: increase granularity of dax_clear_blocks() operations")
>     34c0fd540e79 ("mm, dax, pmem: introduce pfn_t")
>     357ff00b08d6 ("drm/msm/adreno: support for adreno 430.")
>     52db400fcd50 ("pmem, dax: clean up clear_pmem()")
>     667ce33e57d0 ("drm/msm: support multiple address spaces")
>     68209390f116 ("drm/msm: shrinker support")
>     7d0c5ee9f077 ("drm/msm/adreno: get CP_RPTR from register instead of shadow memory")
>     87ba05dff351 ("libnvdimm: don't fail init for full badblocks list")
>     89d777a57245 ("drm/msm: Remove 'src_clk' from adreno configuration")
>     a5725ab0497a ("drm/msm/adreno: move function declarations to header file")
>     b1fc2839d2f9 ("drm/msm: Implement preemption for A5XX targets")
>     b2e0d1625e19 ("dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()")
>     b5f103ab98c7 ("drm/msm: gpu: Add A5XX target support")
>     b95f5f4391fa ("libnvdimm: convert to statically allocated badblocks")
>     edcd60ce243d ("drm/msm: move debugfs code to it's own file")
>     fb0399819239 ("drm/msm: Add adreno_gpu_write64()")
>     fde5de6cb461 ("drm/msm: move fence code to it's own file")
>     fe683adabfe6 ("dax: guarantee page aligned results from bdev_direct_access()")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

For 5.4 it looks like all you need is:

0b462d7a71c07e96b ("drm/msm: add internal MSM_BO_MAP_PRIV flag")

For 4.19 it looks a bit more complicated. I can try to build a stack that would
work.

This patch isn't needed before 4.19 because preemption isn't available (as far
as I can tell from the dependencies list).

Jordan
> 
> -- 
> Thanks
> Sasha

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
