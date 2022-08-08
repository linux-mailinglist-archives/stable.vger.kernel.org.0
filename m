Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8075458C033
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243161AbiHHBtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243165AbiHHBs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:48:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F277515FC1;
        Sun,  7 Aug 2022 18:37:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B185760DBB;
        Mon,  8 Aug 2022 01:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38ABFC433C1;
        Mon,  8 Aug 2022 01:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922624;
        bh=FhVTNG+2NCgm7ZoRqLg5i5RITzfyGFyyrNjWQjlN2ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMaqWYdI22uvYVbUUvzGzb4Z+nvlgoFRhdh6TpZKbWUrehC/+nxkGUgy8BazhUVTQ
         q0fMUeQMXkWxdhLelw/4HvLMGSpezo7/PtCuc+T1ruajDpfP9pqQND5QGj6d8bU85x
         VSDoEJRaoqE6+HckVO+JqnCrbgp3fApL0oJKlWQIIQS1uW1hnabx/EWs+P6BtMt0I9
         Kgf0J5VOMlCHAQxNsr53UpNXMbXtgQ6qDoZxjagfcL56qRycFOnZM0qsoveG0rwlx6
         7fyXRxOZb2Rd3nbCX6syccRZch450n67LhIROKImBjVNfWgad759kjCwO9dfDyyRbP
         4fdA9tUxKAgrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 26/45] ARM: dts: ux500: Fix Gavini accelerometer mounting matrix
Date:   Sun,  7 Aug 2022 21:35:30 -0400
Message-Id: <20220808013551.315446-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013551.315446-1-sashal@kernel.org>
References: <20220808013551.315446-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit e24c75f02a81d6ddac0072cbd7a03e799c19d558 ]

This was fixed wrong so fix it. Now verified by using
iio-sensor-proxy monitor-sensor test program.

Link: https://lore.kernel.org/r/20220611205138.491513-1-linus.walleij@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ux500-samsung-gavini.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ux500-samsung-gavini.dts b/arch/arm/boot/dts/ste-ux500-samsung-gavini.dts
index fabc390ccb0c..6c9e812ef03f 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-gavini.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-gavini.dts
@@ -502,8 +502,8 @@ i2c-gate {
 					accelerometer@18 {
 						compatible = "bosch,bma222e";
 						reg = <0x18>;
-						mount-matrix = "0", "1", "0",
-							       "-1", "0", "0",
+						mount-matrix = "0", "-1", "0",
+							       "1", "0", "0",
 							       "0", "0", "1";
 						vddio-supply = <&ab8500_ldo_aux2_reg>; // 1.8V
 						vdd-supply = <&ab8500_ldo_aux1_reg>; // 3V
-- 
2.35.1

