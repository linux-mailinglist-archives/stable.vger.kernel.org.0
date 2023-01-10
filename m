Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F77066467E
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 17:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbjAJQss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 11:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238983AbjAJQsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 11:48:07 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15B3D9D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 08:47:08 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id hw16so18386168ejc.10
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 08:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ls6LBcwMm2xVgGGJTeN+YYoIl2kLVK7Yc/+Xn5DZygM=;
        b=aJ0gqoWO+qWvHTvMdMgNi0wkV9wmQ+77YhfTQfHAJGFSXtwLzqO1xcV2q79INgIVAg
         8J/MNyx6jxujXomJn1bV+NAxU1cWuwq55gGqf2KJ9CH9CV2UmhuLglzeUOtISVo9Av9R
         ZSxr7QDGdMlCov6XXmSHYOy4L79ESVQ/l6BrvmBRCn0CPL5sYQCJp9rxO3ClemXOZ3p9
         BFhOi9pbGIGKUI+qp5v8ASDtBB0KOBF5xKYSDVndBipyE2sZjnWktkMyeM2kQzSUUrqt
         ckG+i4Jh/nCPXzs1jn56QWBpzi4aF0opTDIlNlmhpN/LbDXiQM5OCZasAkg/QV4YQVbU
         M8vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ls6LBcwMm2xVgGGJTeN+YYoIl2kLVK7Yc/+Xn5DZygM=;
        b=n66B29Fwdtuei9UGnf1Bid3SaigguS/h4WUf3uwYfYCdThTVoxHyTz8sG3Jr8KKwvr
         +QMt5NelPEOUOWHun+CJx2X3/SmGi278PPXupGLc7H5oioKwrxU4bxaKnYn97h4EXaXk
         Yzo9yeRFTqccNZHX42czwOuDHmygnqzvKMRU3jK/sBv8LhXMyvGm7UEm++x8W9TSuv9U
         i/C8i0cdTJwswov/4Hz0/JRBE3PlitbFVtbDp2N6GZ9vR/PvmGstJNA+A/3jtyEVP1L5
         Fh1I7uhMQBebKp19Lt6KrYwuLpOXlmGADKC2UAhx1FIUikfJpD2yG1NlBHpkKJnT4zWF
         bZVw==
X-Gm-Message-State: AFqh2kr1BRs/T6nhKRjpBUCG6l2tyRAh5FRZW4Dz6VZxWNpfku9fSnJh
        jdWH4FXy/xjQ1Q+6L80DPdbKfw==
X-Google-Smtp-Source: AMrXdXtNpex0rz7ncY6hnmVTtHkYo68HdNvSt4pr+LePBAEm6sfd8JaKtzZDRshV3pZ5cD01QlwhJg==
X-Received: by 2002:a17:907:a28c:b0:7c1:6794:1623 with SMTP id rd12-20020a170907a28c00b007c167941623mr72399049ejc.58.1673369227315;
        Tue, 10 Jan 2023 08:47:07 -0800 (PST)
Received: from 1.. ([79.115.63.215])
        by smtp.gmail.com with ESMTPSA id lb11-20020a170907784b00b007b935641971sm5053699ejc.5.2023.01.10.08.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 08:47:06 -0800 (PST)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     Takahiro.Kuwano@infineon.com, tkuw584924@gmail.com
Cc:     linux-mtd@lists.infradead.org, pratyush@kernel.org,
        michael@walle.cc, miquel.raynal@bootlin.com, richard@nod.at,
        Bacem.Daassi@infineon.com,
        Tudor Ambarus <tudor.ambarus@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] mtd: spi-nor: spansion: Consider reserved bits in CFR5 register
Date:   Tue, 10 Jan 2023 18:47:02 +0200
Message-Id: <20230110164703.83413-1-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <493d9a10-aaf3-70f6-36c3-9a2cf39f0759@linaro.org>
References: <493d9a10-aaf3-70f6-36c3-9a2cf39f0759@linaro.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1606; h=from:subject; bh=jF3FpErLQTCqtOjjNcuMmC7+pgd25X61qd7O/piXeqY=; b=owEBbQGS/pANAwAKAUtVT0eljRTpAcsmYgBjvZaGkPAxjVl/mkjAg+vTBPpEWaj47jQ3EBf4n5VY 274YmO2JATMEAAEKAB0WIQQdQirKzw7IbV4d/t9LVU9HpY0U6QUCY72WhgAKCRBLVU9HpY0U6Ty4CA CHotWONuxMqIYV0veIwP56hAutrw5hZ8R/LdMakq/waAIUo+6moepfs9+lgGqCcyuxw5CfGKebVaJG f4H9q4bEG+YOSrNErtpok37evTZj7Bx6G09OVqe2r+wqoT8S+Vs6ehM2ksXSsOA3uuf4JQ4+Se7CwZ EHcRsdm37r3ZlQlepNVyutQFUH5jce00w0PjFTqWP16MfuU1nbF2av6f0r52zKu3Z0iq5XDTh6o+K+ 8EYMobyPS4WD1mdpmBwnQDiO6ZwvJJV5qRE0ivkEBzEPNcEy0VEE9A/d2GnmWeUGYPHfHHWHpyoYim diRNpS2SIW9XA3+yL4lrbKTwaTWSVU
X-Developer-Key: i=tudor.ambarus@linaro.org; a=openpgp; fpr=280B06FD4CAAD2980C46DDDF4DB1B079AD29CF3D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CFR5[6] is reserved bit and must be always 1. Set it to comply with flash
requirements. While fixing SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_{EN, DS}
definition, stop using magic numbers and describe the missing bit fields
in CFR5 register. This is useful for both readability and future possible
addition of Octal STR mode support.

Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress Semper flash")
Cc: stable@vger.kernel.org
Reported-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 drivers/mtd/spi-nor/spansion.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index b621cdfd506f..07fe0f6fdfe3 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -21,8 +21,13 @@
 #define SPINOR_REG_CYPRESS_CFR3V		0x00800004
 #define SPINOR_REG_CYPRESS_CFR3V_PGSZ		BIT(4) /* Page size. */
 #define SPINOR_REG_CYPRESS_CFR5V		0x00800006
-#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN	0x3
-#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	0
+#define SPINOR_REG_CYPRESS_CFR5_BIT6		BIT(6)
+#define SPINOR_REG_CYPRESS_CFR5_DDR		BIT(1)
+#define SPINOR_REG_CYPRESS_CFR5_OPI		BIT(0)
+#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN				\
+	(SPINOR_REG_CYPRESS_CFR5_BIT6 |	SPINOR_REG_CYPRESS_CFR5_DDR |	\
+	 SPINOR_REG_CYPRESS_CFR5_OPI)
+#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	SPINOR_REG_CYPRESS_CFR5_BIT6
 #define SPINOR_OP_CYPRESS_RD_FAST		0xee
 
 /* Cypress SPI NOR flash operations. */
-- 
2.34.1

