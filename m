Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915291A6AC1
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 19:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732274AbgDMRAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 13:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732122AbgDMRAU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 13:00:20 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F004C0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 10:00:20 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id r14so4737799pfl.12
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 10:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/DZYk47NF9C5oaP2cb0H92SO3iTKz5XcVmqra2x+vfs=;
        b=V+K0VNU1GhFD5j0q10I76CUK+x6CT7NLsVwwrzwhJ2i/Exk/WdBgwMOtazG8IaQ131
         FWiwXzug3C+6EaGal59qTW2s//KDiJW/bw7iYM1TrDvJKqtOVDQmz8Qk4/bhXF+ftltb
         4tAXOcZsyvY6inP15tjmjfaCwV+Sjy5qbU2io=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/DZYk47NF9C5oaP2cb0H92SO3iTKz5XcVmqra2x+vfs=;
        b=dK1SlndLiGkL3uV0Qxj5iEmEuIvL0EYJ9nQNrYbzi5B3WNXsCRe8BSg8wNP3hysKB3
         1bEj7QM6zMMr/+MkRkv38lZccpFMh0mh5iSvHkmYXVu1G6FKHW3zQD97erCRsIU1mpsP
         G3eGS98cAbSmAzuXyQ8W3/rdHLn4OkVdeA3WPBdab2ZmHdiy9YbDbpbQFZ5yCVCQu3Rn
         tXsGqNj629DItYpAYzE9ozAGi7hngOUpbJ55UjNrqSfJQE/N86aIKtXQVBiIye19mdz0
         R0S5HHmB/TMb432an+gI6JfzInW4fAjXJWClncCAckAYK03ndkbRIEPxcxzuFRN6YF6J
         gB0A==
X-Gm-Message-State: AGi0PuZVA+88mu+9yKoDnGPA7jbQJ/arRwin3EilVyQkTzYwEnhT7ZRy
        2CildjIoijOvahmf0x7AuBvWcw==
X-Google-Smtp-Source: APiQypJxcY0SVjosN+ylkM26qpGuo5O4HBGJ649o4xEIcDL/Eh179FglGc6bXOaBcKzllMSzft4dYw==
X-Received: by 2002:a62:18c8:: with SMTP id 191mr11645752pfy.255.1586797219675;
        Mon, 13 Apr 2020 10:00:19 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l71sm3635155pge.3.2020.04.13.10.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 10:00:18 -0700 (PDT)
Date:   Mon, 13 Apr 2020 10:00:17 -0700
From:   Kees Cook <keescook@chromium.org>
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        penberg@kernel.org, rientjes@google.com, silvio.cesare@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] slub: improve bit diffusion for freelist
 ptr obfuscation" failed to apply to 4.19-stable tree
Message-ID: <202004130959.2471CBC@keescook>
References: <1586506142226229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586506142226229@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

I've backported this to v4.19 (and v4.14). Those backports require that
d5767057c9a76a29f073dad66b7fa12a90e8c748 is cherry-picked into stable
for v4.19 and v4.14 as well. I will send patches...

-Kees

On Fri, Apr 10, 2020 at 10:09:02AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 1ad53d9fa3f6168ebcf48a50e08b170432da2257 Mon Sep 17 00:00:00 2001
> From: Kees Cook <keescook@chromium.org>
> Date: Wed, 1 Apr 2020 21:04:23 -0700
> Subject: [PATCH] slub: improve bit diffusion for freelist ptr obfuscation
> 
> Under CONFIG_SLAB_FREELIST_HARDENED=y, the obfuscation was relatively weak
> in that the ptr and ptr address were usually so close that the first XOR
> would result in an almost entirely 0-byte value[1], leaving most of the
> "secret" number ultimately being stored after the third XOR.  A single
> blind memory content exposure of the freelist was generally sufficient to
> learn the secret.
> 
> Add a swab() call to mix bits a little more.  This is a cheap way (1
> cycle) to make attacks need more than a single exposure to learn the
> secret (or to know _where_ the exposure is in memory).
> 
> kmalloc-32 freelist walk, before:
> 
> ptr              ptr_addr            stored value      secret
> ffff90c22e019020@ffff90c22e019000 is 86528eb656b3b5bd (86528eb656b3b59d)
> ffff90c22e019040@ffff90c22e019020 is 86528eb656b3b5fd (86528eb656b3b59d)
> ffff90c22e019060@ffff90c22e019040 is 86528eb656b3b5bd (86528eb656b3b59d)
> ffff90c22e019080@ffff90c22e019060 is 86528eb656b3b57d (86528eb656b3b59d)
> ffff90c22e0190a0@ffff90c22e019080 is 86528eb656b3b5bd (86528eb656b3b59d)
> ...
> 
> after:
> 
> ptr              ptr_addr            stored value      secret
> ffff9eed6e019020@ffff9eed6e019000 is 793d1135d52cda42 (86528eb656b3b59d)
> ffff9eed6e019040@ffff9eed6e019020 is 593d1135d52cda22 (86528eb656b3b59d)
> ffff9eed6e019060@ffff9eed6e019040 is 393d1135d52cda02 (86528eb656b3b59d)
> ffff9eed6e019080@ffff9eed6e019060 is 193d1135d52cdae2 (86528eb656b3b59d)
> ffff9eed6e0190a0@ffff9eed6e019080 is f93d1135d52cdac2 (86528eb656b3b59d)
> 
> [1] https://blog.infosectcbr.com.au/2020/03/weaknesses-in-linux-kernel-heap.html
> 
> Fixes: 2482ddec670f ("mm: add SLUB free list pointer obfuscation")
> Reported-by: Silvio Cesare <silvio.cesare@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: <stable@vger.kernel.org>
> Link: http://lkml.kernel.org/r/202003051623.AF4F8CB@keescook
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index fc911c222b11..bc949e3428c9 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -259,7 +259,7 @@ static inline void *freelist_ptr(const struct kmem_cache *s, void *ptr,
>  	 * freepointer to be restored incorrectly.
>  	 */
>  	return (void *)((unsigned long)ptr ^ s->random ^
> -			(unsigned long)kasan_reset_tag((void *)ptr_addr));
> +			swab((unsigned long)kasan_reset_tag((void *)ptr_addr)));
>  #else
>  	return ptr;
>  #endif
> 

-- 
Kees Cook
