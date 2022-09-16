Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8C25BAA6A
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiIPKTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbiIPKS0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:18:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8688AAF4BB;
        Fri, 16 Sep 2022 03:12:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4A10629E6;
        Fri, 16 Sep 2022 10:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1771C433C1;
        Fri, 16 Sep 2022 10:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323120;
        bh=aE3XUsx9yhCv47JRVJw4tRPM/gRu82FTTx4OBbvS8zM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izkDt8jqHJLd/CI6iuwo5CAjBEzRUiPNf4xsWzBR5K4w0Cwgy8rZKmRcOPWOANznz
         12ouQODg+5VbAaDbn559W1fWSN4rWpEKt//VsvWbYsO8OcQTLxLDph85GxvY71gCAz
         L6Av++mJbWLPHri15CjcC9G8/rsnwtOU6/iXP+zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/35] ARM: dts: imx6qdl-kontron-samx6i: fix spi-flash compatible
Date:   Fri, 16 Sep 2022 12:08:27 +0200
Message-Id: <20220916100447.120642135@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
References: <20220916100446.916515275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit af7d78c957017f8b3a0986769f6f18e57f9362ea ]

Drop the "winbond,w25q16dw" compatible since it causes to set the
MODALIAS to w25q16dw which is not specified within spi-nor id table.
Fix this by use the common "jedec,spi-nor" compatible.

Fixes: 2125212785c9 ("ARM: dts: imx6qdl-kontron-samx6i: add Kontron SMARC SoM Support")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index f159c58b9edba..6b791d515e294 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -249,7 +249,7 @@
 
 	/* default boot source: workaround #1 for errata ERR006282 */
 	smarc_flash: flash@0 {
-		compatible = "winbond,w25q16dw", "jedec,spi-nor";
+		compatible = "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <20000000>;
 	};
-- 
2.35.1



