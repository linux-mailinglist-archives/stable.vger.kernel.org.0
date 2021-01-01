Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD9B2E8589
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 21:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbhAAU2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 15:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbhAAU2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 15:28:46 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18812C0613CF
        for <stable@vger.kernel.org>; Fri,  1 Jan 2021 12:28:06 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id i24so20900814edj.8
        for <stable@vger.kernel.org>; Fri, 01 Jan 2021 12:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KEUZAZZ4i9ywnVtXKtjk7HT5a3MIB0wrzjbV5kaLo0M=;
        b=RDFfaRrnPxdXtI5y+zOu0/CtsebXIzGJ6cvdh+kPgfRQBDe4Tx0uCZt2JkDM7RPhIM
         N8T/EpxwgQJdNV6eNxf9fuo7QaUs6yU5mCFC6j1R99VCUOxEK39aa0XZZQ7JIzYP2NWz
         LJGnKfstGPz4KZPrHhTBuWepVwckJxub5RIN52FsxLK2+CaSuEyUJA24QiPMwVXmbnMm
         u9k24fJmYooeluWfd7Yruw9XhwGxJUd8Sys51P7kMZ6LIeryCAiapydk6h3vtaGxypmQ
         1iSaoQlIVdmTBlTpFkTOjNJ0H0W8to2RtCL4OR/qC9HUIVvkCkDopSeCt8piJI2aFF7Y
         YtOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KEUZAZZ4i9ywnVtXKtjk7HT5a3MIB0wrzjbV5kaLo0M=;
        b=toYMZeKGfU2Ul3KQdFOQ1dVqPeq7k8xg5AyAKlVjIL5rd6iYO0frQKdu0v9kA6z2vy
         S/evOUtWV/ysd0IleH9Ie6Bu19L+LWw+X8UHns2A5jU9jhX05dD/A5GMEhQ9BfHw38NG
         iELcePup3hlR0bLxInEqsae/DT/ZATF2dYn/yrV7UaRBJUFLsgJHGlYPot1nBx/rMvA2
         zt+/DFwU4H07blc+Dp6AIsKc/0HQY5CW/EtE0co1ePpNN4VTj9v7H56wDPECyvJy99Ty
         J5UYJiKLmAKn5NFmpOqKpLfEpsdUrzXZnC0QAxaIrvSwTLbvPQsuQPEngXAYD9zO7QYp
         6Rcg==
X-Gm-Message-State: AOAM532Atr97H835Ns9oCacN8JrZ9VtGQYSq6WOdyyQMtuI2C/o80pzQ
        3C8y3ZgNcK4wGZgA/4+2xwg5c4AhZU4isg==
X-Google-Smtp-Source: ABdhPJxx+rYpj+HrVdsE3Y8hcnFslCllxcw02NmDTQoffkMnTgIbUAbVCC+n25Io9m6q2EoJDARcYg==
X-Received: by 2002:a50:b223:: with SMTP id o32mr61457902edd.79.1609532884811;
        Fri, 01 Jan 2021 12:28:04 -0800 (PST)
Received: from localhost.localdomain ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id ld2sm21135378ejb.73.2021.01.01.12.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jan 2021 12:28:04 -0800 (PST)
From:   Petr Vorel <petr.vorel@gmail.com>
To:     stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Rich Felker <dalias@libc.org>,
        Peter Korsgaard <peter@korsgaard.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Florian Weimer <fweimer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Vorel <petr.vorel@gmail.com>
Subject: [PATCH 2/2] tools headers UAPI: Sync linux/const.h with the kernel headers
Date:   Fri,  1 Jan 2021 21:27:58 +0100
Message-Id: <20210101202758.28291-2-petr.vorel@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210101202758.28291-1-petr.vorel@gmail.com>
References: <20210101202758.28291-1-petr.vorel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 7ddcdea5b54492f54700f427f58690cf1e187e5e upstream.

To pick up the changes in:

  a85cbe6159ffc973 ("uapi: move constants from <linux/kernel.h> to <linux/const.h>")

That causes no changes in tooling, just addresses this perf build
warning:

  Warning: Kernel ABI header at 'tools/include/uapi/linux/const.h' differs from latest version at 'include/uapi/linux/const.h'
  diff -u tools/include/uapi/linux/const.h include/uapi/linux/const.h

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Petr Vorel <petr.vorel@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
---
Fix for previous commit (for stable/linux-5.10.y.).

Kind regards,
Petr

 tools/include/uapi/linux/const.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/include/uapi/linux/const.h b/tools/include/uapi/linux/const.h
index 5ed721ad5b19..af2a44c08683 100644
--- a/tools/include/uapi/linux/const.h
+++ b/tools/include/uapi/linux/const.h
@@ -28,4 +28,9 @@
 #define _BITUL(x)	(_UL(1) << (x))
 #define _BITULL(x)	(_ULL(1) << (x))
 
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+
+#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+
 #endif /* _UAPI_LINUX_CONST_H */
-- 
2.29.2

