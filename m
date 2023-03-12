Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A046B6C74
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 00:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjCLXQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 19:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjCLXQO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 19:16:14 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2BA26CEA
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 16:16:13 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id r5so11576559qtp.4
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 16:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678662972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AoGPgKe2IxoYrPUIJ5SHvzZG4v3yw/sB6Vnm+zuZIxo=;
        b=lQ/RO+iSEnK5ZBEa1lcIF0WVTdzciAmoC1PP+hRycMW3GkNDUlO3jt7aGHYwXW+EAj
         nK4tr6vpvcY/OjlCdUQFM8g8Z9o1o/aqWVy0q2o1YPh236+zKpa9NDUyELiS4vaL2lNN
         QX9LNF/Ko7ii+zn7FlC3jWr44B+pXkf18zntaAXQnmD8J0FqPuDfjs4HrYutlAoDPFmc
         bbzNQp8NOxeqmX4/yyJvs984AJ0AEO6g35je8aWkucgTnIirwYUbZT8Z4j2Iysb4fnQZ
         hBfBMZ5NqDilQUCNqyeMSySz4O8IjcJIW5UNw+fu9ssNeVOKhFyO8F/M0x6K2NZIVB8Q
         i6Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678662972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AoGPgKe2IxoYrPUIJ5SHvzZG4v3yw/sB6Vnm+zuZIxo=;
        b=Rf/uMxPMbuZdJnLKmS5V7SJWH1usIe4QfJrUSWezEOho+dpFrL/PxnehtdHB57q4Bd
         FrU5wo3u+AIFRD0JzpGq6c1mzUQoohB3opp6rExLdAxQzfH93RM4RedPuccLQzn2qMIT
         5E96pPE4Y+ME+SoZq0IotndzBzUIW4b6pZU+b3LijmRdddifkMOBtJ/XcgqGI1BVw3p8
         1579Kan1MHiFRGD7oQG9wTJt1WEEQLdtCe/RGVJff33sYO7p0Sr4MM4N8s3JJDVs0k0M
         W+PHCCgFbQB0iKlDfF7UBJu00kgyZZQGvPqXbFpcFnJD1V6kGRmGIjKmOtDhfTj0afAq
         Bk8g==
X-Gm-Message-State: AO0yUKXOEulL8PahpbtCZiaiJFk/6/NT56JOuEbb/WQHc/GbRwAYcTv5
        VSUqFAFkTaceCAuFXAwqfZzZrHK1FPOCPlq6vvo=
X-Google-Smtp-Source: AK7set9ALguWk4ZSeYP4J36WuS5uA8ksrQLDdeq0RjTAVM1WLijpdqARKxpjw5R5zDnw07rw3KnXYw==
X-Received: by 2002:ac8:5bc9:0:b0:3bf:b75a:d7a7 with SMTP id b9-20020ac85bc9000000b003bfb75ad7a7mr16113862qtb.7.1678662972326;
        Sun, 12 Mar 2023 16:16:12 -0700 (PDT)
Received: from fedora.attlocal.net (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id dm21-20020a05620a1d5500b00742f250ebc0sm4307091qkb.9.2023.03.12.16.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 16:16:12 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     linux-iio@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jic23@kernel.org, lars@metafoo.de,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.10 v3 3/6] counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Sun, 12 Mar 2023 19:15:51 -0400
Message-Id: <20230312231554.134858-3-william.gray@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230312231554.134858-1-william.gray@linaro.org>
References: <20230312231554.134858-1-william.gray@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
 drivers/counter/104-quad-8.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 21bb2bb76..1b4fdee9d 100644
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
@@ -643,17 +639,9 @@ static int quad8_count_read(struct counter_device *counter,
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
 
@@ -1198,8 +1186,8 @@ static ssize_t quad8_count_ceiling_read(struct counter_device *counter,
 
 	mutex_unlock(&priv->lock);
 
-	/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
-	return sprintf(buf, "33554431\n");
+	/* By default 0xFFFFFF (24 bits unsigned) is maximum count */
+	return sprintf(buf, "16777215\n");
 }
 
 static ssize_t quad8_count_ceiling_write(struct counter_device *counter,

base-commit: e5f315b55f8e09ac17c968da42f9345f64efcdd2
-- 
2.39.2

