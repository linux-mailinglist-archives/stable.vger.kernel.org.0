Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD65359BCC7
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 11:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbiHVJ0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 05:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbiHVJ0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 05:26:33 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6673717045
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 02:26:32 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id be9so6456630lfb.12
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 02:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=kOmDThbQ/aHdn0cHgaQs8wrJbMuMSQqFEBcMI9WIhrs=;
        b=Gr2oOPm0jk1R1HATQHAa7/8RFEoHIpAE7XpDgd/o3CGdy1L37xQuFdRreCJ/ybgyCO
         Uspg8jF/OQBYmdad2MhUnElmlCnxUL17PpQk3J6p4ioNq6aNhOyzldcveFvOptMwGzme
         l98xqC9sUV4GcghVMoLU9bC5uI4EazsAHkGy+f2Ae4arzIznkbgY0IgFmj6gN1BdtkF/
         qq5+lEEmcCfHZus4q5NrUzhlFTNFcSW0Q10V4T6VXFH5QcsQCxzOxOjTR8/6E5W79qa8
         p3BcD0eFZAbwVdrurLSMLgTmX4LrOd6j5TLxond+OvA8H0DBUQrde7JrUTxh0hiRq6Rm
         ZqYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=kOmDThbQ/aHdn0cHgaQs8wrJbMuMSQqFEBcMI9WIhrs=;
        b=y2RIm3OSXerdAngwRWa1coMY1efZd9S/tcjU0kwjrIOGFsv6NqbspyceqZfpguFmdk
         tdCjUWCb9nVgVqyZqwa8TYVCqWry+8NtjEzOYd/KZnQNT2dmJJI5aqNEcBDfJaDe6nTC
         HiZaNmB/WKlanpdMkqqmvC6lWkyLu+VHoC4VLogliO05jeNo/8EwWugblD7DQJC6UkUR
         GcsKxaE/juwTudfdc3tCRZdw8LXuVe705obERGWmn2n5Ek3RJ+W6YLKk6nPIdI7Sy0fE
         dJU7ecavn7SrTXIy6BirWfImjjj/J+wKkMyUXSvfcsfaqruZ8ON+z79y3aYON78gX6vJ
         FLuA==
X-Gm-Message-State: ACgBeo2lTOohi0EnV9riGjBJX0f9L9YsdXEvbTfgIXu52c+x+3WQm947
        vbBu1F/rVy63OZIyVd4DWoBJyMd2ajA5XA==
X-Google-Smtp-Source: AA6agR5xTQ8JFege08swgT2dXnLmpBkoODT8zmQCd9uphYzIQ2v+kEuEo2UQKKuAFgMZGr/ZbfzBgA==
X-Received: by 2002:a05:6512:13a4:b0:477:a28a:2280 with SMTP id p36-20020a05651213a400b00477a28a2280mr6323040lfa.689.1661160390402;
        Mon, 22 Aug 2022 02:26:30 -0700 (PDT)
Received: from jade.urgonet (h-79-136-84-253.A175.priv.bahnhof.se. [79.136.84.253])
        by smtp.gmail.com with ESMTPSA id s8-20020a19ad48000000b0048ae316caf0sm1840204lfd.18.2022.08.22.02.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 02:26:29 -0700 (PDT)
From:   Jens Wiklander <jens.wiklander@linaro.org>
To:     stable@vger.kernel.org
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] tee: add overflow check in tee_ioctl_shm_register()
Date:   Mon, 22 Aug 2022 11:26:21 +0200
Message-Id: <20220822092621.3691771-1-jens.wiklander@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 573ae4f13f630d6660008f1974c0a8a29c30e18a upstream.

With special lengths supplied by user space, tee_shm_register() has
an integer overflow when calculating the number of pages covered by a
supplied user space memory region.

This may cause pin_user_pages_fast() to do a NULL pointer dereference.

Fix this by adding an an explicit call to access_ok() in
tee_ioctl_shm_register() to catch an invalid user space address early.

Fixes: 033ddf12bcf5 ("tee: add register user memory")
Cc: stable@vger.kernel.org # 5.4
Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
Suggested-by: Jerome Forissier <jerome.forissier@linaro.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[JW: backport to stable-5.4 + update commit message]
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
---
 drivers/tee/tee_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index a7ccd4d2bd10..2db144d2d26f 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -182,6 +182,9 @@ tee_ioctl_shm_register(struct tee_context *ctx,
 	if (data.flags)
 		return -EINVAL;
 
+	if (!access_ok((void __user *)(unsigned long)data.addr, data.length))
+		return -EFAULT;
+
 	shm = tee_shm_register(ctx, data.addr, data.length,
 			       TEE_SHM_DMA_BUF | TEE_SHM_USER_MAPPED);
 	if (IS_ERR(shm))
-- 
2.31.1

