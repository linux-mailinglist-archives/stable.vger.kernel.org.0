Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15DB51A8F7
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355985AbiEDRMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356958AbiEDRJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BBB473B2;
        Wed,  4 May 2022 09:56:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44A72617A6;
        Wed,  4 May 2022 16:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFBCC385AA;
        Wed,  4 May 2022 16:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683402;
        bh=++xBQbxL3Ke9frkNEa1dCEr1e2uSlVluJFZQcYF6dU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1yTxdlaBQQzDiNH5xScP2UbOnT5vXiBf2Gwc3rXKktqMm2Q2ssVsCxVLDyO8eNXv
         4UHczNnVXthGuuRpb02YA6isLCdol9rbfSx8IEO9C6hciCUVKSmbj3hR/l9cOn2cbc
         6vvp162vz7NJLmLk1IMr2uLBWN2Tgcz/Bjqh3J4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 073/225] arm64: dts: imx8mq-tqma8mq: change the spi-nor tx
Date:   Wed,  4 May 2022 18:45:11 +0200
Message-Id: <20220504153117.948907197@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit c7b45c79fb279e539346919a5c196e417925719e ]

This fixes the qspi read command by importing the changes from commit
04aa946d57b2 ("arm64: dts: imx8: change the spi-nor tx").

Fixes: b186b8b6e770 ("arm64: dts: freescale: add initial device tree for TQMa8Mx with i.MX8M")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq-tqma8mq.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq-tqma8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq-tqma8mq.dtsi
index 8aedcddfeab8..2c63b01e93e0 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-tqma8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-tqma8mq.dtsi
@@ -253,7 +253,7 @@ flash0: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		spi-max-frequency = <84000000>;
-		spi-tx-bus-width = <4>;
+		spi-tx-bus-width = <1>;
 		spi-rx-bus-width = <4>;
 	};
 };
-- 
2.35.1



