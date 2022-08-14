Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40FF5923AD
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242123AbiHNQXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241356AbiHNQWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:22:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D361FF1A;
        Sun, 14 Aug 2022 09:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7114E60F40;
        Sun, 14 Aug 2022 16:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B3BC433D6;
        Sun, 14 Aug 2022 16:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494043;
        bh=t3xlxbpc+pSeSGh1Ge9cevaG2rWDIJOPlc1y8yJahgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pID84kgD9Nv32PRGYuHUs04X1lgSb8g4LaeXl4u8cPG9sUNX3iSE/3gTaw3ucOJNP
         DjsXUL8oFIIDu4hDFZnHYj07DTTudZwTP4Hwol2o3dm/7VaONfHKepO2cttH6GDG3t
         0sVu8kzjO4aKYQ/5qEVTUO+hK+Rdw+lVcUQD9d568kJEmeWtFjyPwDM5oSRWFT0D9U
         xoAFvAmsuqXyKuvMudUM6yc45svPYuh37XN1Makzhg2neEyTCFsXMhE50n43Vm7xFg
         V1Jup/4T8F3VhHMhl3XIXKznM+j8Hq+zfZPZC3BE9L616e+S1V0yctrpNOqAPc0sjt
         3iYCTzjtI9WHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Brice Goglin <Brice.Goglin@inria.fr>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, niklas.cassel@wdc.com,
        geert@linux-m68k.org, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 18/48] riscv: dts: canaan: Add k210 topology information
Date:   Sun, 14 Aug 2022 12:19:11 -0400
Message-Id: <20220814161943.2394452-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
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

[ Upstream commit d9d193dea8666bbf69fc21c5bdcdabaa34a466e3 ]

The k210 has no cpu-map node, so tools like hwloc cannot correctly
parse the topology. Add the node using the existing node labels.

Reported-by: Brice Goglin <Brice.Goglin@inria.fr>
Link: https://github.com/open-mpi/hwloc/issues/536
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Link: https://lore.kernel.org/r/20220705190435.1790466-6-mail@conchuod.ie
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/canaan/k210.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/riscv/boot/dts/canaan/k210.dtsi b/arch/riscv/boot/dts/canaan/k210.dtsi
index 44d338514761..ec944d1537dc 100644
--- a/arch/riscv/boot/dts/canaan/k210.dtsi
+++ b/arch/riscv/boot/dts/canaan/k210.dtsi
@@ -65,6 +65,18 @@ cpu1_intc: interrupt-controller {
 				compatible = "riscv,cpu-intc";
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
+			};
+		};
 	};
 
 	sram: memory@80000000 {
-- 
2.35.1

