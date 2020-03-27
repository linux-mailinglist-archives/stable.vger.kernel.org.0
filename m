Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E12019581E
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 14:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgC0Ngk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 09:36:40 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:45009 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0Ngk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 09:36:40 -0400
Received: by mail-qv1-f66.google.com with SMTP id ef12so2792757qvb.11
        for <stable@vger.kernel.org>; Fri, 27 Mar 2020 06:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AuD1hP2SDvNnMIeBCx2+xXnWwBrp0PFdSYPVHiYwolM=;
        b=Yig7/7eC9ibhdFRjmZ17yEFzyHzA1GJlwGQjbMB4byzLgR3/GjaH4+zxBeAi5lSSDW
         A2ulmJPwU57I1jLrxtqiiT2OgKleReKob+JJbRt67V/Y3EdaS4J62YHMoTGrHDuBd3wS
         a1SkZT3HiK51FQ2jRpP7onIYXfWInAAu5aOTi3lz1Sgol4ew/HJt+KdEBonSYVOW/uhg
         f7rpOj3oqrIsaV4/vlUpFQo4efnqSUW+NyLgk3qYAlVHr4cPmsqMZnT/kKik3fDUjze0
         jVgUB+mb3J46eVDHSQscBVC0sKu7sVcKbxBvwrSmWHECDEH8WxK+BV9rOVp0Lc3lWga/
         JO3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AuD1hP2SDvNnMIeBCx2+xXnWwBrp0PFdSYPVHiYwolM=;
        b=DcyzA4NHXUhlb1U7EMy4LC3EQz2giLD+IThie2e+FZ6mT2twyHDqfV/6wloN8FIDlD
         7f1dqBos8NI6ueQsaAqMvdczLTxJvhLdRbUNECIopyWUQOzUDU7A+FwZB15Ea+MLR48y
         sQPjuNdixQ4Uoc8dhGN2IZ81D5mrHlBstm37ZOgie7rHXtBZdehnC/4X+zu7PVLdGRKX
         lSRQuO70Lx+kD1+1QDh4aIuN6IPVW004xL3HmQWupxBOjxbkqURDtCJR7kbwh7BzTU8M
         k9nCWh+j8iYBOMXZytdcEsBkbAI0Mg6aRbOtDk71vW2WSIKgbQnIRHBqVo/n8v0X6jRv
         fupg==
X-Gm-Message-State: ANhLgQ20Tbpi2eOSeRA3yY2SFyB2/6FYT7kApju5NXNGpz2BxzyTaM4K
        qPAxWBfbmDT2HG2ToKAunLs=
X-Google-Smtp-Source: ADFU+vu30tmXNyfs+zodPVKegK0hqcQK8mHj/c7276G9aRecJQr7qGE3V6lHWUFeelkYTU0yt/NL2w==
X-Received: by 2002:a0c:be08:: with SMTP id k8mr13727025qvg.62.1585316199854;
        Fri, 27 Mar 2020 06:36:39 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:482:5bb::4])
        by smtp.gmail.com with ESMTPSA id d141sm3665317qke.68.2020.03.27.06.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 06:36:38 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     shawnguo@kernel.org
Cc:     kernel@pengutronix.de, c.hemp@phytec.de, s.riedmueller@phytec.de,
        linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] ARM: dts: imx27-phytec-phycard-s-rdk: Fix the I2C1 pinctrl entries
Date:   Fri, 27 Mar 2020 10:36:24 -0300
Message-Id: <20200327133624.26160-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The I2C2 pins are already used and the following errors are seen:

imx27-pinctrl 10015000.iomuxc: pin MX27_PAD_I2C2_SDA already requested by 10012000.i2c; cannot claim for 1001d000.i2c
imx27-pinctrl 10015000.iomuxc: pin-69 (1001d000.i2c) status -22
imx27-pinctrl 10015000.iomuxc: could not request pin 69 (MX27_PAD_I2C2_SDA) from group i2c2grp  on device 10015000.iomuxc
imx-i2c 1001d000.i2c: Error applying setting, reverse things back
imx-i2c: probe of 1001d000.i2c failed with error -22

Fix it by adding the correct I2C1 IOMUX entries for the pinctrl_i2c1 group.

Cc: <stable@vger.kernel.org> 
Fixes: 61664d0b432a ("ARM: dts: imx27 phyCARD-S pinctrl")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts b/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
index 0cd75dadf292..188639738dc3 100644
--- a/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
+++ b/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
@@ -75,8 +75,8 @@
 	imx27-phycard-s-rdk {
 		pinctrl_i2c1: i2c1grp {
 			fsl,pins = <
-				MX27_PAD_I2C2_SDA__I2C2_SDA 0x0
-				MX27_PAD_I2C2_SCL__I2C2_SCL 0x0
+				MX27_PAD_I2C_DATA__I2C_DATA 0x0
+				MX27_PAD_I2C_CLK__I2C_CLK 0x0
 			>;
 		};
 
-- 
2.17.1

