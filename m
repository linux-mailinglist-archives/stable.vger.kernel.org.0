Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1099756341B
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 15:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbiGANJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 09:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235544AbiGANJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 09:09:35 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DC431516
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 06:09:32 -0700 (PDT)
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 091BD40A68
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 13:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1656680970;
        bh=b7R8ql7cF0yekbAJkH0ry0LqcE+e1poUS0Q2MROPNF0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=k6gXXNoCjtFgHHe03/HnGsNJJ2lQCLHBYZpgU5wkGZamkZOKxf7rnrCl+i9DPWi9V
         o3LF3QGKm9/vJLRUvDY9xYhHOo22axhn+u6WCkush9CD1IqKVeXMWFHMP5iPIThhc4
         J7mpOc4NAkQ9D8aXRNq5Z3WUc0vhXIuru1wY8ABYxRfHLyVwaulG4kiXle5RLbH5mo
         /5SKMZtahOEr38jVvsiCnmYQ7LnK5umaYU/27U/Dw07p6KJ6AjAZtAuVEYDDM2foqM
         riFGyUTBYjCsi4x7P2JRLe/LzmMleRwOL6oy8Ym3hXhpfgGEJEhxAG37zFd0J1v+ax
         srM12gxt/BeEw==
Received: by mail-pl1-f198.google.com with SMTP id s9-20020a170902ea0900b0016a4515b2e4so1411963plg.16
        for <stable@vger.kernel.org>; Fri, 01 Jul 2022 06:09:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b7R8ql7cF0yekbAJkH0ry0LqcE+e1poUS0Q2MROPNF0=;
        b=GxbZd3Lt1XX/mBE+S/kFr54bH0YUXl8vjJ8lrPMm9383g/Eu/U/b23LOZh1stzlkCg
         azFL7/5cnCZxQqEv2hpXn5ZOJ//FLV+ZLSxcqKWPulPpnpJAzjGrgmRT81HfldmN9vMa
         HM8/c/wJqJh4xX1k9T2NEm45eISbCv3vMiyBACuR6MwNPjIs6LQXWTcZ0l9kkIdqcnZF
         l8oVH9PqK1ymUak4HReSYR4iXrzRZ2FX57oCAl1aB5aRCYkVLUNSo+5GqCyKHTMm4xnA
         SpkIgYLXx0Vser9fpcMIpLwq2wleID2JJad7QVmJjxwEpwRCl7vIZSdkrTfTW6/FQlgy
         bfgA==
X-Gm-Message-State: AJIora+3M6l0fmUZYy+dCqa5E65fsF+bGnI/lLKaMFM6dtpOgQTPIESG
        0PkFS7/cT+tpg2GLoyywVgKcXDPf9Gba9MQQMwO0MfeMwyfZgScO1DG0OfvSIg6MiO/CjePJp9R
        knKI4f/zpR8t6Pki4ATvPBKh3tyuuNMC6
X-Received: by 2002:a17:903:2c2:b0:168:e323:d471 with SMTP id s2-20020a17090302c200b00168e323d471mr20824057plk.147.1656680968725;
        Fri, 01 Jul 2022 06:09:28 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vqObrdPNgdHs2+FKrAT3pPzBjH9lMoLRQETrv6f8KLXOdxkCqEXAlvCi3uZpaAB7QD3CH8FA==
X-Received: by 2002:a17:903:2c2:b0:168:e323:d471 with SMTP id s2-20020a17090302c200b00168e323d471mr20824037plk.147.1656680968462;
        Fri, 01 Jul 2022 06:09:28 -0700 (PDT)
Received: from localhost.localdomain (223-137-32-253.emome-ip.hinet.net. [223.137.32.253])
        by smtp.gmail.com with ESMTPSA id cp2-20020a170902e78200b0015e8d4eb1d7sm15489395plb.33.2022.07.01.06.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 06:09:27 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     memxor@gmail.com, linux-kernel@vger.kernel.org, ast@kernel.org,
        po-hsu.lin@canonical.com
Subject: [PATCH stable 5.15 1/1] selftests/bpf: Add test_verifier support to fixup kfunc call insns
Date:   Fri,  1 Jul 2022 21:08:58 +0800
Message-Id: <20220701130858.282569-2-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220701130858.282569-1-po-hsu.lin@canonical.com>
References: <20220701130858.282569-1-po-hsu.lin@canonical.com>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

commit 0201b80772ac2b712bbbfe783cdb731fdfb4247e upstream.

This allows us to add tests (esp. negative tests) where we only want to
ensure the program doesn't pass through the verifier, and also verify
the error. The next commit will add the tests making use of this.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220114163953.1455836-9-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[PHLin: backport due to lack of fixup_map_timer]
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 3a9e332..68a9a89 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -31,6 +31,7 @@
 #include <linux/if_ether.h>
 #include <linux/btf.h>
 
+#include <bpf/btf.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
@@ -63,6 +64,11 @@ static bool unpriv_disabled = false;
 static int skips;
 static bool verbose = false;
 
+struct kfunc_btf_id_pair {
+	const char *kfunc;
+	int insn_idx;
+};
+
 struct bpf_test {
 	const char *descr;
 	struct bpf_insn	insns[MAX_INSNS];
@@ -88,6 +94,7 @@ struct bpf_test {
 	int fixup_map_event_output[MAX_FIXUPS];
 	int fixup_map_reuseport_array[MAX_FIXUPS];
 	int fixup_map_ringbuf[MAX_FIXUPS];
+	struct kfunc_btf_id_pair fixup_kfunc_btf_id[MAX_FIXUPS];
 	/* Expected verifier log output for result REJECT or VERBOSE_ACCEPT.
 	 * Can be a tab-separated sequence of expected strings. An empty string
 	 * means no log verification.
@@ -718,6 +725,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_event_output = test->fixup_map_event_output;
 	int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
 	int *fixup_map_ringbuf = test->fixup_map_ringbuf;
+	struct kfunc_btf_id_pair *fixup_kfunc_btf_id = test->fixup_kfunc_btf_id;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -903,6 +911,26 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_map_ringbuf++;
 		} while (*fixup_map_ringbuf);
 	}
+
+	/* Patch in kfunc BTF IDs */
+	if (fixup_kfunc_btf_id->kfunc) {
+		struct btf *btf;
+		int btf_id;
+
+		do {
+			btf_id = 0;
+			btf = btf__load_vmlinux_btf();
+			if (btf) {
+				btf_id = btf__find_by_name_kind(btf,
+								fixup_kfunc_btf_id->kfunc,
+								BTF_KIND_FUNC);
+				btf_id = btf_id < 0 ? 0 : btf_id;
+			}
+			btf__free(btf);
+			prog[fixup_kfunc_btf_id->insn_idx].imm = btf_id;
+			fixup_kfunc_btf_id++;
+		} while (fixup_kfunc_btf_id->kfunc);
+	}
 }
 
 struct libcap {
-- 
2.7.4

