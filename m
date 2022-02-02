Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8D04A6CB8
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 09:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbiBBIM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 03:12:26 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:34479 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiBBIMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 03:12:25 -0500
Received: from mail-ot1-f41.google.com ([209.85.210.41]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MmCyE-1mXHHE0ruy-00i8zw; Wed, 02 Feb 2022 09:12:24 +0100
Received: by mail-ot1-f41.google.com with SMTP id g15-20020a9d6b0f000000b005a062b0dc12so18723093otp.4;
        Wed, 02 Feb 2022 00:12:23 -0800 (PST)
X-Gm-Message-State: AOAM531LUQ2yq1oT+wq/HOQMYue3ShWOE012LvyObfdhRIgkGCEilCj3
        O12ZoXx2QDnsq4wcjd5YVk0XWEceu3LcjvRAu1c=
X-Google-Smtp-Source: ABdhPJyEFkk72bdUObGJgIJxLDuxts5d7uWNZdnao0zPMQMtv0LI7rheA2HGG79b1fevO/Ddwrj5pRSA5+k2nVrxNQw=
X-Received: by 2002:a9d:654f:: with SMTP id q15mr16551925otl.119.1643789542701;
 Wed, 02 Feb 2022 00:12:22 -0800 (PST)
MIME-Version: 1.0
References: <20220201232229.2992968-1-nathan@kernel.org>
In-Reply-To: <20220201232229.2992968-1-nathan@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 2 Feb 2022 09:12:06 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2Y8nQ55sycxbpfN=71BNO9wuEDt=Q24ELS_u_WNRpqZw@mail.gmail.com>
Message-ID: <CAK8P3a2Y8nQ55sycxbpfN=71BNO9wuEDt=Q24ELS_u_WNRpqZw@mail.gmail.com>
Subject: Re: [PATCH] Makefile.extrawarn: Move -Wunaligned-access to W=2
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev, "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:mt6tbiBySZHfkxm45G7nxfsst3aa9Qkpr11AXBACtiMx6RWuAA8
 g1nSh7H8TEVnHQeqiFAOJdkbI+I5VrlZSWIB6r+WbESRKD59YIrisvNmbXTgqwMxyiE5oK+
 Ilq8Q1mMoCbX8OJnwBH9C7jjj6ewSOXA5BHUuTZ6l2NlmFmraMRxAyPgPdthKeuKNRcVlSn
 QHwE39GrKMy7j9qttHUxg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kqe6ME5tNYg=:cBHBgE5qbSlhnrADEmCA7v
 SOJZETRaMq/uLBzMqmk9PdZs8NyHbxxAm3XH//7B2r9zTJ7T1bqe+QyZctVF6iT4FVfjeSlgm
 aF5RAXxpMEf5DzPEG0nusfWPX5ge3/pkbgzkNkmm3TByWOJPxjJNvG+KDQCcwk3MHFqw2brMq
 LYoUaduUocOXUvP94pPqsSwlCITM9ggqa6iSR3iuIFIZFG8E8CKiv2cNo4nnOByRjROtzmQ5T
 jtAbwcPRX3J7FjB5782BxhPxCsB7hnTvoG8D3STYxSuTn1YBhTYeeAe5XzpgAtzdRDHC370gP
 tLwSDcnl0UiZ02NaykRMv/gzZQ349G4ljEQhmYOhDe5sZYtHZexPCWkHlBrcRi/bWea/Ak9gv
 r0AbeQOuqdvTikSUkGAaObvPGIQLzDmwMB5HlNX3uEIPBuPXdHXjbTvo4sw4tkTT43yXojxxP
 9itjVFKb3rM7zpepjg02B1/FZgMz0yVQdH6HpVWJ7NSIb1f4XToSfYvNwJq0tHB4ei3SmIcmG
 5UrN1i4ok+shUkHare7+5LJrLaBUgZK3sJALlw24E2o6zwEdx8aUbEYlsrMlR1rpK9uPVChGz
 dDXYNOwoos1Pzo9SXK6vyPb3KWj0ArZccHBjreB6lDI/+8ENNYnvdOjPagAguGZwqHp2oTHv7
 4sE8m6acPBcxrIvxxlTvRPgvAuyqRv/os/n9n7zL6dYow+fGksoDsPb0eUoocUAK/mW2p/jRc
 cQ0UXlK1AVrxaUWdrJVvDBVKR4/F8gXTuPgrfCzig6bacje/Qe5XrYnWfkQFAKGTOJsUV+GyF
 JLzz6tYayun4NT4bQeVY3MSK85DyY9pqmrO7b3hbHdXOustwV4=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 2, 2022 at 12:22 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> -Wunaligned-access is a new warning in clang that is default enabled for
> arm and arm64 under certain circumstances within the clang frontend (see
> LLVM commit below). Under an ARCH=arm allmodconfig, there are
> 1284 total/70 unique instances of this warning (most of the instances
> are in header files), which is quite noisy.
>
> To keep the build green through CONFIG_WERROR, only allow this warning
> with W=2, which seems appropriate according to its description:
> "warnings which occur quite often but may still be relevant".
>
> This intentionally does not use the -Wno-... + -W... pattern that the
> rest of the Makefile does because this warning is not enabled for
> anything other than certain arm and arm64 configurations within clang so
> it should only be "not disabled", rather than explicitly enabled, so
> that other architectures are not disturbed by the warning.
>
> Cc: stable@vger.kernel.org
> Link: https://github.com/llvm/llvm-project/commit/35737df4dcd28534bd3090157c224c19b501278a
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

The warning seems important enough to be considered for W=1 on 32-bit arm,
otherwise the chances of anyone actually fixing drivers for it is
relatively slim.
Can you point post the (sufficiently trimmed) output that you get with
the warning
enabled in an allmodconfig build?

I'm not sure why this is enabled by default for arm64, which does not have
the problem with fixup handlers.

       Arnd
