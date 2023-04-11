Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF336DDFFE
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjDKPwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjDKPwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:52:36 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18524EEB
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 08:52:34 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id d204so253953ybh.6
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 08:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681228354; x=1683820354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fqIfvm1jwgfEXPWpkKRz5ERVmmhoVaNqmhNdHXexQ4w=;
        b=IXFXL/AL+uZl+iYIcoG9aarge/H8K1NeyCmpcIUo+APyfhlvVFnXUhfeKab+TZ37Wv
         uyul1KitAUjiHkMRUztnQZkI3MFselOfNNdKztA0TfZNzN4pRnL7etXrUiBWr0dgthEI
         K2v1DO4n5ASENLCSxuOKPvPIVYKSOWrSpYXS1/QIzniYOrH9fnsdF1bHbjqcpDXdN2eJ
         5OfJdSops0MEQNTu01FWfRtLsSvlpEu4itzmlWjh/s+1yf8MiWAbzrJ9Zxb1MK9XnMp3
         ZOl1XXoGT77K37S7zBfeQOp2jNSX+IVrki2zrQhW0UYfSSYNYOw2VGeCS1wLt+fk0AK/
         I5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681228354; x=1683820354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fqIfvm1jwgfEXPWpkKRz5ERVmmhoVaNqmhNdHXexQ4w=;
        b=sdtEOxyYcRS//0XaP8X6GJJ4iDGgEFZ612hQZJ5oaRpMf4PtGMEuqoJSo2HiQaCanm
         yc2KKhNTeHwQDp5mSGSpVIp7JXSc+84aGiHTD6Nrm60EvPwEO3IlEw8ZDowRHpUWBiA7
         67CKqyVNRpiSNLj3UO/NDM0L2dWqUAvc2/F0HZcUI9iH+O4wicz1njjnfvTfuxeXMTgG
         zjp1Yd2QzSUdBFJ0PeUEDY2W4NcI3MMyGJfy9v6HUNlkArC9oPabiSZGy7gAyzXJXUB2
         y+lq6e0TFBXIgqceKMftEOEFRAo8xKAHzpSEaW5bTKVC99GR1gcBAkueNZJTSyTnzf18
         3GHA==
X-Gm-Message-State: AAQBX9f+hP2o20Sqxls9hrWFYpp9f1Pldlo+Yxp1gPUlSKKZS05rdjbs
        i2TBVQNGdAH379aLrkZTUH82NA==
X-Google-Smtp-Source: AKy350aT0zxuuJUmLFgMSJj+vRNJhxHu2iFB85HVTAvunu3Pqv7KMsK/TGtVpKpmFb+IOxFMWXsb2g==
X-Received: by 2002:a25:d3d0:0:b0:b8f:2033:c10d with SMTP id e199-20020a25d3d0000000b00b8f2033c10dmr2581494ybf.59.1681228353960;
        Tue, 11 Apr 2023 08:52:33 -0700 (PDT)
Received: from fedora.attlocal.net (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id i13-20020a056902068d00b00b7767ca749fsm3683390ybt.60.2023.04.11.08.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 08:52:33 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [RESEND PATCH 5.4 v3 3/5] counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Tue, 11 Apr 2023 11:52:18 -0400
Message-Id: <20230411155220.9754-3-william.gray@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411155220.9754-1-william.gray@linaro.org>
References: <20230411155220.9754-1-william.gray@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

base-commit: 32bea3bac5ca484c6f7e302c8c96fc686f62e7b4
-- 
2.39.2

