Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B33F217AB0
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 23:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgGGVtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 17:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728357AbgGGVtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 17:49:49 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B85CC061755
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 14:49:49 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j19so13759652pgm.11
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 14:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mpd18shi8GLEcLMxPZWWvNdFFRedl4Y7uuQSPmBzhFo=;
        b=kXnMCEke8ckvQzbnSwGYSKdBvP77PeU0ZTB8dUWQKCYfEmsKqGvVCAIFkLFUqw/J9k
         zPdyXNQfxd5evbDSecLwG7iNEVK+rkYwTE/Bx5FW1DBAZPW6/pgjeG6j1nk8racRlVeK
         F7IJi3FYMrPxxpgm8Ao9AgHxdjZ9CjEJAEof2KeYWlkD87KrCWwfRdXFO0+m0TrbZkC7
         6UZpU3xpfuhO6rrx0MoEquHkD2V6l3GYnCk58rXNBW1yzz4hLvchS44ukh0D6/51blCw
         sHCPDVqeVgzbrREIxCySaJSN1v/+mtaL19mvi9+2QJVAVsjSUQvbXxr8mjwXoy63tymT
         YvIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mpd18shi8GLEcLMxPZWWvNdFFRedl4Y7uuQSPmBzhFo=;
        b=AcYyR7cNp4pm700Y6Gn6Wy8QkGvQJABHfhl0W94Fk3Re+s3cwmwqRh1Ph/+MR8efQu
         NLV0XmMw98D3/RwrIue9Ro2izcgaGcP3aVWX7JhUkTw4cggwpqVHSv6DbFD7Bwf7K/ON
         ARRTu6Cfoww8roO1gtmxEoc5qoKZtFEkd5Pc5vu2lGg7I1monBVK9IImj04J4Ck4kT8j
         DYa4K8PKkcLv5z5iA6AANNl8MB0fbZyJho4JyUvhJYIuNAe640EzsTlCl0/aSMz1rdSA
         YhBrhXjO7EzCkpCBApJmFlqGCzQZh1tGqfgF2bxknk3JY4awg8fngyL76tdS/7JVODO1
         pOrw==
X-Gm-Message-State: AOAM530geg/xotlTgveQeYogNtDA7wlUles4H1QFclQiAdqssfcWXE8V
        eCA2qhKWDF0Bb9sgWZEClmLf+A==
X-Google-Smtp-Source: ABdhPJxeP51izVsbYdKGLkHwWWCPzaEWOyEa3CCdyZ/nZhUjxXxfcCCV2AbikppoE4JtYZqnFgHPLg==
X-Received: by 2002:a62:8489:: with SMTP id k131mr51423400pfd.4.1594158588710;
        Tue, 07 Jul 2020 14:49:48 -0700 (PDT)
Received: from google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
        by smtp.gmail.com with ESMTPSA id m16sm24965238pfd.101.2020.07.07.14.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 14:49:48 -0700 (PDT)
Date:   Tue, 7 Jul 2020 14:49:42 -0700
From:   Sami Tolvanen <samitolvanen@google.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Alex Elder <elder@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] bitfield.h: don't compile-time validate _val in FIELD_FIT
Message-ID: <20200707214942.GA1723912@google.com>
References: <20200707211642.1106946-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707211642.1106946-1-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 02:16:41PM -0700, Nick Desaulniers wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> 
> When ur_load_imm_any() is inlined into jeq_imm(), it's possible for the
> compiler to deduce a case where _val can only have the value of -1 at
> compile time. Specifically,
> 
> /* struct bpf_insn: _s32 imm */
> u64 imm = insn->imm; /* sign extend */
> if (imm >> 32) { /* non-zero only if insn->imm is negative */
>   /* inlined from ur_load_imm_any */
>   u32 __imm = imm >> 32; /* therefore, always 0xffffffff */
>   if (__builtin_constant_p(__imm) && __imm > 255)
>     compiletime_assert_XXX()
> 
> This can result in tripping a BUILD_BUG_ON() in __BF_FIELD_CHECK() that
> checks that a given value is representable in one byte (interpreted as
> unsigned).
> 
> FIELD_FIT() should return true or false at runtime for whether a value
> can fit for not. Don't break the build over a value that's too large for
> the mask. We'd prefer to keep the inlining and compiler optimizations
> though we know this case will always return false.
> 
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/kernel-hardening/CAK7LNASvb0UDJ0U5wkYYRzTAdnEs64HjXpEUL7d=V0CXiAXcNw@mail.gmail.com/
> Reported-by: Masahiro Yamada <masahiroy@kernel.org>
> Debugged-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  include/linux/bitfield.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
> index 48ea093ff04c..4e035aca6f7e 100644
> --- a/include/linux/bitfield.h
> +++ b/include/linux/bitfield.h
> @@ -77,7 +77,7 @@
>   */
>  #define FIELD_FIT(_mask, _val)						\
>  	({								\
> -		__BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_FIT: ");	\
> +		__BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_FIT: ");	\
>  		!((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)); \
>  	})
>  

I confirmied that this fixes the issue. Thanks for sending the patch!

Sami
