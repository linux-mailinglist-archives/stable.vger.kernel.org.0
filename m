Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FBC4CF01F
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 04:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiCGDZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 22:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiCGDZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 22:25:19 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BB24B427;
        Sun,  6 Mar 2022 19:24:25 -0800 (PST)
X-UUID: 5d3369bb49df482c9fe9d60bd641ae74-20220307
X-UUID: 5d3369bb49df482c9fe9d60bd641ae74-20220307
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <yf.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1177677395; Mon, 07 Mar 2022 11:24:20 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Mon, 7 Mar 2022 11:24:19 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Mar 2022 11:24:18 +0800
From:   <yf.wang@mediatek.com>
To:     <iommu@lists.linux-foundation.org>
CC:     <Libo.Kang@mediatek.com>, <Ning.Li@mediatek.com>,
        <john.garry@huawei.com>, <joro@8bytes.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <stable@vger.kernel.org>, <will@kernel.org>,
        <wsd_upstream@mediatek.com>, <yf.wang@mediatek.com>
Subject: RE: [PATCH] iommu/iova: Free all CPU rcache for retry when iova alloc failure
Date:   Mon, 7 Mar 2022 11:18:18 +0800
Message-ID: <20220307031818.22875-1-yf.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <33c2e244-95ef-406a-15eb-574cdf61b159@huawei.com>
References: <33c2e244-95ef-406a-15eb-574cdf61b159@huawei.com>
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

On 2022-03-04 9:22, John Garry wrote:
> On 04/03/2022 04:46, yf.wang--- via iommu wrote:
> > ************* MEDIATEK Confidentiality Notice ********************
> > The 
> > information contained in this e-mail message (including any
> > attachments) may be confidential, proprietary, privileged, or 
> > otherwise exempt from disclosure under applicable laws. It is
> > intended 
> > to be
> 
> Can you please stop sending patches with this?

Hi John,

I will remote it later.

Thanks,
Yunfei.
