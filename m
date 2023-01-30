Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73006680FCC
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbjA3N5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbjA3N5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:57:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0197E39CDC
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:57:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9462C61028
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BE3C433D2;
        Mon, 30 Jan 2023 13:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087021;
        bh=2OBjSD5wQA2l0uCnNLlTKFxX2UpDFBT8TxV1iUmOCtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZlOxxpv86+hExW58DR2hj9ppaGkOHhkMR47mVkMyzBi/P7TZI6fhZOpvQfRISiXF
         nb/elEbTXRfxJI8cJ/ub3fVcVvmWuF4OvO/1CcOpL6BuRxK3UGQ35f37I2IpdbP7fB
         4QPo/ILCcbr4PicWnRkIk87j7h9P5AhvnoZ/UXFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/313] arm64: dts: marvell: AC5/AC5X: Fix address for UART1
Date:   Mon, 30 Jan 2023 14:47:59 +0100
Message-Id: <20230130134338.745448625@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 80502ffab2fa92ba9777e381efea2efddc348d13 ]

The correct address offset is 0x12100.

Fixes: 31be791e26cf ("arm64: dts: marvell: Add UART1-3 for AC5/AC5X")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi b/arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi
index 44ed6f963b75..8e2ac687a410 100644
--- a/arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi
@@ -97,7 +97,7 @@ uart0: serial@12000 {
 
 			uart1: serial@12100 {
 				compatible = "snps,dw-apb-uart";
-				reg = <0x11000 0x100>;
+				reg = <0x12100 0x100>;
 				reg-shift = <2>;
 				interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
 				reg-io-width = <1>;
-- 
2.39.0



