Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8CE592436
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241792AbiHNQ33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241580AbiHNQ2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:28:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7431A1D0D0;
        Sun, 14 Aug 2022 09:24:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92CB2B80B7C;
        Sun, 14 Aug 2022 16:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6C4C433B5;
        Sun, 14 Aug 2022 16:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494248;
        bh=9DPDtYyccClLJs//EdauPupiVQGXhPthx19K2X2kN90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YdJNVUPkJuCDdP60wTGL5h8fFbDeoYMLrISf+no4TFne4KFIhjuZT6nLQCOyuDhFc
         nq1Zfcp+rNaqnlUUK74z1fHd289lVSedwZadaAi0G0b97k3eeX1+jALpt3NtXYRniK
         sPcfzpvAi08E6SG9XCF4FQO3e0/us/aZFp1YFULSi7bnIaREoVT49qgWpP2BKaIO1A
         6gwHPLT5c4OCUk42md1lCDJQv1bNOMAo/1CYT9fnQVIbT9+bXIdkdsJT408GGojht5
         U9RjzaDNkRexaXhj2z9vdGC/LbbQsZMvC4bU1+n8hrkpUkrtQBaslsrGfBaSN/sE/+
         fIdcY7rcBzQvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Brice Goglin <Brice.Goglin@inria.fr>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, sboyd@kernel.org,
        geert@linux-m68k.org, zong.li@sifive.com,
        devicetree@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 12/39] riscv: dts: sifive: Add fu740 topology information
Date:   Sun, 14 Aug 2022 12:23:01 -0400
Message-Id: <20220814162332.2396012-12-sashal@kernel.org>
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
index 7b77c13496d8..43bed6c0a84f 100644
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

