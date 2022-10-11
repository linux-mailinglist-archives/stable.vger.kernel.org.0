Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E542B5FB5F4
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiJKPAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiJKO6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:58:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A2D9E6A9;
        Tue, 11 Oct 2022 07:52:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DA6AB8124C;
        Tue, 11 Oct 2022 14:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A298C433B5;
        Tue, 11 Oct 2022 14:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499975;
        bh=na+7HFezGN2FQd39+JFPTtDdI+dOFc8VB2mQvPBTYNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUfkFh5czLLd434slEU+UoCMniNQoVhNboIz9BV2YjXRN/1iGVYMwg8vwRYmeiqDb
         PinBOK9b0ACcirbXj60NsToBst14rFcTMwZ9DK8I77E3FVwn19Dgx5GszLzPb64j/x
         1oHZIxw017Wi9Lc05jPx2P23+kyGcQasONbefLIaUU734uJQbVtao9x8AebHOFsizq
         AeCeDi9nf7iuUS1PpBtZbKcfSHpfWiQGlqgwgw7Y+HgoYmDxal+HtbI20alIl3f4ks
         hg1bDVjDmfviXlcMLCWzLwQ1o+KjkMsXx0iVq6dXirRJa/0om2rpkeDgBp5Zge/yY+
         C1086c+0J6qmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 14/26] arm64: dts: imx8mq-librem5: Add bq25895 as max17055's power supply
Date:   Tue, 11 Oct 2022 10:52:21 -0400
Message-Id: <20221011145233.1624013-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145233.1624013-1-sashal@kernel.org>
References: <20221011145233.1624013-1-sashal@kernel.org>
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

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit 6effe295e1a87408033c29dbcea9d5a5c8b937d5 ]

This allows the userspace to notice that there's not enough
current provided to charge the battery, and also fixes issues
with 0% SOC values being considered invalid.

Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi b/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
index 460ef0d86540..c86cd20d4e70 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
@@ -967,6 +967,7 @@ bat: fuel-gauge@36 {
 		interrupts = <20 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_gauge>;
+		power-supplies = <&bq25895>;
 		maxim,over-heat-temp = <700>;
 		maxim,over-volt = <4500>;
 		maxim,rsns-microohm = <5000>;
-- 
2.35.1

