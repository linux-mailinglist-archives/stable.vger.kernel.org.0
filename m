Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39896EB496
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 00:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbjDUWSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 18:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbjDUWSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 18:18:42 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4783E9C;
        Fri, 21 Apr 2023 15:18:40 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-94f109b1808so371781866b.1;
        Fri, 21 Apr 2023 15:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682115519; x=1684707519;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=MEnCPg1EFSOasyZ2aQqOsmZFBO94tsOHO08kL7eK93E=;
        b=b4FqO+JggWqnbHc1FJY56EO5LhLJQl3EN4Nfzi55AhLahmYvTKax3l09eGHuY2Hstt
         2MRFQPuSJzLIqLdLFEMfCtXkuQM2uV2VM3riraCJtFr1B3nOimVIeCYZQ0CUKG9Afa+J
         8MjcG72nD0d3yrA5IZy6U7URN2SfZZx9bUFv940fW54W352GdNpjvN6B8Cb9wMm0ON9C
         JmJi0c/RCSDiRYeKI7ol3z8PNXuIM/aG8JTZiNRhYEnlqedV0YWbtB3HhllyTPjGykww
         EKDtfiytvafVoBZF0XsD43+Ne9pBnB1LI78gxIV/ItThrMBGKx43/jzF1IVR1l7wk/se
         w+UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682115519; x=1684707519;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MEnCPg1EFSOasyZ2aQqOsmZFBO94tsOHO08kL7eK93E=;
        b=aUSSthycCxksJjAiP017/hfPmbqKyJCkeFH742F5QcV7VywoVBqQdQNwPYSJpB6GYs
         StLd296djMgGx7LV/QbaoZOkod+lzaJGE2pYEnpCFUv7NdQgs0ltbUkxWmk+S16vSGD4
         9U707IyT7YguJ9c0YJZVRFIiKSc1kNVI5prN70M5IdEhzWj3Q4E0b79Zl5d/tonYwyct
         nfEvB2U0gLM1LQKpbXFaMn+1HpOvtLC2QpkyfAXtnKBcmCUyq5+m/zxvc85EEWkseNQM
         aTfTzLZSz3PeJfgFnq8Fvpw6SO3wRMMLcN2msETAy60/P7D4icS3QU77pgToJoDXrqsp
         uE8g==
X-Gm-Message-State: AAQBX9dIrFi2OyhU5Jm5cY78TACCdmH9D8CwE1ZGmmhoS0IKRaRh3pWJ
        nQL0ivm/F6M35S/3ewTwnsk=
X-Google-Smtp-Source: AKy350aTnGNi+48nikoYbsQNtqheZwrv0gOWvCFN4rRl31/ubfbpj+6JJsD9ukwHUBz1N4l4UY4aEA==
X-Received: by 2002:a17:906:90c8:b0:92b:e1ff:be30 with SMTP id v8-20020a17090690c800b0092be1ffbe30mr3111949ejw.4.1682115518696;
        Fri, 21 Apr 2023 15:18:38 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id va2-20020a17090711c200b0093a0e5977e2sm2569188ejb.225.2023.04.21.15.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 15:18:37 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 198F2BE2DE0; Sat, 22 Apr 2023 00:18:37 +0200 (CEST)
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH v2 stable-5.10.y stable-5.15.y] docs: futex: Fix kernel-doc references after code split-up preparation
Date:   Sat, 22 Apr 2023 00:17:42 +0200
Message-Id: <20230421221741.1827866-1-carnil@debian.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In upstream commit 77e52ae35463 ("futex: Move to kernel/futex/") the
futex code from kernel/futex.c was moved into kernel/futex/core.c in
preparation of the split-up of the implementation in various files.

Point kernel-doc references to the new files as otherwise the
documentation shows errors on build:

    [...]
    Error: Cannot open file ./kernel/futex.c
    Error: Cannot open file ./kernel/futex.c
    [...]
    WARNING: kernel-doc './scripts/kernel-doc -rst -enable-lineno -sphinx-version 3.4.3 -internal ./kernel/futex.c' failed with return code 2

There is no direct upstream commit for this change. It is made in
analogy to commit bc67f1c454fb ("docs: futex: Fix kernel-doc
references") applied as consequence of the restructuring of the futex
code.

Fixes: 77e52ae35463 ("futex: Move to kernel/futex/")
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
---
v1->v2:
 - Fix typo in description about new target file for futex.c code
 - Indent block with build log output

 Documentation/kernel-hacking/locking.rst                    | 2 +-
 Documentation/translations/it_IT/kernel-hacking/locking.rst | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-hacking/locking.rst b/Documentation/kernel-hacking/locking.rst
index 6ed806e6061b..a6d89efede79 100644
--- a/Documentation/kernel-hacking/locking.rst
+++ b/Documentation/kernel-hacking/locking.rst
@@ -1358,7 +1358,7 @@ Mutex API reference
 Futex API reference
 ===================
 
-.. kernel-doc:: kernel/futex.c
+.. kernel-doc:: kernel/futex/core.c
    :internal:
 
 Further reading
diff --git a/Documentation/translations/it_IT/kernel-hacking/locking.rst b/Documentation/translations/it_IT/kernel-hacking/locking.rst
index bf1acd6204ef..192ab8e28125 100644
--- a/Documentation/translations/it_IT/kernel-hacking/locking.rst
+++ b/Documentation/translations/it_IT/kernel-hacking/locking.rst
@@ -1400,7 +1400,7 @@ Riferimento per l'API dei Mutex
 Riferimento per l'API dei Futex
 ===============================
 
-.. kernel-doc:: kernel/futex.c
+.. kernel-doc:: kernel/futex/core.c
    :internal:
 
 Approfondimenti
-- 
2.40.0

