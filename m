Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8121D66C9C7
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbjAPQ4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbjAPQz5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:55:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505714B1AF
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:38:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AD52B8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E60C433F1;
        Mon, 16 Jan 2023 16:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887132;
        bh=Iv+k1qt2dE+P+obIjqCuvMAVgJ6Ys1BAGipPgiyqWjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DskqgXXTR7jNB8HkgYOTi5qCAdWpvUEilhwklwlBD4M535E5OAZPq7xwkeacPnVEO
         JRkMHen7IqOH3h/X379UFffLrC+R9gBi5srdKsbnuqMEBQlMQuAaCxBhp9Xy9KCURA
         3JRG9V9/bim9qkw98+aoqTdzRhXBPXjp7YaAuiNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 033/521] ARM: dts: armada-370: Fix assigned-addresses for every PCIe Root Port
Date:   Mon, 16 Jan 2023 16:44:55 +0100
Message-Id: <20230116154848.800364745@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Pali Rohár <pali@kernel.org>

[ Upstream commit d9208b0fa2e803d16b28d91bf1d46b7ee9ea13c6 ]

BDF of resource in DT assigned-addresses property of Marvell PCIe Root Port
(PCI-to-PCI bridge) should match BDF in address part in that DT node name
as specified resource belongs to Marvell PCIe Root Port itself.

Fixes: a09a0b7c6ff1 ("arm: mvebu: add PCIe Device Tree informations for Armada 370")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-370.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
index 46e6d3ed8f35..c042c416a94a 100644
--- a/arch/arm/boot/dts/armada-370.dtsi
+++ b/arch/arm/boot/dts/armada-370.dtsi
@@ -74,7 +74,7 @@ pcie0: pcie@1,0 {
 
 			pcie2: pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x80000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
-- 
2.35.1



