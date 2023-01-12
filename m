Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606F96673EF
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbjALOBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234270AbjALOAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:00:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC3B53280
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:00:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A5EDB81E6D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EA0C433EF;
        Thu, 12 Jan 2023 14:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532038;
        bh=Ws6JxjOE0cyqbqFW1RBire7KAQYzyONk1Aq1pWi7DxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zuB5s8amJmb4VBadyzdpXT1wlZQlu3G7sR3BgoU/xa2OIweqcLHy9tQ6FhkRCXmkP
         9V804t1nHZYHRNJ02tJH8ZvGS+WYHtAmIHVRhhYztGuHwug1lThP6wSy/6T9cR68Az
         KWUMVdAfnZrR+yCcxTdnjUvJcomTP5f48fsYUuzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/783] ARM: dts: armada-375: Fix assigned-addresses for every PCIe Root Port
Date:   Thu, 12 Jan 2023 14:45:48 +0100
Message-Id: <20230112135525.642965947@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit 823956d2436f70ced74c0fe8ab99facd8abfc060 ]

BDF of resource in DT assigned-addresses property of Marvell PCIe Root Port
(PCI-to-PCI bridge) should match BDF in address part in that DT node name
as specified resource belongs to Marvell PCIe Root Port itself.

Fixes: 4de59085091f ("ARM: mvebu: add Device Tree description of the Armada 375 SoC")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-375.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-375.dtsi b/arch/arm/boot/dts/armada-375.dtsi
index 9805e507c695..d117fc4ae6d9 100644
--- a/arch/arm/boot/dts/armada-375.dtsi
+++ b/arch/arm/boot/dts/armada-375.dtsi
@@ -582,7 +582,7 @@ pcie0: pcie@1,0 {
 
 			pcie1: pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x44000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
-- 
2.35.1



