Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0D86DE000
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjDKPwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDKPwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:52:36 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7552F4C2C
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 08:52:35 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id ch3so9744781ybb.4
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 08:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681228354; x=1683820354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=daPYhCzB7SEVb4s3T1TV70tcgOBLpgetbD3DUYP20DI=;
        b=s8nmKgrHFtdn17kHL7e1AxEvw/l9oWgrKWasQIEECRD09VQvjuMH3wUp94Rgz6Q4XW
         NpVnJB8dFk+Gdu0wY2+P26KhCH7RhK0/a+8Jms/AXXbByLKejAlXnrehwcu33l2h9wfI
         lyWjcwofFlBT2M6R/AQeuZndzij/g4V3TvJpjYozj1NqRM/hGee/FklCDrqmFrvq/W5m
         jbMLBlZzdTyCt1liXeL7RDvEidKVs/8P5wS1n2PbpTIE5s8h1nKghywrbxj46Rr0mB5i
         AlECqO8KkbJVX0KHo5WHWyF4wRB4oWQ4Cv0Zh5fzOOiJM20ywsoMdcMMFtz7ZYiXcTVF
         8Scg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681228354; x=1683820354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=daPYhCzB7SEVb4s3T1TV70tcgOBLpgetbD3DUYP20DI=;
        b=ki+dCG34ukNAzkek6chkqL+wLqfwRno+TvDnEEtbshO8xnlfbCYqMT4YboVxrO7h0j
         1pqPpmsQcJ/PqpnEIn7+ewZnLnG2emivTuzQ+PPqUViR3yniRQHR90eQgUyJTpUfZGH0
         eWZGFFJAw8/cXHTOj+NDRSfSCEf3c6JcmC/F5PcGlfr3dKGilDTvxPzlA9Yzh7heU1SJ
         hIKDY5cX0mwH5u5ARUqwM3on1xZC4Mq6dvcUVep7x5O4d7Es8rv6mXBMIEYv7Hjyc2DB
         kkMXjUMbsiPcVicpPQKDAoeHq9C9yBpYLPZYwzThX72d8rNEAeseq37SK6jmBpJmD0CA
         It2g==
X-Gm-Message-State: AAQBX9dGCuA7MLX/X+17ZFBgL74A0L3nS6J35keofWdRcICSe/AV101U
        5v32Y04Zpe7d0dTpNnOUdWd4Tw==
X-Google-Smtp-Source: AKy350YqtHt8PRSduE8nry8VW1BZVJSdeFbIFj8k3jRBK2Jrmh+0Tt5oD9pk3wCgW8SunPZMEqrykg==
X-Received: by 2002:a25:ea03:0:b0:b8f:f5f:13e9 with SMTP id p3-20020a25ea03000000b00b8f0f5f13e9mr3368186ybd.2.1681228354656;
        Tue, 11 Apr 2023 08:52:34 -0700 (PDT)
Received: from fedora.attlocal.net (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id i13-20020a056902068d00b00b7767ca749fsm3683390ybt.60.2023.04.11.08.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 08:52:34 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [RESEND PATCH 5.10 v3 4/5] counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Tue, 11 Apr 2023 11:52:19 -0400
Message-Id: <20230411155220.9754-4-william.gray@linaro.org>
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
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/counter/104-quad-8.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 21bb2bb767..1b4fdee9d9 100644
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

base-commit: 387078f9030cf336cd9fef521540db75b61615e0
-- 
2.39.2

