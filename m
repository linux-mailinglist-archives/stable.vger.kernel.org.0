Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F98C553B48
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 22:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiFUUOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 16:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235107AbiFUUOB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:14:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D11911E3FC
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 13:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655842439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9jTNcwWavdUq8ZRKIHth20RsV2uziGPAfKD6CafsLwI=;
        b=FvooTC6WrPeQq0TYv2FGCrsyFmIewWVb2pnKAOcB93YigMkW5NR6cUnQwTRvBPIOMxy+xP
        YyaAT8TXTytveVOH/XqHZYGna9qPTPYn0qbZ+NA0nGuveT+kTTgi6DUeIgXxjiNvscyfDB
        hkc/1qg7ZR4W95eE/hRlhhYIXzowzu4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-GvFeeM7EMxaVpGGmyY52kA-1; Tue, 21 Jun 2022 16:13:57 -0400
X-MC-Unique: GvFeeM7EMxaVpGGmyY52kA-1
Received: by mail-ej1-f71.google.com with SMTP id gn39-20020a1709070d2700b00722abe40a31so2649009ejc.7
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 13:13:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9jTNcwWavdUq8ZRKIHth20RsV2uziGPAfKD6CafsLwI=;
        b=CvjGpsfv3KtH9mB1XFH4W0exhyw/rzW+tSwFk1HFtbYlCQYBaaKkJYv57RvYzcUM/A
         dL4Z9/HzO2GQ0504j605EdF8hIYvL9h8fvog2FyxTkMtWFAldyxZRF8qcSOtGKfhvzJI
         LggahpXAjmg+vEKfc3WOq5xECXfYy8oOgRRZYstC6dSYJl1dho8OBCExwmqePuYxYQXB
         Xu/44Xa1WI6ROZQp4k1qzH71IlkX7FOtVXEeYd51+y4u4CDmPdQKGYo2joZ7v8RyrVqL
         /8H/TbUl8IIK9yU8js7t1f0x21tT+hyYCYt+eRrUS+W3W8UbnFEkmfQ7Cf5hr2/9CBq3
         N+yQ==
X-Gm-Message-State: AJIora/ZXwN8Vv5gIT0Z9dPrTHwKZGusiKof0BcgT54KzEBvGTFeqTGX
        DlnKQzX+pWT+hcokA/mfcxaSF8jOouc42+tjfQn2Vt1DXctt2Kt3TbvoqLWFIC7ginh9EW+2zHC
        ZoWDaoVVoeTupeGkB
X-Received: by 2002:a17:906:1ca:b0:715:73f3:b50f with SMTP id 10-20020a17090601ca00b0071573f3b50fmr27172790ejj.374.1655842435949;
        Tue, 21 Jun 2022 13:13:55 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1usUm3TosOiIkK8jbIR7TwiUvOs6rX4mM3kTWHQSto+WNFsN60cV9OZy8/8pj+2aB07qrZSHg==
X-Received: by 2002:a17:906:1ca:b0:715:73f3:b50f with SMTP id 10-20020a17090601ca00b0071573f3b50fmr27172776ejj.374.1655842435644;
        Tue, 21 Jun 2022 13:13:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id sd12-20020a1709076e0c00b00722e8c47cc9sm686169ejc.181.2022.06.21.13.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 13:13:54 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A83EE407828; Tue, 21 Jun 2022 22:13:52 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH 5.15 2/2] selftests/bpf: Add selftest for calling global functions from freplace
Date:   Tue, 21 Jun 2022 22:13:45 +0200
Message-Id: <20220621201345.112137-2-toke@redhat.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621201345.112137-1-toke@redhat.com>
References: <20220621201345.112137-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2cf7b7ffdae519b284f1406012b52e2282fa36bf upstream

Add a selftest that calls a global function with a context object parameter
from an freplace function to check that the program context type is
correctly converted to the freplace target when fetching the context type
from the kernel BTF.

v2:
- Trim includes
- Get rid of global function
- Use __noinline

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20220606075253.28422-2-toke@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ backport: fix conflict because tests were not serialised ]
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c   | 14 ++++++++++++++
 .../selftests/bpf/progs/freplace_global_func.c | 18 ++++++++++++++++++
 2 files changed, 32 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_global_func.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index 73b4c76e6b86..52f1426ae06e 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -371,6 +371,18 @@ static void test_func_map_prog_compatibility(void)
 				     "./test_attach_probe.o");
 }
 
+static void test_func_replace_global_func(void)
+{
+	const char *prog_name[] = {
+		"freplace/test_pkt_access",
+	};
+
+	test_fexit_bpf2bpf_common("./freplace_global_func.o",
+				  "./test_pkt_access.o",
+				  ARRAY_SIZE(prog_name),
+				  prog_name, false, NULL);
+}
+
 void test_fexit_bpf2bpf(void)
 {
 	if (test__start_subtest("target_no_callees"))
@@ -391,4 +403,6 @@ void test_fexit_bpf2bpf(void)
 		test_func_replace_multi();
 	if (test__start_subtest("fmod_ret_freplace"))
 		test_fmod_ret_freplace();
+	if (test__start_subtest("func_replace_global_func"))
+		test_func_replace_global_func();
 }
diff --git a/tools/testing/selftests/bpf/progs/freplace_global_func.c b/tools/testing/selftests/bpf/progs/freplace_global_func.c
new file mode 100644
index 000000000000..96cb61a6ce87
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/freplace_global_func.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+__noinline
+int test_ctx_global_func(struct __sk_buff *skb)
+{
+	volatile int retval = 1;
+	return retval;
+}
+
+SEC("freplace/test_pkt_access")
+int new_test_pkt_access(struct __sk_buff *skb)
+{
+	return test_ctx_global_func(skb);
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.36.1

