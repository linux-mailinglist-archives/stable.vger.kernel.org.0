Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E1965F9F2
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 04:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjAFDIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 22:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjAFDIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 22:08:31 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29067193DD
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 19:08:31 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id n4so403641plp.1
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 19:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2VLetstegDAmF4ny1Y3gq8bwqwrD3M6s6ZsjuqPUW4g=;
        b=SQPs4GjIr8E+QL7RL+S6LiM5UGFEtcKNIVi1YyDci+rzwXIkEZ6ibNhWiz33+cCUf0
         77uyX8lmz34q4uMLDII1loYhM6yh6LNqUc9qlvAHGRZwWlNl/AQGnB6pqlihsIl6cish
         SYdIgmU7p7B4gL4JD98JMpgthQbianUbZPVIJZavBEDJ5FrozI+6lV5KfMm+aiG4AhGf
         cy/BRBjyxeW6Z1RMf6rpj7jkXIyubdQonF77zlBpokVJMUIr3HPujjlENJ+vKO2ZyP4x
         rTfqNLQsGM8nW50SCv8qZ6/UJJ5EA2wBqbYuRAdSmUE6jPB9vJtGLZNZPZ8lMNAe4TWF
         u08A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2VLetstegDAmF4ny1Y3gq8bwqwrD3M6s6ZsjuqPUW4g=;
        b=brQmM6qRtKnQjPHxsdE4zZpdemyUVA0onFhpbVWuN2GMP9/f1TztU/yQgG428GhojA
         OkFJ67XUlwE4S6u3wxyQvyuuGqF4bpa+c6UlqupOVvwJv3gmX6qcMb0c8keYrRbaECRX
         bFKvwuZP09cz6vbSj98+h7SgQQc8hgkBKM//6NCcakImXKcg++9944extITOq/8s0d0A
         b9MFHI3HdHntdkWrUoxLAkDsPmT6u1yC7C+vF1V7vq/iF0S6O8HevX03dEo8jkhBrkOH
         YBkv1jyBNH45Ogn/MHEC9tA1FT9WSJndtt+Og7BA7FKstomv4SbZW9UumvDKN608M7qW
         6tAQ==
X-Gm-Message-State: AFqh2kp517og/SrUPejr6BArgVjP3/gGnfHZlKwVWkJ9F4bfFQrPL2nl
        K8qT9iwGwHOFJLXiiPo/HOQ=
X-Google-Smtp-Source: AMrXdXuTzulKtnn92wYsH6GDStMBQGa72y5AwYy4Qvf8gge4HSZhAb2ApBfO6xNG7QyeUPGPRrgsag==
X-Received: by 2002:a17:90a:62cc:b0:223:7910:95f8 with SMTP id k12-20020a17090a62cc00b00223791095f8mr65230627pjs.36.1672974510675;
        Thu, 05 Jan 2023 19:08:30 -0800 (PST)
Received: from ISCNPF1JZGWX.infineon.com (KD106168128197.ppp-bb.dion.ne.jp. [106.168.128.197])
        by smtp.gmail.com with ESMTPSA id ns22-20020a17090b251600b00218f9bd50c7sm1979891pjb.50.2023.01.05.19.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 19:08:30 -0800 (PST)
From:   tkuw584924@gmail.com
X-Google-Original-From: Takahiro.Kuwano@infineon.com
To:     linux-mtd@lists.infradead.org
Cc:     tudor.ambarus@linaro.org, pratyush@kernel.org, michael@walle.cc,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        tkuw584924@gmail.com, Bacem.Daassi@infineon.com,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        stable@vger.kernel.org
Subject: [PATCH] mtd: spi-nor: spansion: Keep CFR5V[6] as 1 in Octal DTR enable/disable
Date:   Fri,  6 Jan 2023 12:06:01 +0900
Message-Id: <20230106030601.6530-1-Takahiro.Kuwano@infineon.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>

CFR5V[6] is reserved bit and must always be 1.

Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress Semper flash")
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Cc: stable@vger.kernel.org
---
 drivers/mtd/spi-nor/spansion.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index b621cdfd506f..4e094a432d29 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -21,8 +21,8 @@
 #define SPINOR_REG_CYPRESS_CFR3V		0x00800004
 #define SPINOR_REG_CYPRESS_CFR3V_PGSZ		BIT(4) /* Page size. */
 #define SPINOR_REG_CYPRESS_CFR5V		0x00800006
-#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN	0x3
-#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	0
+#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN	0x43
+#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	0x40
 #define SPINOR_OP_CYPRESS_RD_FAST		0xee
 
 /* Cypress SPI NOR flash operations. */
-- 
2.25.1

