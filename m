Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17FE710E8E9
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfLBKbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:31:19 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38330 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfLBKbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:31:19 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so9723342wmi.3
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+T3I2qcXZZl5cdoe8/t6jX4UHeNDaQgtBVsOUTonFpo=;
        b=tlchkpn2BAImgn+XwjY40TIhXaScx9O5JrzCGF8HjHWv4zecZkeDxQmqcjJPjOmPqP
         2ty7/jEbC3iqM+x0wVLEjvHqjMS4KKsqlzOt7xmOa0PYgwap0a98win/COR8t/DfzcKN
         KtIoFIuZre2vSMURhN/bOTNpxUCYw93woqy204BwxgQXLCdQ1OV9ouSk425Cy52dWXfi
         5MFKkOGn4t/pU3pVOe2sxmKk3jZEVIqnGftRlZy+37lEmiYfV45Ej0OhKq1F2mJWjHqS
         tNc7Vv6yTs7iD+NlHqagiR8w6wEpK1Ig49Goz9AQc+fqHEln5OBMhvigolpAwHqfMiXh
         dF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+T3I2qcXZZl5cdoe8/t6jX4UHeNDaQgtBVsOUTonFpo=;
        b=sx2YYt/p0ZoaT6Fl1TZpQgjog34r6uLf6pxDYTxPO4fo5g/afGDVAyB2DjTH+CO8am
         xvJFk7g5MJxn6/NI2AUvh9P64ak/CmUYVxqUTllQ0ZbhsyvXku0DA/nEsMcDctYaiiFv
         eQtzUBrWvtYvYHuzY3kCtqX68egr0iP4huBzb8fYaR5aDuH0RVYdD05Feot6fdp7XERh
         8H7oBWSGxDY8BL92SfIrdYOscLJL9N+hfkGUrP++AD8E1I+OnycEcWF31cMq5/ZH8v6D
         KcAyi8IfxEEjqJNXDIbZ6Kd7aaZ8Z8H9y2bmcFa7/Oalwh1rF7kRWf+srPLQ0/1PuTig
         aVnQ==
X-Gm-Message-State: APjAAAVTvo6VQk85wlMtGe6gH5oketKGOpI7wmG32rV4zOIZQmbV+ht8
        Q5nVt+txfDUO95yEMwaFWysqbCqbriY=
X-Google-Smtp-Source: APXvYqyMWHK/75hACrcx3s/MRgcznZMmJ7POu6RHUbSZM2U1O2CSFL69uOmmdtKxo4fF2kl7h2Fg/Q==
X-Received: by 2002:a05:600c:28c:: with SMTP id 12mr26902759wmk.25.1575282676681;
        Mon, 02 Dec 2019 02:31:16 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id r6sm26402860wrq.92.2019.12.02.02.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:31:16 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 10/15] mtd: rawnand: atmel: Fix spelling mistake in error message
Date:   Mon,  2 Dec 2019 10:30:45 +0000
Message-Id: <20191202103050.2668-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202103050.2668-1-lee.jones@linaro.org>
References: <20191202103050.2668-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit e39bb786816453788836c367caefd72eceea380c ]

Wrong copy/paste from the previous block, the error message should
refer to #size-cells instead of #address-cells.

Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/raw/atmel/nand-controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd/nand/raw/atmel/nand-controller.c
index 32e95af486a2..ea022712edee 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -1826,7 +1826,7 @@ static int atmel_nand_controller_add_nands(struct atmel_nand_controller *nc)
 
 	ret = of_property_read_u32(np, "#size-cells", &val);
 	if (ret) {
-		dev_err(dev, "missing #address-cells property\n");
+		dev_err(dev, "missing #size-cells property\n");
 		return ret;
 	}
 
-- 
2.24.0

