Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F3559248D
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242555AbiHNQct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243061AbiHNQby (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:31:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226AB23BF7;
        Sun, 14 Aug 2022 09:26:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5C5A60F49;
        Sun, 14 Aug 2022 16:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2D7C433D6;
        Sun, 14 Aug 2022 16:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494393;
        bh=iWJWUz344lCyYNJJ7lliPy3Fs2pinpwuoHwp3qll1kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBpahoM8DGAQdzgJT7jMktWsovag1CjEeLaB5sKs3tAa5PPBFXW1U6Y9SaAlJyhky
         7scG5ooqslVNEvuHAfWCtNEoGIa03mXHJ0ZUyE4ZR+k1MNI+X+82z8E2MbizkfILVB
         f39Dr9gDzYap5r9NcTxh/LlSgWbAkj6p2+t5ijTTzzLSgiSd+5susB4KYzCUx/0MWB
         7Ri7rIf0ttuqeuDfJkjRFbUeJV6Td01QY85a4elps4L9eTrqU0ViFdmgnyGcJAWmZ2
         83t+pidvnPc8Uk5WqYG8nPnGNpcMgQ6ewktpm+GIWRxCdxgTBDsV+RGr0FSpOtWWOA
         quIIsvtGBVPQQ==
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
Subject: [PATCH AUTOSEL 5.15 09/28] riscv: dts: sifive: Add fu540 topology information
Date:   Sun, 14 Aug 2022 12:25:49 -0400
Message-Id: <20220814162610.2397644-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162610.2397644-1-sashal@kernel.org>
References: <20220814162610.2397644-1-sashal@kernel.org>
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
index 64c06c9b41dc..87d6e5a4253f 100644
--- a/arch/riscv/boot/dts/sifive/fu540-c000.dtsi
+++ b/arch/riscv/boot/dts/sifive/fu540-c000.dtsi
@@ -133,6 +133,30 @@ cpu4_intc: interrupt-controller {
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

