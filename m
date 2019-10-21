Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48CE9DE452
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 08:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfJUGIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 02:08:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35567 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfJUGIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 02:08:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id 14so4757454wmu.0
        for <stable@vger.kernel.org>; Sun, 20 Oct 2019 23:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4/kY4Iuh46NZmdPYDysMt8pq2ZGIAr2/rIRYTWprc/0=;
        b=oB1t6MTnzf47Ko9MJt4hXHXmaNHS2l9pnu0h4fYYHPxKIGDHcsgPdVyoo/NsSbv1O2
         uCTLW6kDH+oaDa+OMJSo40Otaxe8aaCJyyKm9bN3s9j4EHVixD6E9soNlalXtzJTWADB
         DJAKX4ZjYEgZQhvNbjmZOLQGmhA8Tfzz55vmJQ2/davbZjC6n55rh+rbvIs7L5/4FTeh
         v8rUweDQ7PsWfJKC1LWaVdS5zxkjcbVH9fZsEzb+BaiK8YYGPR1pSrYpSBoj+M+uiEAl
         Gg2xxpmKbyh4ZnDMCR1dI6pO2bfUnkE9t5szRJWG2hWKS4uYzRdfRc2y2t5fUGvCStDh
         /nlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4/kY4Iuh46NZmdPYDysMt8pq2ZGIAr2/rIRYTWprc/0=;
        b=CtP66oUAyza0Dcg2wnMmDCXd/M6HxV7UWOYZAt1onrWvpl9cOrM5zYOWBMbQd+5a62
         2dak8EIcLRs+1bA9zGP2GDgz9Rwjbf5SCwiSFj4vZyLh7HSzO3DSTA9xrhX6xH5XqkFR
         fHL7+mOkGLQGdKQW7kP5TuvIM3bZoEo89+FVJxmX/dyf+6RTL5b3+LI86lWhBK67hYQG
         yyTOoKdkKwFymYIYBT0H5osPFsjYx1tR+DNRfqBYuN2gV+u7WEl47fb6VxQB1Ey2KnXh
         O5hTy9+KtGlKpIjmeD0Hknq1fs4Jn77/e5IGirLqhEbSWmPDfx4mweuFiqgJEflqu/l5
         KScg==
X-Gm-Message-State: APjAAAXFvGpw48WDROvM/PnoQLY5Y+9a285aHWggByxkhZlrvlFieBt+
        ZTyLQgWR2ZYyOT9qw1bpiagSRsZoFc19crunkUijQg==
X-Google-Smtp-Source: APXvYqx7XQxrLMJoK6NNdCUXziFruma0esfovBxJGHOWgCA/3qMDBV1vUmG67RGywQZI7SPK2OszFu1whjLRm3Zdceg=
X-Received: by 2002:a7b:cb54:: with SMTP id v20mr16697896wmj.119.1571638093988;
 Sun, 20 Oct 2019 23:08:13 -0700 (PDT)
MIME-Version: 1.0
References: <20191018220525.9042-1-sashal@kernel.org> <20191018220525.9042-63-sashal@kernel.org>
In-Reply-To: <20191018220525.9042-63-sashal@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 21 Oct 2019 08:08:02 +0200
Message-ID: <CAKv+Gu_6vzE-Je4G-ZZ=jU1qAWnCcADr7cJ_MG8m+tPzcC0QBw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 063/100] crypto: arm/aes-ce - add dependency
 on AES library
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 19 Oct 2019 at 00:07, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> [ Upstream commit f703964fc66804e6049f2670fc11045aa8359b1a ]
>
> The ARM accelerated AES driver depends on the new AES library for
> its non-SIMD fallback so express this in its Kconfig declaration.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please drop this, it doesn't belong in -stable.

> ---
>  arch/arm/crypto/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
> index b8e69fe282b8d..44278f375ae23 100644
> --- a/arch/arm/crypto/Kconfig
> +++ b/arch/arm/crypto/Kconfig
> @@ -89,6 +89,7 @@ config CRYPTO_AES_ARM_CE
>         tristate "Accelerated AES using ARMv8 Crypto Extensions"
>         depends on KERNEL_MODE_NEON
>         select CRYPTO_BLKCIPHER
> +       select CRYPTO_LIB_AES
>         select CRYPTO_SIMD
>         help
>           Use an implementation of AES in CBC, CTR and XTS modes that uses
> --
> 2.20.1
>
