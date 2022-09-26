Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEC65EA492
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238519AbiIZLrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238514AbiIZLp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:45:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6441B74BB8;
        Mon, 26 Sep 2022 03:47:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02B4960A36;
        Mon, 26 Sep 2022 10:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1272BC433C1;
        Mon, 26 Sep 2022 10:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189174;
        bh=J/fD2m4D+RAJIbJ4ywOImke5ptOLROIsQy4z/Q0yhfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/eo2cm+sOPOifoapjDiCahAh9cIiDQqypXjasoRFpkVeqJ6M2QINareJFUQdmVm3
         CTAru0CkRofwwjJXJZzxjZvMYApCsAX0NB0isWUC94pdyK5cfOxaGnpekwkojdogPZ
         1nzTNPtUL63OcLzJynBQlD/+Gib5pwVV959w4va4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 096/207] arm64: dts: tqma8mqml: Include phy-imx8-pcie.h header
Date:   Mon, 26 Sep 2022 12:11:25 +0200
Message-Id: <20220926100810.894474099@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 70ae49c5ac876f0f4689889588544104209c09c4 ]

imx8mm-tqma8mqml.dtsi has PCIe support, so it should include
<dt-bindings/phy/phy-imx8-pcie.h>.

Otherwise, there are build errors when this SoM dtsi is included
on customers' carrier boards.

While at it, remove the PCI header from imx8mm-tqma8mqml-mba8mx.dts,
which is now unneeded.

Fixes: 1d84283101fc ("arm64: dts: tqma8mqml: add PCIe support")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts | 1 -
 arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi       | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts b/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts
index 286d2df01cfa..7e0aeb2db305 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts
@@ -5,7 +5,6 @@
 
 /dts-v1/;
 
-#include <dt-bindings/phy/phy-imx8-pcie.h>
 #include "imx8mm-tqma8mqml.dtsi"
 #include "mba8mx.dtsi"
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi
index 16ee9b5179e6..f649dfacb4b6 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi
@@ -3,6 +3,7 @@
  * Copyright 2020-2021 TQ-Systems GmbH
  */
 
+#include <dt-bindings/phy/phy-imx8-pcie.h>
 #include "imx8mm.dtsi"
 
 / {
-- 
2.35.1



