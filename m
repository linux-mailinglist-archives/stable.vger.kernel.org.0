Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F6010E827
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfLBKEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:04:02 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53915 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbfLBKEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:04:02 -0500
Received: by mail-wm1-f67.google.com with SMTP id u18so21080765wmc.3
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=snLx6GTAmI8hTKqhJ93sNeXAAa7a7JDnkHsiqbTGl5Q=;
        b=pKxxqHEbjLrg4js37vFaNdCHdzcGt2brcoOT58d1XIPgE9foFdbRYeZtayCzqvdJLI
         y8lJb5mGxLXFazlTCn2AObgir4EOzkK0uQhntJNezTi49uNNEoJ3cgWgL8zazB4crh21
         sAiBYHvWS8snKiudXz7HqXSekRLsF2rKqSJ49JWSC4LTNLg2tx1ZGRyo07Gsa2slmznZ
         uDQ3O8SIVsIcifkevkl/12NmFvi4wzOYU7RrabTLuea+UF74tNyunE38VwH+dFQSh+06
         MtLEMt+NCYJKElUa9lYXt0QvxjT+vUnSY568bkfjLtYjBLyAK0cfYn5G/99ZONiofVbB
         Zpxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=snLx6GTAmI8hTKqhJ93sNeXAAa7a7JDnkHsiqbTGl5Q=;
        b=D+DWQmlgky7Mo+j2P8FckP0w4IIf+b9anCD1YCH0hkJ3ohn2/W93XJt4TFbiY0xDt5
         qxjoMcn31Fz97KNKToLf0j9vzsnxlt87zf1MtdgBSE+zfknEe/ji0tRkGOfZGbIBarJb
         IsZoxkqam5W2HU+t+mzOErwZjEQhn2ijEP+cW20A44t+1doqLApYMrBA3ZhQi+hjac8q
         jZekfY0gFLANq9+E8/YJGs5EAXeC8CCCahxJcZRPcpdvjKrpgDLU5e2l66paO/iPc/HZ
         vB0jcqBB8lE/oSP/07C8zKkR9htL0F+yRux/jqzWgWfE/CE72a+6KmdOumnfGRwakwmR
         lclQ==
X-Gm-Message-State: APjAAAXhtpekwO3f5uRz0QTsWpmBn0qLquvvmjS+xzAP2+OaY15mJ4bE
        D+tvs46vDhtxWio0pvHGa2teQLDjhfU=
X-Google-Smtp-Source: APXvYqw3wjZ0z/E2ioiA5leAei2mWIWFWl8B0cosTlVQugzJLoqxU0QZL9/r2mbXnZdwg6tRhRM0og==
X-Received: by 2002:a05:600c:296:: with SMTP id 22mr27407278wmk.155.1575281038353;
        Mon, 02 Dec 2019 02:03:58 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id h8sm22975665wrx.63.2019.12.02.02.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:03:57 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 09/14] mtd: rawnand: atmel: Fix spelling mistake in error message
Date:   Mon,  2 Dec 2019 10:03:07 +0000
Message-Id: <20191202100312.1397-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202100312.1397-1-lee.jones@linaro.org>
References: <20191202100312.1397-1-lee.jones@linaro.org>
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
 drivers/mtd/nand/atmel/nand-controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/atmel/nand-controller.c b/drivers/mtd/nand/atmel/nand-controller.c
index 0b93f152d993..d5a493e8ee08 100644
--- a/drivers/mtd/nand/atmel/nand-controller.c
+++ b/drivers/mtd/nand/atmel/nand-controller.c
@@ -1888,7 +1888,7 @@ static int atmel_nand_controller_add_nands(struct atmel_nand_controller *nc)
 
 	ret = of_property_read_u32(np, "#size-cells", &val);
 	if (ret) {
-		dev_err(dev, "missing #address-cells property\n");
+		dev_err(dev, "missing #size-cells property\n");
 		return ret;
 	}
 
-- 
2.24.0

