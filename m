Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5B84BE324
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiBUKA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:00:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353479AbiBUJ53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FF339695;
        Mon, 21 Feb 2022 01:26:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EB7961016;
        Mon, 21 Feb 2022 09:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DFAC340EB;
        Mon, 21 Feb 2022 09:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435571;
        bh=vTNezd7ITeYogPa6Ic5lEnlszyEHwfYUKwFOjDwVfeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFeIsmGjmAtdb6IbDXbgJrJiNskr9o6172dMJDadIZTwmrcWfJKpzqT/vbm/OSck0
         pUzP55gr3eo68WL4YtIQF1MXmpFjV5HI7L/3So+A2WLsP5kTJUDGu0G5E7T1WwaYQt
         sJXlphLBOotkRJurkOBl9joj2L7wQwzcGfcOPgPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 209/227] arm64: dts: meson-g12: add ATF BL32 reserved-memory region
Date:   Mon, 21 Feb 2022 09:50:28 +0100
Message-Id: <20220221084941.776436938@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit 08982a1b3aa2611c9c711d24825c9002d28536f4 ]

Add an additional reserved memory region for the BL32 trusted firmware
present in many devices that boot from Amlogic vendor u-boot.

Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20220126044954.19069-3-christianshewitt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 428449d98c0ae..a3a1ea0f21340 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -107,6 +107,12 @@
 			no-map;
 		};
 
+		/* 32 MiB reserved for ARM Trusted Firmware (BL32) */
+		secmon_reserved_bl32: secmon@5300000 {
+			reg = <0x0 0x05300000 0x0 0x2000000>;
+			no-map;
+		};
+
 		linux,cma {
 			compatible = "shared-dma-pool";
 			reusable;
-- 
2.34.1



