Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6475055FC32
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 11:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbiF2Jhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 05:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiF2Jhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 05:37:53 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9B73B3EB
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 02:37:51 -0700 (PDT)
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 5ED8C40274
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 09:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1656495470;
        bh=UIiPhgOT/03uiJTtpVYwIGBzVjBkOGXHNhzjdhIPa0c=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=GlTyzTG6avpo0iINsijvR4/3HfD9rw7Cp7HYEDEWpFaucpuYySjYqecvP6AHMb+uB
         lboukkMj5ve/LG7sU442PoXpaUXK/LZ7iVInFigujDjGNYwLqipjjhVDTDDwcZQ89A
         CUkli57Jx+NxHeS3yfx24FICtBv3UISNNwYME3NzXPFL7mvw9GInJz2+Bc62bnBBbv
         S9T1iaUcaYRtpHRkoqECUE2UfJ1eAnTe1xe4h8aI7e5G5aoFjSjwlYVany1gPE7yFB
         /fsDAl3+pcqCafQDvwGr5ubvuyCgWoZkQLs3zDeyb7GJk0rJEQy5ZqiOh60uY3Qs3X
         FOiTdhdfjkGEQ==
Received: by mail-wm1-f69.google.com with SMTP id r4-20020a1c4404000000b003a02fa133ceso2293831wma.2
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 02:37:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UIiPhgOT/03uiJTtpVYwIGBzVjBkOGXHNhzjdhIPa0c=;
        b=GZL2eoR8xgnw6KlTDfEnjIxAnJh+Q72IOmemoB0nVIE8F2VgsraZeFK22Rwnm7/1Kc
         7ay/S9jm8fD3jXxwXI9bBCJFUVI/tVMMTgqPmIfC1Gzyyoo2NXFya94FKN4Mcs0+4AMe
         s5s4FsgWwQON4wn8fsHhn/ApUXBaM7Wz3Irhl10HIuYAoeuIKJWGL+BCeSAxqgOx9Ahs
         0iKvgrV3oKU65Y9Ml0z6fpeM3aTSk+DZyr3tVHNnJ+HJpQpPB1Z1X0JXIfgLSpHMesi6
         EXaSrFvedgoHQw2PzEk+l6oz4HS/XsjIbAyLIaEvNnaTNw2lfYbOXsmASHImQOvj5lu7
         vQFA==
X-Gm-Message-State: AJIora/2xESO+uuMyK31lQeht2mMu+kErFwA3ci5Wggxc2QcX13sXwse
        aj5NOXT4SM9mR94pDL3ITX6m/dSFIkj4AvtyIx4mBaCYeFak/534GK9adsaMu5t46iPXMQu0p2f
        uX4L9H8+6zpO6W5ZySKhlqzoXMHJSyyk59Q==
X-Received: by 2002:a05:600c:1907:b0:3a0:ac8a:7c35 with SMTP id j7-20020a05600c190700b003a0ac8a7c35mr2723288wmq.5.1656495469632;
        Wed, 29 Jun 2022 02:37:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sMgp2Qj6QrOxCqt0xqo5P9l3dyuY3EV78WGlm1MglLDo/p2ibV2mNGdmwSP3BdrE6mbD+Zvw==
X-Received: by 2002:a05:600c:1907:b0:3a0:ac8a:7c35 with SMTP id j7-20020a05600c190700b003a0ac8a7c35mr2723261wmq.5.1656495469278;
        Wed, 29 Jun 2022 02:37:49 -0700 (PDT)
Received: from localhost ([2001:67c:1562:8007::aac:415c])
        by smtp.gmail.com with ESMTPSA id q20-20020a7bce94000000b0039c4b518df4sm3179851wmj.5.2022.06.29.02.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 02:37:48 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     stable@vger.kernel.org
Cc:     Kevin Hao <haokexin@gmail.com>,
        Nathaniel Filardo <nwfilardo@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH for v5.15+] powerpc: Export mmu_feature_keys[] as non-GPL
Date:   Wed, 29 Jun 2022 10:37:36 +0100
Message-Id: <20220629093736.268003-1-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

commit d9e5c3e9e75162f845880535957b7fd0b4637d23 upstream.

When the mmu_feature_keys[] was introduced in the commit c12e6f24d413
("powerpc: Add option to use jump label for mmu_has_feature()"),
it is unlikely that it would be used either directly or indirectly in
the out of tree modules. So we exported it as GPL only.

But with the evolution of the codes, especially the PPC_KUAP support, it
may be indirectly referenced by some primitive macro or inline functions
such as get_user() or __copy_from_user_inatomic(), this will make it
impossible to build many non GPL modules (such as ZFS) on ppc
architecture. Fix this by exposing the mmu_feature_keys[] to the non-GPL
modules too.

Fixes: 7613f5a66bec ("powerpc/64s/kuap: Use mmu_has_feature()")
Reported-by: Nathaniel Filardo <nwfilardo@gmail.com>
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220329085709.4132729-1-haokexin@gmail.com

Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
---

 Please apply this patch to v5.15+ as it unbreaks zfs-dkms usage on
 powerpc platforms.

 Overall, this patch applies to v5.12+ kernels.

 arch/powerpc/kernel/cputable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index ae0fdef0ac11..3a8cd40b6368 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -2119,7 +2119,7 @@ void __init cpu_feature_keys_init(void)
 struct static_key_true mmu_feature_keys[NUM_MMU_FTR_KEYS] = {
 			[0 ... NUM_MMU_FTR_KEYS - 1] = STATIC_KEY_TRUE_INIT
 };
-EXPORT_SYMBOL_GPL(mmu_feature_keys);
+EXPORT_SYMBOL(mmu_feature_keys);
 
 void __init mmu_feature_keys_init(void)
 {
-- 
2.32.0

