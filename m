Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B76A23B4B9
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 07:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgHDF7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 01:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbgHDF7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 01:59:00 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF6FC06174A;
        Mon,  3 Aug 2020 22:59:00 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k13so14432854plk.13;
        Mon, 03 Aug 2020 22:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GYIRPWu1+RXNtTv+6/2vW+rM1Dz8G3uUTyxXnTJAPW8=;
        b=kcFPor72EKkfd/pLvfCuhLMFIG/ObCDlDNbi0hLOBeC+tBkg0AU0akxD/sgDGjFM6V
         2W+3ET9nXv823CMVVLKKAsOkIOXlCN/HaBv07F4bG5LfnJk2hvO0NVRHXciB4BBJ2owM
         5lyill+DG8W+UkUd7daFCtuN0Zk16UVgPnavEyhg9P1B76FEwOtpzc2bQE6meqwu7uQk
         LPtUjgBxTNGZNNCJjsUwpyk0oIrZNucXF/+eFtAlciNkJowp/D5uA1b0tNNgxXxxS+xY
         lBsFjxhYME5KmQe75ad30RUGICh/uHEtYAnqiSA4EEUn6OLbK37sTz8TNS7YwpoNFW/l
         Xo3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=GYIRPWu1+RXNtTv+6/2vW+rM1Dz8G3uUTyxXnTJAPW8=;
        b=DNil5zNuj4wDafsRgm6LdMdU6Isz0NyWUwvfIiAWdOnU+X9K30KpiolQXxWja22hPv
         mFYuPZHyZbd1IeePLyw1MWCJPiifKXYVBCh0/LHERTWkfNYBL0D//MozMZu/RmReSN2N
         24oOooRCZf86QtmUpQDPsTWTXnKr07C9XWJw9s5K8enVIxGij3kNfSIiQgJ8SGNTRZbZ
         JDiNdu5SmDFlL64Q2kBOGW3Xpo9nQrxQTT+xiDcqj3a9KA8ubN7nSGjz7/XLX9EtC5PP
         MgD4Hl4/h/6rNeGX+6MUapTnW/ginLN3R0O6egKJZtKRlcMXM6sUR0NY3pcbHBTbt8mo
         +TvQ==
X-Gm-Message-State: AOAM531yUbXBGdM3KsW5KiIaIvPPFhXIgkddGpXH/tWfPmEDiH5gi2AF
        L1R81aqOMfODwua/hItKtgNsSJRB
X-Google-Smtp-Source: ABdhPJwdBNAJ9tRXA2tNDCCu6b45bf/7hrxCbxIzmRcLgvFUngbU/fSe3PXX+OYykKjwA/3nLcTD/g==
X-Received: by 2002:a17:902:8498:: with SMTP id c24mr18068078plo.332.1596520739974;
        Mon, 03 Aug 2020 22:58:59 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k4sm1229258pjg.48.2020.08.03.22.58.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Aug 2020 22:58:58 -0700 (PDT)
Date:   Mon, 3 Aug 2020 22:58:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.7 000/120] 5.7.13-rc1 review
Message-ID: <20200804055855.GA114969@roeck-us.net>
References: <20200803121902.860751811@linuxfoundation.org>
 <20200803155820.GA160756@roeck-us.net>
 <20200803173330.GA1186998@kroah.com>
 <CAMuHMdW1Cz_JJsTmssVz_0wjX_1_EEXGOvGjygPxTkcMsbR6Lw@mail.gmail.com>
 <20200804030107.GA220454@roeck-us.net>
 <CAHk-=wi-WH0vTEVb=yTuWv=3RrGC2T28dHxqc=QXKkRMz3N3-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi-WH0vTEVb=yTuWv=3RrGC2T28dHxqc=QXKkRMz3N3-g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 03, 2020 at 08:12:51PM -0700, Linus Torvalds wrote:
> On Mon, Aug 3, 2020 at 8:01 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > The bisect log below applies to both the sparc and the powerpc build
> > failures.
> 
> Does the attached fix it?
> 
>                  Linus

> From 780c8591bce09bbdd2908b7c07b3baba883a1ce6 Mon Sep 17 00:00:00 2001
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Fri, 31 Jul 2020 07:51:14 +0200
> Subject: [PATCH] random32: move the pseudo-random 32-bit definitions to prandom.h
> 
> The addition of percpu.h to the list of includes in random.h revealed
> some circular dependencies on arm64 and possibly other platforms.  This
> include was added solely for the pseudo-random definitions, which have
> nothing to do with the rest of the definitions in this file but are
> still there for legacy reasons.
> 
> This patch moves the pseudo-random parts to linux/prandom.h and the
> percpu.h include with it, which is now guarded by _LINUX_PRANDOM_H and
> protected against recursive inclusion.
> 
> A further cleanup step would be to remove this from <linux/random.h>
> entirely, and make people who use the prandom infrastructure include
> just the new header file.  That's a bit of a churn patch, but grepping
> for "prandom_" and "next_pseudo_random32" should catch most users.
> 
> Acked-by: Willy Tarreau <w@1wt.eu>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

With this patch applied on top of v5.8:

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks,
Guenter

> ---
>  include/linux/prandom.h | 78 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/random.h  | 66 +++-------------------------------
>  2 files changed, 82 insertions(+), 62 deletions(-)
>  create mode 100644 include/linux/prandom.h
> 
> diff --git a/include/linux/prandom.h b/include/linux/prandom.h
> new file mode 100644
> index 000000000000..968c4287a277
> --- /dev/null
> +++ b/include/linux/prandom.h
> @@ -0,0 +1,78 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * include/linux/prandom.h
> + *
> + * Include file for the fast pseudo-random 32-bit
> + * generation.
> + */
> +#ifndef _LINUX_PRANDOM_H
> +#define _LINUX_PRANDOM_H
> +
> +#include <linux/types.h>
> +#include <linux/percpu.h>
> +
> +u32 prandom_u32(void);
> +void prandom_bytes(void *buf, size_t nbytes);
> +void prandom_seed(u32 seed);
> +void prandom_reseed_late(void);
> +
> +struct rnd_state {
> +	__u32 s1, s2, s3, s4;
> +};
> +
> +DECLARE_PER_CPU(struct rnd_state, net_rand_state);
> +
> +u32 prandom_u32_state(struct rnd_state *state);
> +void prandom_bytes_state(struct rnd_state *state, void *buf, size_t nbytes);
> +void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state);
> +
> +#define prandom_init_once(pcpu_state)			\
> +	DO_ONCE(prandom_seed_full_state, (pcpu_state))
> +
> +/**
> + * prandom_u32_max - returns a pseudo-random number in interval [0, ep_ro)
> + * @ep_ro: right open interval endpoint
> + *
> + * Returns a pseudo-random number that is in interval [0, ep_ro). Note
> + * that the result depends on PRNG being well distributed in [0, ~0U]
> + * u32 space. Here we use maximally equidistributed combined Tausworthe
> + * generator, that is, prandom_u32(). This is useful when requesting a
> + * random index of an array containing ep_ro elements, for example.
> + *
> + * Returns: pseudo-random number in interval [0, ep_ro)
> + */
> +static inline u32 prandom_u32_max(u32 ep_ro)
> +{
> +	return (u32)(((u64) prandom_u32() * ep_ro) >> 32);
> +}
> +
> +/*
> + * Handle minimum values for seeds
> + */
> +static inline u32 __seed(u32 x, u32 m)
> +{
> +	return (x < m) ? x + m : x;
> +}
> +
> +/**
> + * prandom_seed_state - set seed for prandom_u32_state().
> + * @state: pointer to state structure to receive the seed.
> + * @seed: arbitrary 64-bit value to use as a seed.
> + */
> +static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
> +{
> +	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
> +
> +	state->s1 = __seed(i,   2U);
> +	state->s2 = __seed(i,   8U);
> +	state->s3 = __seed(i,  16U);
> +	state->s4 = __seed(i, 128U);
> +}
> +
> +/* Pseudo random number generator from numerical recipes. */
> +static inline u32 next_pseudo_random32(u32 seed)
> +{
> +	return seed * 1664525 + 1013904223;
> +}
> +
> +#endif
> diff --git a/include/linux/random.h b/include/linux/random.h
> index 9ab7443bd91b..f45b8be3e3c4 100644
> --- a/include/linux/random.h
> +++ b/include/linux/random.h
> @@ -11,7 +11,6 @@
>  #include <linux/kernel.h>
>  #include <linux/list.h>
>  #include <linux/once.h>
> -#include <asm/percpu.h>
>  
>  #include <uapi/linux/random.h>
>  
> @@ -111,63 +110,12 @@ declare_get_random_var_wait(long)
>  
>  unsigned long randomize_page(unsigned long start, unsigned long range);
>  
> -u32 prandom_u32(void);
> -void prandom_bytes(void *buf, size_t nbytes);
> -void prandom_seed(u32 seed);
> -void prandom_reseed_late(void);
> -
> -struct rnd_state {
> -	__u32 s1, s2, s3, s4;
> -};
> -
> -DECLARE_PER_CPU(struct rnd_state, net_rand_state);
> -
> -u32 prandom_u32_state(struct rnd_state *state);
> -void prandom_bytes_state(struct rnd_state *state, void *buf, size_t nbytes);
> -void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state);
> -
> -#define prandom_init_once(pcpu_state)			\
> -	DO_ONCE(prandom_seed_full_state, (pcpu_state))
> -
> -/**
> - * prandom_u32_max - returns a pseudo-random number in interval [0, ep_ro)
> - * @ep_ro: right open interval endpoint
> - *
> - * Returns a pseudo-random number that is in interval [0, ep_ro). Note
> - * that the result depends on PRNG being well distributed in [0, ~0U]
> - * u32 space. Here we use maximally equidistributed combined Tausworthe
> - * generator, that is, prandom_u32(). This is useful when requesting a
> - * random index of an array containing ep_ro elements, for example.
> - *
> - * Returns: pseudo-random number in interval [0, ep_ro)
> - */
> -static inline u32 prandom_u32_max(u32 ep_ro)
> -{
> -	return (u32)(((u64) prandom_u32() * ep_ro) >> 32);
> -}
> -
>  /*
> - * Handle minimum values for seeds
> - */
> -static inline u32 __seed(u32 x, u32 m)
> -{
> -	return (x < m) ? x + m : x;
> -}
> -
> -/**
> - * prandom_seed_state - set seed for prandom_u32_state().
> - * @state: pointer to state structure to receive the seed.
> - * @seed: arbitrary 64-bit value to use as a seed.
> + * This is designed to be standalone for just prandom
> + * users, but for now we include it from <linux/random.h>
> + * for legacy reasons.
>   */
> -static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
> -{
> -	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
> -
> -	state->s1 = __seed(i,   2U);
> -	state->s2 = __seed(i,   8U);
> -	state->s3 = __seed(i,  16U);
> -	state->s4 = __seed(i, 128U);
> -}
> +#include <linux/prandom.h>
>  
>  #ifdef CONFIG_ARCH_RANDOM
>  # include <asm/archrandom.h>
> @@ -210,10 +158,4 @@ static inline bool __init arch_get_random_long_early(unsigned long *v)
>  }
>  #endif
>  
> -/* Pseudo random number generator from numerical recipes. */
> -static inline u32 next_pseudo_random32(u32 seed)
> -{
> -	return seed * 1664525 + 1013904223;
> -}
> -
>  #endif /* _LINUX_RANDOM_H */
> -- 
> 2.28.0.4.g1bac1770cd
> 

