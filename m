Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75DD4EBC9F
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 10:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbiC3IXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 04:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244311AbiC3IXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 04:23:51 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AD433E9B
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 01:22:04 -0700 (PDT)
X-UUID: ce3e6344d2164d5e943adbd904edddec-20220330
X-UUID: ce3e6344d2164d5e943adbd904edddec-20220330
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2014590360; Wed, 30 Mar 2022 16:21:58 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 30 Mar 2022 16:21:57 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 30 Mar 2022 16:21:57 +0800
From:   Miles Chen <miles.chen@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     <yf.wang@mediatek.com>, <miles.chen@mediatek.com>
Subject: suggest commit 5b61343b50 to stable
Date:   Wed, 30 Mar 2022 16:21:57 +0800
Message-ID: <20220330082157.3444-1-miles.chen@mediatek.com>
X-Mailer: git-send-email 2.18.0
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

Hi reviewers,

I suggest to apply the following patch to stable kernel 5.4.y and 5.10.y:

commit: 5b61343b50590fb04a3f6be2cdc4868091757262
Subject: iommu/iova: Improve 32-bit free space estimate
kernel version to apply to: 5.4.y and 5.10.y

Reason:
The patch fix a corner case of iova allocation and the allocation failure
can be found under stress tests.

Test:
The patch can be applied to Linux 5.10.109 and Linux 5.4.188 without conflicts.
Both Linux 5.10.109 and Linux 5.4.188 can be built successfully with
this patch. (ARCH=arm64 defconfig)

Thanks,
Miles
