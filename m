Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59D42F0C3B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 06:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbhAKFWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 00:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbhAKFWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 00:22:30 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFBBC061786;
        Sun, 10 Jan 2021 21:21:49 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id x15so1370612ilk.3;
        Sun, 10 Jan 2021 21:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4l64O1cL8mld7+QbyRcMbphc6gWq2pCIGE+VaAyHP00=;
        b=Xr76vSnV0HqEjGmgxVvhNZkeUCAw+BlVtDjqz+mtfAiXv1BsmIPrigVbPZb9JhcLj2
         fgoNfvChsZkGGMY1ikj3k9dHnqwj5+XnOnafMq0ZXXlIf9bxbNlEpjqLpz8JcAzmAzYg
         TEYsl3cNQp6CPueNKGQPJpRuZvswBIXDQV3JKx9pn2Zh7liq9YI211UHa9PY1CiDziCg
         KHo9Sc0V9uEh678sYy+9ol1wQJyMq6aPeeUwemPZa1Aq3wbQW1lk33xSzgHeA8w+SKRI
         sCdYgwR7+TjjK4bw37uHSpTzR8Ws3ZXNgHdbBgLU26Klpp6YK6AU8GQ2mGYMHpUjrbSN
         q8KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4l64O1cL8mld7+QbyRcMbphc6gWq2pCIGE+VaAyHP00=;
        b=fSdhBb4N4ejL0rv5jopC3sDs1f7Cbi9S8dRXNp0j/THkNlXzDysPwasvrIvVvq7lBv
         4CKyg/9mH5hd+StuuhO6WMXpEg+R19LaOgCkAa4TfC4TrWFQ12McVeEGyAT2MYXLiFNv
         W2McRH61PyoNPYugMb2P0aNH2X/xC7dyQaa3vM8NAU2pzKZIIs1GqKjwImjBPCD8gLcE
         zoasNZjYV64g6o6kITz6kuZCM76enX9+dqXmub03PA2CD+l9QE2domn14wX+NUuDre45
         qLRvjrllCk5aoPvqH50z8R14gFfhvKQR0GOv130DJRUqgDN9FD/89gntZan3NLC4XFNJ
         eVew==
X-Gm-Message-State: AOAM531cfghGF0YWLaeOZOba3wtgJr5AWTqqBa6s6dsMN50elI2QSUUJ
        AIa/Firkn1t2O46tAlvWWuQ=
X-Google-Smtp-Source: ABdhPJyfStv6on8rG1XJx6IhcZyH437rcGoQf/fNgV2x80K8V17nfkj0KEvchYXzZK4sQgLR2DHocA==
X-Received: by 2002:a92:41d2:: with SMTP id o201mr13827519ila.117.1610342509012;
        Sun, 10 Jan 2021 21:21:49 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id z18sm14020189ilb.26.2021.01.10.21.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 21:21:48 -0800 (PST)
Date:   Sun, 10 Jan 2021 22:21:46 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Jinyang He <hejinyang@loongson.cn>,
        Ralf Baechle <ralf@linux-mips.org>,
        Matt Redfearn <matt.redfearn@mips.com>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH mips-fixes] MIPS: relocatable: fix possible boot hangup
 with KASLR enabled
Message-ID: <20210111052146.GA1018564@ubuntu-m3-large-x86>
References: <20210110142023.185275-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110142023.185275-1-alobakin@pm.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 10, 2021 at 02:21:05PM +0000, Alexander Lobakin wrote:
> LLVM-built Linux triggered a boot hangup with KASLR enabled.
> 
> arch/mips/kernel/relocate.c:get_random_boot() uses linux_banner,
> which is a string constant, as a random seed, but accesses it
> as an array of unsigned long (in rotate_xor()).
> When the address of linux_banner is not aligned to sizeof(long),
> such access emits unaligned access exception and hangs the kernel.
> 
> Use PTR_ALIGN() to align input address to sizeof(long) and also
> align down the input length to prevent possible access-beyond-end.
> 
> Fixes: 405bc8fd12f5 ("MIPS: Kernel: Implement KASLR using CONFIG_RELOCATABLE")
> Cc: stable@vger.kernel.org # 4.7+
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Apologies for not being familiar enough with the issue to give a review
but I did reproduce the hang that the commit mentions with
malta_kvm_guest_defconfig + CONFIG_RELOCATABLE=y +
CONFIG_RANDOMIZE_BASE=y and this patch does resolve it so:

Tested-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  arch/mips/kernel/relocate.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/mips/kernel/relocate.c b/arch/mips/kernel/relocate.c
> index 47aeb3350a76..0e365b7c742d 100644
> --- a/arch/mips/kernel/relocate.c
> +++ b/arch/mips/kernel/relocate.c
> @@ -187,8 +187,14 @@ static int __init relocate_exception_table(long offset)
>  static inline __init unsigned long rotate_xor(unsigned long hash,
>  					      const void *area, size_t size)
>  {
> -	size_t i;
> -	unsigned long *ptr = (unsigned long *)area;
> +	const typeof(hash) *ptr = PTR_ALIGN(area, sizeof(hash));
> +	size_t diff, i;
> +
> +	diff = (void *)ptr - area;
> +	if (unlikely(size < diff + sizeof(hash)))
> +		return hash;
> +
> +	size = ALIGN_DOWN(size - diff, sizeof(hash));
>  
>  	for (i = 0; i < size / sizeof(hash); i++) {
>  		/* Rotate by odd number of bits and XOR. */
> -- 
> 2.30.0
> 
> 
