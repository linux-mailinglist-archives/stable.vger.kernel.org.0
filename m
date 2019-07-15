Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2602695B5
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731444AbfGOO7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:59:40 -0400
Received: from glenfiddich.mraw.org ([62.210.215.98]:51530 "EHLO
        glenfiddich.mraw.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389560AbfGOOSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 10:18:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mraw.org;
         s=mail; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:
        Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3izMUbk5igF8rc0SL5fLHxZkvh1RVPcCPYsW7Iz4hYw=; b=fyBA4ue/L48LMqEac3tnpQuT43
        cUZzGfneCL0pJ7P6Kzy/V9k1vs13pLgKsv1HCBy1Ty/zNIBg27FBdXi1leUJLj7/GM8Arnvzu0jmM
        PCdrJmeto5pm4ug1JTu420gepsV+ZYZuf55I7yDtb9T8KFtLYNtuczE2w1gdVLRfH0ps=;
Received: from localhost ([127.0.0.1] helo=armor.home)
        by glenfiddich.mraw.org with esmtp (Exim 4.89)
        (envelope-from <cyril@debamax.com>)
        id 1hn1YA-00008C-DU; Mon, 15 Jul 2019 16:01:54 +0200
From:   Cyril Brulebois <cyril@debamax.com>
To:     stable@vger.kernel.org
Cc:     charles.fendt@me.com, Stefan Wahren <stefan.wahren@i2se.com>,
        Cyril Brulebois <cyril@debamax.com>
Subject: [PATCH 2/3] arm64: dts: broadcom: Add reference to Compute Module IO Board V3
Date:   Mon, 15 Jul 2019 16:01:11 +0200
Message-Id: <20190715140112.6180-3-cyril@debamax.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190715140112.6180-1-cyril@debamax.com>
References: <20190715140112.6180-1-cyril@debamax.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

commit a7eb26392b893bff92b1eb6483f4af3d2eb19510 upstream.

This adds a reference to the dts of the Compute Module IO Board V3 in arm,
so we don't need to maintain the content in arm64.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Tested-by: Charles Fendt <charles.fendt@me.com>
Signed-off-by: Cyril Brulebois <cyril@debamax.com>
---
 arch/arm64/boot/dts/broadcom/Makefile                | 3 ++-
 arch/arm64/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts

diff --git a/arch/arm64/boot/dts/broadcom/Makefile b/arch/arm64/boot/dts/broadcom/Makefile
index 1193a9e34bbb..3d98f5f5ab88 100644
--- a/arch/arm64/boot/dts/broadcom/Makefile
+++ b/arch/arm64/boot/dts/broadcom/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 dtb-$(CONFIG_ARCH_BCM2835) += bcm2837-rpi-3-b.dtb \
-			      bcm2837-rpi-3-b-plus.dtb
+			      bcm2837-rpi-3-b-plus.dtb \
+			      bcm2837-rpi-cm3-io3.dts
 
 subdir-y	+= northstar2
 subdir-y	+= stingray
diff --git a/arch/arm64/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts b/arch/arm64/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts
new file mode 100644
index 000000000000..b1c4ab212c64
--- /dev/null
+++ b/arch/arm64/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "arm/bcm2837-rpi-cm3-io3.dts"
-- 
2.11.0

