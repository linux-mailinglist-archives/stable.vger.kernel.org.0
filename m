Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E026B6C76
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 00:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCLXQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 19:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjCLXQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 19:16:15 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC462687F
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 16:16:14 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id ne1so7224393qvb.9
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 16:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678662973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bCcXjp0lmCj4QKMRCOzzdkCGwVUe3cwJnV9tyaVVNvo=;
        b=U8pWOtImrgJIFjVZj/Xq28/NpjxPFf4vLzvZkVXzha0RwiZNbGTkVlx+8nsrFxRvrx
         jXOd94daNGzJuQaiJoKqIAW72RfljfcnTf8SmgRtf2Yy/4jyh93POzHWWPyP3/vjmDW7
         kNS/hwRH0mC8W2H0Dzc3U8gj9PCqhahCDy+U0JjcZpAFiEeUF/p0+moqlX1cyCQHno+h
         thwIGBFuRVMl6uAz4UISKWlVaMCjtWgXuMoiPEFolSAkISbJJclZUEqpNEt/zWI/bVjb
         NmL4bLI0fXg6n6khREG9g4j1pISa2iT2g4ZTjFCy3fcZqcsSVrglBeiA069Kvobtap9l
         +ftA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678662973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bCcXjp0lmCj4QKMRCOzzdkCGwVUe3cwJnV9tyaVVNvo=;
        b=jgkTSGLMcl6gf7POSavoIBrNhc7u/cgzUCWKaxSlGMfIHCBFtmnoBS/XvgJ/wbtlFI
         bQnB07yN9DGM1Xs2Q9qvV93/DcVdyg5wOHnK3nHmurfe5rmsn/2cU8Np0k/zN6Z8BTOj
         ptk0N4BVRRkdTfZa/9JYAgpOCbZDIKAhVFAeZdih6R4p4LoS6m2fwGw5N4K/9CzWhopC
         7xPEieFkrZxoVxBrvB27eojWqGxufZd0xdUkjKSVTaOWJB2SIpa4WSDdMfi/BrZalafQ
         0Yix+z6UmSYcoZIltPdY9V8hF6yVPU6bQUOVW1LxQR8uTF90/gX8GHt4gq5gO6NvkdCa
         8mjA==
X-Gm-Message-State: AO0yUKUz5t/bjwN38i+riydc8gQv4LJskMPwzklsufuZ1NC7yQhIs3aG
        kYq5FntYszVAiv97+ZfzSGq4RQ==
X-Google-Smtp-Source: AK7set8TQw8kYJb3ilSZLR2EUfhLXZ5VF3QVyPy8kdoT5WxN/ahhT4HfrRMD+6Pc5opZDP1IqA54Hw==
X-Received: by 2002:a05:6214:f06:b0:56e:a96a:2bdc with SMTP id gw6-20020a0562140f0600b0056ea96a2bdcmr11438508qvb.40.1678662973185;
        Sun, 12 Mar 2023 16:16:13 -0700 (PDT)
Received: from fedora.attlocal.net (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id dm21-20020a05620a1d5500b00742f250ebc0sm4307091qkb.9.2023.03.12.16.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 16:16:12 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     linux-iio@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jic23@kernel.org, lars@metafoo.de,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.4 v3 4/6] counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Sun, 12 Mar 2023 19:15:52 -0400
Message-Id: <20230312231554.134858-4-william.gray@linaro.org>
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
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/counter/104-quad-8.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index f261a57af..48de69f58 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -57,10 +57,6 @@ struct quad8_iio {
 
 #define QUAD8_REG_CHAN_OP 0x11
 #define QUAD8_REG_INDEX_INPUT_LEVELS 0x16
-/* Borrow Toggle flip-flop */
-#define QUAD8_FLAG_BT BIT(0)
-/* Carry Toggle flip-flop */
-#define QUAD8_FLAG_CT BIT(1)
 /* Error flag */
 #define QUAD8_FLAG_E BIT(4)
 /* Up/Down flag */
@@ -639,19 +635,9 @@ static int quad8_count_read(struct counter_device *counter,
 {
 	struct quad8_iio *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id;
-	unsigned int flags;
-	unsigned int borrow;
-	unsigned int carry;
-	unsigned long position;
+	unsigned long position = 0;
 	int i;
 
-	flags = inb(base_offset + 1);
-	borrow = flags & QUAD8_FLAG_BT;
-	carry = !!(flags & QUAD8_FLAG_CT);
-
-	/* Borrow XOR Carry effectively doubles count range */
-	position = (unsigned long)(borrow ^ carry) << 24;
-
 	mutex_lock(&priv->lock);
 
 	/* Reset Byte Pointer; transfer Counter to Output Latch */
@@ -1204,8 +1190,8 @@ static ssize_t quad8_count_ceiling_read(struct counter_device *counter,
 
 	mutex_unlock(&priv->lock);
 
-	/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
-	return sprintf(buf, "33554431\n");
+	/* By default 0xFFFFFF (24 bits unsigned) is maximum count */
+	return sprintf(buf, "16777215\n");
 }
 
 static ssize_t quad8_count_ceiling_write(struct counter_device *counter,

base-commit: 126ee8982bfcae6111f0fd157ee5cdd0ec7f5ca5
-- 
2.39.2

