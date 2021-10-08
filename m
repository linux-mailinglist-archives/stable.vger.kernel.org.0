Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE914272F6
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 23:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243192AbhJHVUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 17:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhJHVUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 17:20:44 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4F7C061570
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 14:18:48 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cs11-20020a17090af50b00b0019fe3df3dddso7800947pjb.0
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 14:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rHy4HvfxK920/DAzRQ2LEGB6EW308Wa/3xEBO3I3ZhE=;
        b=BhVVj3vKt/JTppbgAK2mAsECRb50DXsS6r6M65L9zK/mN6kuIBXR6Buqs3rERRipGg
         1fFkRryHhsSY6tHK3Na1GTCd6pXVcac06u0Oi8e9R8Y/sXRYy7YNOsnPYVgk2OqMOeIz
         29j82p/ttntW9wToU6jvggtbtH4TaDHv5o6HA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rHy4HvfxK920/DAzRQ2LEGB6EW308Wa/3xEBO3I3ZhE=;
        b=GBwcv+O6j03LqlJS0T2Nld+LfzFaQsiOAXGxjMM75l/HSHaej1g4//iM/UuxBxcxNZ
         8Ns9N7UEobG9dHbALeAvk0S9ySMrM1BMjtlRbL5U1MS5XGoUi027bh6yGsDAdQb/z+4I
         TVZedIEkKrKokpNJZ5wTeIBApQfrUAS/IZdnm8mkmsUXfTfMEPgVco1R6UWuiC/eOtQe
         aIiFscA8ghzcmv1YKOYFhExX9TSIxd01bnII/c59MnRgPw2zz/IpOSpSqmHdpGHQM7ev
         kj73oYOMp/RT37XsAaFDtzJQ1KW4PXr0XmRSsvkMEWNejcWYkWiLqZemnkMVNgmi5ayg
         KamA==
X-Gm-Message-State: AOAM533E+mux92JrUZ2CE2SgkcoKWHVT61h6i+FSDpzv3v59FIg0gZct
        F91700f8w0Vr5ITmfT21FIax3g==
X-Google-Smtp-Source: ABdhPJyv4C5+P+SgYIf226CgVLrqAnPgnVXY5QUVMiim6AYeLnzTfC3cD84QYWdFL1q3lMAKjijtkw==
X-Received: by 2002:a17:902:ea05:b0:13f:4b5:cda2 with SMTP id s5-20020a170902ea0500b0013f04b5cda2mr11620979plg.86.1633727928442;
        Fri, 08 Oct 2021 14:18:48 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n1sm228706pfo.116.2021.10.08.14.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 14:18:47 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] lkdtm: Fix content of section containing lkdtm_rodata_do_nothing()
Date:   Fri,  8 Oct 2021 14:17:49 -0700
Message-Id: <163372786562.2954264.14524923434528443035.b4-ty@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <8900731fbc05fb8b0de18af7133a8fc07c3c53a1.1633712176.git.christophe.leroy@csgroup.eu>
References: <8900731fbc05fb8b0de18af7133a8fc07c3c53a1.1633712176.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 8 Oct 2021 18:58:40 +0200, Christophe Leroy wrote:
> On a kernel without CONFIG_STRICT_KERNEL_RWX, running EXEC_RODATA
> test leads to "Illegal instruction" failure.
> 
> Looking at the content of rodata_objcopy.o, we see that the
> function content zeroes only:
> 
> 	Disassembly of section .rodata:
> 
> [...]

Applied to for-next/lkdtm, thanks!

[1/1] lkdtm: Fix content of section containing lkdtm_rodata_do_nothing()
      https://git.kernel.org/kees/c/19c3069c5f5f

Also, can you take a moment and get "patatt" set up[1] for signing your
patches? I would appreciate that since b4 yells at me when patches aren't
signed. :)

-Kees

[1] https://github.com/mricon/patatt

-- 
Kees Cook

