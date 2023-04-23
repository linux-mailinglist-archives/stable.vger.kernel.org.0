Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5156EC31A
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 01:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjDWXVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 19:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjDWXU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 19:20:59 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BFC10F0
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 16:20:57 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-54fb6ac1e44so44171837b3.1
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 16:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682292057; x=1684884057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwu1vhLpwiGpAHC/Cs/4RYcqfeSmxKDk74qORfSjerc=;
        b=KiJIx1lLBudl5/4Qj/SXSbYpb2JKY8zbM6jvYAio1X9nOb1fQ9hXxJQ8Kufczf8IIY
         JpkjEKSp1YfIO3fP56IzROgCrAXcBt0N1MN7DKTVZqG8UqT50v3N56L1RpXcQ873nCtv
         TpBAVN92QuLkzRS/iAX8e4BvMnOJqP6bLJfYc5qd+CQhsHJTx/XiWm1UpDi4wiIwooEi
         QcG4g3zGOBGa+qdPX4WXD5klcZ/qEKAsBPIKxhRmZpD4L1Mnl3xV1QxIBlhbvK0MGpbM
         PPTLz+PoOp+r3XhvRKScO2EgT4ptDqLIP22Dy+38rTLL7MpsvhWo//Vk4U6LElLiaxw0
         wqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682292057; x=1684884057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uwu1vhLpwiGpAHC/Cs/4RYcqfeSmxKDk74qORfSjerc=;
        b=gkYyYxjS0CVVeSfPrWwH6gnS9yErvmAKVcAhmTU++2Q2y5aU6VZwvwVuhLZ0hnILi/
         bb2jrTYLge8/37pLs1jxcyL/36gQlJHCcE4fTjc7aAduUvz/O7eC0kSafLDrxZFR48nL
         o+9uJfRHExLnAg1X8xVeUYXGcrMHEyv9RrgzCXwJ5He6ThvxeTCkyzGQRx/32YR5PK1F
         9uodwrKA41W+lstzOAV3m8tDI2fyw7S5ZuKODUvhp7wkKbaio5r+6R8ss548fwcN6Wsr
         9k5McYIoB7xisiYyB/x/K2Jc4dPQfkSke/mu/ZZzrrvDLepeU40WK74iwSCVQkvKEh+l
         7c7Q==
X-Gm-Message-State: AAQBX9eq2W70T+ULecm8p0H2CJnB6s5PYIlFIggO3INndJ70lB48KL59
        fEK6EKfVMG9MLWZMh3YmA/EFdg==
X-Google-Smtp-Source: AKy350aKIQWgrvAgAAvztgDvqheIbGCFbUU49e68tH9Z7HssooWmErHS4yQsKScaMjot4tO5ooOuHA==
X-Received: by 2002:a0d:ed07:0:b0:54e:b6b2:1bba with SMTP id w7-20020a0ded07000000b0054eb6b21bbamr6777137ywe.0.1682292056933;
        Sun, 23 Apr 2023 16:20:56 -0700 (PDT)
Received: from fedora.. ([198.136.190.5])
        by smtp.gmail.com with ESMTPSA id z205-20020a0dd7d6000000b0054f856bdc4dsm2607352ywd.38.2023.04.23.16.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 16:20:56 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.4 v4 3/5] counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Sun, 23 Apr 2023 19:20:45 -0400
Message-Id: <20230423232047.12589-3-william.gray@linaro.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230423232047.12589-1-william.gray@linaro.org>
References: <20230423232047.12589-1-william.gray@linaro.org>
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
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/counter/104-quad-8.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index f261a57af1..48de69f58e 100644
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

base-commit: 58f42ed1cd31238745bddd943c4f5849dc83a2ac
-- 
2.40.0

