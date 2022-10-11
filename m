Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5905FB74C
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbiJKPc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiJKPb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:31:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8A0DF52;
        Tue, 11 Oct 2022 08:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA8C0B8162F;
        Tue, 11 Oct 2022 14:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAD0C43142;
        Tue, 11 Oct 2022 14:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500004;
        bh=mlG4x3B6j3t2lsc9J0zN1tWAJ4ERPXibQbQ2yj3boZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g35buEIJuMa8empsC1SUxbPbQFgvj5n9ZCJJSlnK6Uxg4Mze6Blj74/FDXXHWZjcK
         OjKpbNPIXJYsD7LD66AOT3PypGuNKigdtN2PRwhcPggZ3ZHWbNp9ZlbnUVPRcoP0uP
         JojypHM7dTpBIyOhzh+0mn8a4C1jp7uJFbwlwHlGVXzP25CZVZKcT8ZkWKFpI3QGsq
         CRWzqsG4GrmI/lU8+IS0ol1c+FHpRs3LPB6t1lJ1rNrZxc3FgtUQrxl6GHZWwSGnYq
         Tfnb4Y/hAGJeHhb9ZnPk0eIH5rbH6CTNsD0qDZtP1DdX+ad9jNuzlKHeJLQ72o3zFH
         66Tvw7AMkKGeg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 08/17] ARM: dts: imx6sll: add missing properties for sram
Date:   Tue, 11 Oct 2022 10:53:03 -0400
Message-Id: <20221011145312.1624341-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145312.1624341-1-sashal@kernel.org>
References: <20221011145312.1624341-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 7492a83ed9b7a151e2dd11d64b06da7a7f0fa7f9 ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@900000: '#address-cells' is a required property
sram@900000: '#size-cells' is a required property
sram@900000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sll.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx6sll.dtsi b/arch/arm/boot/dts/imx6sll.dtsi
index 0b622201a1f3..bf5b262b91f9 100644
--- a/arch/arm/boot/dts/imx6sll.dtsi
+++ b/arch/arm/boot/dts/imx6sll.dtsi
@@ -115,6 +115,9 @@ soc {
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 		};
 
 		intc: interrupt-controller@a01000 {
-- 
2.35.1

