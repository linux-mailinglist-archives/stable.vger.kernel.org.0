Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83495592496
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242566AbiHNQc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243077AbiHNQbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:31:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2E9F51;
        Sun, 14 Aug 2022 09:26:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25489B80B79;
        Sun, 14 Aug 2022 16:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D17C433D6;
        Sun, 14 Aug 2022 16:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494397;
        bh=LH+qngev9GVWoKdABacpYK8mUUp5zBmrIWwMEfqludM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WhrWFqqkj7Jlj/3tVDy5gZqe9yMwOSW2XsbugGFMcs7KWvZsCn+6tpNVVdivkfVZS
         ClXHbTxJcEV3Nz4QbCh4H7gSLKFxyk+FrPytKQAPbGJeWDXY0rWu2933dcgcvvziDL
         MzbNyGodzuyod33EDMy3A9J9kkVPvhABuxhYHspkXoZkzJxrfhDnBGmxqn6gFh37dM
         QxKdgQ2TFtiqoCE2HUON4dOSUHme5CIcB04de0nJZIDYikU1iZLOeoaBa+IafYbaBB
         kO+DUXN6dTqGfiEaXQ65Sb/dm4eOJIyLPgFFWdNfoto3KzE9rSqbMJsr3tkOMu7kzW
         shOg02ve9E6VA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Brice Goglin <Brice.Goglin@inria.fr>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, geert@linux-m68k.org,
        sboyd@kernel.org, zong.li@sifive.com, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 10/28] riscv: dts: sifive: Add fu740 topology information
Date:   Sun, 14 Aug 2022 12:25:50 -0400
Message-Id: <20220814162610.2397644-10-sashal@kernel.org>
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

[ Upstream commit bf6cd1c01c959a31002dfa6784c0d8caffed4cf1 ]

The fu740 has no cpu-map node, so tools like hwloc cannot correctly
parse the topology. Add the node using the existing node labels.

Reported-by: Brice Goglin <Brice.Goglin@inria.fr>
Link: https://github.com/open-mpi/hwloc/issues/536
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20220705190435.1790466-4-mail@conchuod.ie
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/sifive/fu740-c000.dtsi | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/riscv/boot/dts/sifive/fu740-c000.dtsi b/arch/riscv/boot/dts/sifive/fu740-c000.dtsi
index abbb960f90a0..454079a69ab4 100644
--- a/arch/riscv/boot/dts/sifive/fu740-c000.dtsi
+++ b/arch/riscv/boot/dts/sifive/fu740-c000.dtsi
@@ -134,6 +134,30 @@ cpu4_intc: interrupt-controller {
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

