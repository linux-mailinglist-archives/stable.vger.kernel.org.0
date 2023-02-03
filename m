Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521A368962F
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbjBCKa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbjBCKaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:30:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA47CA08
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:29:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B74061EC3
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F14DC433D2;
        Fri,  3 Feb 2023 10:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420155;
        bh=HN0VHEpgGcHB0xexks/sWMOfOg7F/2yWXVj5l/Vt4X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffknQllCU1e7GeKrVvk5aZ5VKQxWzou/jFkelxjy7JnV+dImUXHH7TLlHp7b/v28B
         F6t6xtBKsuKHHHRoKVJBDSKR08XtujHUEINTEm3Ryz+fOqUUarE//5XdQG0HJy1Yu7
         Ctx4tGA23lKqytclrfcIv4Lel3qhTG1uVh5DUIQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/134] net/phy/mdio-i2c: Move header file to include/linux/mdio
Date:   Fri,  3 Feb 2023 11:13:24 +0100
Message-Id: <20230203101028.300350389@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit fcba68bd75bb1d42b3aec7f471d382a9e639a672 ]

In preparation for moving all MDIO drivers into drivers/net/mdio, move
the mdio-i2c header file into include/linux/mdio so it can be used by
both the MDIO driver and the SFP code which instantiates I2C MDIO
busses.

v2:
Add include/linux/mdio

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7083df59abbc ("net: mdio-mux-meson-g12a: force internal PHY off on mux switch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                                        | 1 +
 drivers/net/phy/mdio-i2c.c                         | 3 +--
 drivers/net/phy/sfp.c                              | 2 +-
 {drivers/net/phy => include/linux/mdio}/mdio-i2c.h | 0
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename {drivers/net/phy => include/linux/mdio}/mdio-i2c.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 973fcc9143d1..ea8f1c885089 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14661,6 +14661,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/phy/phylink.c
 F:	drivers/net/phy/sfp*
+F:	include/linux/mdio/mdio-i2c.h
 F:	include/linux/phylink.h
 F:	include/linux/sfp.h
 K:	phylink
diff --git a/drivers/net/phy/mdio-i2c.c b/drivers/net/phy/mdio-i2c.c
index 0dce67672548..5969878e0aa7 100644
--- a/drivers/net/phy/mdio-i2c.c
+++ b/drivers/net/phy/mdio-i2c.c
@@ -10,10 +10,9 @@
  * of their settings.
  */
 #include <linux/i2c.h>
+#include <linux/mdio/mdio-i2c.h>
 #include <linux/phy.h>
 
-#include "mdio-i2c.h"
-
 /*
  * I2C bus addresses 0x50 and 0x51 are normally an EEPROM, which is
  * specified to be present in SFP modules.  These correspond with PHY
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index beaa00342a13..9639aa181968 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -7,6 +7,7 @@
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
+#include <linux/mdio/mdio-i2c.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
@@ -16,7 +17,6 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
-#include "mdio-i2c.h"
 #include "sfp.h"
 #include "swphy.h"
 
diff --git a/drivers/net/phy/mdio-i2c.h b/include/linux/mdio/mdio-i2c.h
similarity index 100%
rename from drivers/net/phy/mdio-i2c.h
rename to include/linux/mdio/mdio-i2c.h
-- 
2.39.0



