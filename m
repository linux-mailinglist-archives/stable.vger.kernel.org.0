Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5F253183F
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241008AbiEWRdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241868AbiEWRb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:31:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CE56CA9A;
        Mon, 23 May 2022 10:26:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59FA560B2C;
        Mon, 23 May 2022 17:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B56C385A9;
        Mon, 23 May 2022 17:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326818;
        bh=xxmuGGHwfPjvuitV71R0fm92HyHL15ulKwslD7AyDaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZewEg4IyNA0L/+k8jJiFtazX/61Po54LdfgwN9fYQuB9nsZcu55t+plGYcBCIlT9
         c2QnwIMnU/pYNePKbCGa1ra06QTjQWJLzzkhQzDmQ76zs4dJkSyeRBUiHMieHSSYCe
         c+yQ0Io3lvXUhnaw+tJIQ9JDyEyDfDhM1tHHzut0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jae Hyun Yoo <quic_jaehyoo@quicinc.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 069/158] ARM: dts: aspeed-g6: remove FWQSPID group in pinctrl dtsi
Date:   Mon, 23 May 2022 19:03:46 +0200
Message-Id: <20220523165842.339974289@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jae Hyun Yoo <quic_jaehyoo@quicinc.com>

[ Upstream commit efddaa397cceefb61476e383c26fafd1f8ab6356 ]

FWSPIDQ2 and FWSPIDQ3 are not part of FWSPI18 interface so remove
FWQSPID group in pinctrl dtsi. These pins must be used with the
FWSPI pins that are dedicated for boot SPI interface which provides
same 3.3v logic level.

Fixes: 2f6edb6bcb2f ("ARM: dts: aspeed: Fix AST2600 quad spi group")
Signed-off-by: Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20220329173932.2588289-2-quic_jaehyoo@quicinc.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
index e4775bbceecc..06d60a8540e9 100644
--- a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
+++ b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
@@ -117,11 +117,6 @@ pinctrl_fwspid_default: fwspid_default {
 		groups = "FWSPID";
 	};
 
-	pinctrl_fwqspid_default: fwqspid_default {
-		function = "FWSPID";
-		groups = "FWQSPID";
-	};
-
 	pinctrl_fwspiwp_default: fwspiwp_default {
 		function = "FWSPIWP";
 		groups = "FWSPIWP";
-- 
2.35.1



