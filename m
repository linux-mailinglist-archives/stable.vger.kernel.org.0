Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FE12D6177
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733165AbgLJQQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 11:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391127AbgLJQNJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 11:13:09 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56021C061793
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 08:12:29 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id a6so5125379wmc.2
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 08:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OoPa7i+VjjxLCqnKVlKszdfnGOBJMF8Ur1yfeI8lT8g=;
        b=kYt9uVy8zkVSh4REB40VTCqQ+WMZGsCr7gx+E/nqPzh/Z4red+B7R8zcpBdH83/QJG
         rHJV7WzlgVE5ZYgdnbYDqn8cgJ9hmwDJ8jXAbzH9pTqPL2yC1NkJC4OyEapVOgsuqo0+
         vcwBVADEy0pY6wO4oftjVoSh6FCNbRRkFrTytgRw8++OBWi8w97OpLoVp3dRt7ffZ7kG
         d7GXP9M89b75fI+9oYJbcylWUmnaHI0MuY1fYwM5RYqFCIhOj7gcfL1AyHiMq4Eg8eZn
         D/WVLUqB0UFja6YaJ2XQaDPVPzTr17G6daP1S/z1YW+juaO1Z8bfnasIqYXmOLd2OwTv
         dWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OoPa7i+VjjxLCqnKVlKszdfnGOBJMF8Ur1yfeI8lT8g=;
        b=dMCV+PAf82/OZUS0lYA/Zis3vvbod6KhfE6uAnt4Mwt4wFywl//uJTj0Nxvmd0qOpw
         XqbE/2d2/f5W4Y+uQrEBy7A0VyW4DpDa5H/nivtMT6IZi91tBJGohYcnV24hE0KVtEbL
         GYuL3i6qUs7neV1behrL/noKcfkBaWyc9IDo86714Hjmb4r06MpbdT9I6dqprSRLkGxT
         TLYP1cnwLDM6SXTKS92Xlxf5Zdv1fdvIOQ0+u/ogw+KgGcLIvz+wGH4j36KVm1ILAaKC
         EpvS6Tz3w4cfj5qzyxTxlmC4x/Z00NRbskJ/DHjlQNSnXHBOptS14TxwCUhM3xEGnpHB
         y8/A==
X-Gm-Message-State: AOAM532tyzP7NZQthIf49o+b6eWYgVjjXTus2SEU1tooqn5MSYJNhSda
        mn5GJod00VI5+lFpPvYRWnyXKw==
X-Google-Smtp-Source: ABdhPJxjHiQwdE7P5CURTVD9+TCxtJVPiDrFIqxpI+tJ42OLjjvgGjh5If+sqe5dHeGURf1lY944kg==
X-Received: by 2002:a7b:c184:: with SMTP id y4mr478178wmi.92.1607616747948;
        Thu, 10 Dec 2020 08:12:27 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:15:13:f693:9fff:fef4:2449])
        by smtp.gmail.com with ESMTPSA id d17sm9307735wro.62.2020.12.10.08.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 08:12:27 -0800 (PST)
Date:   Thu, 10 Dec 2020 17:12:20 +0100
From:   Marco Elver <elver@google.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: avoid static_assert for genksyms
Message-ID: <X9JI5KpWoo23wkRg@elver.google.com>
References: <20201203230955.1482058-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203230955.1482058-1-arnd@kernel.org>
User-Agent: Mutt/2.0.2 (2020-11-20)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 04, 2020 at 12:09AM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> genksyms does not know or care about the _Static_assert() built-in,
> and sometimes falls back to ignoring the later symbols, which causes
> undefined behavior such as
> 
> WARNING: modpost: EXPORT symbol "ethtool_set_ethtool_phy_ops" [vmlinux] version generation failed, symbol will not be versioned.
> ld: net/ethtool/common.o: relocation R_AARCH64_ABS32 against `__crc_ethtool_set_ethtool_phy_ops' can not be used when making a shared object
> net/ethtool/common.o:(_ftrace_annotated_branch+0x0): dangerous relocation: unsupported relocation
> 
> Redefine static_assert for genksyms to avoid that.
> 
> Cc: stable@vger.kernel.org
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/linux/build_bug.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/build_bug.h b/include/linux/build_bug.h
> index e3a0be2c90ad..7bb66e15b481 100644
> --- a/include/linux/build_bug.h
> +++ b/include/linux/build_bug.h
> @@ -77,4 +77,9 @@
>  #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
>  #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
>  
> +#ifdef __GENKSYMS__
> +/* genksyms gets confused by _Static_assert */
> +#define _Static_assert(expr, ...)
> +#endif
> +

I had sent

	https://lkml.kernel.org/r/20201201152017.3576951-1-elver@google.com

3 days before your patch. :-)

I guess what you propose is simpler, but might still have corner cases
where we still get warnings. In particular, if some file (for whatever
reason) does not include build_bug.h and uses a raw _Static_assert(),
then we still get warnings. E.g. I see 1 user of raw _Static_assert()
(drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h ).

In the end I don't mind either way, as long as those warnings are fixed
in 5.11. :-)

Thanks,
-- Marco
