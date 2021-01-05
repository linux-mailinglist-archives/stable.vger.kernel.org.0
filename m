Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB91A2EB4E1
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 22:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbhAEV3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 16:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbhAEV3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 16:29:19 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565F2C061574;
        Tue,  5 Jan 2021 13:28:39 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id 186so862981qkj.3;
        Tue, 05 Jan 2021 13:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DJIWST9KinNPbLnh2UPAjV8WC1wtmvyxVwRAyl2BJww=;
        b=sanHFk+uTvDMG57iYABh3HT7B9zRIKEF/2fUBwEWBWsFSmwhWkUtmZxcvQIuo8z4S7
         Ockj0axdFNytyXZvhNwk5/euFUetEitBRMgTriCuSVMofltmriC2TlL1GcgGmt8YR2XV
         vtMipNauuCZNhAs1XEZEgCFetLSM3ywYG7PoQfJM7xjilDjgtnI/uUgTv5mJirQhx2K2
         pNzdBzVXA4qNX/VCq/EH1unS2EfkZgKDOCafrDK9JrgxPFckI+uuT7gqM3p8UI7jaZrC
         s39ma7dzY+rWHOiPpFQeTzLCvdUAIj4Aok/j7OTADmR9WTCLNq9Wrx4MezhYC5tkAm53
         krPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=DJIWST9KinNPbLnh2UPAjV8WC1wtmvyxVwRAyl2BJww=;
        b=D74/JgAICiXPkDKBjpJr0TslfTDGGE+EVUz/yk+ciPBhMjyY0UVvaJUYMO7bzDZ2UG
         t/EA9318WUqtWLdQUOiMqEQeVxl83KQOiuD48i2TobG4BeeFONTbbRV7p29Aqry58D93
         kUGCaeXjqx//3GWtQ6uk5k4GY+YFEklQxpssy++I/2IYONaXH1PvdKOiFW98WoFZNAeJ
         RqrmMVEVLGYrwKzZKHJAeAgdp6XjvHS0A9ajgJtS5XLJIbwcn3/jJe2eBpXPVzhSmMkb
         3ZVLpPkIb8GNubExa+OEbpF+eEIN1IPXz1wrwOb05+VDZkbkD12BEzSZQo6MH4nAyt78
         0BBQ==
X-Gm-Message-State: AOAM531cEQ0KJ3WAWEn2cgVIW6xbZv91KjJNWsSGcJN6spkFL2d1U2Fj
        itSOUuDLtNAsJWIkO9wRbqY=
X-Google-Smtp-Source: ABdhPJzCmxWSIbCTRP2czGY6AmjGDWFXM4tLgBxbVrhlBvsnr4dCXrwN3GzYheg5JmnBjNnsgazlwg==
X-Received: by 2002:a05:620a:804:: with SMTP id s4mr1585343qks.158.1609882118489;
        Tue, 05 Jan 2021 13:28:38 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id k7sm211427qtg.65.2021.01.05.13.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 13:28:37 -0800 (PST)
Sender: Arvind Sankar <niveditas98@gmail.com>
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Tue, 5 Jan 2021 16:28:36 -0500
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] x86/mm: Remove duplicate definition of
 _PAGE_PAT_LARGE
Message-ID: <X/TaBK3AnKJCbI3n@rani.riverdale.lan>
References: <13073a85-24c1-6efa-578b-54218d21f49d@amd.com>
 <20201111160946.147341-1-nivedita@alum.mit.edu>
 <20201111160946.147341-2-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201111160946.147341-2-nivedita@alum.mit.edu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 11, 2020 at 11:09:46AM -0500, Arvind Sankar wrote:
> _PAGE_PAT_LARGE is already defined next to _PAGE_PAT. Remove the
> duplicate.
> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> Fixes: 4efb56649132 ("x86/mm: Tabulate the page table encoding definitions")
> ---
>  arch/x86/include/asm/pgtable_types.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index 394757ee030a..f24d7ef8fffa 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -177,8 +177,6 @@ enum page_cache_mode {
>  #define __pgprot(x)		((pgprot_t) { (x) } )
>  #define __pg(x)			__pgprot(x)
>  
> -#define _PAGE_PAT_LARGE		(_AT(pteval_t, 1) << _PAGE_BIT_PAT_LARGE)
> -
>  #define PAGE_NONE	     __pg(   0|   0|   0|___A|   0|   0|   0|___G)
>  #define PAGE_SHARED	     __pg(__PP|__RW|_USR|___A|__NX|   0|   0|   0)
>  #define PAGE_SHARED_EXEC     __pg(__PP|__RW|_USR|___A|   0|   0|   0|   0)
> -- 
> 2.26.2
> 

Ping
