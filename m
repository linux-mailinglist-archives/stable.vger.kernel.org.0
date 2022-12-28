Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E24365795A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbiL1PAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbiL1PAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:00:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCC012746
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:00:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43FBEB8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D54C433EF;
        Wed, 28 Dec 2022 15:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239605;
        bh=qHNKDTYQZ7r6fbuZ4CQddHe5QhJgh9PS3kiUugWEc5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xz/SwZeKL9/10h8Szpo7izfjBQayHQS7N20i58CcKRWhxGgj+dsfYmvzbyxshRTwz
         B8tW86N5AHjnIf69eQHzF/xjfbgfX5BWsLIOzQ5SqXNzulzxnp2IrW+jvUtDKSiDe6
         MrSaV8kBmGTl4yCTjIvvT0nZgNQJ8UlqXXsosZy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0018/1146] ARM: dts: stm32: Drop stm32mp15xc.dtsi from Avenger96
Date:   Wed, 28 Dec 2022 15:25:57 +0100
Message-Id: <20221228144330.667452205@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 3b835f1b8acef53c8882b25f40f48d7f5982c938 ]

The Avenger96 is populated with STM32MP157A DHCOR SoM, drop the
stm32mp15xc.dtsi which should only be included in DTs of devices
which are populated with STM32MP15xC/F SoC as the stm32mp15xc.dtsi
enables CRYP block not present in the STM32MP15xA/D SoC .

Fixes: 7e76f82acd9e1 ("ARM: dts: stm32: Split Avenger96 into DHCOR SoM and Avenger96 board")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts b/arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts
index 2e3c9fbb4eb3..275167f26fd9 100644
--- a/arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts
+++ b/arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts
@@ -13,7 +13,6 @@
 /dts-v1/;
 
 #include "stm32mp157.dtsi"
-#include "stm32mp15xc.dtsi"
 #include "stm32mp15xx-dhcor-som.dtsi"
 #include "stm32mp15xx-dhcor-avenger96.dtsi"
 
-- 
2.35.1



