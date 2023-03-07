Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63656AE879
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjCGRQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjCGRPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:15:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CF794A5E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:11:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08BBEB8199E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AB1C433D2;
        Tue,  7 Mar 2023 17:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209079;
        bh=WSxrCnlHBqY07jRR3K2uwS1/jl2abgMueD47yVC6aY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NI8WR0RlKCKktLJXaIVYv7E3Qg8cRdoA4sGjS6c+9JJWTLS4LLqdJaboUatEfdUwv
         aMolWqXD3IrHyoEcnx8g0oMh+ByKlnrhMFb8zpP2rHRRKSJErg0uenMrA2HVwY1sO3
         +jOD8mjvt+lEkqp1w9+A/oOmvTovsqSWH4S2/R5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0104/1001] ARM: dts: stm32: Update part number NVMEM description on stm32mp131
Date:   Tue,  7 Mar 2023 17:47:56 +0100
Message-Id: <20230307170026.658110437@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Delaunay <patrick.delaunay@foss.st.com>

[ Upstream commit 366384e495511bea8583e44173629a3012d62db0 ]

The STM32MP13x Device Part Number (also named RPN in reference manual)
only uses the first 12 bits in OTP4, all the other bit are reserved and
they can be different of zero; they must be masked in NVMEM result, so
the number of bits must be defined in the nvmem cell description.

Fixes: 1da8779c0029 ("ARM: dts: stm32: add STM32MP13 SoCs support")
Signed-off-by: Patrick Delaunay <patrick.delaunay@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp131.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/stm32mp131.dtsi b/arch/arm/boot/dts/stm32mp131.dtsi
index accc3824f7e98..99d88096959eb 100644
--- a/arch/arm/boot/dts/stm32mp131.dtsi
+++ b/arch/arm/boot/dts/stm32mp131.dtsi
@@ -527,6 +527,7 @@ bsec: efuse@5c005000 {
 
 			part_number_otp: part_number_otp@4 {
 				reg = <0x4 0x2>;
+				bits = <0 12>;
 			};
 			ts_cal1: calib@5c {
 				reg = <0x5c 0x2>;
-- 
2.39.2



