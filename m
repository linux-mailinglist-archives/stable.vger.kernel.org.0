Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6F56ED1E2
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 18:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjDXQBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 12:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjDXQBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 12:01:17 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E6F6A79
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 09:01:14 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9505214c47fso855806166b.1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 09:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682352073; x=1684944073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sll20Qvo96Pu0tmrXLoBnzqOrXx0GuRY8gBuzLvCX8I=;
        b=aH3+3yqkYqqOWyeUC/DjCwm29/sOAO/ezgePl+sTlC72v33GrjEBFutmsCWXd3UYDZ
         TbQvXw8g+awlKJjzX5/JvTMAC81dJsYt+uRu9oWDPMdW73G1PJhMLSUTq9v+If4uTeha
         BQTew3WXVL4rwfHajrx0P/vfyxVgyW5cth3hyEZj57SRATufB+2+7i9MMa7zKKW3JJT2
         bCzHYd5OQTHTN2n6bisjKkfqB3P98fERujPc2Z9d2PkvQReQ5555FtsmysIIvDX9VFGg
         6JtmiS3xKUSfVMra/AVyLYXgZ/gEOsTGlkdrR0xrmjJ6ORkBEDEhWFbR9aCiIT7drysZ
         O00Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682352073; x=1684944073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sll20Qvo96Pu0tmrXLoBnzqOrXx0GuRY8gBuzLvCX8I=;
        b=TaaPeBk30DttFFRACsPx+ehvQBTF5w2B93n8IFTbKA83gG6ImxHJk2a2hf5/iKJm50
         2zPXdVN4osLxGBB/DHFr5Mb1CLExxs9h7PRv/GaFzmWVQQz/yyxvler1PTPi4hpoWFbR
         uAQiuePnKli1qTsnr+sfgxKtm8UCl1PqpD7MIrRg/trt+ry3IlXU1eI7QxL+px8r5CkD
         6hqcsn+MdTLLEmzwuiNc7kIajh/qmtgY9EdiAdeQnxNY0H7T6/QdE7Sc0mslz4JiYNQI
         Q1yy+dpO0IrFM+qeIMG7GFuBdT0PLozpfmW6Z7IBs9v0iaQQFFbGMpDLGB3PACItXJsO
         Y/4A==
X-Gm-Message-State: AAQBX9fKusFa7WBjEfIgaPg+LldqB17cywWBU0m3AJnIpUQ4YtN3ghRT
        fLHxrAPCfNCaSeUfIeuVYdQRiQ==
X-Google-Smtp-Source: AKy350ZslENU0n/+EW9o/PtF7iqsmAR6mRvFkYStLGKHWxRBGPkEUrNXTT1bUsZSHShxzVdcEjJIaQ==
X-Received: by 2002:a17:907:7f04:b0:94e:3d6f:9c0f with SMTP id qf4-20020a1709077f0400b0094e3d6f9c0fmr12384686ejc.55.1682352072898;
        Mon, 24 Apr 2023 09:01:12 -0700 (PDT)
Received: from fedora.. ([195.167.132.10])
        by smtp.gmail.com with ESMTPSA id g10-20020a170906594a00b008cecb8f374asm5665879ejr.0.2023.04.24.09.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 09:01:12 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.10 v5 2/2] counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Mon, 24 Apr 2023 12:01:05 -0400
Message-Id: <20230424160106.4415-2-william.gray@linaro.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424160106.4415-1-william.gray@linaro.org>
References: <20230424160106.4415-1-william.gray@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4aa3b75c74603c3374877d5fd18ad9cc3a9a62ed upstream.

The Counter (CNTR) register is 24 bits wide, but we can have an
effective 25-bit count value by setting bit 24 to the XOR of the Borrow
flag and Carry flag. The flags can be read from the FLAG register, but a
race condition exists: the Borrow flag and Carry flag are instantaneous
and could change by the time the count value is read from the CNTR
register.

Since the race condition could result in an incorrect 25-bit count
value, remove support for 25-bit count values from this driver.

Fixes: 28e5d3bb0325 ("iio: 104-quad-8: Add IIO support for the ACCES 104-QUAD-8")
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/counter/104-quad-8.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 21bb2bb767a..89c9cb850a3 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -62,10 +62,6 @@ struct quad8_iio {
 #define QUAD8_REG_CHAN_OP 0x11
 #define QUAD8_REG_INDEX_INPUT_LEVELS 0x16
 #define QUAD8_DIFF_ENCODER_CABLE_STATUS 0x17
-/* Borrow Toggle flip-flop */
-#define QUAD8_FLAG_BT BIT(0)
-/* Carry Toggle flip-flop */
-#define QUAD8_FLAG_CT BIT(1)
 /* Error flag */
 #define QUAD8_FLAG_E BIT(4)
 /* Up/Down flag */
@@ -104,9 +100,6 @@ static int quad8_read_raw(struct iio_dev *indio_dev,
 {
 	struct quad8_iio *const priv = iio_priv(indio_dev);
 	const int base_offset = priv->base + 2 * chan->channel;
-	unsigned int flags;
-	unsigned int borrow;
-	unsigned int carry;
 	int i;
 
 	switch (mask) {
@@ -117,12 +110,7 @@ static int quad8_read_raw(struct iio_dev *indio_dev,
 			return IIO_VAL_INT;
 		}
 
-		flags = inb(base_offset + 1);
-		borrow = flags & QUAD8_FLAG_BT;
-		carry = !!(flags & QUAD8_FLAG_CT);
-
-		/* Borrow XOR Carry effectively doubles count range */
-		*val = (borrow ^ carry) << 24;
+		*val = 0;
 
 		mutex_lock(&priv->lock);
 
@@ -643,17 +631,9 @@ static int quad8_count_read(struct counter_device *counter,
 {
 	struct quad8_iio *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id;
-	unsigned int flags;
-	unsigned int borrow;
-	unsigned int carry;
 	int i;
 
-	flags = inb(base_offset + 1);
-	borrow = flags & QUAD8_FLAG_BT;
-	carry = !!(flags & QUAD8_FLAG_CT);
-
-	/* Borrow XOR Carry effectively doubles count range */
-	*val = (unsigned long)(borrow ^ carry) << 24;
+	*val = 0;
 
 	mutex_lock(&priv->lock);
 
@@ -1198,8 +1178,8 @@ static ssize_t quad8_count_ceiling_read(struct counter_device *counter,
 
 	mutex_unlock(&priv->lock);
 
-	/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
-	return sprintf(buf, "33554431\n");
+	/* By default 0xFFFFFF (24 bits unsigned) is maximum count */
+	return sprintf(buf, "16777215\n");
 }
 
 static ssize_t quad8_count_ceiling_write(struct counter_device *counter,

base-commit: 791a854ae5a5f5988f1291ae91168a149bd5ba57
-- 
2.40.0

