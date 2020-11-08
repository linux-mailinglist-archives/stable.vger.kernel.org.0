Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29DC2AA895
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 01:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgKHAbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 19:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgKHAba (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 19:31:30 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E3EC0613CF;
        Sat,  7 Nov 2020 16:31:29 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id z16so5104676otq.6;
        Sat, 07 Nov 2020 16:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OVTt9CdxGRPNpa7pvvi1WLJ3ASvRko+oyJpEiXWS7KM=;
        b=k3VfPstuC1jXHErcaMYzfXVo9mZMz3efn1rfKODiWOsuAmv3DbKpusT0km2syuEeD3
         lutmFkofnPLylfe4El2Zb1sVhVMWYxzdpbQ7TTWF2q40FNmceA9oh9c4t19sjE9paFFc
         vIaYyWmqZEcZzPfifOkhhp3EMUhFPJbmHGZ/Rh7gNtjTGTDWa6IcKEjvafS0L7jTWgCx
         DoFT1cG4z/CQQVSdN+V1UbyPICZfZ2CNraw2CO1y++tTp9nHapynRnYfhFOlwWMr3WAG
         +OmcLlWKlrXMXihZqffe0PhH5cWLazqLbjVvQrny2VsxmYU/8sqxpZ/lkB+0m6TEVoIU
         aZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=OVTt9CdxGRPNpa7pvvi1WLJ3ASvRko+oyJpEiXWS7KM=;
        b=B3VZpC4DisKE1PyfBtVLDYiuBtpxJgxuGf/qSSzp2dqWRHk9fiiGYW/nAwua6uuBTD
         hKcJM4rG9592KdBOJM9o4jcsUkCqFhkmz1R7yqqtjzfhzywGcL8o9Od+zrGtLBaNifoh
         Pg0k/PCHJvQ3ksejTq678q9/DRxV2+B5/0QiZ02lGbLyBykfRdj7g1l3nRrX1cP8AxaC
         Crsqq1tDcs9/GeQ7qdJfJ88Y4OaZfkZKvcmwfHVGVG0wiogf8sHYIcX+OA75I247thle
         FAzUzjAf6qoxAPaIHIVXUcCTLEXEEW5eX7swT456kkYwT/0d2CuflQTMC3DDvQt3jVjI
         kIzA==
X-Gm-Message-State: AOAM532NTX01VEEStoNlCZNnqtmetNz6DZcvOEbc7TR3AsmiN5dDhAIo
        0Wq6eI4iL+bxjm9ZAPqRAUI=
X-Google-Smtp-Source: ABdhPJz0YKpovFwRm3D7sa7apznTCbPlbR3gvulxNtkM+GVZeCU9NffEG3LvOSpQ+r3R36RyfMmUaA==
X-Received: by 2002:a9d:8ee:: with SMTP id 101mr3852763otf.93.1604795488657;
        Sat, 07 Nov 2020 16:31:28 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e5sm1399400oii.6.2020.11.07.16.31.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 07 Nov 2020 16:31:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v4.19] tools: perf: Fix build error in v4.19.y
Date:   Sat,  7 Nov 2020 16:31:24 -0800
Message-Id: <20201108003124.100732-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

perf may fail to build in v4.19.y with the following error.

util/evsel.c: In function ‘perf_evsel__exit’:
util/util.h:25:28: error:
	passing argument 1 of ‘free’ discards ‘const’ qualifier from pointer target type

This is observed (at least) with gcc v6.5.0. The underlying problem is
the following statement.
	zfree(&evsel->pmu_name);
evsel->pmu_name is decared 'const *'. zfree in turn is defined as
	#define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
and thus passes the const * to free(). The problem is not seen
in the upstream kernel since zfree() has been rewritten there.

The problem has been introduced into v4.19.y with the backport of upstream
commit d4953f7ef1a2 (perf parse-events: Fix 3 use after frees found with
clang ASAN).

One possible fix of this problem would be to not declare pmu_name
as const. This patch chooses to typecast the parameter of zfree()
to void *, following the guidance from the upstream kernel which
does the same since commit 7f7c536f23e6a ("tools lib: Adopt
zalloc()/zfree() from tools/perf")

Fixes: a0100a363098 ("perf parse-events: Fix 3 use after frees found with clang ASAN")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
This patch only applies to v4.19.y and has no upstream equivalent.

 tools/perf/util/util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index dc58254a2b69..8c01b2cfdb1a 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -22,7 +22,7 @@ static inline void *zalloc(size_t size)
 	return calloc(1, size);
 }
 
-#define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
+#define zfree(ptr) ({ free((void *)*ptr); *ptr = NULL; })
 
 struct dirent;
 struct nsinfo;
-- 
2.17.1

