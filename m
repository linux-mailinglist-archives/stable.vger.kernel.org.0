Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FAD474645
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 16:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbhLNPSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 10:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235369AbhLNPSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 10:18:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8F5C061574;
        Tue, 14 Dec 2021 07:18:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58F1B6156E;
        Tue, 14 Dec 2021 15:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CDBC34606;
        Tue, 14 Dec 2021 15:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639495123;
        bh=EtXNCqqEF5z7tNX4x034w1DmPhsexirc5bJSadieaTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVm5vp4S50b4rGVhdHXirrlW9wzjjz4QmXBPKuTPQVSv/iN+1KZIYc+ukAokyG3NL
         5EYAUnXwYT8ooc8tJFGmtoEDjqtHvO/PwLht9tW7rIei49/5ZuWUxgnlpm7jakwUu4
         RuZaKfNUYRG5L0hCu6TcCcKyzOWrAVuaD+FuRTe4jxKgYgYc9svs4ZyN6qkE8nUKwS
         BBukGp4WcOJykx+A28YWnsysRITIEDLDwZiQ5HX90vpD9G0x8B4JfDDHdcfWMZtmGM
         APhy0y3yr6Hpsir8HXkbr5sLUFrMdYOmyezphCTsrTIhyRE4DNECZMowppwfbBJRHo
         peKqoXbWSIPFw==
From:   Will Deacon <will@kernel.org>
To:     yf.wang@mediatek.com
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, Guangming.Cao@mediatek.com,
        linux-mediatek@lists.infradead.org,
        iommu@lists.linux-foundation.org, wsd_upstream@mediatek.com,
        Libo.Kang@mediatek.com, linux-kernel@vger.kernel.org,
        robin.murphy@arm.com, matthias.bgg@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] iommu/io-pgtable-arm-v7s: Add error handle for page table allocation failure
Date:   Tue, 14 Dec 2021 15:18:17 +0000
Message-Id: <163949313634.2865984.16870619152235318237.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211207113315.29109-1-yf.wang@mediatek.com>
References: <20211207094817.GA31382@willie-the-truck> <20211207113315.29109-1-yf.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 Dec 2021 19:33:15 +0800, yf.wang@mediatek.com wrote:
> From: Yunfei Wang <yf.wang@mediatek.com>
> 
> In __arm_v7s_alloc_table function:
> iommu call kmem_cache_alloc to allocate page table, this function
> allocate memory may fail, when kmem_cache_alloc fails to allocate
> table, call virt_to_phys will be abnomal and return unexpected phys
> and goto out_free, then call kmem_cache_free to release table will
> trigger KE, __get_free_pages and free_pages have similar problem,
> so add error handle for page table allocation failure.
> 
> [...]

Applied to will (for-joerg/arm-smmu/updates), thanks!

[1/1] iommu/io-pgtable-arm-v7s: Add error handle for page table allocation failure
      https://git.kernel.org/will/c/a556cfe4cabc

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
