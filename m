Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36332E8587
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 21:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbhAAUXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 15:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727306AbhAAUXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 15:23:35 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AFEC061757
        for <stable@vger.kernel.org>; Fri,  1 Jan 2021 12:22:54 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id 6so28865818ejz.5
        for <stable@vger.kernel.org>; Fri, 01 Jan 2021 12:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ByznZ0Gm9SIrLSRoWGLA0mAxlw1e3MRKplvzmFgYNVA=;
        b=aQPXnLsuGXd+yvRf9eTDycWH+QuvKRDGypoSNTYcdq6hwxjaP+Fcb46KpIgEDxxtvT
         TXiljW8tmngl0sgMfjGFIjF2xuiEvndXfQF5nMxqUhE/y0ryAWEueqnnTJBH+C8NjYV0
         GWqKQsKhJVuOYdZd9COTjHdpLZRY4LrQr62wMhtvTlLvoh4fbj5Wn7kKcdYco5nEXSyx
         4/9j240vLCXphMGyFjZd8Tz9Stbagr3E3KhpKs3qDZq3M2r5poOHDvdujj8XtHbHwaqz
         vyDH/g4kMcU3Yswjy0tMiLNqap9rdT4XzmDPxaiIogBRPRs8eNfY7Wev9YLb9HgcDVxt
         X2JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ByznZ0Gm9SIrLSRoWGLA0mAxlw1e3MRKplvzmFgYNVA=;
        b=SYp6tmttIs//dhi68QLnOcIjsEyUJHRZxtoH4nQRRQ5jV1UphVSHRpI5pD26Jx3Bvm
         9Py+f+vqiSnHQNNR5ee7zRudY0kWhARn2wDAGx7CqVCwVv1voETxvC0ugnm1+nVO/CSF
         OlPpWdfgJ5a0Xx9dvEb2J2NSqAwIkz8WdsQZJjtRA53JViis2Pf81w0OEctuzWq462DN
         dCJFMcoet8CEU5c9it2OAZU5sIPb/ZP+cCLby2GV1XW4wx9eGPwKzkAHmuoHfqZksL1R
         KG2AzOjWksCe6hevv28wC/G+Nb43oRpKmt4PI6TfV/1Z7EFDP36Xkel+/tiyBWgx3BZr
         XFoQ==
X-Gm-Message-State: AOAM533ifp7H/q78YckEo9oXUE0EusGoV4Z3+gISWGfai/X49RqJYhYS
        40qS4WlviV9aq9qpWLBEJK7x9wEUSi+L1A==
X-Google-Smtp-Source: ABdhPJxArP0jKH7s4Hz8YJ1o+L+XXxWRWkBU9kKqToG76yVBSrHctWVFYTIrEiyeQrwhiZ4JejQMAQ==
X-Received: by 2002:a17:906:6d47:: with SMTP id a7mr59416788ejt.340.1609532573427;
        Fri, 01 Jan 2021 12:22:53 -0800 (PST)
Received: from localhost.localdomain ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id e27sm21214898ejm.60.2021.01.01.12.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jan 2021 12:22:52 -0800 (PST)
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
Date:   Fri,  1 Jan 2021 21:22:45 +0100
Message-Id: <20210101202245.27409-2-petr.vorel@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210101202245.27409-1-petr.vorel@gmail.com>
References: <20210101202245.27409-1-petr.vorel@gmail.com>
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
Fix for previous commit.

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

