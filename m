Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E65517F9BB
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbgCJM7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730023AbgCJM71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:59:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 488602253D;
        Tue, 10 Mar 2020 12:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845166;
        bh=hKYGiz4zk2QHN8e6pfKsbViwp/zI0pmUHjXxczMOWvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1D2vPTPT9+64SItJcGxyjMR/40/J0qPWnVLr4YYHyOXRz7KpVBf5HP5mD68cOkcK
         rMpuUjsudQzPwsWYEEO+ImM/vxhKdMmgJxsTAox2Nkx8pKTPBsYNTzo40sNkJm4njY
         tFNWkgBhSjInMvwx0zbwomP+yMHB379ngUHJavHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Ondrej Jirman <megous@megous.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 5.5 087/189] phy: allwinner: Fix GENMASK misuse
Date:   Tue, 10 Mar 2020 13:38:44 +0100
Message-Id: <20200310123648.473874835@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>

commit 96b4ea324ae92386db2b0c73ace597c80cde1ecb upstream.

Arguments are supposed to be ordered high then low.

Fixes: a228890f9458 ("phy: allwinner: add phy driver for USB3 PHY on Allwinner H6 SoC")
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Tested-by: Ondrej Jirman <megous@megous.com>
Signed-off-by: Ondrej Jirman <megous@megous.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191110124355.1569-1-rikard.falkeborn@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/phy/allwinner/phy-sun50i-usb3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/allwinner/phy-sun50i-usb3.c
+++ b/drivers/phy/allwinner/phy-sun50i-usb3.c
@@ -49,7 +49,7 @@
 #define SUNXI_LOS_BIAS(n)		((n) << 3)
 #define SUNXI_LOS_BIAS_MASK		GENMASK(5, 3)
 #define SUNXI_TXVBOOSTLVL(n)		((n) << 0)
-#define SUNXI_TXVBOOSTLVL_MASK		GENMASK(0, 2)
+#define SUNXI_TXVBOOSTLVL_MASK		GENMASK(2, 0)
 
 struct sun50i_usb3_phy {
 	struct phy *phy;


