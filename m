Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD3B68BEB8
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 18:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfHMQgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 12:36:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35834 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfHMQgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 12:36:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1EC6F61634; Tue, 13 Aug 2019 16:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565714196;
        bh=HLRq8enPPAHK99SmXfdA8gnV+R4faZElbvmc862zOh0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EtLsqSmmjLExTXRHHVtHkkIvYJTYPfOlfMYi7rmyScvY+VZeFyxxfqosxnEPwqeVm
         RQY27+1oGJfydoZgTCzcR9L0za8/TqC5miwW9bWZ+9FEn9m0c7u29a6awfLvTVSjK6
         k2yxwEhPv2PYEIAL2TGW2ijJ8qiM1gBMENcdFJfI=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 49BC560A50;
        Tue, 13 Aug 2019 16:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565714192;
        bh=HLRq8enPPAHK99SmXfdA8gnV+R4faZElbvmc862zOh0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kclTIwMS4JJqUqNWd8JVKxh9kdCL4ZX6YAagUkS3LgQ0vulPyWdlCaO0vTpWt/yVA
         0mtIa0ZkOMP1tLjWKnQuKZPppNjyy0w84E/LXlHJU6cedSCO55jeLfaO1HrdUihsYp
         o1DLduJoQzVl+oN2IPwZpTmzq1kFLPc1AtGb1/Xw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 13 Aug 2019 09:36:30 -0700
From:   isaacm@codeaurora.org
To:     Sasha Levin <sashal@kernel.org>
Cc:     hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] dma-mapping: Use unsigned types for size checks
In-Reply-To: <20190813124814.A17F320578@mail.kernel.org>
References: <1565636582-9802-1-git-send-email-isaacm@codeaurora.org>
 <20190813124814.A17F320578@mail.kernel.org>
Message-ID: <6950d1b480ef9b0398ca425ade6f1eee@codeaurora.org>
X-Sender: isaacm@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-08-13 05:48, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: ee7e5516be4f generic: per-device coherent dma allocator.
> 
> The bot has tested the following trees: v5.2.8, v4.19.66, v4.14.138,
> v4.9.189, v4.4.189.
> 
> v5.2.8: Build OK!
> v4.19.66: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> v4.14.138: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> v4.9.189: Failed to apply! Possible dependencies:
>     43fc509c3efb ("dma-coherent: introduce interface for default DMA 
> pool")
>     92f66f84d969 ("arm64: Fix the DMA mmap and get_sgtable API with
> DMA_ATTR_FORCE_CONTIGUOUS")
>     93228b44c33a ("drivers: dma-coherent: Introduce default DMA pool")
>     c41f9ea998f3 ("drivers: dma-coherent: Account dma_pfn_offset when
> used with device tree")
> 
> v4.4.189: Failed to apply! Possible dependencies:
>     052c96dbe33b ("arc: convert to dma_map_ops")
>     20d666e41166 ("dma-mapping: remove <asm-generic/dma-coherent.h>")
>     340f3039acd6 ("m68k: convert to dma_map_ops")
>     4605f04b2893 ("c6x: convert to dma_map_ops")
>     5348c1e9e0dc ("metag: convert to dma_map_ops")
>     5a1a67f1d7fe ("nios2: convert to dma_map_ops")
>     6f62097583e7 ("blackfin: convert to dma_map_ops")
>     79387179e2e4 ("parisc: convert to dma_map_ops")
>     a34a517ac96c ("avr32: convert to dma_map_ops")
>     e1c7e324539a ("dma-mapping: always provide the dma_map_ops based
> implementation")
>     e20dd88995df ("cris: convert to dma_map_ops")
>     eae075196305 ("frv: convert to dma_map_ops")
>     f151341ca00e ("mn10300: convert to dma_map_ops")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is 
> upstream.
> 
> How should we proceed with this patch?
> 
> --
> Thanks,
> Sasha

If everyone is okay with this patch, then we can just apply it on the 
mainline kernel.
The change can be backported to the older kernels at a later point in 
time.

Thanks,
Isaac
