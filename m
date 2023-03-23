Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A306C5B92
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 01:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjCWAyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 20:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjCWAyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 20:54:50 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FE31EFCD
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 17:54:49 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id o4-20020a056a00214400b00627ddde00f4so6712466pfk.4
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 17:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679532889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lNczrnjI9fLzctoQRfjJZ+KU1k+dORFqLry+bDuii3g=;
        b=Q3niXSv3TU/rPDYqaXU0udm2NNE/4I0uv8wVE+6PAaA3V+on/H74HK/KCTriTq5QWB
         aWBzepVKqOOtB7b4bm7fOmcmDe1VlyP5RRnTQEcbsMfyJgh2C5vlgBgSxLY6mSeJiDTI
         kIfibqsx7t9uf3kNWc8kSwXAN/S1+1k2ydeyJGiHrcGkcgRc6psXaKdYo32nl5Mg0RkM
         ByRubYLYM11NOsjKy3ZBmksRdR52VxTFvZ0iAV0jX7VXKIrqqc5e4FtyjV9G6mhibRwR
         5kL23SdB/pNCZz5uX9snSnf0IrZfVNNxCCGpgTb7+4/UJVVg/ylCHrUod8snhXrERSOM
         vJlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679532889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lNczrnjI9fLzctoQRfjJZ+KU1k+dORFqLry+bDuii3g=;
        b=s0Q87I4SDS2YHGBDEOWECJcM45xPbmDEK+lH9jePUR0MetQL6yVlzVFi038mS5l0vs
         iJ9agmgAq0igyaqbg2Rhixt5HCxK8Ui4myUvvj3C3ju3QS+B93qSznAViPTVjf58Q9uO
         75zUoFta4CqpcTzIDYExBLuEOva8hZzwRnScNsPLieaIMuNKql6s5Sc31VONZBveA9E7
         Fozt2aEmFfLv+yIWxA5uwmjUW2u5JMizSN+ZGjNKYCWd2YbUA9kUr+AS6josNuXmiEBx
         pP3CDpo534UCKlRikOiFuY9iwESya1V7Erq/ihJc1DuBktWvUPy5msAJqwylDnccjSnk
         OmtA==
X-Gm-Message-State: AO0yUKUr8GmDlX0gtnwr5AR9RghLjMM9opXllA+3+ShS87DOiQ9IQzlj
        mxqgjoeLBG/ghUU15meMCDPZr5J8GDrgPtvqd7cMkUlahf/Os6H7yCVv5gJ7evDvQ0CVhhF7vln
        /CUxPLZkq8Urt4Bp1jETfI8YevfQjKe/2Yw4lEtilXIFK3GGKhaHO/U82Q/N4kUrXEeg/xAGumB
        MIm97MjLk=
X-Google-Smtp-Source: AK7set8b9qbiTF4ob1TsbGJH8frs50ija09fYfKzowugbytwWN/K+TbuzFEqbuTcWfJlR/UKr8qHtMxZq3JzsxJbQeWxDg==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a05:6a00:174c:b0:628:123c:99be with
 SMTP id j12-20020a056a00174c00b00628123c99bemr2805803pfc.2.1679532889038;
 Wed, 22 Mar 2023 17:54:49 -0700 (PDT)
Date:   Thu, 23 Mar 2023 00:54:40 +0000
In-Reply-To: <20230323005440.518172-1-meenashanmugam@google.com>
Mime-Version: 1.0
References: <20230323005440.518172-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230323005440.518172-2-meenashanmugam@google.com>
Subject: [PATCH 5.15 1/1] net: tls: fix possible race condition between
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
index a947cfb100bd..abd0c4557cb9 100644
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

