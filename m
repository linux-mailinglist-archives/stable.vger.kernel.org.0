Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE555F5B22
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 22:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiJEUki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 16:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiJEUki (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 16:40:38 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090635720C;
        Wed,  5 Oct 2022 13:40:37 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id x18so10969830qkn.6;
        Wed, 05 Oct 2022 13:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G/SJy23pyHdTBOwqTvrrJjRP4JYmINx8osvDYRRfOiA=;
        b=Gy2RS+n5aXZK/vbHagqSrb642CEVulU2rctaskWTRmnr/sdYVgV4mAbCQqUvBgujAS
         2B8STm+OdCYJV2Vtpl8N4n/6xG0eHNHV5s4KnDUZpU0MgglzBPD8kTNOlvbb/MFBBBTf
         0EJZHfN14FTlV8tJ5RlypE3zqGPme/Y6S7Tjy5Wo9OtPIE+4lD9ryV8txeMlKyxs+S+r
         tuXA+VUKfiEz7gh9D8EF/aJ7zJL3mhFqiZxB6AL2a98l4enLblbZz5oNfJ+yhaPyRCaQ
         RCSpRA34xniiuaAniw+8di6h6vSqgmzH55DcgCOeyXr30QAYxDnC4soKmqH7LB7+Loa7
         aD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/SJy23pyHdTBOwqTvrrJjRP4JYmINx8osvDYRRfOiA=;
        b=Sqrtco3puHrTX/LDgTm8BFlNIjzAxrmkumJFqLT9hq5AFp+2YUj4iLTVQrhjeeFV7j
         mQr2Nulfnli1+sdVXK0eTa3h8vZdv+Xc/hqgptPBwQ5jF5L+S74l2VLnPwViBHtFxam6
         Du/KGopESC6nMshw7y+DmwhJK00+z+j8yCs0eBbzuaCXpFZVHfRmfy8kO/+6qwoejflx
         zB/fBk+3G5ZZXOBoFDIt6ZqzrxwJKFHUV2Pv9r4cKxUpywfzwoKLdf1kKWd0ef1mNOwH
         j3U/rkWIjFCbpSP3m1NB5o9vNeLiYcKSrZj1hkkBI0goemZKcHTl3BclUl/U5eWSfqzx
         83Fg==
X-Gm-Message-State: ACrzQf12pDR5knt8QWHJy7FBGXNqPAWuY8N9nAgw+wLBhS4Kq0aNqd53
        4GjcgtQfXD3nKiYcFcoMaxK0M+mE/Hs=
X-Google-Smtp-Source: AMsMyM7uaIQVk5zGnmo7PkS8GSfpolbEaCPgcEymH0ZgxosWhQ7hqkxd8iG5Aq1/q5kpC4kIC/9AnQ==
X-Received: by 2002:ae9:f205:0:b0:6bc:2d40:2f3d with SMTP id m5-20020ae9f205000000b006bc2d402f3dmr977651qkg.448.1665002435555;
        Wed, 05 Oct 2022 13:40:35 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y20-20020ac87c94000000b0038cdc487886sm3351624qtv.80.2022.10.05.13.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 13:40:33 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org (open list:PERFORMANCE EVENTS SUBSYSTEM),
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH RESEND stable 5.4] perf tools: Fixup get_current_dir_name() compilation
Date:   Wed,  5 Oct 2022 13:40:28 -0700
Message-Id: <20221005204028.4066674-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

commit 128dbd78bd673f9edbc4413072b23efb6657feb0 upstream

strdup() prototype doesn't live in stdlib.h .

Add limits.h for PATH_MAX definition as well.

This fixes the build on Android.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/YRukaQbrgDWhiwGr@localhost.localdomain
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---

This patch is necessary to build perf with a musl-libc toolchain, not
just Android's bionic.

Resending because missed stable the first time

 tools/perf/util/get_current_dir_name.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/get_current_dir_name.c b/tools/perf/util/get_current_dir_name.c
index b205d929245f..e68935e9ac8c 100644
--- a/tools/perf/util/get_current_dir_name.c
+++ b/tools/perf/util/get_current_dir_name.c
@@ -3,8 +3,9 @@
 //
 #ifndef HAVE_GET_CURRENT_DIR_NAME
 #include "get_current_dir_name.h"
+#include <limits.h>
+#include <string.h>
 #include <unistd.h>
-#include <stdlib.h>
 
 /* Android's 'bionic' library, for one, doesn't have this */
 
-- 
2.25.1

