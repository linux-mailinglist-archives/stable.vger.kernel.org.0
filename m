Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C0C5E9A09
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 09:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiIZHFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 03:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbiIZHFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 03:05:54 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D4D20BF0;
        Mon, 26 Sep 2022 00:05:51 -0700 (PDT)
X-UUID: 453819600b4d4394b0bae28adba70ee6-20220926
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=y09of+4Ca7fIldBTzPfxeEaCyJ/Ci1lYdycpsFFRdpM=;
        b=dUk2wHyDgSw8BUykyu2VxhHfBVKMKXYp+T41XEoGnGYJQLXGPuQN+PTPMYtyy54k1in2aswwo84b0K81GZKVQC7lRYfRslBjYllj4aho3n3rUviuyQU2vvkrXGfGkvYsi7MFTPqn0lZ5gygOSaGaTEWz2vhkyGqWwVRB0DhHB8o=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:99164de2-f91b-4e02-87fc-5679c1761b19,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-META: VersionHash:39a5ff1,CLOUDID:39260207-1cee-4c38-b21b-a45f9682fdc0,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 453819600b4d4394b0bae28adba70ee6-20220926
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1593890310; Mon, 26 Sep 2022 15:05:45 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Mon, 26 Sep 2022 15:05:44 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Mon, 26 Sep 2022 15:05:44 +0800
From:   Miles Chen <miles.chen@mediatek.com>
To:     <macpaul.lin@mediatek.com>
CC:     <bear.wang@mediatek.com>, <devicetree@vger.kernel.org>,
        <fparent@baylibre.com>, <krzysztof.kozlowski+dt@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <macpaul@gmail.com>, <matthias.bgg@gmail.com>,
        <miles.chen@mediatek.com>, <pablo.sun@mediatek.com>,
        <robh+dt@kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] arm64: dts: mediatek: mt8195-demo: fix the memory size of node secmon
Date:   Mon, 26 Sep 2022 15:05:44 +0800
Message-ID: <20220926070544.13257-1-miles.chen@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220922091648.2821-1-macpaul.lin@mediatek.com>
References: <20220922091648.2821-1-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Macpaul,

> The size of device tree node secmon (bl31_secmon_reserved) was
> incorrect. It should be increased to 2MiB (0x200000).

192K should work when the patch(6147314aeedc) was accepted.
Does the trusted-firmware-a get larger now, so we need to
increase the size to 2MiB?

thanks,
Miles

> 
> The origin setting will cause some abnormal behavior due to
> trusted-firmware-a and related firmware didn't load correctly.
> The incorrect behavior may vary because of different software stacks.
> For example, it will cause build error in some Yocto project because
> it will check if there was enough memory to load trusted-firmware-a
> to the reserved memory.
> 
> Cc: stable@vger.kernel.org      # v5.19
> Fixes: 6147314aeedc ("arm64: dts: mediatek: Add device-tree for MT8195 Demo board")
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
