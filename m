Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16EE6B5DDA
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 17:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjCKQ0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 11:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjCKQ0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 11:26:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41491DDB2B
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 08:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678551930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=OBRwTopEw0dwu9lEDf0/COJ56MV55wT/icRDi86Rorw=;
        b=hgKiwc5K3AEYc1ozz2s6L/TDjL85M5wqTU3p+4JCzmoUOGsIFEEdfDu909UTLmUpk+9UaM
        cVmcZTu/kqQWhCsGCuUSVrjaq8mc56TuNc9PU9cC9OXJQrOgpP1VD28IjOy3ZNL5yrdtl/
        w7+RTX18d72KGr31lYH6YSxcm2uKFW4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-3xbLBuAcNna3wIw6Fhd-6g-1; Sat, 11 Mar 2023 11:25:29 -0500
X-MC-Unique: 3xbLBuAcNna3wIw6Fhd-6g-1
Received: by mail-ed1-f70.google.com with SMTP id r9-20020a05640251c900b004d4257341c2so11484559edd.19
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 08:25:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678551927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OBRwTopEw0dwu9lEDf0/COJ56MV55wT/icRDi86Rorw=;
        b=ZD8NBGtqxRZi4+CiqhfOdUuvAdpGFtFsNx2AgTFdbyKB0dhK/sIIxFLGq2RNv8DCgj
         m3mR3qpjE0ACGZv3qiDeuF2FEhddQt9Nie6aaQ1xn2cuuzaZZ+uY1PXoGv4gDj8mLd3J
         kYC/gMB1u9v8DXPAgFhyi30X3eyG5B+GyQHI7GSKqplXIKeVabbi0roTJhIjJkCll8ZN
         GaqiuN5qSUu3voo4AXFA3D2KbI46o9tQfQVI8RNlZVEDYjxH+tGBJur2ix3dL50Zj/+V
         Tppw5xIgBQgme+X2hH7CAcnju62A2uZ4o5/YJeayHT2BY+gGDXOy1DH2OMCPCsHtsb0p
         h+0g==
X-Gm-Message-State: AO0yUKVShfdLmh8MjLTTum2Wxjgb+vjrx27v/J6mwYu2YeiXZ5wWkXKm
        dmANI3YDPdRqgc6HW9hY+DDGl7kldcSb0beDxWgYlLvP4vs93V+a5mE3LCn6wLdxatMHjL72oD2
        3qpb1CgZy1XpfbjqHlacerTQ6
X-Received: by 2002:a17:906:ceca:b0:8c0:386e:6693 with SMTP id si10-20020a170906ceca00b008c0386e6693mr27175001ejb.63.1678551927312;
        Sat, 11 Mar 2023 08:25:27 -0800 (PST)
X-Google-Smtp-Source: AK7set+rB5736nbPM8uObuYQm7AkW2LUTsc52rqURJ7YquC4fxKP64uuIVCUlPeNSQ0YVhQKJDLigw==
X-Received: by 2002:a17:906:ceca:b0:8c0:386e:6693 with SMTP id si10-20020a170906ceca00b008c0386e6693mr27174950ejb.63.1678551926672;
        Sat, 11 Mar 2023 08:25:26 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r9-20020a50c009000000b004af71e8cc3dsm1336817edb.60.2023.03.11.08.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 08:25:25 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9E9359E2874; Sat, 11 Mar 2023 17:25:23 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Mathew McBride <matt@traverse.com.au>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: Demote BUG_ON() in crypto_unregister_alg() to a WARN_ON()
Date:   Sat, 11 Mar 2023 17:25:12 +0100
Message-Id: <20230311162513.6746-1-toke@redhat.com>
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

To avoid such hangs on shutdown, demote the BUG_ON() to WARN_ON() in
crypto_unregister_alg(). Cc stable because this problem was observed on a
6.2 kernel, cf the link below.

Link: https://lore.kernel.org/r/87r0tyq8ph.fsf@toke.dk
Cc: stable@vger.kernel.org
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 crypto/algapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index d08f864f08be..e9954fcb61be 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -493,7 +493,7 @@ void crypto_unregister_alg(struct crypto_alg *alg)
 	if (WARN(ret, "Algorithm %s is not registered", alg->cra_driver_name))
 		return;
 
-	BUG_ON(refcount_read(&alg->cra_refcnt) != 1);
+	WARN_ON(refcount_read(&alg->cra_refcnt) != 1);
 	if (alg->cra_destroy)
 		alg->cra_destroy(alg);
 
-- 
2.39.2

