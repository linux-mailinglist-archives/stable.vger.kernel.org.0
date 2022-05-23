Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F67F53191E
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241490AbiEWRda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240950AbiEWR0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708243E5D4;
        Mon, 23 May 2022 10:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37A92B81204;
        Mon, 23 May 2022 17:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A788C385A9;
        Mon, 23 May 2022 17:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326380;
        bh=qnwdIkkYiFCRu6fRjyWwB/vxSHwpyJ8MWSzbKllOeWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Au/SqaJ9+S2OaCLzbkinyiQ0b4fctDsfPLRCyGk+zW50mbu8k855Yv7DcKiJKBdP9
         Ym147LEms95JFZa8Cl2xJIzjqdjE3c6zMxdfW4gLcwJowZsfeL7eCmxitEADhJa4Yk
         qUTqU083fTAqi1a47g35bKvArvR9++/kqxQhJuao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jae Hyun Yoo <quic_jaehyoo@quicinc.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/132] ARM: dts: aspeed-g6: fix SPI1/SPI2 quad pin group
Date:   Mon, 23 May 2022 19:04:33 +0200
Message-Id: <20220523165833.855707916@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
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

[ Upstream commit 890362d41b244536ab63591f813393f5fdf59ed7 ]

Fix incorrect function mappings in pinctrl_qspi1_default and
pinctrl_qspi2_default since their function should be SPI1 and
SPI2 respectively.

Fixes: f510f04c8c83 ("ARM: dts: aspeed: Add AST2600 pinmux nodes")
Signed-off-by: Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20220329173932.2588289-8-quic_jaehyoo@quicinc.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
index 06d60a8540e9..ac07c240419a 100644
--- a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
+++ b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
@@ -648,12 +648,12 @@ pinctrl_pwm9g1_default: pwm9g1_default {
 	};
 
 	pinctrl_qspi1_default: qspi1_default {
-		function = "QSPI1";
+		function = "SPI1";
 		groups = "QSPI1";
 	};
 
 	pinctrl_qspi2_default: qspi2_default {
-		function = "QSPI2";
+		function = "SPI2";
 		groups = "QSPI2";
 	};
 
-- 
2.35.1



