Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255526DE001
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjDKPwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjDKPwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:52:37 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43C24EC3
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 08:52:35 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id i20so12334465ybg.10
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 08:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681228355; x=1683820355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVnzCMuG8yOr6jsr0GEp0cpvdQzZRFZZBcpuklzVomM=;
        b=MP3/MBQD+/KeXIGk4Kq2i951jxW+nIqkXxpC4/5Ve3x6RHWDhUhRiLM5bhHVzAz46J
         LFwbUIMhG2IhEDlG6Bp9RQgJvMtkye5PzZldbGZQr83UyNzvyAGjI9GGIpKwkLGnk8Mf
         CdkJ7zJAWpyapByQSRGQuo/SKPvlSNySk6iZx5Lj9bZdfVe0xLA5YGLtJYlgS5NnJm5v
         Ms4LeTJoxunl2EvuENwyZtsEqQRqF4PkpNd9nbQLBsV/jE/muQ5JsmgmvjIqBPT+iuHP
         2e4YxRUUIUkWKgSUKkgkPCiOn1ZVvVdNlEVI0AVljrjWP8g+8TTBwpiaq78o4KOsRrEV
         cNIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681228355; x=1683820355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YVnzCMuG8yOr6jsr0GEp0cpvdQzZRFZZBcpuklzVomM=;
        b=OEtF//SVmZGdvEQ40dtXIu0v50qt6kdpWVh0d7Mhbk26O8fvAYkXXbUNC1LohM9YhA
         dB/Nh0ksBq/gJNCklA3AX5WG/j9XyzfIlFuh/F2l6korSN9XNm3muNf/3BTUFP+8rJOi
         dSTADkliBlIxBnVOxNzYZ3DN5BaEF6nm8K+tkj6qKSL1be6KQ33JTY4BnvCY7BhKzBHT
         lePipG/tmMYBHymj9tzHng06nUUHAt4MEzDH/T0eEpqKbKkikBsnxGiGl32sIU+Tw8Ty
         MlnvN4O0j67vUeArFnaSFXEz9SITo9m07E6rvP7tXMx8SzzVMxSuZqSMlwblNu3KU7Rg
         0gNQ==
X-Gm-Message-State: AAQBX9cAZmJO7/0+oP13KIRsfXEwGv7WX7v7eHafgYWwy6QQ05RRnbBS
        7vLVyEcYE8VR+7Xl2wUqen/Hzg==
X-Google-Smtp-Source: AKy350a2r0p6xSocXox5/NbH6U0w0MyqWWZVnRpVrTTXIQZjimC9nR1mrVSwDRzh9GaQCiZHx2TSIQ==
X-Received: by 2002:a25:ab0a:0:b0:b72:245f:4411 with SMTP id u10-20020a25ab0a000000b00b72245f4411mr2396336ybi.46.1681228355448;
        Tue, 11 Apr 2023 08:52:35 -0700 (PDT)
Received: from fedora.attlocal.net (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id i13-20020a056902068d00b00b7767ca749fsm3683390ybt.60.2023.04.11.08.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 08:52:35 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [RESEND PATCH 5.15 v3 5/5] counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Tue, 11 Apr 2023 11:52:20 -0400
Message-Id: <20230411155220.9754-5-william.gray@linaro.org>
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
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/counter/104-quad-8.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 0caa60537b..643aae0c9f 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -61,10 +61,6 @@ struct quad8 {
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
@@ -121,17 +117,9 @@ static int quad8_count_read(struct counter_device *counter,
 {
 	struct quad8 *const priv = counter->priv;
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
 
@@ -699,8 +687,8 @@ static ssize_t quad8_count_ceiling_read(struct counter_device *counter,
 
 	mutex_unlock(&priv->lock);
 
-	/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
-	return sprintf(buf, "33554431\n");
+	/* By default 0xFFFFFF (24 bits unsigned) is maximum count */
+	return sprintf(buf, "16777215\n");
 }
 
 static ssize_t quad8_count_ceiling_write(struct counter_device *counter,

base-commit: d86dfc4d95cd218246b10ca7adf22c8626547599
-- 
2.39.2

