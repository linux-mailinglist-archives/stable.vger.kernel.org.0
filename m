Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045C75F5B26
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 22:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiJEUlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 16:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiJEUlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 16:41:24 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D20B62A95;
        Wed,  5 Oct 2022 13:41:23 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id fb18so1238486qtb.12;
        Wed, 05 Oct 2022 13:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aRUqCLLcHsh6POG9Rz1BBcJxeSLfOpSm82me8CPX0EE=;
        b=a2w8m56hVR7oUjeaD3xC4eThLHjX8yEcgKQl3QPBYBTqGtjfaagppF85rJzly3lIes
         KVm3ZkDRjC/QmMDrH7BsuIyfRJ70+O7WAFjYPhrVQb7JE6HQSq4j1nA8hjI2iD7gI6UH
         BCSY0FoV68JsPoM7wcACKxx4s9IvXcGljNgtJ+Qjy8VfeTO/N/vVu0aWaezckVcY/bEY
         T/29YUMAa+1NduUQmouMzLnjAl0xhnJo7YO+75sbVaVvO5lZLeAMCaBZxwAX6KPDR33l
         mzJgUclQbWoLYgk0D+f2rQBTdb82fQil8OAfU/dsN5QfhChXSxt9tOx0fdXjHfWI2WSl
         K+sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aRUqCLLcHsh6POG9Rz1BBcJxeSLfOpSm82me8CPX0EE=;
        b=MkKu6myKa8216DRQ5rCwWtv7/0HcL9lsfHuDQviSG3SkfROcnwSNB8wNFBYVhaLliQ
         aBjDgNY2q3WuNKRYums3boL/N2AFQu8mFfPyrlG+ezbIIuajZEJOD37tyzcFggIatXSj
         Z5wj1JEKJ6QvwhUeomq5as+BiLBnWS5p/R0RC9+kxB6lhzrGj5gyoYs3Xd6fyDu6irUY
         oCU5fWMvgGfyq1oPItm+6slXcadv35cHmApj/Go8rtsAh5fjNVmn2f8zQnWQHl/M8iZO
         M3LPZCs9vJUjDLdQm0rEBj35EwfkiAvUO4Wm8v3qDqde822e9c559tj/MElI1uld/PF0
         77Lg==
X-Gm-Message-State: ACrzQf3RfjE8UJZJy/Kp88k1UFpk4lt6vPWT9gHUG9NuImwlpwrlwuP5
        MKa7FkmhD1wlMAvlfRuV89jWWMJonzM=
X-Google-Smtp-Source: AMsMyM77hOUYTwq3haH99gmohdvewNsrQ6T6C4Z4jNAq2MuVfu26WWSo3+luTr5tzXJrzofs3e974Q==
X-Received: by 2002:ac8:7d11:0:b0:35c:f5c4:324a with SMTP id g17-20020ac87d11000000b0035cf5c4324amr1106355qtb.400.1665002481487;
        Wed, 05 Oct 2022 13:41:21 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z10-20020ac87caa000000b0035d43eb67bcsm14387534qtv.91.2022.10.05.13.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 13:41:20 -0700 (PDT)
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
Subject: [PATCH RESEND stable 5.10] perf tools: Fixup get_current_dir_name() compilation
Date:   Wed,  5 Oct 2022 13:41:16 -0700
Message-Id: <20221005204116.4066871-1-f.fainelli@gmail.com>
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

