Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0985924F7
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243063AbiHNQiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242737AbiHNQg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:36:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7EA113F;
        Sun, 14 Aug 2022 09:28:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27770B80B37;
        Sun, 14 Aug 2022 16:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DB4C433C1;
        Sun, 14 Aug 2022 16:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494525;
        bh=tP8nyLUZMqeNmRgDheb7Nrl0KDTu9tGn+e/8TFk4Paw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+ARdsISzluwrk/FH7SwQNEA7l1hjiQBerug6dsB196tY1X7Gx7no/0ynqPtdPH+4
         PUDjliAEVW+5OrEALh8DE+mNjSRYOw18HHDV/jSgWOVMPIg5Bvhb5cHr0MQcEVBiy2
         0wVtZPBM4pfDnTJ83t6eABUQdtmoXQwyn22+4aSc+3pGBcGB0Wah4qaCcC30TSb3+b
         uJVyqUOgqIikamv2uwhSsl+rDsoLu5k9nUOYIhde2ULnx+zJ7E8CTzLhM46mbrjTaT
         3fyrcHWHEDo6RVT3kfp8aNP1eP4+qbslZ9oFaqISnyUjfymqCwi5oTrR4FZ4a5iPqS
         q4yM+Dd69wk9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Brice Goglin <Brice.Goglin@inria.fr>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, palmer@dabbelt.com,
        paul.walmsley@sifive.com, aou@eecs.berkeley.edu,
        geert@linux-m68k.org, zong.li@sifive.com, bmeng.cn@gmail.com,
        devicetree@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 05/16] riscv: dts: sifive: Add fu540 topology information
Date:   Sun, 14 Aug 2022 12:28:20 -0400
Message-Id: <20220814162833.2398478-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162833.2398478-1-sashal@kernel.org>
References: <20220814162833.2398478-1-sashal@kernel.org>
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

[ Upstream commit af8f260abc608c06e4466a282b53f1e2dc09f042 ]

The fu540 has no cpu-map node, so tools like hwloc cannot correctly
parse the topology. Add the node using the existing node labels.

Reported-by: Brice Goglin <Brice.Goglin@inria.fr>
Link: https://github.com/open-mpi/hwloc/issues/536
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20220705190435.1790466-3-mail@conchuod.ie
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/sifive/fu540-c000.dtsi | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/riscv/boot/dts/sifive/fu540-c000.dtsi b/arch/riscv/boot/dts/sifive/fu540-c000.dtsi
index afa43c7ea369..0e4514f32576 100644
--- a/arch/riscv/boot/dts/sifive/fu540-c000.dtsi
+++ b/arch/riscv/boot/dts/sifive/fu540-c000.dtsi
@@ -129,6 +129,30 @@ cpu4_intc: interrupt-controller {
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
 	soc {
 		#address-cells = <2>;
-- 
2.35.1

