Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68664CE152
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 01:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiCEAEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 19:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiCEAEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 19:04:34 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4121D207A0A;
        Fri,  4 Mar 2022 16:03:45 -0800 (PST)
X-UUID: d4708299e3234759b8b7d1d628fb891a-20220305
X-UUID: d4708299e3234759b8b7d1d628fb891a-20220305
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 974430699; Sat, 05 Mar 2022 08:03:38 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Sat, 5 Mar 2022 08:03:37 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 5 Mar 2022 08:03:37 +0800
From:   Miles Chen <miles.chen@mediatek.com>
To:     <robin.murphy@arm.com>
CC:     <iommu@lists.linux-foundation.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <miles.chen@mediatek.com>,
        <stable@vger.kernel.org>, <will@kernel.org>,
        <wsd_upstream@mediatek.com>, <yf.wang@mediatek.com>
Subject: Re: [PATCH] iommu/iova: Improve 32-bit free space estimate
Date:   Sat, 5 Mar 2022 08:03:37 +0800
Message-ID: <20220305000337.24995-1-miles.chen@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <77b0c978-7caa-c333-6015-1d784b5daf3f@arm.com>
References: <77b0c978-7caa-c333-6015-1d784b5daf3f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Joerg, Robin,

> Applied without stable tag for now. If needed, please consider
> re-sending it for stable when this patch is merged upstream.

> Yeah, having figured out the history, I ended up with the opinion that 
> it was a missed corner-case optimisation opportunity, rather than an 
> actual error with respect to intent or implementation, so I 
> intentionally left that out. Plus figuring out an exact Fixes tag might 
> be tricky - as above I reckon it probably only started to become 
> significant somwehere around 5.11 or so.
> 
> All of these various levels of retry mechanisms are only a best-effort 
> thing, and ultimately if you're making large allocations from a small 
> space there are always going to be *some* circumstances that still 
> manage to defeat them. Over time, we've made them try harder, but that 
> fact that we haven't yet made them try hard enough to work well for a 
> particular use-case does not constitute a bug. However as Joerg says, 
> anyone's welcome to make a case to Greg to backport a mainline commit if 
> it's a low-risk change with significant benefit to real-world stable 
> kernel users.

Got it, thank you. 
We will try to push to the android LTS trees we need.

Thanks,
Miles

> 
> Thanks all!
> 
> Robin.
