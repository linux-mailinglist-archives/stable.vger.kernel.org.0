Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B478059EF6F
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 00:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiHWWsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 18:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiHWWsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 18:48:19 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33978B2E5
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 15:48:16 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id i16-20020a170902c95000b00172c39b3fb0so7918555pla.22
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 15:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=YHBqbQM3NMY0cCrSntfkljesc8TAC/U4AG8R+VgzY3A=;
        b=O6VMZWlXVxl9lfPpxPjKWilGV07sUHi4GKZV0gZX1Gi2ZF7dN+73ZJ/PK0Sa1jwLCk
         tWszWgO9rxX+fbVFHqYkehQqb2wrkVqGRUty1VpJFrJ1VttT3vVIWTh8cWd2TMVD4pVi
         ZZ3V0qE4frtaEiKuUAymKgGXB3tpSxUqf7oeCG3oy+9iq1VH2RWR1y+IOD1n7hOsbeTb
         UKbmIX5Feo7H7ML7Wkk8jFv3IyTcmmR3TeTlTlycH3AE1ZYIi2L+aJj2b74i96zn0VUn
         qfk1zDrcVxMUDFm3hbvH/6ZJJR1XzhvTzG7x7uVCM0r/mSn/m11MqrlXpCdVdBPgHEhv
         Hu3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=YHBqbQM3NMY0cCrSntfkljesc8TAC/U4AG8R+VgzY3A=;
        b=LPFy52TWdCKcHNC8P3yFKIwoMPceE+ocSdP9XsGHRKKt1UCFZHNzg0sh9wq6fdcKM6
         EFh54AC2gHrU6AGB3rFkQODvp5e7K9uve5R+cFThdEjs7L87TITx00O7+puRchHQHOjg
         vzTJ8XdLjCB68CBPsmAJEQ7gHlsXZAK1wMZV3XkCXyt/h1P4JCyLG2iF5CznZDlF4rKy
         d4TYgc6cbyU0BFiT+p53mC3GY4BzQySPA9CN4+/HrwMJXbdkYwSajVH2nJkrgLbuJpmU
         /1Yw3UfYu5uoS7fdSfFe7xiEnsCd8yiK8Mfivcdhd+bmgxMoGGf8pgBtVAf6d8DCFhQr
         d+QA==
X-Gm-Message-State: ACgBeo1LeC5u+Ap/4opteqDr1OanU13YS5ezK3OLVO7JHKLJMo2XXHBg
        FNpw+dHXD7iasOeDwedRHcs1LqZ1tQ==
X-Google-Smtp-Source: AA6agR4/Tw3x1nc5MgOSIj9wYmOp31p/sL5WQ6wQTxMTGs1JLO43iiGd6CU2gmPX6d61M3Y0Ckx07mWGfQ==
X-Received: from adelg-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:d1f])
 (user=adelg job=sendgmr) by 2002:a05:6a00:10c2:b0:4f7:5af4:47b6 with SMTP id
 d2-20020a056a0010c200b004f75af447b6mr22564043pfu.6.1661294895970; Tue, 23 Aug
 2022 15:48:15 -0700 (PDT)
Date:   Tue, 23 Aug 2022 22:48:11 +0000
Message-Id: <20220823224811.12758-1-adelg@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH] selftests: remove unused variable in close_range test
From:   Andrew Delgadilo <adelg@google.com>
To:     Shuah Khan <shuah@kernel.org>, Andrew Delgadillo <adelg@google.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Delgadillo <adelg@google.com>

commit 2c5db60e46ad ("tests: add close_range() tests") adds the
close_range test under the core namespace. In its current form, the
close_range test has an unused variable, namely, ret. For those building
with -Werror,-Wall, this breaks the build.

Without this patch:
$ make -C tools/testing/selftests/ TARGETS=core V=1 CFLAGS="-Werror -Wall"
> make: Entering directory '/.../kernel-src/tools/testing/selftests'
> make[1]: Entering directory '/.../kernel-src/tools/testing/selftests/core'
> gcc -Werror -Wall    close_range_test.c  -o /.../kernel-src/tools/testing/selftests/core/close_range_test
> close_range_test.c: In function 'core_close_range':
> close_range_test.c:55:16: error: unused variable 'ret' [-Werror=unused-variable]
>   55 |         int i, ret;
>      |                ^~~
> cc1: all warnings being treated as errors
> make[1]: *** [../lib.mk:135: /.../kernel-src/tools/testing/selftests/core/close_range_test] Error 1
> make[1]: Leaving directory '/.../kernel-src/tools/testing/selftests/core'
> make: *** [Makefile:155: all] Error 2
> make: Leaving directory '/.../kernel-src/tools/testing/selftests'

With this patch:
$ make -C tools/testing/selftests/ TARGETS=core V=1 CFLAGS="-Werror -Wall"
> make: Entering directory '/.../kernel-src/tools/testing/selftests'
> make[1]: Entering directory '/.../kernel-src/tools/testing/selftests/core'
> gcc -Werror -Wall    close_range_test.c  -o /.../kernel-src/tools/testing/selftests/core/close_range_test
> make[1]: Leaving directory '/.../kernel-src/tools/testing/selftests/core'
> make: Leaving directory '/.../kernel-src/tools/testing/selftests'

Fixes: 2c5db60e46ad ("tests: add close_range() tests")
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Delgadillo <adelg@google.com>
---
 tools/testing/selftests/core/close_range_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/core/close_range_test.c b/tools/testing/selftests/core/close_range_test.c
index 749239930ca83..17c76c6c13cb9 100644
--- a/tools/testing/selftests/core/close_range_test.c
+++ b/tools/testing/selftests/core/close_range_test.c
@@ -52,7 +52,7 @@ static inline int sys_close_range(unsigned int fd, unsigned int max_fd,
 
 TEST(core_close_range)
 {
-	int i, ret;
+	int i;
 	int open_fds[101];
 
 	for (i = 0; i < ARRAY_SIZE(open_fds); i++) {
-- 
2.37.1.595.g718a3a8f04-goog

