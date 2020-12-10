Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33A52D69B1
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394025AbgLJVYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390277AbgLJVYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:24:24 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F80C061793
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:23:44 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id c12so5335530pfo.10
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=N8l4WOGf0AE290AqR90NHKz2nZ7//k75F9W9fLOfN6M=;
        b=qxjx02I3QhS8KruRibVH7Jn5mKd7eeoQrOpe+VBIixgZBeS4hUZJq3Yo7npqB03l6E
         Uuq+0QhUW8pVv3Q4gUbdXDyF85EwDRb6LnCJ9e4Kp1NsXfgIExnRO5KGhwbsX6Zz8bWL
         5XMFfm2yPU08STApk9VY8lZ36bSm6teRdUeDt8koAaYf7gGN0edRLk+gyHEmgXRfEtf0
         vO0hbwz0XisUYo9dckbecMyTZZqq8bSvBKpMmyU2AHNMCMvmJE7xYbZlwLhWwyIoFq2x
         m9Mn0QpEketfalZcVTcj/VENaFjS94HZKxALoo1B0W2VtbumT8iXijGaXPQy/YP85Jb4
         zmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=N8l4WOGf0AE290AqR90NHKz2nZ7//k75F9W9fLOfN6M=;
        b=Zv7VR9AAXS4FhtHJPh5yPnLyjZq363hVX7IzWMuIGq2grEzJZ99yrOYsKX4Fj2kjNM
         mwpTFatKsymSnKIrXivWwBuBvAUlQJyCEDHFSn3wcbZ1B7WgjkpDfxIdA7lZXN/I9oRy
         b6PfOVzMkm2yHTNpiFcA/9PvkvZKHFtGGKDQVrZ1lZ8mN5C0C/2zkSGMNjZUzka+o+Mr
         01CyRvXNIy1YYYycXN2NUR+Qugl+2oZkhEzBYDa5HzvKX6P7OY+LY/mv9MjoFHOhHwja
         LuXGkjhE2p9gWFxE2/KILz9JHJaUzASpBxs51ADQi7eeAiPxxv72gDPvEkZ/bxS4qvEC
         qiEw==
X-Gm-Message-State: AOAM531ni96l+5O3cA73TgKwB5V/KRlfTYiiBaHq3HFILEuiroobS33Y
        GGJLvMxYkV1h1PMzVTaS9wwPvEj3gTJuF2gapv2J301o5w5rLQ==
X-Received: by 2002:a63:2242:: with SMTP id t2mt7765130pgm.428.1607635422943;
 Thu, 10 Dec 2020 13:23:42 -0800 (PST)
MIME-Version: 1.0
References: <160750466162135@kroah.com>
In-Reply-To: <160750466162135@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 10 Dec 2020 13:23:31 -0800
Message-ID: <CAKwvOdmemyowq_o39hiDL0-f++n0CFyyPshFT0hemOE42uZs9A@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] Kbuild: do not emit debug info for
 assembly with LLVM_IAS=1" failed to apply to 5.4-stable tree
Cc:     Dmitry Golovin <dima@golovin.in>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Fangrui Song <maskray@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 9, 2020 at 1:03 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Cross referencing the thread where manual backports were provided:
https://lore.kernel.org/stable/CAKwvOdnGDHn+Y+g5AsKvOFiuF7iVAJ8+x53SgWxH9ejqEZwY9w@mail.gmail.com/
Sorry for the noise.

>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From b8a9092330da2030496ff357272f342eb970d51b Mon Sep 17 00:00:00 2001
> From: Nick Desaulniers <ndesaulniers@google.com>
> Date: Mon, 9 Nov 2020 10:35:28 -0800
> Subject: [PATCH] Kbuild: do not emit debug info for assembly with LLVM_IAS=1
>
> Clang's integrated assembler produces the warning for assembly files:
>
> warning: DWARF2 only supports one section per compilation unit
>
> If -Wa,-gdwarf-* is unspecified, then debug info is not emitted for
> assembly sources (it is still emitted for C sources).  This will be
> re-enabled for newer DWARF versions in a follow up patch.
>
> Enables defconfig+CONFIG_DEBUG_INFO to build cleanly with
> LLVM=1 LLVM_IAS=1 for x86_64 and arm64.
>
> Cc: <stable@vger.kernel.org>
> Link: https://github.com/ClangBuiltLinux/linux/issues/716
> Reported-by: Dmitry Golovin <dima@golovin.in>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Suggested-by: Dmitry Golovin <dima@golovin.in>
> Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
> Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
> Reviewed-by: Fangrui Song <maskray@google.com>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>
> diff --git a/Makefile b/Makefile
> index 87d659d3c8de..ae1592c1f5d6 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -828,7 +828,9 @@ else
>  DEBUG_CFLAGS   += -g
>  endif
>
> +ifneq ($(LLVM_IAS),1)
>  KBUILD_AFLAGS  += -Wa,-gdwarf-2
> +endif
>
>  ifdef CONFIG_DEBUG_INFO_DWARF4
>  DEBUG_CFLAGS   += -gdwarf-4
>


-- 
Thanks,
~Nick Desaulniers
