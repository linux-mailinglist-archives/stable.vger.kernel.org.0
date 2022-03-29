Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5D04EB587
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 00:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbiC2WF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 18:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235691AbiC2WF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 18:05:29 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DF3275FD
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 15:03:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso4304265pjb.5
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 15:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RgBLxNlHqhpjGgDIooRHNrY/gUphnBv0RQLJE6uSxsI=;
        b=kjNy8s7IflDPA9HgtA42F13Bd6WGkDqG3DJoQT09YqK6qVWXVEgqztTjU+DwodPfWa
         FUELv7AwGgWZFYT+6ENg3kcnzntzt8zh94D6HCi+WPRn9OELga0lPtRlysBtLJabCLpx
         DKvFd5Mvep7qhq0VupWooR08++Dz0gfU5lTBu04nWYtijRBVVpqAhCAmVcjsRMvU5Vxx
         UmjwewGKL07txF/YpymKb1qkSrX/Smkz7a5BRHBUmvk9nM3oI8yq2qqVBk+FREhFpz9y
         +UD4ihsQy3WV65J9HSnQ2CQ82LL2xkT6zpR8YVH9xuFEhV77CXDWB3JWKok1Inb8bh1t
         4now==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RgBLxNlHqhpjGgDIooRHNrY/gUphnBv0RQLJE6uSxsI=;
        b=5L5FD+fNmYKkRCcDQUd+fM8du3yevvgiT9iceIyRl8wbDznZdRXXlA6mwds1b145rD
         pRTjyT5knQNr5N+vTJgd/06s7IVyWloyH7qpYWw5j4gUbmKadhq5BXqcO8Viv72btz3h
         kh+KV9d6EpctM+eK/NgoGoz48Vt2gj7/aGA+AohgX6NuFsjjvJ/WQr3KJwh3VCi68hZp
         LsBmJ0hKRMIvWZ5QRW6gJ0AnolQnKgu1TmyNCj5FY2YswjTKTiOUznk1hytIWeCpn3fO
         Vp6r07+GR76L/+ctJ+KkU63sQGPkMyP7ka+FS4GShBp3KP6lx3oQlpDYpaCtXxvOFeY2
         +8BA==
X-Gm-Message-State: AOAM531BLSykrTi7JEXAej1UL5mp2Q5VDAiAraMfVi2XJadbX6OwqNfF
        uG+zVop0RivqR0+giUl5ASzwLBniBVemfTBJCeI=
X-Google-Smtp-Source: ABdhPJx4Z/92cpqhPHWfLpNnSVgDiAma6BXNRr+4a1l0D4jUMA9L7TpiL32xaPEhSUbESyvSCbOJ2Q==
X-Received: by 2002:a17:902:c3c1:b0:156:1109:2383 with SMTP id j1-20020a170902c3c100b0015611092383mr11470720plj.64.1648591423743;
        Tue, 29 Mar 2022 15:03:43 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id 16-20020a17090a005000b001c7511dc31esm3937452pjb.41.2022.03.29.15.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 15:03:43 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     stable@vger.kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Keith Packard <keithp@keithp.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/2] stddef: Introduce struct_group() helper macro
Date:   Tue, 29 Mar 2022 15:02:55 -0700
Message-Id: <20220329220256.72283-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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

Please apply this to stable 5.10.y, 5.15.y
---8<---

From: Kees Cook <keescook@chromium.org>

Upstream commit: 50d7bd38c3aa ("stddef: Introduce struct_group() helper macro")

Kernel code has a regular need to describe groups of members within a
structure usually when they need to be copied or initialized separately
from the rest of the surrounding structure. The generally accepted design
pattern in C is to use a named sub-struct:

        struct foo {
                int one;
                struct {
                        int two;
                        int three, four;
                } thing;
                int five;
        };

This would allow for traditional references and sizing:

        memcpy(&dst.thing, &src.thing, sizeof(dst.thing));

However, doing this would mean that referencing struct members enclosed
by such named structs would always require including the sub-struct name
in identifiers:

        do_something(dst.thing.three);

This has tended to be quite inflexible, especially when such groupings
need to be added to established code which causes huge naming churn.
Three workarounds exist in the kernel for this problem, and each have
other negative properties.

To avoid the naming churn, there is a design pattern of adding macro
aliases for the named struct:

        #define f_three thing.three

This ends up polluting the global namespace, and makes it difficult to
search for identifiers.

Another common work-around in kernel code avoids the pollution by avoiding
the named struct entirely, instead identifying the group's boundaries using
either a pair of empty anonymous structs of a pair of zero-element arrays:

        struct foo {
                int one;
                struct { } start;
                int two;
                int three, four;
                struct { } finish;
                int five;
        };

        struct foo {
                int one;
                int start[0];
                int two;
                int three, four;
                int finish[0];
                int five;
        };

This allows code to avoid needing to use a sub-struct named for member
references within the surrounding structure, but loses the benefits of
being able to actually use such a struct, making it rather fragile. Using
these requires open-coded calculation of sizes and offsets. The efforts
made to avoid common mistakes include lots of comments, or adding various
BUILD_BUG_ON()s. Such code is left with no way for the compiler to reason
about the boundaries (e.g. the "start" object looks like it's 0 bytes
in length), making bounds checking depend on open-coded calculations:

        if (length > offsetof(struct foo, finish) -
                     offsetof(struct foo, start))
                return -EINVAL;
        memcpy(&dst.start, &src.start, offsetof(struct foo, finish) -
                                       offsetof(struct foo, start));

However, the vast majority of places in the kernel that operate on
groups of members do so without any identification of the grouping,
relying either on comments or implicit knowledge of the struct contents,
which is even harder for the compiler to reason about, and results in
even more fragile manual sizing, usually depending on member locations
outside of the region (e.g. to copy "two" and "three", use the start of
"four" to find the size):

        BUILD_BUG_ON((offsetof(struct foo, four) <
                      offsetof(struct foo, two)) ||
                     (offsetof(struct foo, four) <
                      offsetof(struct foo, three));
        if (length > offsetof(struct foo, four) -
                     offsetof(struct foo, two))
                return -EINVAL;
        memcpy(&dst.two, &src.two, length);

In order to have a regular programmatic way to describe a struct
region that can be used for references and sizing, can be examined for
bounds checking, avoids forcing the use of intermediate identifiers,
and avoids polluting the global namespace, introduce the struct_group()
macro. This macro wraps the member declarations to create an anonymous
union of an anonymous struct (no intermediate name) and a named struct
(for references and sizing):

        struct foo {
                int one;
                struct_group(thing,
                        int two;
                        int three, four;
                );
                int five;
        };

        if (length > sizeof(src.thing))
                return -EINVAL;
        memcpy(&dst.thing, &src.thing, length);
        do_something(dst.three);

There are some rare cases where the resulting struct_group() needs
attributes added, so struct_group_attr() is also introduced to allow
for specifying struct attributes (e.g. __align(x) or __packed).
Additionally, there are places where such declarations would like to
have the struct be tagged, so struct_group_tagged() is added.

Given there is a need for a handful of UAPI uses too, the underlying
__struct_group() macro has been defined in UAPI so it can be used there
too.

To avoid confusing scripts/kernel-doc, hide the macro from its struct
parsing.

Co-developed-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Acked-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/lkml/20210728023217.GC35706@embeddedor
Enhanced-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Link: https://lore.kernel.org/lkml/41183a98-bdb9-4ad6-7eab-5a7292a6df84@rasmusvillemoes.dk
Enhanced-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/lkml/1d9a2e6df2a9a35b2cdd50a9a68cac5991e7e5f0.camel@intel.com
Enhanced-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://lore.kernel.org/lkml/YQKa76A6XuFqgM03@phenom.ffwll.local
Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 include/linux/stddef.h      | 48 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/stddef.h | 24 +++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 998a4ba28eba..938216f8ab7e 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -36,4 +36,52 @@ enum {
 #define offsetofend(TYPE, MEMBER) \
 	(offsetof(TYPE, MEMBER)	+ sizeof_field(TYPE, MEMBER))
 
+/**
+ * struct_group() - Wrap a set of declarations in a mirrored struct
+ *
+ * @NAME: The identifier name of the mirrored sub-struct
+ * @MEMBERS: The member declarations for the mirrored structs
+ *
+ * Used to create an anonymous union of two structs with identical
+ * layout and size: one anonymous and one named. The former can be
+ * used normally without sub-struct naming, and the latter can be
+ * used to reason about the start, end, and size of the group of
+ * struct members.
+ */
+#define struct_group(NAME, MEMBERS...)	\
+	__struct_group(/* no tag */, NAME, /* no attrs */, MEMBERS)
+
+/**
+ * struct_group_attr() - Create a struct_group() with trailing attributes
+ *
+ * @NAME: The identifier name of the mirrored sub-struct
+ * @ATTRS: Any struct attributes to apply
+ * @MEMBERS: The member declarations for the mirrored structs
+ *
+ * Used to create an anonymous union of two structs with identical
+ * layout and size: one anonymous and one named. The former can be
+ * used normally without sub-struct naming, and the latter can be
+ * used to reason about the start, end, and size of the group of
+ * struct members. Includes structure attributes argument.
+ */
+#define struct_group_attr(NAME, ATTRS, MEMBERS...) \
+	__struct_group(/* no tag */, NAME, ATTRS, MEMBERS)
+
+/**
+ * struct_group_tagged() - Create a struct_group with a reusable tag
+ *
+ * @TAG: The tag name for the named sub-struct
+ * @NAME: The identifier name of the mirrored sub-struct
+ * @MEMBERS: The member declarations for the mirrored structs
+ *
+ * Used to create an anonymous union of two structs with identical
+ * layout and size: one anonymous and one named. The former can be
+ * used normally without sub-struct naming, and the latter can be
+ * used to reason about the start, end, and size of the group of
+ * struct members. Includes struct tag argument for the named copy,
+ * so the specified layout can be reused later.
+ */
+#define struct_group_tagged(TAG, NAME, MEMBERS...) \
+	__struct_group(TAG, NAME, /* no attrs */, MEMBERS)
+
 #endif
diff --git a/include/uapi/linux/stddef.h b/include/uapi/linux/stddef.h
index ee8220f8dcf5..9f5da295ff1c 100644
--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -1,6 +1,30 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #include <linux/compiler_types.h>
+#ifndef _UAPI_LINUX_STDDEF_H
+#define _UAPI_LINUX_STDDEF_H
 
 #ifndef __always_inline
 #define __always_inline inline
 #endif
+
+/**
+ * __struct_group() - Create a mirrored named and anonyomous struct
+ *
+ * @TAG: The tag name for the named sub-struct (usually empty)
+ * @NAME: The identifier name of the mirrored sub-struct
+ * @ATTRS: Any struct attributes (usually empty)
+ * @MEMBERS: The member declarations for the mirrored structs
+ *
+ * Used to create an anonymous union of two structs with identical layout
+ * and size: one anonymous and one named. The former's members can be used
+ * normally without sub-struct naming, and the latter can be used to
+ * reason about the start, end, and size of the group of struct members.
+ * The named struct can also be explicitly tagged for layer reuse, as well
+ * as both having struct attributes appended.
+ */
+#define __struct_group(TAG, NAME, ATTRS, MEMBERS...) \
+	union { \
+		struct { MEMBERS } ATTRS; \
+		struct TAG { MEMBERS } ATTRS NAME; \
+	}
+#endif
-- 
2.35.1

