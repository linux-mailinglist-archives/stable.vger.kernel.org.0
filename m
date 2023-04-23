Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D886EC318
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 01:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjDWXVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 19:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjDWXU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 19:20:58 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCC110FA
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 16:20:56 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 3f1490d57ef6-b95c3b869dcso12048299276.1
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 16:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682292056; x=1684884056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YzAHMc97ie/I1BcVW78M2VJNx9wjhBXHbWDgzi0U6j8=;
        b=DHVnP7nGrg3vRnIqtPn1Q7mvsvrHjcTern73pfkIbqsV9bRZPyP+MqQ5KrjJfSLW2A
         ImSGBdVeLWUAHIEaqo1ptnqhYq5k8JfyfS3qnHJvTvV/tJ5j9DWNh2Rnp6PxvxvNgP/a
         vaxJQXbZbAfwINkpKh1fg+2Jj2yF4CKx949f2oPgiuXGaGqBgCsSPyqL7zyobXg5BKi5
         LTbWdtswKpcCYv0oAh41d0mqSd3G1qzTDrCtDXlwl7Tj0a2E7bWhYQA6vFVgqU3ZRS6/
         osMpsJUlObexxTVr0xxCfrEZLHcJzr40NjKXCVYbPwuK8mtGtBBy17EYDtkBE+m22ItH
         t0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682292056; x=1684884056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YzAHMc97ie/I1BcVW78M2VJNx9wjhBXHbWDgzi0U6j8=;
        b=EW2hXRvWdq0AljHEFgcrohI4ctUkBAa8OLa6hh02r1pGmnA6Kc5xQ/NGp/XChAKkr5
         tlYNb+3f9+Xi/YtE+Q47zARuExK1fbpicZLMfDSIXPGEFW66McakSRPLnw/BslRaweHt
         Ot4H2iZfKEZeHs58t93og50wnCz5WxkWErsFdSllJmdB4wm2dFEyCVqiAE82E8sYGJOP
         PcoXZDLmHnNIWpnk107Mcjk9kD6JJobDUfhpZvfHBie7NCFAt0lutkuVlSRRbs1aY8Sh
         wZzwDui8kMRVm/Cwg4yTMbBIbeHFfEGuOgFoBwEtKrkqaYciw78VT8CJKt+JYWqoi998
         51Hw==
X-Gm-Message-State: AAQBX9c8gJbp/plnmnRlUld22T8C0L1S2ApEgksvELoBQJWtfLQZ9l+i
        8D+Mi3TyFP0UVTsCbGIWh+02HQ==
X-Google-Smtp-Source: AKy350Y4bsziUezOmWgOvpjrp33g5jOYb3Yhg5QNTxK1FyUPU1gTw5mq7+2RSZuXM/1EMS6om+fMYw==
X-Received: by 2002:a81:49cb:0:b0:54f:52b7:3eac with SMTP id w194-20020a8149cb000000b0054f52b73eacmr8050321ywa.9.1682292055967;
        Sun, 23 Apr 2023 16:20:55 -0700 (PDT)
Received: from fedora.. ([198.136.190.5])
        by smtp.gmail.com with ESMTPSA id z205-20020a0dd7d6000000b0054f856bdc4dsm2607352ywd.38.2023.04.23.16.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 16:20:55 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 4.19 v4 2/5] iio: counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Sun, 23 Apr 2023 19:20:44 -0400
Message-Id: <20230423232047.12589-2-william.gray@linaro.org>
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
Cc: <stable@vger.kernel.org> # 4.19.x
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/iio/counter/104-quad-8.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/iio/counter/104-quad-8.c b/drivers/iio/counter/104-quad-8.c
index 92be8d0f77..92e68cada8 100644
--- a/drivers/iio/counter/104-quad-8.c
+++ b/drivers/iio/counter/104-quad-8.c
@@ -61,10 +61,6 @@ struct quad8_iio {
 
 #define QUAD8_REG_CHAN_OP 0x11
 #define QUAD8_REG_INDEX_INPUT_LEVELS 0x16
-/* Borrow Toggle flip-flop */
-#define QUAD8_FLAG_BT BIT(0)
-/* Carry Toggle flip-flop */
-#define QUAD8_FLAG_CT BIT(1)
 /* Error flag */
 #define QUAD8_FLAG_E BIT(4)
 /* Up/Down flag */
@@ -97,9 +93,6 @@ static int quad8_read_raw(struct iio_dev *indio_dev,
 {
 	struct quad8_iio *const priv = iio_priv(indio_dev);
 	const int base_offset = priv->base + 2 * chan->channel;
-	unsigned int flags;
-	unsigned int borrow;
-	unsigned int carry;
 	int i;
 
 	switch (mask) {
@@ -110,12 +103,7 @@ static int quad8_read_raw(struct iio_dev *indio_dev,
 			return IIO_VAL_INT;
 		}
 
-		flags = inb(base_offset + 1);
-		borrow = flags & QUAD8_FLAG_BT;
-		carry = !!(flags & QUAD8_FLAG_CT);
-
-		/* Borrow XOR Carry effectively doubles count range */
-		*val = (borrow ^ carry) << 24;
+		*val = 0;
 
 		/* Reset Byte Pointer; transfer Counter to Output Latch */
 		outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP | QUAD8_RLD_CNTR_OUT,

base-commit: a5b79a58cfc02977cd4d5c1e20454cd98e88f749
-- 
2.40.0

