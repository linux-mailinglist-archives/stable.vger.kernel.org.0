Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0FF6DDFF8
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjDKPwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDKPwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:52:34 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271E62723
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 08:52:33 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id v7so7169639ybi.0
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 08:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681228352; x=1683820352;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7DQjB9jjSniX8WUn0hxZzli/VJttza7GiVrQjQV9IoA=;
        b=dpyrf0ifpUMeAEvu8Wf578r8CUr/1v6SAD7UgK0B3YcGvaSKQ3g2wlO2F7wbE09ACW
         +80MxGqHgY9PUMgzKrtA96in292vvDoNetsu6pJHqDaTXVDcvi3MtnqLQvRbFfrpNlAv
         tPzlU1PvUacXf3sd3OYkdq8l3tlDRsxDMoZKBNZx/SAzrJU1TGZjUnflNmA0x6Y0OIic
         d2ucXIikHJeU5BYCm6xr1EQNtKZ1uW+nyqt+OCFJ/qE8LtMyQLupVNMTfdiEOgFkyd1T
         cp3Ih6v/GvBGoKcgEQfJaAUiglhOk/x/Z8zMh/bvqd2VJlzkCgzAX+FN3WJWEsHM5PX/
         hW4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681228352; x=1683820352;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7DQjB9jjSniX8WUn0hxZzli/VJttza7GiVrQjQV9IoA=;
        b=qCAtjiEv34WXTfVLoD5uvcewt6f24hSrlvynCZyDUSUboGnlfBOpDA1MuVJ+yPleLr
         S8Gpsk0sdhG3fJLpMi2+hwL6qsqD+bqa62LXi5zuEHw9xn+97xofccs6xubTXeuxVm3k
         PKski5GP2vhd5O9nZBviR5aYLCweZN9+xb8t2CaJS13pNmoanhVX7d6oOcekjws1Eg+j
         oR58P8S9wQIjP+sW2+ghWwfaIzGFgHEJq3l/nsPFH63PMhR8oq5zdd9kzD8QN0BbNHIs
         +DM5tverK83hXZ168FF1fkXiAXNUnU7noHpHSuU3QtzSf2XNEWhA6fZhP2Meu/zxCa7L
         OHqg==
X-Gm-Message-State: AAQBX9d4bZS7XsJVz5ycRhwrV5UNEqZR7NehfiMrT/RIu0K/5VmBEvRS
        i1SLbswb4gncVuka2Wx54MgitsE7j1SZIRjBUW6NYw==
X-Google-Smtp-Source: AKy350bvU9oF7Z3oiDlXBWDjKnr5iukeWwTFd1dtkT3Gt8bLaR4FVVNT+wSpGQYLJwyBBI20EpbPWw==
X-Received: by 2002:a25:e78e:0:b0:b8e:e4be:923a with SMTP id e136-20020a25e78e000000b00b8ee4be923amr6238760ybh.4.1681228352348;
        Tue, 11 Apr 2023 08:52:32 -0700 (PDT)
Received: from fedora.attlocal.net (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id i13-20020a056902068d00b00b7767ca749fsm3683390ybt.60.2023.04.11.08.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 08:52:31 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [RESEND PATCH 4.14 v3 1/5] iio: counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Tue, 11 Apr 2023 11:52:16 -0400
Message-Id: <20230411155220.9754-1-william.gray@linaro.org>
X-Mailer: git-send-email 2.39.2
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
Cc: <stable@vger.kernel.org> # 4.14.x
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/iio/counter/104-quad-8.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/iio/counter/104-quad-8.c b/drivers/iio/counter/104-quad-8.c
index 181585ae6..bdb07694e 100644
--- a/drivers/iio/counter/104-quad-8.c
+++ b/drivers/iio/counter/104-quad-8.c
@@ -64,9 +64,6 @@ static int quad8_read_raw(struct iio_dev *indio_dev,
 {
 	struct quad8_iio *const priv = iio_priv(indio_dev);
 	const int base_offset = priv->base + 2 * chan->channel;
-	unsigned int flags;
-	unsigned int borrow;
-	unsigned int carry;
 	int i;
 
 	switch (mask) {
@@ -76,12 +73,7 @@ static int quad8_read_raw(struct iio_dev *indio_dev,
 			return IIO_VAL_INT;
 		}
 
-		flags = inb(base_offset + 1);
-		borrow = flags & BIT(0);
-		carry = !!(flags & BIT(1));
-
-		/* Borrow XOR Carry effectively doubles count range */
-		*val = (borrow ^ carry) << 24;
+		*val = 0;
 
 		/* Reset Byte Pointer; transfer Counter to Output Latch */
 		outb(0x11, base_offset + 1);

base-commit: f03c8bbaf6d9cbebee390e8353c5df75293aff7c
-- 
2.39.2

