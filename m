Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399F96799D3
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbjAXNmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbjAXNmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:42:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDA645BCB;
        Tue, 24 Jan 2023 05:41:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7618DB811E3;
        Tue, 24 Jan 2023 13:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F096FC433D2;
        Tue, 24 Jan 2023 13:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567715;
        bh=qbSGnQlAtzWva+t/AgMOcqav+DHSqPi2FkRVLWcY2gI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gp1tGude3zlPFvkANSSfPuIVp8lYgKmYtopyLunSSdHW2HDkCbOio1up9XaiEBbBc
         8d0f0DLK7u1ShTeOFjMSY81tvVkywuqQqPi2dGyewqGsI14aTMH86H194cCVineCDV
         PVTNMpyKqJ5XzlIemgQbzfxMt7HOY9DamVD7kTh9I8A8Uq/CX/nuyQJBhdqSjIDKqc
         e2EttjguMSxcLVTI7PiVRIvFMLsVQ/6/Qi7Ad0GLBKPMvIxiCroylYJh8CzfsbO3O6
         9oN0S2RFK/0RE4GZ6AHaE5X9cOv/x7y7j3avz046cEe/qGzYwSxoq7wEc9F8hWzW6q
         fRVthYKO1kI7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dominik Kobinski <dominikkobinski314@gmail.com>,
        Petr Vorel <petr.vorel@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 09/35] arm64: dts: msm8994-angler: fix the memory map
Date:   Tue, 24 Jan 2023 08:41:05 -0500
Message-Id: <20230124134131.637036-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
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

From: Dominik Kobinski <dominikkobinski314@gmail.com>

[ Upstream commit 380cd3a34b7f9825a60ccb045611af9cb4533b70 ]

Add reserved regions for memory hole and tz app mem to prevent
rebooting. Also enable cont_splash_mem, it is the same as the
generic 8994 one.

Reported-by: Petr Vorel <petr.vorel@gmail.com>
Signed-off-by: Dominik Kobinski <dominikkobinski314@gmail.com>
Reviewed-by: Petr Vorel <petr.vorel@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221230194845.57780-1-dominikkobinski314@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../qcom/msm8994-huawei-angler-rev-101.dts    | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
index dbfbb77e9ff5..7e2c0dcc11ab 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
@@ -8,9 +8,6 @@
 
 #include "msm8994.dtsi"
 
-/* Angler's firmware does not report where the memory is allocated */
-/delete-node/ &cont_splash_mem;
-
 / {
 	model = "Huawei Nexus 6P";
 	compatible = "huawei,angler", "qcom,msm8994";
@@ -27,6 +24,22 @@ aliases {
 	chosen {
 		stdout-path = "serial0:115200n8";
 	};
+
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		tzapp_mem: tzapp@4800000 {
+			reg = <0 0x04800000 0 0x1900000>;
+			no-map;
+		};
+
+		removed_region: reserved@6300000 {
+			reg = <0 0x06300000 0 0xD00000>;
+			no-map;
+		};
+	};
 };
 
 &blsp1_uart2 {
-- 
2.39.0

