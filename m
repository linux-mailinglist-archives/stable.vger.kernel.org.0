Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D708ACDCC
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387619AbfIHMx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387559AbfIHMxY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:53:24 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A8D3218AC;
        Sun,  8 Sep 2019 12:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947203;
        bh=6bw/7DLwCJ+tcJ/MtAGG0BRvVdqLRy+kRlXfBgIdE9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7H8y78noEF0KxvAR0oTnn10yTnaDcocyr6IzW+HDZxOTDZILx9Cg8xJb7md/Rw7/
         6BZ8Wx2Nvklc9z/DhZmeREgkLE7pD5iUaPij9anO//DwuBGcc8c5p2Lb6DtC5ddyUX
         scEdcTHopmilMiwF8cCMQjnJVS5WDj3RKXWEXzek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 60/94] net: cavium: fix driver name
Date:   Sun,  8 Sep 2019 13:41:56 +0100
Message-Id: <20190908121152.151128338@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3434341004a380f4e47c3a03d4320d43982162a0 ]

The driver name gets exposed in sysfs under /sys/bus/pci/drivers
so it should look like other devices. Change it to be common
format (instead of "Cavium PTP").

This is a trivial fix that was observed by accident because
Debian kernels were building this driver into kernel (bug).

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/common/cavium_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/common/cavium_ptp.c b/drivers/net/ethernet/cavium/common/cavium_ptp.c
index 73632b8437498..b821c9e1604cf 100644
--- a/drivers/net/ethernet/cavium/common/cavium_ptp.c
+++ b/drivers/net/ethernet/cavium/common/cavium_ptp.c
@@ -10,7 +10,7 @@
 
 #include "cavium_ptp.h"
 
-#define DRV_NAME	"Cavium PTP Driver"
+#define DRV_NAME "cavium_ptp"
 
 #define PCI_DEVICE_ID_CAVIUM_PTP	0xA00C
 #define PCI_DEVICE_ID_CAVIUM_RST	0xA00E
-- 
2.20.1



