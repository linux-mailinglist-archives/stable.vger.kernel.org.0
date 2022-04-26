Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CB850F78E
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343758AbiDZJI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346398AbiDZJEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:04:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E89E5E30;
        Tue, 26 Apr 2022 01:43:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B3A160C43;
        Tue, 26 Apr 2022 08:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C7AC385A0;
        Tue, 26 Apr 2022 08:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962629;
        bh=vdB1mcr+hQGostS7uAzJApdd0uO8++TjEPTRv0E3UK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDPvC918Bo6GFKKdsoxJpPzvZhOeMiN0k3bzt48awBx2yfHb4FTS4qnR/Ga8peVKY
         8CiZzhgK1UfFzNjJZA3N6+UXRfZs3iEZPwXJCMrZ5Q3L1MHZkj6PADJr0k4q5nWk8O
         3727fsBbCUv81S9SdmWqEyhRcrTcrfH4HwUaEVmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 036/146] net: restore alpha order to Ethernet devices in config
Date:   Tue, 26 Apr 2022 10:20:31 +0200
Message-Id: <20220426081751.083023077@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit da367ac74aecb59b62a9538009d4aee8ce4bdfb3 ]

The displayed list of Ethernet devices in make menuconfig
has gotten out of order. This is mostly due to changes in vendor
names etc, but also because of new Microsoft entry in wrong place.

This restores so that the display is in order even if the names
of the sub directories are not.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/Kconfig | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index db3ec4768159..7a730c9d4bdf 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -35,15 +35,6 @@ source "drivers/net/ethernet/aquantia/Kconfig"
 source "drivers/net/ethernet/arc/Kconfig"
 source "drivers/net/ethernet/asix/Kconfig"
 source "drivers/net/ethernet/atheros/Kconfig"
-source "drivers/net/ethernet/broadcom/Kconfig"
-source "drivers/net/ethernet/brocade/Kconfig"
-source "drivers/net/ethernet/cadence/Kconfig"
-source "drivers/net/ethernet/calxeda/Kconfig"
-source "drivers/net/ethernet/cavium/Kconfig"
-source "drivers/net/ethernet/chelsio/Kconfig"
-source "drivers/net/ethernet/cirrus/Kconfig"
-source "drivers/net/ethernet/cisco/Kconfig"
-source "drivers/net/ethernet/cortina/Kconfig"
 
 config CX_ECAT
 	tristate "Beckhoff CX5020 EtherCAT master support"
@@ -57,6 +48,14 @@ config CX_ECAT
 	  To compile this driver as a module, choose M here. The module
 	  will be called ec_bhf.
 
+source "drivers/net/ethernet/broadcom/Kconfig"
+source "drivers/net/ethernet/cadence/Kconfig"
+source "drivers/net/ethernet/calxeda/Kconfig"
+source "drivers/net/ethernet/cavium/Kconfig"
+source "drivers/net/ethernet/chelsio/Kconfig"
+source "drivers/net/ethernet/cirrus/Kconfig"
+source "drivers/net/ethernet/cisco/Kconfig"
+source "drivers/net/ethernet/cortina/Kconfig"
 source "drivers/net/ethernet/davicom/Kconfig"
 
 config DNET
@@ -84,7 +83,6 @@ source "drivers/net/ethernet/huawei/Kconfig"
 source "drivers/net/ethernet/i825xx/Kconfig"
 source "drivers/net/ethernet/ibm/Kconfig"
 source "drivers/net/ethernet/intel/Kconfig"
-source "drivers/net/ethernet/microsoft/Kconfig"
 source "drivers/net/ethernet/xscale/Kconfig"
 
 config JME
@@ -127,8 +125,9 @@ source "drivers/net/ethernet/mediatek/Kconfig"
 source "drivers/net/ethernet/mellanox/Kconfig"
 source "drivers/net/ethernet/micrel/Kconfig"
 source "drivers/net/ethernet/microchip/Kconfig"
-source "drivers/net/ethernet/moxa/Kconfig"
 source "drivers/net/ethernet/mscc/Kconfig"
+source "drivers/net/ethernet/microsoft/Kconfig"
+source "drivers/net/ethernet/moxa/Kconfig"
 source "drivers/net/ethernet/myricom/Kconfig"
 
 config FEALNX
@@ -140,10 +139,10 @@ config FEALNX
 	  Say Y here to support the Myson MTD-800 family of PCI-based Ethernet
 	  cards. <http://www.myson.com.tw/>
 
+source "drivers/net/ethernet/ni/Kconfig"
 source "drivers/net/ethernet/natsemi/Kconfig"
 source "drivers/net/ethernet/neterion/Kconfig"
 source "drivers/net/ethernet/netronome/Kconfig"
-source "drivers/net/ethernet/ni/Kconfig"
 source "drivers/net/ethernet/8390/Kconfig"
 source "drivers/net/ethernet/nvidia/Kconfig"
 source "drivers/net/ethernet/nxp/Kconfig"
@@ -163,6 +162,7 @@ source "drivers/net/ethernet/packetengines/Kconfig"
 source "drivers/net/ethernet/pasemi/Kconfig"
 source "drivers/net/ethernet/pensando/Kconfig"
 source "drivers/net/ethernet/qlogic/Kconfig"
+source "drivers/net/ethernet/brocade/Kconfig"
 source "drivers/net/ethernet/qualcomm/Kconfig"
 source "drivers/net/ethernet/rdc/Kconfig"
 source "drivers/net/ethernet/realtek/Kconfig"
@@ -170,10 +170,10 @@ source "drivers/net/ethernet/renesas/Kconfig"
 source "drivers/net/ethernet/rocker/Kconfig"
 source "drivers/net/ethernet/samsung/Kconfig"
 source "drivers/net/ethernet/seeq/Kconfig"
-source "drivers/net/ethernet/sfc/Kconfig"
 source "drivers/net/ethernet/sgi/Kconfig"
 source "drivers/net/ethernet/silan/Kconfig"
 source "drivers/net/ethernet/sis/Kconfig"
+source "drivers/net/ethernet/sfc/Kconfig"
 source "drivers/net/ethernet/smsc/Kconfig"
 source "drivers/net/ethernet/socionext/Kconfig"
 source "drivers/net/ethernet/stmicro/Kconfig"
-- 
2.35.1



