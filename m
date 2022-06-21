Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB2A553B4D
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 22:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352453AbiFUUQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 16:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbiFUUQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:16:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 995021ADAC
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 13:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655842567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=u6th9lpXmxR7QuY7ofQaPZryyTTuOkaSeW8+oHUqr2Q=;
        b=JnKsuQJ/fpk71Hl8baQpZ7mWUHiWz740NJmvaaw/ePjsys5qLr5I1gIrWYbBAyxsjZ3+RE
        KvavmJun/3xnZpIenJ0HfMOMSoZCtzz+EvYr6XcJVfpbpZz+HzVbWtJTZw0r8a06r5sTdt
        s4lgjVes9Jhf6S47yre8+evDJWs3heQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-L_-qY-sUP1KxXMkjRO3Law-1; Tue, 21 Jun 2022 16:16:06 -0400
X-MC-Unique: L_-qY-sUP1KxXMkjRO3Law-1
Received: by mail-ed1-f72.google.com with SMTP id q18-20020a056402519200b004358ce90d97so3978556edd.4
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 13:16:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u6th9lpXmxR7QuY7ofQaPZryyTTuOkaSeW8+oHUqr2Q=;
        b=BcecAuoxoAJ6pgOwvLYae/ijnw/65CWwmYg3lnP2NJFwCihT8vL7dybb9TBTDJYvx5
         9VYh1WzSPitk/Zb5q98T7+a6+KemME90FARFtUBJzWUUEYmt5G1wigl8Op63pXSITd+X
         hLWvs+hsujOWu/hBCsouOOcn+o32OLyTAZYFR5naZNw7SO+1HOoetcA+WM5K8Yhyx1JE
         L6GInzEyphTjPxISh3YP8KoSkTuPyDq/hgjtGMEpfRCr7YggAvM16jkqP7DhxvPVM/po
         K4zlIRHtf4u5pxp4Hg/eLNLQrvHhUKX6sr8qMzHPiPPhFeTBkmqdGQaCvB2yZe0Gro23
         rjqA==
X-Gm-Message-State: AJIora8WH0faCunsajRMcJutBlaOQ9CePxllJGS0cxAuZHd0ehPCoT+P
        zXeG5AjrYftIIvk324NN2GDMwZBdMZiv4kgZgbqjOKlPdrKYiWQsTWcwnuMio6mw76odYXYSR8d
        ++E5x8BLiV0HI72O9
X-Received: by 2002:a17:906:5055:b0:6ff:1dfb:1e2c with SMTP id e21-20020a170906505500b006ff1dfb1e2cmr27402206ejk.200.1655842563897;
        Tue, 21 Jun 2022 13:16:03 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v3ivlf9H7VRFwtbrARoKCL88FC1NROunEYknmS0c0ACgWGCE06a8i91smgFXF8U4HOIbzfGQ==
X-Received: by 2002:a17:906:5055:b0:6ff:1dfb:1e2c with SMTP id e21-20020a170906505500b006ff1dfb1e2cmr27402103ejk.200.1655842562310;
        Tue, 21 Jun 2022 13:16:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id w13-20020a170906480d00b00704b196e59bsm8069662ejq.185.2022.06.21.13.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 13:15:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 27C6A40782D; Tue, 21 Jun 2022 22:15:03 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Simon Sundberg <simon.sundberg@kau.se>
Subject: [PATCH 5.18 1/2] bpf: Fix calling global functions from BPF_PROG_TYPE_EXT programs
Date:   Tue, 21 Jun 2022 22:15:00 +0200
Message-Id: <20220621201501.112598-1-toke@redhat.com>
X-Mailer: git-send-email 2.36.1
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

commit f858c2b2ca04fc7ead291821a793638ae120c11d upstream

The verifier allows programs to call global functions as long as their
argument types match, using BTF to check the function arguments. One of the
allowed argument types to such global functions is PTR_TO_CTX; however the
check for this fails on BPF_PROG_TYPE_EXT functions because the verifier
uses the wrong type to fetch the vmlinux BTF ID for the program context
type. This failure is seen when an XDP program is loaded using
libxdp (which loads it as BPF_PROG_TYPE_EXT and attaches it to a global XDP
type program).

Fix the issue by passing in the target program type instead of the
BPF_PROG_TYPE_EXT type to bpf_prog_get_ctx() when checking function
argument compatibility.

The first Fixes tag refers to the latest commit that touched the code in
question, while the second one points to the code that first introduced
the global function call verification.

v2:
- Use resolve_prog_type()

Fixes: 3363bd0cfbb8 ("bpf: Extend kfunc with PTR_TO_CTX, PTR_TO_MEM argument support")
Fixes: 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
Reported-by: Simon Sundberg <simon.sundberg@kau.se>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20220606075253.28422-1-toke@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ backport: resolve conflict due to kptr series missing ]
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/btf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0918a39279f6..feef799884d1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5769,6 +5769,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    struct bpf_reg_state *regs,
 				    bool ptr_to_mem_ok)
 {
+	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
 	struct bpf_verifier_log *log = &env->log;
 	u32 i, nargs, ref_id, ref_obj_id = 0;
 	bool is_kfunc = btf_is_kernel(btf);
@@ -5834,8 +5835,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		if (ret < 0)
 			return ret;
 
-		if (btf_get_prog_ctx_type(log, btf, t,
-					  env->prog->type, i)) {
+		if (btf_get_prog_ctx_type(log, btf, t, prog_type, i)) {
 			/* If function expects ctx type in BTF check that caller
 			 * is passing PTR_TO_CTX.
 			 */
-- 
2.36.1

