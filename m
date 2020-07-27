Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B3C22F44C
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 18:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgG0QG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 12:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbgG0QG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 12:06:26 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B690C061794
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 09:06:26 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id t6so2798276qvw.1
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 09:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PcrstqUpq9nlkeFBw0gWGbZYMfJbHQE2gCXLy9ozsXk=;
        b=klicSDPN8Eb/8wZaWClo7E/zGmfFo8vl2cEIyobjNG47IwNP7rtRcGzs6fO3QrsSUa
         zwIVcakdL6bQSNq5jbaGsZimaTE/VTYBW9dbRmkj4JVLwO+qVr3cUGogw/RHz4qVdxUs
         rt+wJKhYu75IMmpdFlPkA1vu9CNLkrySKu9Prx5kYLjpo45G8pVJHZkQ0YwVxvGiZ/Tn
         xjC6zxdP2SlDxY9ZYak4UCaWT9R9jywy6akbSt/nQumWVDpRlQEJpLR9ORr8MlFediYg
         QktGZdYXGu/8rfiChJDe6cOQQsLFvZYj1olnI6q5qWETZ+owTaeW7F0TCqqXaToG1EnC
         bMZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PcrstqUpq9nlkeFBw0gWGbZYMfJbHQE2gCXLy9ozsXk=;
        b=syO4YoNeePerhRmIuloJTL4n0TGet8i2yqv9QsPocvy3CBORB2yE3sMbmMLlXLLoof
         k/CDUh6qDZ+CrJ5yjYn+1vrRmsfDqbgKTcS/bHTn3hcsbN0XawIkkeBMFz6bQdGa5whq
         /jVl/ArHFFQxmzSGm/8sSMq5N6AZ25MpiMXg35PiqD+6l5b/izvB0S+ZkOg8UrmUEa3c
         Fix1Oav++F7viza9/v0Cx4UXPhJGt8ijlOog6TFwRl766dYcjZxKxfm+4SH7W7Q8WydG
         iItzghSxyZzh2cr5dwekChcLwZVXW3xA2CdM4vgKYSg8chQ6JE5ejNmdRsoK5lWKnnQ6
         Jjsw==
X-Gm-Message-State: AOAM530DUK8Mri6pX3pjtmOqNoXczWft0tukcT3sj0jnc9AwlZ7dAeq7
        0GDcWeyC4fqo1g4S8Uw1DAA=
X-Google-Smtp-Source: ABdhPJxrLe9zg1jRKVcq0u1NIHh6gPEjib84fO0r1Ha5WAzAcAjmRsMre7lmBVPn+EJ+u4G+6mICKw==
X-Received: by 2002:ad4:4e6e:: with SMTP id ec14mr22432117qvb.79.1595865968011;
        Mon, 27 Jul 2020 09:06:08 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id h55sm16114349qte.16.2020.07.27.09.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 09:06:00 -0700 (PDT)
Date:   Mon, 27 Jul 2020 09:05:59 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     maskray@google.com, masahiroy@kernel.org, ndesaulniers@google.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Makefile: Fix GCC_TOOLCHAIN_DIR prefix
 for Clang cross" failed to apply to 4.4-stable tree
Message-ID: <20200727160559.GA1386610@ubuntu-n2-xlarge-x86>
References: <159585527713469@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <159585527713469@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 27, 2020 at 03:07:57PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From ca9b31f6bb9c6aa9b4e5f0792f39a97bbffb8c51 Mon Sep 17 00:00:00 2001
> From: Fangrui Song <maskray@google.com>
> Date: Tue, 21 Jul 2020 10:31:23 -0700
> Subject: [PATCH] Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross
>  compilation
> 
> When CROSS_COMPILE is set (e.g. aarch64-linux-gnu-), if
> $(CROSS_COMPILE)elfedit is found at /usr/bin/aarch64-linux-gnu-elfedit,
> GCC_TOOLCHAIN_DIR will be set to /usr/bin/.  --prefix= will be set to
> /usr/bin/ and Clang as of 11 will search for both
> $(prefix)aarch64-linux-gnu-$needle and $(prefix)$needle.
> 
> GCC searchs for $(prefix)aarch64-linux-gnu/$version/$needle,
> $(prefix)aarch64-linux-gnu/$needle and $(prefix)$needle. In practice,
> $(prefix)aarch64-linux-gnu/$needle rarely contains executables.
> 
> To better model how GCC's -B/--prefix takes in effect in practice, newer
> Clang (since
> https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90)
> only searches for $(prefix)$needle. Currently it will find /usr/bin/as
> instead of /usr/bin/aarch64-linux-gnu-as.
> 
> Set --prefix= to $(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
> (/usr/bin/aarch64-linux-gnu-) so that newer Clang can find the
> appropriate cross compiling GNU as (when -no-integrated-as is in
> effect).
> 
> Cc: stable@vger.kernel.org
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Fangrui Song <maskray@google.com>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1099
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> 
> diff --git a/Makefile b/Makefile
> index 676f1cfb1d56..9d9d4166c0be 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -567,7 +567,7 @@ ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
>  ifneq ($(CROSS_COMPILE),)
>  CLANG_FLAGS	+= --target=$(notdir $(CROSS_COMPILE:%-=%))
>  GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)elfedit))
> -CLANG_FLAGS	+= --prefix=$(GCC_TOOLCHAIN_DIR)
> +CLANG_FLAGS	+= --prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
>  GCC_TOOLCHAIN	:= $(realpath $(GCC_TOOLCHAIN_DIR)/..)
>  endif
>  ifneq ($(GCC_TOOLCHAIN),)
> 

Patch attached.

Cheers,
Nathan

--Qxx1br4bt0+wmkIi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-Makefile-Fix-GCC_TOOLCHAIN_DIR-prefix-for-Clang-cros.patch"

From daab2c7d8578f450e6f96b72f01c85abcb46e525 Mon Sep 17 00:00:00 2001
From: Fangrui Song <maskray@google.com>
Date: Tue, 21 Jul 2020 10:31:23 -0700
Subject: [PATCH 4.4] Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross
 compilation

commit ca9b31f6bb9c6aa9b4e5f0792f39a97bbffb8c51 upstream.

When CROSS_COMPILE is set (e.g. aarch64-linux-gnu-), if
$(CROSS_COMPILE)elfedit is found at /usr/bin/aarch64-linux-gnu-elfedit,
GCC_TOOLCHAIN_DIR will be set to /usr/bin/.  --prefix= will be set to
/usr/bin/ and Clang as of 11 will search for both
$(prefix)aarch64-linux-gnu-$needle and $(prefix)$needle.

GCC searchs for $(prefix)aarch64-linux-gnu/$version/$needle,
$(prefix)aarch64-linux-gnu/$needle and $(prefix)$needle. In practice,
$(prefix)aarch64-linux-gnu/$needle rarely contains executables.

To better model how GCC's -B/--prefix takes in effect in practice, newer
Clang (since
https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90)
only searches for $(prefix)$needle. Currently it will find /usr/bin/as
instead of /usr/bin/aarch64-linux-gnu-as.

Set --prefix= to $(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
(/usr/bin/aarch64-linux-gnu-) so that newer Clang can find the
appropriate cross compiling GNU as (when -no-integrated-as is in
effect).

Cc: stable@vger.kernel.org
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Fangrui Song <maskray@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1099
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
[nc: Adjust context, CLANG_FLAGS does not exist in 4.4]
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 46178c83906c..de97963888fc 100644
--- a/Makefile
+++ b/Makefile
@@ -607,7 +607,7 @@ ifeq ($(cc-name),clang)
 ifneq ($(CROSS_COMPILE),)
 CLANG_TARGET	:= --target=$(notdir $(CROSS_COMPILE:%-=%))
 GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)elfedit))
-CLANG_PREFIX	:= --prefix=$(GCC_TOOLCHAIN_DIR)
+CLANG_PREFIX	:= --prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
 GCC_TOOLCHAIN	:= $(realpath $(GCC_TOOLCHAIN_DIR)/..)
 endif
 ifneq ($(GCC_TOOLCHAIN),)

base-commit: 554bbfc0d87fcbc842a18997c2a11a772dc3f003
-- 
2.28.0.rc1


--Qxx1br4bt0+wmkIi--
