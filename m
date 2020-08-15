Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F342453B5
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 00:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgHOWE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 18:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbgHOVvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 17:51:02 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCDCC06134C;
        Fri, 14 Aug 2020 18:33:15 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id e5so8359915qth.5;
        Fri, 14 Aug 2020 18:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vJ/jVWhGTXG1e9E+PiLPXFME4LoN6xMadImJ1YD9YHU=;
        b=bI9yTul+XenFvqeVlqilZ/1PwJ1K3UFEioFw2tHq8PaWt4T8LWxVgwRJSMMkhCUE6S
         Mhk+1TtNGS6OWGrlFWUOTVc0gMvTT5rGsqPSPF7y7J9R5EjAKpFUxmIDn1hRIQ/wtohD
         h7ryjmhJ5t+sRCgBkpOsNhDqwsFM230xxiBOLSfm+c/bPJD3fF/amzVpL35ZoJJDtLUI
         yPPUOToH6zKsZZ56/pzJ3TtCqrkDl5KRjH98qkAEoQJehZkYfRWLA6mKX6g7SAAlM2p+
         hM1RQv8oPv1ZMBB3K1KLvw53CeRFVuV+sLMvOML/8vh1qbpqShRfnoqCIec5DNVLUsfr
         Eb2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=vJ/jVWhGTXG1e9E+PiLPXFME4LoN6xMadImJ1YD9YHU=;
        b=rw635h449WWyb2LdxXwhLh6f64LaB/PGG829ylZXHG7wbg42YpTQR4jvlJDrDXhEzp
         1SogV3Ph9t+bxew3WgQxmyt4KwUNq0fLDl92SOTzzLnj3eJ4tuwyGSZUZyz9EnFvANPK
         fWvB8RVa63Q+WHO7l9zS/RmCbE1vnr2AFXJlvQ6hXpxc/atZh1lkrpMDYkxFMDO5wwg2
         pkEmKCPzXZi2wqvWKwrDd78Ta/hJ9mBOwxsM3bIzeZIUKhbtYaj2ENTvqTsBWlp5XYjx
         JpaUeN/ykWSk1vJLkYdN1rPR6ZtliiGz3BvOAcJZr9VY63vsgICUgwR0XBY7U1b0evt3
         ROnQ==
X-Gm-Message-State: AOAM531s2W0jywcll4pKZ6C8x19MKcPUaWOBCJ3YbP161lqYt8R9kO7B
        jMoOuxzxD4ZoRbKVkoVg01CGxoz2IoY=
X-Google-Smtp-Source: ABdhPJzT7OzYhDt4EGcOfivsmmvRSIEn2XltAWy/5uJNgRq1XLSKbN6URmiVpoEPnEgK3HsV7HyH9Q==
X-Received: by 2002:ac8:7405:: with SMTP id p5mr4604950qtq.308.1597455192803;
        Fri, 14 Aug 2020 18:33:12 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id t69sm10061523qka.73.2020.08.14.18.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 18:33:12 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Fri, 14 Aug 2020 21:33:10 -0400
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?RMOhdmlkIEJvbHZhbnNrw70=?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>, stable@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>,
        Joe Perches <joe@perches.com>, Tony Luck <tony.luck@intel.com>,
        Yury Norov <yury.norov@gmail.com>,
        Daniel Axtens <dja@axtens.net>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Dan Williams <dan.j.williams@intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] lib/string.c: implement stpcpy
Message-ID: <20200815013310.GA99152@rani.riverdale.lan>
References: <20200815002417.1512973-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200815002417.1512973-1-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 14, 2020 at 05:24:15PM -0700, Nick Desaulniers wrote:
> +#ifndef __HAVE_ARCH_STPCPY
> +/**
> + * stpcpy - copy a string from src to dest returning a pointer to the new end
> + *          of dest, including src's NULL terminator. May overrun dest.
> + * @dest: pointer to end of string being copied into. Must be large enough
> + *        to receive copy.
> + * @src: pointer to the beginning of string being copied from. Must not overlap
> + *       dest.
> + *
> + * stpcpy differs from strcpy in two key ways:
> + * 1. inputs must not overlap.
> + * 2. return value is the new NULL terminated character. (for strcpy, the
> + *    return value is a pointer to src.
> + */
> +#undef stpcpy
> +char *stpcpy(char *__restrict__ dest, const char *__restrict__ src)
> +{
> +	while ((*dest++ = *src++) != '\0')
> +		/* nothing */;
> +	return dest;
> +}
> +#endif
> +

Won't this return a pointer that's one _past_ the terminating NUL? I
think you need the increments to be inside the loop body, rather than as
part of the condition.

Nit: NUL is more correct than NULL to refer to the string terminator.
