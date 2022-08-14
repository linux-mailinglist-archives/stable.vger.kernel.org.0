Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E457592428
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239990AbiHNQ25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241168AbiHNQ17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:27:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D17C1BE8B;
        Sun, 14 Aug 2022 09:23:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF996B80B7C;
        Sun, 14 Aug 2022 16:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA77C43141;
        Sun, 14 Aug 2022 16:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494229;
        bh=QycXXiRXYvZUqf9kFMY/DwyY1FZDeN0MoDAl5eoQP24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNV9lD6pr/UwkP1ZNXL01p76S6QGlTWtrIpSRf1rT2h86Orz74qEBwStR0YhajYeG
         KriJBvC1czCYoChBzlV9+d8uIODUu5cGyj4gQP/PlJsIiubPSjy+dzs7JLpHB0j5Ja
         CBODuO68X3jcnE3nJdRoLND0SipbMid3VKn9XADuC4RZWyZx2pRIo3NOIZAGtRr9nR
         eSaznbxKIBkMFY93dWbeqeZoc/XnjLiexp0gTY7K0lS7BH/fMwdPmS/qkZvHRlN8eT
         d2ub+nW+QLpoIpWbMAnC2+OXY+uhV1IkvSnyOrMyeUbqPj4bo9N8jgCxRFTmo6SHil
         jsvhl4/XgsbWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Brice Goglin <Brice.Goglin@inria.fr>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>, daire.mcnamara@microchip.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 07/39] riscv: dts: microchip: Add mpfs' topology information
Date:   Sun, 14 Aug 2022 12:22:56 -0400
Message-Id: <20220814162332.2396012-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162332.2396012-1-sashal@kernel.org>
References: <20220814162332.2396012-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 88d319c6abaeb37f0e2323275eaf57a8388e0265 ]

The mpfs has no cpu-map node, so tools like hwloc cannot correctly
parse the topology. Add the node using the existing node labels.

Reported-by: Brice Goglin <Brice.Goglin@inria.fr>
Link: https://github.com/open-mpi/hwloc/issues/536
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/microchip/microchip-mpfs.dtsi    | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
index 2f75e39d2fdd..37c05ba6e6bf 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
@@ -143,6 +143,30 @@ cpu4_intc: interrupt-controller {
 				interrupt-controller;
 			};
 		};
+
+		cpu-map {
+			cluster0 {
+				core0 {
+					cpu = <&cpu0>;
+				};
+
+				core1 {
+					cpu = <&cpu1>;
+				};
+
+				core2 {
+					cpu = <&cpu2>;
+				};
+
+				core3 {
+					cpu = <&cpu3>;
+				};
+
+				core4 {
+					cpu = <&cpu4>;
+				};
+			};
+		};
 	};
 
 	refclk: mssrefclk {
-- 
2.35.1

