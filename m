Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E270D6B7254
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 10:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCMJST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 05:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjCMJSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 05:18:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E3CB746
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 02:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678699052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PALIqLlKg2GDdZ3UjcapC6mNS6Y/72QSCU5pkVKimfk=;
        b=FLddYpG89ApUlnVswugA6hwltV2wpFzgzlVQjkTb7QaxYPm/BXRCOJucaz3QtG+Jv9qb5Z
        18Wl6W0Uh3jvKqxFADS6epKxJZuRK/gWcCOy3us6UFTFKl+ResEJh5Xz13OUFvPeMx8PW9
        vIzSuSteHoAzMRozEhWe4uGM3fHjKOE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-qYWIe1fkNQWjSPDUz-f0wA-1; Mon, 13 Mar 2023 05:17:30 -0400
X-MC-Unique: qYWIe1fkNQWjSPDUz-f0wA-1
Received: by mail-ed1-f72.google.com with SMTP id en6-20020a056402528600b004fa01232e6aso7541229edb.16
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 02:17:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678699049;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PALIqLlKg2GDdZ3UjcapC6mNS6Y/72QSCU5pkVKimfk=;
        b=cOPU7q1P7g8SBKPIE3kaAmROxLbWSiUrWRl2aKFr6D7gJ+5dbgCzJgowhhqJLnKwj/
         LE+/ujg8qNXLqjqzBXm8R8A+n0DJc/tmCXIi1LiLqkO45OriiZ6xwyhKA5KAfCME0QV2
         zwCl4s5vhskhTRWs0ny/0G3SsKwAsVKYZ2sSjHeY16IeytoJJu3bF9w3EQRzj+iXuxqp
         H3yS5dwH6ZFGLcejAMHchioL5nwelFKrZmMRHxeec2bA5wJ12ez4gVt9ELBLpCJMMrhH
         C+tVuFpZfu5N3Ue+YChOwL2i9JccKfhuZRdhtxmbr5TaZo94I5lTPkAy93Ff/Dupd7Zy
         VSNg==
X-Gm-Message-State: AO0yUKUcX9i29js6xxzJQP0o9rzHg017eUgvvGE3BfcbVsxN4Qq0kb8w
        JUSRCb1Z30Coud3m9TLmbgtwFfU9hAiuTNIhDSlfuQ9MGilld6w1tpOncVtbMPzA/LuFwpc4kD4
        KPLa7q38FLEGoYbD9
X-Received: by 2002:a17:907:20b2:b0:91f:723b:8d04 with SMTP id pw18-20020a17090720b200b0091f723b8d04mr7757644ejb.28.1678699049358;
        Mon, 13 Mar 2023 02:17:29 -0700 (PDT)
X-Google-Smtp-Source: AK7set+s8ziOEYmIxZzjuqn+zHkdK/VTYAgSg4adtZ63uwaJqLAC+a8GiSsrhkC8qnhxtGv5uyBERQ==
X-Received: by 2002:a17:907:20b2:b0:91f:723b:8d04 with SMTP id pw18-20020a17090720b200b0091f723b8d04mr7757628ejb.28.1678699048937;
        Mon, 13 Mar 2023 02:17:28 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t16-20020a1709063e5000b0092435626c0asm2103342eji.29.2023.03.13.02.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 02:17:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 23B0D9E2974; Mon, 13 Mar 2023 10:17:26 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v2] crypto: Demote BUG_ON() in crypto_unregister_alg() to a WARN_ON()
Date:   Mon, 13 Mar 2023 10:17:24 +0100
Message-Id: <20230313091724.20941-1-toke@redhat.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The crypto_unregister_alg() function expects callers to ensure that any
algorithm that is unregistered has a refcnt of exactly 1, and issues a
BUG_ON() if this is not the case. However, there are in fact drivers that
will call crypto_unregister_alg() without ensuring that the refcnt has been
lowered first, most notably on system shutdown. This causes the BUG_ON() to
trigger, which prevents a clean shutdown and hangs the system.

To avoid such hangs on shutdown, demote the BUG_ON() in
crypto_unregister_alg() to a WARN_ON() with early return. Cc stable because
this problem was observed on a 6.2 kernel, cf the link below.

Link: https://lore.kernel.org/r/87r0tyq8ph.fsf@toke.dk
Cc: stable@vger.kernel.org
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v2:
  - Return early if the WARN_ON() triggers

 crypto/algapi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index d08f864f08be..9de0677b3643 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -493,7 +493,9 @@ void crypto_unregister_alg(struct crypto_alg *alg)
 	if (WARN(ret, "Algorithm %s is not registered", alg->cra_driver_name))
 		return;
 
-	BUG_ON(refcount_read(&alg->cra_refcnt) != 1);
+	if (WARN_ON(refcount_read(&alg->cra_refcnt) != 1))
+		return;
+
 	if (alg->cra_destroy)
 		alg->cra_destroy(alg);
 
-- 
2.39.2

