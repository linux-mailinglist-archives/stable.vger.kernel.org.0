Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5AE3703AF
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 00:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhD3WuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 18:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhD3WuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 18:50:03 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90305C06138B
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 15:49:14 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id z13so31431172lft.1
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 15:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iDj/KqljFidoYmUB3JwJD5XIMfVHo2ILy+QB0Z4+7eY=;
        b=Hdkd+OSzAEW5kG/LYPVp9EWvvnwA2RN6Zcf57KQxFF0bLBLXPESKJS049xblm7jeMT
         P9ad+q7y1qPiqnStuvGV02DOckOp2WORBpSUYodQ5FUg+S/bj2AIRvQMtJ6GqHPh1lOc
         8WHv7ObX+EvIy/BAkLgIcbEoDj/DcCZ0/yHq3g7WqTJORopr6+IOwEwylce/YkEwrQ/e
         KqwoDBr4d6QCwGoVs02Bon9aBUaRh2fhFJrBYoo0guOrgodpRUEzt9PK/gECsDMy8IxA
         wxRYTIXbDLb+8HwzUilL5s1OkZyJw9FfEeFL3PAM1MhGr93iUtBGTHocxGWlEpvp85OB
         4Yjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iDj/KqljFidoYmUB3JwJD5XIMfVHo2ILy+QB0Z4+7eY=;
        b=TO+D346Jcgwo/P74VHbqc7laoP14GoOb1Hi3UVFMPbZLekugUn2pnkaLsxfovZ7zAo
         35GJo1731+eonmcHFKCe0MfkmCuFEy0NlcsKSFVWNlM5kHjyN7yROt2CHG0k64/98jgm
         9AyU3SeFBXtWMQHSLHgk0XfOHjdkC8xAhuZoOANzxCFAiS2UeN1KvbK1m1ZjNqJEKdFy
         Ll/nkdSh2u9izI/H8WLH5Fu2lFyGOvKAxqQ6EKzfzE3no63dPXAvciXmDd44Ld1cVz85
         ULIehjujKu4mlH4uLLlW0qVs0M7GQPQ/IENCdB8Vt1IDIbn8E3wJDizs5Lv1/vgldzgI
         vH0w==
X-Gm-Message-State: AOAM531b/zow0FTC13Mclb+WiDyC4eU3mAyZF8Yaw++oJmg0595dhRKg
        GZQmOD90uHaSremHWl5onkXDt4g4+blt5Xkgo2ZEiQ==
X-Google-Smtp-Source: ABdhPJywWmeJ2QmLmmKiD5eZ7WjRzX8EqYzEBw8K21R8QXzgYftmJURNZ0tjHvWjnKYgivNjQo7Z1wuvpbmKD0HDKHA=
X-Received: by 2002:a05:6512:2190:: with SMTP id b16mr4831831lft.122.1619822952803;
 Fri, 30 Apr 2021 15:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210429012350.600951-1-nathan@kernel.org>
In-Reply-To: <20210429012350.600951-1-nathan@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 30 Apr 2021 15:49:00 -0700
Message-ID: <CAKwvOdkXBY_5goFo_DvbuaDNE=vcXxXYsw6tJGy4ZBRySW9_oA@mail.gmail.com>
Subject: Re: [PATCH] Makefile: Move -Wno-unused-but-set-variable out of GCC
 only block
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>, Jian Cai <jiancai@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 28, 2021 at 6:24 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Currently, -Wunused-but-set-variable is only supported by GCC so it is
> disabled unconditionally in a GCC only block (it is enabled with W=1).
> clang currently has its implementation for this warning in review so
> preemptively move this statement out of the GCC only block and wrap it
> with cc-disable-warning so that both compilers function the same.
>
> Cc: stable@vger.kernel.org
> Link: https://reviews.llvm.org/D100581

Thanks for the patch.

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>

(That's actually one of Jian's teammates working on implementing that
warning).  Tested with https://reviews.llvm.org/D100581 applied, which
I do fully expect to land in LLVM soon.

> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  Makefile | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index f03888cdba4e..911d839cfea8 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -775,16 +775,16 @@ KBUILD_CFLAGS += -Wno-gnu
>  KBUILD_CFLAGS += -mno-global-merge
>  else
>
> -# These warnings generated too much noise in a regular build.
> -# Use make W=1 to enable them (see scripts/Makefile.extrawarn)
> -KBUILD_CFLAGS += -Wno-unused-but-set-variable
> -
>  # Warn about unmarked fall-throughs in switch statement.
>  # Disabled for clang while comment to attribute conversion happens and
>  # https://github.com/ClangBuiltLinux/linux/issues/636 is discussed.
>  KBUILD_CFLAGS += $(call cc-option,-Wimplicit-fallthrough,)
>  endif
>
> +# These warnings generated too much noise in a regular build.
> +# Use make W=1 to enable them (see scripts/Makefile.extrawarn)
> +KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
> +
>  KBUILD_CFLAGS += $(call cc-disable-warning, unused-const-variable)
>  ifdef CONFIG_FRAME_POINTER
>  KBUILD_CFLAGS  += -fno-omit-frame-pointer -fno-optimize-sibling-calls
>
> base-commit: d8201efe75e13146ebde433745c7920e15593baf
> --
> 2.31.1.362.g311531c9de
>
> --

-- 
Thanks,
~Nick Desaulniers
