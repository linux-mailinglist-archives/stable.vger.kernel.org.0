Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D65D9148143
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390203AbgAXLS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:18:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390415AbgAXLS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:18:29 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DA5920704;
        Fri, 24 Jan 2020 11:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864708;
        bh=Zs02ywLE7SDP/oQzJ8F7Au/vD5FLZvJksT105XKIaCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4t6Qz0G+EkFk+VoEhpENPfVJnSK8FeyxI9tIV5auUQ6J/h2mePMPapYRcwrHzbLe
         El/Z2ESEfGWaIZfqxeEFE55LUXwGl2rJEvgEUnywHwajKi7zk10AMJ10CgHVA5v/Tb
         Ym5yNzMBHzBXliNBO17TTySnomUisjee+WLSHm0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongbo Yao <yaohongbo@huawei.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 330/639] irqchip/gic-v3-its: fix some definitions of inner cacheability attributes
Date:   Fri, 24 Jan 2020 10:28:20 +0100
Message-Id: <20200124093128.446070516@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongbo Yao <yaohongbo@huawei.com>

[ Upstream commit 0f29456d08042134aff6e562d07a6365c841c4ad ]

Some definitions of Inner Cacheability attibutes need to be corrected.

Fixes: 8c828a535e29f ("irqchip/gicv3-its: Restore all cacheability attributes")
Signed-off-by: Hongbo Yao <yaohongbo@huawei.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irqchip/arm-gic-v3.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 3188c0bef3e79..1d21e98d68549 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -165,7 +165,7 @@
 #define GICR_PROPBASER_nCnB	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, nCnB)
 #define GICR_PROPBASER_nC 	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, nC)
 #define GICR_PROPBASER_RaWt	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWt)
-#define GICR_PROPBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWt)
+#define GICR_PROPBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWb)
 #define GICR_PROPBASER_WaWt	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, WaWt)
 #define GICR_PROPBASER_WaWb	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, WaWb)
 #define GICR_PROPBASER_RaWaWt	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWaWt)
@@ -192,7 +192,7 @@
 #define GICR_PENDBASER_nCnB	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, nCnB)
 #define GICR_PENDBASER_nC 	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, nC)
 #define GICR_PENDBASER_RaWt	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWt)
-#define GICR_PENDBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWt)
+#define GICR_PENDBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWb)
 #define GICR_PENDBASER_WaWt	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, WaWt)
 #define GICR_PENDBASER_WaWb	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, WaWb)
 #define GICR_PENDBASER_RaWaWt	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWaWt)
@@ -251,7 +251,7 @@
 #define GICR_VPROPBASER_nCnB	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, nCnB)
 #define GICR_VPROPBASER_nC 	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, nC)
 #define GICR_VPROPBASER_RaWt	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, RaWt)
-#define GICR_VPROPBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, RaWt)
+#define GICR_VPROPBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, RaWb)
 #define GICR_VPROPBASER_WaWt	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, WaWt)
 #define GICR_VPROPBASER_WaWb	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, WaWb)
 #define GICR_VPROPBASER_RaWaWt	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, RaWaWt)
@@ -277,7 +277,7 @@
 #define GICR_VPENDBASER_nCnB	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, nCnB)
 #define GICR_VPENDBASER_nC 	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, nC)
 #define GICR_VPENDBASER_RaWt	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, RaWt)
-#define GICR_VPENDBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, RaWt)
+#define GICR_VPENDBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, RaWb)
 #define GICR_VPENDBASER_WaWt	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, WaWt)
 #define GICR_VPENDBASER_WaWb	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, WaWb)
 #define GICR_VPENDBASER_RaWaWt	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, RaWaWt)
@@ -351,7 +351,7 @@
 #define GITS_CBASER_nCnB	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, nCnB)
 #define GITS_CBASER_nC		GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, nC)
 #define GITS_CBASER_RaWt	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWt)
-#define GITS_CBASER_RaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWt)
+#define GITS_CBASER_RaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWb)
 #define GITS_CBASER_WaWt	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, WaWt)
 #define GITS_CBASER_WaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, WaWb)
 #define GITS_CBASER_RaWaWt	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWt)
@@ -375,7 +375,7 @@
 #define GITS_BASER_nCnB		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, nCnB)
 #define GITS_BASER_nC		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, nC)
 #define GITS_BASER_RaWt		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWt)
-#define GITS_BASER_RaWb		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWt)
+#define GITS_BASER_RaWb		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWb)
 #define GITS_BASER_WaWt		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, WaWt)
 #define GITS_BASER_WaWb		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, WaWb)
 #define GITS_BASER_RaWaWt	GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWaWt)
-- 
2.20.1



