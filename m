Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD9665EB3C
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 13:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbjAEM5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 07:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbjAEM53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 07:57:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF8D5006D
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 04:57:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91CF0B81AD0
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 12:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0339DC433F0;
        Thu,  5 Jan 2023 12:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923446;
        bh=blwIcLD+S2/yJhNRurvN7bS9M/FNaBf/WhOgBmF4gtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/wuSdlHo9yiDHHqFpFj0fu1BW/FsWXfxf3O9l+zqiPtzIaOrbSNyu5y1IdFNRSX9
         YKvHGAAdHAM5pHrk1cceEy8gMQ7EME4XnFi8NfvgzDOPbtH7rlvJLzNcg5oRqWDSec
         TljmOTjjCQ5QA6Y1FF6jMgMkZto7lYdqt2cOQSKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 022/251] ARM: dts: armada-375: Fix assigned-addresses for every PCIe Root Port
Date:   Thu,  5 Jan 2023 13:52:39 +0100
Message-Id: <20230105125335.768623475@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 823956d2436f70ced74c0fe8ab99facd8abfc060 ]

BDF of resource in DT assigned-addresses property of Marvell PCIe Root Port
(PCI-to-PCI bridge) should match BDF in address part in that DT node name
as specified resource belongs to Marvell PCIe Root Port itself.

Fixes: 4de59085091f ("ARM: mvebu: add Device Tree description of the Armada 375 SoC")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-375.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-375.dtsi b/arch/arm/boot/dts/armada-375.dtsi
index 024f1b75b0a3..681c8458c8f2 100644
--- a/arch/arm/boot/dts/armada-375.dtsi
+++ b/arch/arm/boot/dts/armada-375.dtsi
@@ -618,7 +618,7 @@ pcie@1,0 {
 
 			pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x44000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
-- 
2.35.1



