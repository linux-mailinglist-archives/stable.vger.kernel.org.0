Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40EE86A7329
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjCASNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjCASNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:13:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573801C302
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:13:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AFA9B810C3
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63346C4339B;
        Wed,  1 Mar 2023 18:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694394;
        bh=TTVb/FAA0tZrNRdTGBMrBBucjEXf/rsl3YeQsmLViO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7FIZkiV9+NjjJCJl38N/bs5EsvbSXjRgBjh+thfzyFPK2HvNkmYwXFqYT9p6BakP
         Rq4I32HAD51pGVQ0IOD2HK7XcR7X+qM2DQ5FQpTdhi0ZldcHBrBvWKDU774+zlFgaW
         /Yst+NowgAvtEeyWkF5nc5bYEb7Td2UjeMQmAJoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.1 33/42] arm64: dts: uniphier: Fix property name in PXs3 USB node
Date:   Wed,  1 Mar 2023 19:08:54 +0100
Message-Id: <20230301180658.545313154@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

commit 2508d5efd7a588d07915a762e1731173854525f9 upstream.

The property "snps,usb2_gadget_lpm_disable" is wrong.
It should be fixed to "snps,usb2-gadget-lpm-disable".

Cc: stable@vger.kernel.org
Fixes: 19fee1a1096d ("arm64: dts: uniphier: Add USB-device support for PXs3 reference board")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/20230207021429.28925-1-hayashi.kunihiko@socionext.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts | 2 +-
 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts
index 7069f51bc120..99136adb1857 100644
--- a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts
+++ b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts
@@ -24,7 +24,7 @@
 	snps,dis_enblslpm_quirk;
 	snps,dis_u2_susphy_quirk;
 	snps,dis_u3_susphy_quirk;
-	snps,usb2_gadget_lpm_disable;
+	snps,usb2-gadget-lpm-disable;
 	phy-names = "usb2-phy", "usb3-phy";
 	phys = <&usb0_hsphy0>, <&usb0_ssphy0>;
 };
diff --git a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts
index a3cfa8113ffb..4c960f455461 100644
--- a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts
+++ b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts
@@ -24,7 +24,7 @@
 	snps,dis_enblslpm_quirk;
 	snps,dis_u2_susphy_quirk;
 	snps,dis_u3_susphy_quirk;
-	snps,usb2_gadget_lpm_disable;
+	snps,usb2-gadget-lpm-disable;
 	phy-names = "usb2-phy", "usb3-phy";
 	phys = <&usb1_hsphy0>, <&usb1_ssphy0>;
 };
-- 
2.39.2



