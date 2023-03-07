Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A516AE84B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjCGRPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjCGROa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:14:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125BA8EA33
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:09:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80D3AB819A4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3D8C433EF;
        Tue,  7 Mar 2023 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208954;
        bh=lkMmKqgQxNZWcSW/Ey9R8pBfJOSXKZvGqkUWuwaDhOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QzkdBGrGb8XjEjrgTI8qeYKwyh8b5vqeWhfSojAQmFpZs22oE6atzptpg1ugPP7LL
         hF/N2AHJhV5B7ihj06nsOM5NsEfwfU1XvXy2J4XgKC6Z6tzJI3OpdebrSPtcQ9zbh5
         zILHVJlRCv0JBvmj58DnSXUZpl57R7cuCzN/PVtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Robert Marko <robimarko@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0056/1001] arm64: dts: qcom: ipq8074: fix Gen2 PCIe QMP PHY
Date:   Tue,  7 Mar 2023 17:47:08 +0100
Message-Id: <20230307170024.548019181@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 100d9c94ccf15b02742c326cd04f422ab729153b ]

Serdes register space sizes are incorrect, update them to match the
actual sizes from downstream QCA 5.4 kernel.

Fixes: 942bcd33ed45 ("arm64: dts: qcom: Fix IPQ8074 PCIe PHY nodes")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230113164449.906002-1-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index 9dcb48ebc4661..90b0abf8bbbcd 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -242,9 +242,9 @@ pcie_qmp1: phy@8e000 {
 			status = "disabled";
 
 			pcie_phy1: phy@8e200 {
-				reg = <0x8e200 0x16c>,
+				reg = <0x8e200 0x130>,
 				      <0x8e400 0x200>,
-				      <0x8e800 0x4f4>;
+				      <0x8e800 0x1f8>;
 				#phy-cells = <0>;
 				#clock-cells = <0>;
 				clocks = <&gcc GCC_PCIE1_PIPE_CLK>;
-- 
2.39.2



