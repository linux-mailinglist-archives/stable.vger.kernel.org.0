Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4542E6C5ED7
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 06:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjCWFbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 01:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbjCWFav (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 01:30:51 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D3020A06
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 22:30:38 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q1-20020a656841000000b0050be5e5bb24so5417916pgt.3
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 22:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679549438;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Xgq7CKszmLr4ydLz5iWl2WGqdRQcnyBZB5qo8QWcYU=;
        b=fHs4HG8CKvRAfon2tHwYDFCQmWtAK3kFiGrIBmZzb3t13fVYVGbzy37pPqALjpAB1+
         yF7makMG2NuzX7Z9Vv0O1NKfCfsuJH5Dvs8S9o9qG4vU7arfUxWBd3pxuu/fhRvlCI/A
         vueMtQGxEVguHCFOYgMhd4FfLVJxekPql0Uj14tQon4VOT+5rCD8yX/4e2UiKKgOr53K
         P9CMJJmjEnQYVp/xGUQmqm3sw4hz8WzclL9WxzqilNykXqTL6qQ8jPVTikpwkOhPbAgL
         EW05Zx7z+aKV3eLn2xoEBvvY5GHW9iL1HrH87Wo2LNlT56eW2gv0zZhAgYwn0tWhqJ4z
         Fx4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679549438;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Xgq7CKszmLr4ydLz5iWl2WGqdRQcnyBZB5qo8QWcYU=;
        b=VS/6424YIuti+Yrgp2RoSHJ5RGy3JLn3MO+qA1vfgpCm03+lM2KgMgiveH5qMN/ZM+
         E8Q3zM9+E9SBHYyrYuAvi5P6e9r3yO9dGs9aM670b3cVv/q/EhyD8buynnqJVZJ68t+Z
         yiCRrnbv6jvtRYL3Eh7udggGM7f4+NrUDPnXSuzDiVtFVzjcPsIrdU3PqD8OK8Vsgpgm
         UVAYKJxnMLYaxGTnVCeADfk9Ac1i8fyiS8XxlshVi8XvFIp3Iu1LVfPAc+onelcS20yB
         KTZhasHAqWe99NCYSw/HatPnfh34X8+/bjZkMzFLS2BqUZ82vhVADzHp02y6cqvE3qSR
         aUeA==
X-Gm-Message-State: AO0yUKX1ssAKv0Yv5ApjDrZ4/w6jmebDCdklG9LRU0RWKe/hciX2O60/
        g4VIwjmN2Rz+yx84Sttc7+E1CU+8w7kmGVGPJamUmDAjFD6TA+qASh7tAuCyP/4RZ8DudYw8EFe
        A8CEYnOQFB4KbcH/HjPvepz+ldlGCxDxfppPvq2HzwNw4HS1qIx/1FxBA4RXYcxT6O7WG6njbaZ
        rU10MW3LA=
X-Google-Smtp-Source: AK7set/FfX+Q7Mc2M0UYBwS/Fj72dlFG9rzTkjguLEty+aqoA3aoyyonmGi9qU9KNFQ05mVaDPExQHdECL4LYLB2NSY0BQ==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a63:9a51:0:b0:50b:188d:25bb with
 SMTP id e17-20020a639a51000000b0050b188d25bbmr1530920pgo.5.1679549438336;
 Wed, 22 Mar 2023 22:30:38 -0700 (PDT)
Date:   Thu, 23 Mar 2023 05:30:32 +0000
In-Reply-To: <20230323053032.720729-1-meenashanmugam@google.com>
Mime-Version: 1.0
References: <20230323053032.720729-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230323053032.720729-2-meenashanmugam@google.com>
Subject: [PATCH 5.4 1/1] net: tls: fix possible race condition between
 do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, hbh25y@gmail.com,
        Jakub Kicinski <kuba@kernel.org>,
        Meena Shanmugam <meenashanmugam@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

commit 49c47cc21b5b7a3d8deb18fc57b0aa2ab1286962 upstream.

ctx->crypto_send.info is not protected by lock_sock in
do_tls_getsockopt_conf(). A race condition between do_tls_getsockopt_conf()
and error paths of do_tls_setsockopt_conf() may lead to a use-after-free
or null-deref.

More discussion:  https://lore.kernel.org/all/Y/ht6gQL+u6fj3dG@hog/

Fixes: 3c4d7559159b ("tls: kernel TLS support")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20230228023344.9623-1-hbh25y@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Meena Shanmugam <meenashanmugam@google.com>
---
 net/tls/tls_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 7aba4ee77aba..cb51a2f46b11 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -371,13 +371,11 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_128->iv,
 		       ctx->tx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_128->rec_seq, ctx->tx.rec_seq,
 		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_128,
 				 sizeof(*crypto_info_aes_gcm_128)))
@@ -395,13 +393,11 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_256->iv,
 		       ctx->tx.iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_256_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_256->rec_seq, ctx->tx.rec_seq,
 		       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_256,
 				 sizeof(*crypto_info_aes_gcm_256)))
@@ -421,6 +417,8 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 {
 	int rc = 0;
 
+	lock_sock(sk);
+
 	switch (optname) {
 	case TLS_TX:
 		rc = do_tls_getsockopt_tx(sk, optval, optlen);
@@ -429,6 +427,9 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 		rc = -ENOPROTOOPT;
 		break;
 	}
+
+	release_sock(sk);
+
 	return rc;
 }
 
-- 
2.40.0.348.gf938b09366-goog

