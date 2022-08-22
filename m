Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77FC59C045
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 15:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbiHVNMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 09:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiHVNMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 09:12:35 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAC733E2E
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 06:12:33 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id l21so10571457ljj.2
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 06:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=WHRiTdknvIzmLKSQC7SoHlph9QyvuI2juima1oTGFkg=;
        b=P/qCcn1EfnD1wN/T2nNdl5AYYdx/JPKU82FEZfflsyg1ogp30U8eyNiiBrAFlVuHNT
         Q5xktsPnB+QnxSml3VFa/5Kc9J66wZwAGmjM4yn0LQIobrvIyeRn/jCHnHdVMcgd04jj
         wc3HEyyxBwz2nKSPip2eRk8FDmnfEkKyX+8nlPw7CM45CZzA2/WRr/UUSiGTQpRvJK9r
         tFvc76OJ7sVKwfSXNuFR9L7+BsBlm302vejsFZ2uI/d62qMg9BVSEYxHKnVljvy3+ulB
         /8UlCaaGVnZDs+6YfGSiqwR0Pqr40bVXwqoCsVIgTwqQRzkIhqGsrxW7jpPJI52bX5KL
         Yxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=WHRiTdknvIzmLKSQC7SoHlph9QyvuI2juima1oTGFkg=;
        b=zAkqAgitL9J6T7awPcQv2sx0FXNxtZ7G2QNW7SMxiIxoVMIr3czx2VRR52W/UJanEY
         FtUF5WGDmYZ72XdfPm/VsNu4vjeQVZgfMHi9F2+VYV0AVOHxRgEB1b06R+tU9KFKEDrX
         8cX7zimsx2v0NZPGkscOYWWargrbJNWGb+YAS//za/hA7KI/064DUKolowrHN7DpfuDR
         /F2NQCAg79mCcfqscSVXQ4Gkpi9Fg8KsMs7Zv7nvco3rL4bejwzOoivnnYVLxm+92RzT
         mzSrSNVez4S7U65c81T6A0AO7e+Qzsopv3iYaNkBAqJpZxDZwGxWD1Q4LYG8F+Fp9fni
         UE4w==
X-Gm-Message-State: ACgBeo1ThQZlwt2E1eojFe0W7fZhPhjB6l3XHMvDJB5IhEg9XY/B9/ox
        7AJdu7Dw7bi34IUcOmpcu/d+4QoBre55qA==
X-Google-Smtp-Source: AA6agR4mmUCqjN0xhYvgfjfYTy0sm8d7BNbD+1gdmk9h2rA2XhEabWRfLUWACr+hkhd2gW3nrUMazQ==
X-Received: by 2002:a2e:a552:0:b0:25e:6fa1:a6c4 with SMTP id e18-20020a2ea552000000b0025e6fa1a6c4mr5456016ljn.90.1661173951250;
        Mon, 22 Aug 2022 06:12:31 -0700 (PDT)
Received: from jade.urgonet (h-79-136-84-253.A175.priv.bahnhof.se. [79.136.84.253])
        by smtp.gmail.com with ESMTPSA id x3-20020a056512046300b0047f7722b73csm1915169lfd.142.2022.08.22.06.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 06:12:30 -0700 (PDT)
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
Date:   Mon, 22 Aug 2022 15:12:27 +0200
Message-Id: <20220822131227.3865684-1-jens.wiklander@linaro.org>
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
Cc: stable@vger.kernel.org # 5.10
Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
Suggested-by: Jerome Forissier <jerome.forissier@linaro.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[JW: backport to stable 5.4 and 5.10 + update commit message]
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

