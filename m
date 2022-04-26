Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E5B50F667
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237966AbiDZIzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346918AbiDZIux (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:50:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F378170441;
        Tue, 26 Apr 2022 01:39:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 57FF7CE1BB4;
        Tue, 26 Apr 2022 08:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B04C385A0;
        Tue, 26 Apr 2022 08:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962346;
        bh=Qe2fgAm189XICDfRKp2WfFEyRLGDq5+OziHxA7nd2no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmmounRgfadoOBqLRiJhXMXAEitTno8B9sI928aKLoEcfQXTb3A0w5C0/1+LVSvAQ
         KbN/sFw6XOdACN8jU798Cmh1oh9Lh8LeUhVAWIVuLY/ONihOoK3c4b6Y4HWjcf/dG8
         0Idn/QXeH12kdkWUjdP47/F+iGMvQRR90dwrEgpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/124] net: restore alpha order to Ethernet devices in config
Date:   Tue, 26 Apr 2022 10:20:39 +0200
Message-Id: <20220426081748.386171035@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
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
index 412ae3e43ffb..35ac6fe7529c 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -34,15 +34,6 @@ source "drivers/net/ethernet/apple/Kconfig"
 source "drivers/net/ethernet/aquantia/Kconfig"
 source "drivers/net/ethernet/arc/Kconfig"
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
@@ -56,6 +47,14 @@ config CX_ECAT
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
@@ -82,7 +81,6 @@ source "drivers/net/ethernet/huawei/Kconfig"
 source "drivers/net/ethernet/i825xx/Kconfig"
 source "drivers/net/ethernet/ibm/Kconfig"
 source "drivers/net/ethernet/intel/Kconfig"
-source "drivers/net/ethernet/microsoft/Kconfig"
 source "drivers/net/ethernet/xscale/Kconfig"
 
 config JME
@@ -125,8 +123,9 @@ source "drivers/net/ethernet/mediatek/Kconfig"
 source "drivers/net/ethernet/mellanox/Kconfig"
 source "drivers/net/ethernet/micrel/Kconfig"
 source "drivers/net/ethernet/microchip/Kconfig"
-source "drivers/net/ethernet/moxa/Kconfig"
 source "drivers/net/ethernet/mscc/Kconfig"
+source "drivers/net/ethernet/microsoft/Kconfig"
+source "drivers/net/ethernet/moxa/Kconfig"
 source "drivers/net/ethernet/myricom/Kconfig"
 
 config FEALNX
@@ -138,10 +137,10 @@ config FEALNX
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
@@ -161,6 +160,7 @@ source "drivers/net/ethernet/packetengines/Kconfig"
 source "drivers/net/ethernet/pasemi/Kconfig"
 source "drivers/net/ethernet/pensando/Kconfig"
 source "drivers/net/ethernet/qlogic/Kconfig"
+source "drivers/net/ethernet/brocade/Kconfig"
 source "drivers/net/ethernet/qualcomm/Kconfig"
 source "drivers/net/ethernet/rdc/Kconfig"
 source "drivers/net/ethernet/realtek/Kconfig"
@@ -168,10 +168,10 @@ source "drivers/net/ethernet/renesas/Kconfig"
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



