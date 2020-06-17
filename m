Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56AC1FD72C
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 23:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgFQV1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 17:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgFQV1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 17:27:09 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61857C061755
        for <stable@vger.kernel.org>; Wed, 17 Jun 2020 14:27:09 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s135so1913883pgs.2
        for <stable@vger.kernel.org>; Wed, 17 Jun 2020 14:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2nweBLFqBZAQdpGCmNWKSAsTxcg83keuNMEngTx9xf4=;
        b=iS5qr4j2jYfHzGGbhesyIJUTnsGRa9IuN+Jl4fPLDGmN8Gke6H88DdYjKDHwrWfEf1
         /juIa85YnrqZffvIfhiCjYqxxxAIkDfxVWShz0uKUrVPf/7IsN76HMeksxs//UhpzeGK
         TmNk1sEkVyNbwZ4I2Sqdw7gfzZLCpugvbg4r0zmyFHpo869eLEJeZyWSPsqT8yv0K96r
         w9zTU5DHZj70u+cUsqzcVJx3Bc3SZYG/SBfcndzrRQhv6CuMwHA9NhaI8lss21I1BOgV
         RJw0PmOazu4zptp4cPhneUrJXlLBGHLgvAQLt5xApO6v/359aVgyNfiQDi39AXVKNSWW
         LZxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2nweBLFqBZAQdpGCmNWKSAsTxcg83keuNMEngTx9xf4=;
        b=C6mfem3Xfj+ycv06RhS6k05oFsGm++lK+i/QcpbTQrJ8lRKX9Pt4Nrx0znpPBXVDdN
         QlDf/8wrMYH7hSipNrKt1mPDKWOijCJDlgz3bCeFwkPCdfBs2ZawTKiDiYdCPBtPhVG1
         Y0nmHkhfS47G7aKoR6IYAaS5NTBNBlALMzX+xe5M75BshkQFlB0C7p0vkmXrLnejwFXF
         2uQWRCofMNBcN5KzFZ70cBA/KRAP/chxcjwinNT91Vvg80TKH2gDxmNn3Z5zgm++M63l
         HAuYAk6Dv4lkGN7NwdJ5XGCwLrMMHcThzfv9LEKmFXgKqkYNGmUfvYu3yczTTGSUaiE9
         8YvA==
X-Gm-Message-State: AOAM531VIMKZ7Nwyp3ceU6qXhvldj2zJYAqS6/asY7oKJLWXv5LomAGi
        yujmIS88q8kNbl+0W3pUVn8vxA==
X-Google-Smtp-Source: ABdhPJxYyUBYE6IphPAEyvDdCsWndemGsGv25bBXi+wuKSeSYT+KvkLCOsnLwdE99qal0DA1+G+XFg==
X-Received: by 2002:a63:5307:: with SMTP id h7mr702582pgb.28.1592429228594;
        Wed, 17 Jun 2020 14:27:08 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:0:9efe:9f1:9267:2b27])
        by smtp.gmail.com with ESMTPSA id m4sm644574pgp.32.2020.06.17.14.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 14:27:07 -0700 (PDT)
Date:   Wed, 17 Jun 2020 14:27:05 -0700
From:   =?utf-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, clang-built-linux@googlegroups.com,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Jian Cai <jiancai@google.com>,
        Luis Lozano <llozano@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vmlinux.lds: consider .text.{hot|unlikely}.* part of
 .text too
Message-ID: <20200617212705.tq2q6bi446gydymo@google.com>
References: <20200617210613.95432-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200617210613.95432-1-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2020-06-17, Nick Desaulniers wrote:
>ld.bfd's internal linker script considers .text.hot AND .text.hot.* to
>be part of .text, as well as .text.unlikely and .text.unlikely.*.

>ld.lld will produce .text.hot.*/.text.unlikely.* sections.

Correction to this sentence. lld is not relevant here.

-ffunction-sections combined with profile-guided optimization can
produce .text.hot.* .text.unlikely.* sections.  Newer clang may produce
.text.hot. .text.unlikely. (without suffix, but with a trailing dot)
when -fno-unique-section-names is specified, as an optimization to make
.strtab smaller.

We've already seen that GCC can place main in .text.startup without
-ffunction-sections. There may be other non -ffunction-sections cases
for .text.hot.* or .text.unlikely.*. So it is definitely a good idea to
be more specific even if we don't care about -ffunction-sections for
now.

>Make sure to group these together.  Otherwise these orphan sections may
>be placed outside of the the _stext/_etext boundaries.
>
>Cc: stable@vger.kernel.org
>Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commitdiff;h=add44f8d5c5c05e08b11e033127a744d61c26aee
>Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commitdiff;h=1de778ed23ce7492c523d5850c6c6dbb34152655
>Link: https://reviews.llvm.org/D79600
>Reported-by: Jian Cai <jiancai@google.com>
>Debugged-by: Luis Lozano <llozano@google.com>
>Suggested-by: Fāng-ruì Sòng <maskray@google.com>
>Tested-by: Luis Lozano <llozano@google.com>
>Tested-by: Manoj Gupta <manojgupta@google.com>
>Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
>---
> include/asm-generic/vmlinux.lds.h | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>index d7c7c7f36c4a..fe5aaef169e3 100644
>--- a/include/asm-generic/vmlinux.lds.h
>+++ b/include/asm-generic/vmlinux.lds.h
>@@ -560,7 +560,9 @@
>  */
> #define TEXT_TEXT							\
> 		ALIGN_FUNCTION();					\
>-		*(.text.hot TEXT_MAIN .text.fixup .text.unlikely)	\
>+		*(.text.hot .text.hot.*)				\
>+		*(TEXT_MAIN .text.fixup)				\
>+		*(.text.unlikely .text.unlikely.*)			\
> 		NOINSTR_TEXT						\
> 		*(.text..refcount)					\
> 		*(.ref.text)						\
>-- 
>2.27.0.290.gba653c62da-goog
>
