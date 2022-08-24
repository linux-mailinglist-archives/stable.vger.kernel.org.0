Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21AF59FA04
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 14:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbiHXMae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 08:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237472AbiHXMad (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 08:30:33 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7964B4AD6A
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 05:30:32 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso1428990pjh.5
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 05:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=u8y/r/XRzUdXpFeOgWGRlYtl7JW+XG3qjD2H5X3t6VU=;
        b=xoMLQ/pbCct2ail+mi5yAKNNxllhIFJ4jLnUZilIT1gXuHDI7VlCvxuidcviokMLCL
         BpyH8EShKjQ/+Nz3eoMlu3ZxxqIIgo15Ontekj3/eHu2xinMuZQT8T7O9NQCuBie9QY2
         PthruMNGFkU8zkLGyQVxqjAvTOL9a3dRFQJUWInOojPWVjpFXx1/TP+/AeXu4cXXuV7f
         5J5MQlICHS3GgpHZN29vNN9q3aHf61FE5S6+X168CrtyittLFP8XfAfXJ29/+iT48JHR
         khvdauqIZfKb8mBhLJMpQVnEsdLBBspTJ0X/EivsfG70LoD/QkuY6bpaZtAx8WAwl3Jc
         Ar1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=u8y/r/XRzUdXpFeOgWGRlYtl7JW+XG3qjD2H5X3t6VU=;
        b=PfF9hIgzTCUYECBto6ufyp/rYoGegWxPUQY6eZr1IYSRmoBugHW41pM+N8qhb8HDeV
         AdNsAdLnVxd5554pqeQML+PItHb1XTMUimzdm3AKqpN2U0lBq6luIYtAtfu4fypNRoDD
         Q0f+DmTYzOXcBRYVUnNA9v6D7gYYIYcuMQsetckTXQO+Qy7U0EQKh1ruwptHjPJmYl45
         zSFCXud8RVwZaEFUWt8dO1pOSYK2KN3boYq0qG2U1BkMfIOMLrjELGzjgP1jRYQbvujV
         rX3H7UnOCXsH5sYj8GbDU0kCUBCqOFuWZ7zXmxl0PXx415S36zm2LG6AYnYI/BfICVox
         C49g==
X-Gm-Message-State: ACgBeo2IN8TWYO/DwGaoojyVhA4b22+j+ZjNCoIsGNx0ZiTsMVS0Itgd
        C32O1jRc6wjx0im4yerjUBZO
X-Google-Smtp-Source: AA6agR5lbQb07q07y2DyrSsy/8lWjg7mGKNQL+ZYzktgLJ385BIgC8leoq3f8ciKsvVmcjFupnMCxg==
X-Received: by 2002:a17:902:ebc8:b0:172:549d:e392 with SMTP id p8-20020a170902ebc800b00172549de392mr28527048plg.141.1661344231883;
        Wed, 24 Aug 2022 05:30:31 -0700 (PDT)
Received: from localhost.localdomain ([117.207.24.28])
        by smtp.gmail.com with ESMTPSA id b3-20020a1709027e0300b00173031308fdsm3539220plm.158.2022.08.24.05.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 05:30:31 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     kishon@ti.com, gregkh@linuxfoundation.org, lpieralisi@kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        mie@igel.co.jp, kw@linux.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 3/5] Documentation: PCI: endpoint: Use the correct return value of pcitest.sh
Date:   Wed, 24 Aug 2022 18:00:08 +0530
Message-Id: <20220824123010.51763-4-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220824123010.51763-1-manivannan.sadhasivam@linaro.org>
References: <20220824123010.51763-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The pci_endpoint_test driver has been fixed to return correct error no
from IOCTL. In that process, the pcitest tool now returns SUCCESS and
FAILED instead of OKAY and NOT_OKAY. So change that in documentation also.

Cc: stable@vger.kernel.org #5.10
Fixes: 16263d9e1ded ("Documentation: PCI: Add userguide for PCI endpoint test function")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 Documentation/PCI/endpoint/pci-test-howto.rst | 152 +++++++++---------
 1 file changed, 76 insertions(+), 76 deletions(-)

diff --git a/Documentation/PCI/endpoint/pci-test-howto.rst b/Documentation/PCI/endpoint/pci-test-howto.rst
index 909f770a07d6..3bc43b9f9856 100644
--- a/Documentation/PCI/endpoint/pci-test-howto.rst
+++ b/Documentation/PCI/endpoint/pci-test-howto.rst
@@ -144,92 +144,92 @@ pcitest.sh Output
 	# pcitest.sh
 	BAR tests
 
-	BAR0:           OKAY
-	BAR1:           OKAY
-	BAR2:           OKAY
-	BAR3:           OKAY
-	BAR4:           NOT OKAY
-	BAR5:           NOT OKAY
+	BAR0:           SUCCESS
+	BAR1:           SUCCESS
+	BAR2:           SUCCESS
+	BAR3:           SUCCESS
+	BAR4:           FAILED
+	BAR5:           FAILED
 
 	Interrupt tests
 
-	SET IRQ TYPE TO LEGACY:         OKAY
-	LEGACY IRQ:     NOT OKAY
-	SET IRQ TYPE TO MSI:            OKAY
-	MSI1:           OKAY
-	MSI2:           OKAY
-	MSI3:           OKAY
-	MSI4:           OKAY
-	MSI5:           OKAY
-	MSI6:           OKAY
-	MSI7:           OKAY
-	MSI8:           OKAY
-	MSI9:           OKAY
-	MSI10:          OKAY
-	MSI11:          OKAY
-	MSI12:          OKAY
-	MSI13:          OKAY
-	MSI14:          OKAY
-	MSI15:          OKAY
-	MSI16:          OKAY
-	MSI17:          NOT OKAY
-	MSI18:          NOT OKAY
-	MSI19:          NOT OKAY
-	MSI20:          NOT OKAY
-	MSI21:          NOT OKAY
-	MSI22:          NOT OKAY
-	MSI23:          NOT OKAY
-	MSI24:          NOT OKAY
-	MSI25:          NOT OKAY
-	MSI26:          NOT OKAY
-	MSI27:          NOT OKAY
-	MSI28:          NOT OKAY
-	MSI29:          NOT OKAY
-	MSI30:          NOT OKAY
-	MSI31:          NOT OKAY
-	MSI32:          NOT OKAY
-	SET IRQ TYPE TO MSI-X:          OKAY
-	MSI-X1:         OKAY
-	MSI-X2:         OKAY
-	MSI-X3:         OKAY
-	MSI-X4:         OKAY
-	MSI-X5:         OKAY
-	MSI-X6:         OKAY
-	MSI-X7:         OKAY
-	MSI-X8:         OKAY
-	MSI-X9:         NOT OKAY
-	MSI-X10:        NOT OKAY
-	MSI-X11:        NOT OKAY
-	MSI-X12:        NOT OKAY
-	MSI-X13:        NOT OKAY
-	MSI-X14:        NOT OKAY
-	MSI-X15:        NOT OKAY
-	MSI-X16:        NOT OKAY
+	SET IRQ TYPE TO LEGACY:         SUCCESS
+	LEGACY IRQ:     FAILED
+	SET IRQ TYPE TO MSI:            SUCCESS
+	MSI1:           SUCCESS
+	MSI2:           SUCCESS
+	MSI3:           SUCCESS
+	MSI4:           SUCCESS
+	MSI5:           SUCCESS
+	MSI6:           SUCCESS
+	MSI7:           SUCCESS
+	MSI8:           SUCCESS
+	MSI9:           SUCCESS
+	MSI10:          SUCCESS
+	MSI11:          SUCCESS
+	MSI12:          SUCCESS
+	MSI13:          SUCCESS
+	MSI14:          SUCCESS
+	MSI15:          SUCCESS
+	MSI16:          SUCCESS
+	MSI17:          FAILED
+	MSI18:          FAILED
+	MSI19:          FAILED
+	MSI20:          FAILED
+	MSI21:          FAILED
+	MSI22:          FAILED
+	MSI23:          FAILED
+	MSI24:          FAILED
+	MSI25:          FAILED
+	MSI26:          FAILED
+	MSI27:          FAILED
+	MSI28:          FAILED
+	MSI29:          FAILED
+	MSI30:          FAILED
+	MSI31:          FAILED
+	MSI32:          FAILED
+	SET IRQ TYPE TO MSI-X:          SUCCESS
+	MSI-X1:         SUCCESS
+	MSI-X2:         SUCCESS
+	MSI-X3:         SUCCESS
+	MSI-X4:         SUCCESS
+	MSI-X5:         SUCCESS
+	MSI-X6:         SUCCESS
+	MSI-X7:         SUCCESS
+	MSI-X8:         SUCCESS
+	MSI-X9:         FAILED
+	MSI-X10:        FAILED
+	MSI-X11:        FAILED
+	MSI-X12:        FAILED
+	MSI-X13:        FAILED
+	MSI-X14:        FAILED
+	MSI-X15:        FAILED
+	MSI-X16:        FAILED
 	[...]
-	MSI-X2047:      NOT OKAY
-	MSI-X2048:      NOT OKAY
+	MSI-X2047:      FAILED
+	MSI-X2048:      FAILED
 
 	Read Tests
 
-	SET IRQ TYPE TO MSI:            OKAY
-	READ (      1 bytes):           OKAY
-	READ (   1024 bytes):           OKAY
-	READ (   1025 bytes):           OKAY
-	READ (1024000 bytes):           OKAY
-	READ (1024001 bytes):           OKAY
+	SET IRQ TYPE TO MSI:            SUCCESS
+	READ (      1 bytes):           SUCCESS
+	READ (   1024 bytes):           SUCCESS
+	READ (   1025 bytes):           SUCCESS
+	READ (1024000 bytes):           SUCCESS
+	READ (1024001 bytes):           SUCCESS
 
 	Write Tests
 
-	WRITE (      1 bytes):          OKAY
-	WRITE (   1024 bytes):          OKAY
-	WRITE (   1025 bytes):          OKAY
-	WRITE (1024000 bytes):          OKAY
-	WRITE (1024001 bytes):          OKAY
+	WRITE (      1 bytes):          SUCCESS
+	WRITE (   1024 bytes):          SUCCESS
+	WRITE (   1025 bytes):          SUCCESS
+	WRITE (1024000 bytes):          SUCCESS
+	WRITE (1024001 bytes):          SUCCESS
 
 	Copy Tests
 
-	COPY (      1 bytes):           OKAY
-	COPY (   1024 bytes):           OKAY
-	COPY (   1025 bytes):           OKAY
-	COPY (1024000 bytes):           OKAY
-	COPY (1024001 bytes):           OKAY
+	COPY (      1 bytes):           SUCCESS
+	COPY (   1024 bytes):           SUCCESS
+	COPY (   1025 bytes):           SUCCESS
+	COPY (1024000 bytes):           SUCCESS
+	COPY (1024001 bytes):           SUCCESS
-- 
2.25.1

