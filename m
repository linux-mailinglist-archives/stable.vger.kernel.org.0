Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D632C5388B1
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 23:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239825AbiE3VyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 17:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238722AbiE3VyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 17:54:00 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC3553B65
        for <stable@vger.kernel.org>; Mon, 30 May 2022 14:53:59 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-e5e433d66dso15903581fac.5
        for <stable@vger.kernel.org>; Mon, 30 May 2022 14:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q4tX2unISVTEMXuSarvQMefge27FVjfxa72GeTTlhxU=;
        b=F6di6nRhnEP7CQD3IYx6KBqawGnGcuwoyZC1nDOz72rMvu0o3tSs+S5k5/fD2cPJpA
         9BCMY+SD1Q0u2Nq5lu2b1prgCYqmAhhlm/nzD+gwnUubuYo0AhkcUquZzN2H/GMMu2ru
         SeAL9GdXAd2rOPkLNqsBZEV5JKF6bmS9mT6iSCKuj908qY2+BP0qJrU7w9sGwB8Ma3uQ
         WsqeYdxzwUJsICbCXJ9fiIGbVyCzPpI1pLvpnFxFX/44A85oDAnzzS9jLwKRCHquGJKP
         TkqNnEX5Dnb1/R/iPAXH08J0wzwhV9NW3a2t0ImUCipSjkGTfKY6citL9Daz6wOZl3xk
         yLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q4tX2unISVTEMXuSarvQMefge27FVjfxa72GeTTlhxU=;
        b=t3ZmyYW0v6gRxvtiYCzHAIevevqo2uwijDAhhKyQFrIHIFgF/Wnha2TOO53CuK5EIq
         A6fnOlI0xaP+1vM8RAA7S9IF2O8iwL+Qqp3APO6SMF9rCWatHovhQipnbkoP/4opZ1zN
         6tcUv4pbcf/3dKBZ5xG5I8bH2brFkeiAn4NgzVlop+KGWAeyBfVYLd2fWEur6zzGrNNm
         ypCshObkPiE2DE09l9bcHXo55YgnDMqdXCwD/KJA8sH+NTfnPmg5EZVd/JoK+ryofg29
         AGnO6M/tdrWrFxOStx/EIL01Y7CcKGTxChBaAA1Bc/GEE2hG/lSkDuPyXTRsmMPYgBWy
         RdBA==
X-Gm-Message-State: AOAM533n1N+qIP/HiPxJdtxTOA0u8a3gN7m4kR4yR2JbnXs+AiRC2YCz
        ZQ6a4K0iUXz/Q36cW6BYCBLzNxBnuAM8gQ==
X-Google-Smtp-Source: ABdhPJxOYx7Cb1DoOHc3+hYozSM0oMTnK3TLX7L+58tg7dapzOZGXyi/o+BqGrN3A8kDKRmOnSVnQw==
X-Received: by 2002:a05:6870:c8a9:b0:f2:87f0:6707 with SMTP id er41-20020a056870c8a900b000f287f06707mr11484483oab.97.1653947638698;
        Mon, 30 May 2022 14:53:58 -0700 (PDT)
Received: from alago.cortijodelrio.net ([189.219.75.147])
        by smtp.googlemail.com with ESMTPSA id fq11-20020a0568710b0b00b000f23989c532sm4230425oab.8.2022.05.30.14.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 14:53:58 -0700 (PDT)
From:   =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>
Subject: [PATCH 4.19 0/3] Backports for Kirkstone
Date:   Mon, 30 May 2022 16:53:22 -0500
Message-Id: <20220530215325.921847-1-daniel.diaz@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

We recently started building with Poky Kirkstone (quite a leap
from our ancient and venerable branch of Sumo) which includes
a newer set of tools in the toolchain:

  binutils   2.30 -> 2.38
  gcc       7.3.3 -> 11.2.0
  glibc      2.27 -> 2.35

This uncovered some issues while cross-compiling on the 4.x
kernels. The following patches help in building the 4.19
branch again.

These backports are already applied all the way down to 5.4.

Arnaldo Carvalho de Melo (2):
  perf bench: Share some global variables to fix build with gcc 10
  perf tests bp_account: Make global variable static

Ben Hutchings (1):
  libtraceevent: Fix build with binutils 2.35

 tools/lib/traceevent/Makefile    |  2 +-
 tools/perf/bench/bench.h         |  4 ++++
 tools/perf/bench/futex-hash.c    | 12 ++++++------
 tools/perf/bench/futex-lock-pi.c | 11 +++++------
 tools/perf/tests/bp_account.c    |  2 +-
 5 files changed, 17 insertions(+), 14 deletions(-)

-- 
2.32.0

