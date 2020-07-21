Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840EE228986
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 21:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbgGUTyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 15:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728683AbgGUTyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 15:54:45 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7BBC061794;
        Tue, 21 Jul 2020 12:54:45 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t18so17484818ilh.2;
        Tue, 21 Jul 2020 12:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=iseUsb4cwqFRjmEUZSESf/WmYPRnoCDuuKRyDEs9PoA=;
        b=SenRoNEMiots8jEaKK0lgPbkx6jsvSyCzBfJzL/ibpa1bSd3B735SQ9uwjkrtV0adN
         l4CKmFsuVAs1YML/DexjReCUFTlxH4w0WbvtU0iEtU865GcNwdqYwMmlTu/XHqPKrCsr
         S1c6CpICb/yZd4W5IHK5E2SdVn9bWUWuKN11iwm5SWc0yXAS8+aRwRcKXOnrwFeOG1JD
         YM/YtWjR6/j36XYMQoOg+8cAOLBHwtpqxGz+lscASuU8ngWBvDY8dvZg7dts7saQmt1g
         AYcs9IwwYDrk8mhpb5x4T+nvHzLYm77xkUOgC6TNesAmMWk82NpASIAT468q1D+F4A0N
         lzvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=iseUsb4cwqFRjmEUZSESf/WmYPRnoCDuuKRyDEs9PoA=;
        b=rytEMGnERmaOP6NEA8ZoVLeVw57jj29RKN2UGcbOwIeOJKPwUEUj7nHUNt7K9MF3ba
         KyeThaOcjzzL8SV0sBYf0xBKicAe1Co/Ol2B8EfKBPAIB9s0Uyaz6IQhuHcNQ6n3Ccdw
         oFzQ9gpj9mWTczr4XRX7YOZuCMXjwbnRCEexwbPLPy3AqNYzpevQcWxRqgLz11DVVESe
         oDHjj81YHdWJ+B/tcyoxjJfNfIIRUJo7DOV/ywujyfMl395B2tRWSaeC/vXjlHVfMvbq
         D60hAZovLsytWwsW3aRQYf1rBx4Cei5uqQqXBATJ0j2D3/57z6JVqG0IFBP58uLjVijQ
         s9DA==
X-Gm-Message-State: AOAM531HxkrixLpo8MbOcZAD0gVNkgXXbRbU9m50wRLYSqleyKpoUz+J
        vzEZjlXsk+mSZqDsiGMUi+KKmvWpCQnshueP6js=
X-Google-Smtp-Source: ABdhPJxtro6L/mmZCFmnlQFdDMRf/sv/H0msP9fG8u/lWygvyq5Sr6L0XiZeKRoFTgHlstL3iaGrVobxkbpQTOqBzH0=
X-Received: by 2002:a92:d843:: with SMTP id h3mr31183810ilq.255.1595361284863;
 Tue, 21 Jul 2020 12:54:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200721041940.4029552-1-maskray@google.com>
In-Reply-To: <20200721041940.4029552-1-maskray@google.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 21 Jul 2020 21:54:33 +0200
Message-ID: <CA+icZUU1npgQEp9-CK67ZnUQHapW9Q1xtsh2Sqtkup08MaKCyQ@mail.gmail.com>
Subject: Re: [PATCH v2] Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross compilation
To:     Fangrui Song <maskray@google.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        stable@vger.kernel.org, Jian Cai <jiancai@google.com>,
        Bill Wendling <morbo@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 6:20 AM 'Fangrui Song' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
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
> Set --prefix= to $(GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE)
> (/usr/bin/aarch64-linux-gnu-) so that newer Clang can find the
> appropriate cross compiling GNU as (when -no-integrated-as is in
> effect).
>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Fangrui Song <maskray@google.com>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1099
> ---
> Changes in v2:
> * Updated description to add tags and the llvm-project commit link.
> * Fixed a typo.

Tested-by: Sedat Dilek <sedat.dilek@gmail,com>

- Sedat -

> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index 0b5f8538bde5..3ac83e375b61 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -567,7 +567,7 @@ ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
>  ifneq ($(CROSS_COMPILE),)
>  CLANG_FLAGS    += --target=$(notdir $(CROSS_COMPILE:%-=%))
>  GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)elfedit))
> -CLANG_FLAGS    += --prefix=$(GCC_TOOLCHAIN_DIR)
> +CLANG_FLAGS    += --prefix=$(GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE)
>  GCC_TOOLCHAIN  := $(realpath $(GCC_TOOLCHAIN_DIR)/..)
>  endif
>  ifneq ($(GCC_TOOLCHAIN),)
> --
> 2.28.0.rc0.105.gf9edc3c819-goog
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200721041940.4029552-1-maskray%40google.com.
