Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80CF1585E70
	for <lists+stable@lfdr.de>; Sun, 31 Jul 2022 12:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiGaKRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 06:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiGaKRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 06:17:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A87EE0D
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 03:17:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C09260BA4
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 10:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1185C43141
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 10:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659262672;
        bh=3V+zkEH2kj0uyLD0Zf4fmZ2Pg+4GGAv1pnjj3naBw9A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tRHIUHF5bXYZtdJQhdHYrL456og93A8Z/M61DgkiABd6xM4YnrzLU62GhttUTLW6o
         CbYDJHUzEpw9xAa+LgimXCSY/C3Vg4DyfSL9GZKCn96z+5mAlUhktUAlInRW9FyuNP
         GD2ghAq8XWwxEDdwyoC15BdylhEVInXL/39YFxI11GvWTont2euZzHuBdC9bhwUD68
         JjN51LovpTMmPSDmrKziUSwilPwL5UMySt7ube2PVl1Y2IvrVSSPWhxbIzAHoey/Qb
         C1m8WiNVmKyQTzgEyuotGj7+lAksEuq7MMhFQSU6WyC+nX1I2Y1gz9rKgkpzCxK5Rx
         0iSkchPyWaLbA==
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-10e615a36b0so8979678fac.1
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 03:17:52 -0700 (PDT)
X-Gm-Message-State: AJIora+mcUxZSk2mhYknzL/RE9MI4rSfqVKm6lWDnLn3IeoaXoU9v8Lj
        xOwRg7JfSwro0ZKZDvxboG3Om736wGq828w4zpU=
X-Google-Smtp-Source: AGRyM1vytzxNc0fLki0AnnbT3oGQHj+ls3vhMAmzGwqvqPlZDiW8p1JkLe3Jj0h7CESA/U1IpMCD9DKVq0xeP56GM9k=
X-Received: by 2002:a05:6870:a90a:b0:10d:9e83:98a6 with SMTP id
 eq10-20020a056870a90a00b0010d9e8398a6mr5380475oab.228.1659262671811; Sun, 31
 Jul 2022 03:17:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220731100551.3679874-1-gregkh@linuxfoundation.org>
In-Reply-To: <20220731100551.3679874-1-gregkh@linuxfoundation.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 31 Jul 2022 12:17:40 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHPV-EHVQDa5hmJJAQP-dDfTgVpD6+7g65+Q9-C6xdwhg@mail.gmail.com>
Message-ID: <CAMj1kXHPV-EHVQDa5hmJJAQP-dDfTgVpD6+7g65+Q9-C6xdwhg@mail.gmail.com>
Subject: Re: [PATCH] ARM: crypto: comment out gcc warning that breaks clang builds
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Justin M. Forbes" <jforbes@fedoraproject.org>,
        Arnd Bergmann <arnd@kernel.org>,
        Nicolas Pitre <nico@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 31 Jul 2022 at 12:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> The gcc build warning prevents all clang-built kernels from working
> properly, so comment it out to fix the build.
>
> This is a -stable kernel only patch for now, it will be resolved
> differently in mainline releases in the future.
>
> Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Cc: "Justin M. Forbes" <jforbes@fedoraproject.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Arnd Bergmann <arnd@kernel.org>
> Cc: Nicolas Pitre <nico@linaro.org>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/arm/lib/xor-neon.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/lib/xor-neon.c b/arch/arm/lib/xor-neon.c
> index b99dd8e1c93f..7ba6cf826162 100644
> --- a/arch/arm/lib/xor-neon.c
> +++ b/arch/arm/lib/xor-neon.c
> @@ -26,8 +26,9 @@ MODULE_LICENSE("GPL");
>   * While older versions of GCC do not generate incorrect code, they fail to
>   * recognize the parallel nature of these functions, and emit plain ARM code,
>   * which is known to be slower than the optimized ARM code in asm-arm/xor.h.
> + *
> + * #warning This code requires at least version 4.6 of GCC
>   */
> -#warning This code requires at least version 4.6 of GCC
>  #endif
>
>  #pragma GCC diagnostic ignored "-Wunused-variable"

LGTM but doesn't Clang also complain about the GCC specific pragma?
