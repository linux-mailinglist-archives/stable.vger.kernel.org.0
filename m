Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7290C59C205
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 17:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbiHVPD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 11:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235836AbiHVPDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 11:03:41 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77232721
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:03:33 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id bt10so2696232lfb.1
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=s9RkTDo4SoFjXudAZwuI5Hyszfl41uP+HRAn3oY2OzA=;
        b=apTA10eCmlIWRtitS2POO7e2XPAtkk5uK4fNNgARNQpGE6sk3cbFtMMKWxs3gYRTcb
         RGj6RdIS5exESO8UjG8BUW6x8eh52IAjrNGiTv4N0qMjaNMToqxmEXdHuLmpoTgjaWJ4
         mB1X2HeJDQ6J1UDUYjXhfmP9tU2ImugoStKvGNULLkZ1KPi+0TsWkER82VSxkzlV1Zs8
         SAk3CjOG3OknPVfZiIc9sp2sLPPmZJUnqtLEWxcx5U9HKeh+n1vr/EedlaYM9H2pTl3E
         1/U8QM0BPgOKFwX+YJptXim7g2raMZ88ztd/cSa2P9mNbTIMRpzw2yUkbVSPmxYAMkc8
         qcCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=s9RkTDo4SoFjXudAZwuI5Hyszfl41uP+HRAn3oY2OzA=;
        b=uQivBEpDvS6c6MckcMS+sLRjn9/aIPbOvR66r7ldlCKdE7dhVfiCMKKtw6NkeM4CTA
         jSyvR2EGZErZzKsPNvuX4Hnn4F+6qAuxgRCuvfqVrL/5TFB2/pGNluoKJ/gZSKKy/pNB
         xr8ekuy09f49/0J8DaSwJaF2gUeifjQuc+/KvpTRWOHs42yyEjmcomQvaTXq77RV67HC
         et2teG0WshYnQHvVKtyJLF2pTo9774L4Wynv+aFuT4XF3KEbMgIllLYgJSx+hy7hOaWh
         1XQKU6uzFmHWNZZNCChaasPl8NY2J7VHBvx9pGMZgSdkyIfMUX6b/UKasYrulT5DlPQG
         FOIA==
X-Gm-Message-State: ACgBeo38bcu4RpfMa/Par6H230TdnXuBSCbp0KhOofk4MVpqWgt0fhKZ
        YTbJZLnDkzmgDuFgXSyjwlwxSls62EV7Sg==
X-Google-Smtp-Source: AA6agR4IjnFiJo4JNVyHGVCndKpUvYXQ4xb2KHrRqNBwION/JcZHGt+mopVMN8tgED073QS9wYVBYA==
X-Received: by 2002:a05:6512:139c:b0:48f:da64:d050 with SMTP id p28-20020a056512139c00b0048fda64d050mr6573187lfa.268.1661180610934;
        Mon, 22 Aug 2022 08:03:30 -0700 (PDT)
Received: from jade.urgonet (h-79-136-84-253.A175.priv.bahnhof.se. [79.136.84.253])
        by smtp.gmail.com with ESMTPSA id k13-20020ac257cd000000b00492f099e489sm101300lfo.20.2022.08.22.08.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 08:03:29 -0700 (PDT)
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
Date:   Mon, 22 Aug 2022 17:02:53 +0200
Message-Id: <20220822150253.3924012-1-jens.wiklander@linaro.org>
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
Cc: stable@vger.kernel.org # 4.19
Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
Suggested-by: Jerome Forissier <jerome.forissier@linaro.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[JW: backport to stable-4.19 + update commit message]
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
---
 drivers/tee/tee_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index d42fc2ae8592..e568cb4b2ffc 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -175,6 +175,10 @@ tee_ioctl_shm_register(struct tee_context *ctx,
 	if (data.flags)
 		return -EINVAL;
 
+	if (!access_ok(VERIFY_WRITE, (void __user *)(unsigned long)data.addr,
+		       data.length))
+		return -EFAULT;
+
 	shm = tee_shm_register(ctx, data.addr, data.length,
 			       TEE_SHM_DMA_BUF | TEE_SHM_USER_MAPPED);
 	if (IS_ERR(shm))
-- 
2.31.1

