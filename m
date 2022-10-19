Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC761603DC8
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiJSJG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbiJSJFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:05:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE98B1DD4;
        Wed, 19 Oct 2022 01:58:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A60E61812;
        Wed, 19 Oct 2022 08:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917F5C433D6;
        Wed, 19 Oct 2022 08:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169831;
        bh=vIO8+0zIbWy8XC0Cc4AMXbfc1zpvWXoPw75Iug1V1jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eu591wkLWY5FSUaCKxMGWreIhz0YpEUX1RcBKinkJnY6ps0CfzZOfUZvt0r6n/2xD
         e36LGQ5NDmNoyIQV5yYS01u1osSg2LrZex1sSfZBE6KyVmdET7XalPYr/062Y3BNYM
         7NYDDD6tHGe4Ly/fsSviT2zbMUycGJuASxvi5Zmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Caleb Connolly <caleb@connolly.tech>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 426/862] arm64: dts: qcom: sdm845-xiaomi-polaris: Fix sde_dsi_active pinctrl
Date:   Wed, 19 Oct 2022 10:28:33 +0200
Message-Id: <20221019083308.786429481@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 5a0504945878b4af7534c1ce668a5678dc0201cf ]

"make dtbs_check" says:

    bias-disable: boolean property with value b'\x00\x00\x00\x00'

Fix this by dropping the offending value.

Fixes: be497abe19bf08fb ("arm64: dts: qcom: Add support for Xiaomi Mi Mix2s")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Caleb Connolly <caleb@connolly.tech>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/629afd26008c2b1ba5822799ea7ea5b5271895e8.1660903997.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
index 7747081b9887..dba7c2693ff5 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
@@ -617,7 +617,7 @@
 		pins = "gpio6", "gpio10";
 		function = "gpio";
 		drive-strength = <8>;
-		bias-disable = <0>;
+		bias-disable;
 	};
 
 	sde_dsi_suspend: sde-dsi-suspend {
-- 
2.35.1



