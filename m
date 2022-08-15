Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A845942EB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350438AbiHOWmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244050AbiHOWkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:40:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E021F21B4;
        Mon, 15 Aug 2022 12:51:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95164B80EAB;
        Mon, 15 Aug 2022 19:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE99C433D6;
        Mon, 15 Aug 2022 19:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593113;
        bh=jztBd4sZFkZnnNSyY7Gg8qvaMjbW9hiYtsi5arzlBw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkgwN17edshAOHwUv5PdJ7oonU4hsYMPLC10IzYroOlKSk6iY/22xmNsnmOYRth18
         PTjSZZOZ607W0kPvWqOWPI/l2nuSneWoXeZ+/WAGuiC8YN/zxzBYHeDdDxU0GYvdPw
         rJPkD0jZO/3s4L2J0rqZwikDlW04nVKyq+rvdBMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0216/1157] ARM: dts: ast2600-evb-a1: fix board compatible
Date:   Mon, 15 Aug 2022 19:52:52 +0200
Message-Id: <20220815180448.247493103@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 33c39140cc298e0d4e36083cb9a665a837773a60 ]

The AST2600 EVB A1 board should have dedicated compatible.

Fixes: a72955180372 ("ARM: dts: aspeed: ast2600evb: Add dts file for A1 and A0")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220529104928.79636-6-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-ast2600-evb-a1.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/aspeed-ast2600-evb-a1.dts b/arch/arm/boot/dts/aspeed-ast2600-evb-a1.dts
index dd7148060c4a..d0a5c2ff0fec 100644
--- a/arch/arm/boot/dts/aspeed-ast2600-evb-a1.dts
+++ b/arch/arm/boot/dts/aspeed-ast2600-evb-a1.dts
@@ -5,6 +5,7 @@
 
 / {
 	model = "AST2600 A1 EVB";
+	compatible = "aspeed,ast2600-evb-a1", "aspeed,ast2600";
 
 	/delete-node/regulator-vcc-sdhci0;
 	/delete-node/regulator-vcc-sdhci1;
-- 
2.35.1



