Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABCA6C5E58
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 06:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjCWFDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 01:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCWFDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 01:03:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6D1C15C
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 22:03:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e129-20020a251e87000000b00b56598237f5so21611054ybe.16
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 22:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679547817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=paqMP8fA2xU/Nz2y6g7Xo+BLaQLriUhZgJuersmsJng=;
        b=esLqnQ+8iAUh+EcaTTTRQ9rGKo919NHqTbkjeQUP1coczq/FRGHDKsA5i2oV24eE1X
         rDDv161HiD9algY/CwHjVhwTSRGuHd1w5InDXT/5aOwoekY3+iGXQgtPJg8DtLEl+Vy7
         O9oeZhtOw1SvfHCPG6kAWI0vMkQtDpFGPsXG2zDtdxvBpODG8ETL9sbKv1ws5hrpC4kR
         8cY0o+UBgikok8nJDskOY0VSpT2t3O8j9PfAExuH3mEqfGtcG3pzqpIdxkFuapSX4Nqy
         k5K5LzhKJ1r1tYXL5Q+AZdLnDLzDF6V23mPfgmLcViF3MVk+3hMTEjGNtG0H4g0Gfivw
         ix3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679547817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=paqMP8fA2xU/Nz2y6g7Xo+BLaQLriUhZgJuersmsJng=;
        b=bYecr+NV6n0g6TzhZD4SGOVSJYp93K3Gi8qo6dVcT+9Nd2QQNIRBkCeQOoV9U6tG1o
         huMDPpDwVMsBm4I39VTL0J7HOy0o4nTm2TcP9zPP/IvVS4rcppkLyPHxUvHSUywYjN8F
         /EeQG6E9wD3B4X1a+fH3tiXEDnFCi7lq+kdNHiVA3jmT2o1wAqkvZqIG3ZgHuaKHjGZR
         U5MfB8yAZZzYLSuZBOPt5vuWdsXPJNGl+/DbN5LsHa+oQRnOftFtCGVA0vfAKRDQKX2F
         ZN4JswTB5/bNS4AFgZVHnUXl5QldMp1kzdBOUpshqUrcnzglGyB1ODzbVJVQXLGQzqBz
         A7Cw==
X-Gm-Message-State: AAQBX9eMJRtZKidmxFJ38W1KpbNyCW66ag5a22T8Uv15bE9G1mKe15CE
        VVwswsGLwl/5Bz+EGmZ3t8SprBPWU1+S1ClG397UcIBr+oG+faOTYNuRm5YjBLTBmKr2NUtuQCu
        gu8uxGYWqhKfCByxr48lMDd3gejQEtnQVSqYhIFkVc9wwxV3SNmhG8DQucIcHCJ5Y+/3XYcEtZE
        thOA4e7zY=
X-Google-Smtp-Source: AKy350YZfvOdRHI8b7qouSKCViL1WNkXwjyDlgxb5uAycghxfIXcW0gxoNUwwocD149JyldlTyMQ++pLElw9rWDkLNrs7A==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a05:6902:a93:b0:b23:4649:7ef3 with
 SMTP id cd19-20020a0569020a9300b00b2346497ef3mr1374749ybb.4.1679547817065;
 Wed, 22 Mar 2023 22:03:37 -0700 (PDT)
Date:   Thu, 23 Mar 2023 05:03:22 +0000
In-Reply-To: <20230323050323.634232-1-meenashanmugam@google.com>
Mime-Version: 1.0
References: <20230323050323.634232-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230323050323.634232-2-meenashanmugam@google.com>
Subject: [PATCH 5.10 1/1] net: tls: fix possible race condition between
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
index e537085b184f..54863e68f304 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -386,13 +386,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_128->iv,
 		       cctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_128->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_128,
 				 sizeof(*crypto_info_aes_gcm_128)))
@@ -410,13 +408,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_256->iv,
 		       cctx->iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_256_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_256->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_256,
 				 sizeof(*crypto_info_aes_gcm_256)))
@@ -436,6 +432,8 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 {
 	int rc = 0;
 
+	lock_sock(sk);
+
 	switch (optname) {
 	case TLS_TX:
 	case TLS_RX:
@@ -446,6 +444,9 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
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

