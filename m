Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6003686A1
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 20:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbhDVShN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 14:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236885AbhDVShM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 14:37:12 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C75C06174A;
        Thu, 22 Apr 2021 11:36:37 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id r186so18963892oif.8;
        Thu, 22 Apr 2021 11:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BYTuPMRUexPPGvW6L1BJds8lSCPzcxEGFZPlK6FTX5Q=;
        b=lzLVIMk/sD6EH5Ou0EKkBA7/dkiIEbylUlyG2qLLy2nEv6Qy9kCTwiat6sai94yuO5
         WyGo6aFBOA74o/iDElyktIv/qsytHyeIH2qxw5gp4efQbzMHZEI4KEJtnmEE6uKKCYeZ
         cwYpCIVJi/2ujGTBEHeN8ux8KTKcBsPULjVapcG5R8fqPPJT50POaMiAq8zE2qpqnCnh
         tXWRKRgoqh6PkeFgpY7VRx4mgge3WcWw1n9ke7hGbN3GhzpMenpI4aBJuuV8TALvFsUL
         uR6oRY3U6ThdOomUPVo4wQDkMUYwrgOKBrYCkasvPKmb4MJX4RG0QsnSfrwVyVErzv3W
         8SVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=BYTuPMRUexPPGvW6L1BJds8lSCPzcxEGFZPlK6FTX5Q=;
        b=W9Xw0ZQSiCP/KhQdadt/tcRgJyeparzTGGI1eu2lkdAESdmibHJRYkKCaDY/qYwXn4
         yz4LMnltpp+Epe93pYlnp6O8v9x7Bj1YBe7aHBFkNYbS22QVjPqeuGTj7yAV4P1WIUB7
         l3attTiRT3uGFCq62kxIziEpWWHzN241AUPdPnBGrBmFwRz7xZ7PySt66I7B9e3+jPqN
         /gsaX4sUM9AUAPYbtEd/TwRkVBd4M/VksXRgmtqW0j/lMk+BkpQ8gCAb9l9lMJXAOlGj
         riHILZ1QkAAW6w7ENy8jc4CFpu4lunoM8V+DlIerpMB6osjg1iNDQeOn2mez12yaUdmy
         WQCA==
X-Gm-Message-State: AOAM533QlpLW/Q95fy8C89YKf7TjKIMybRJ5CeT9IAajXlXP4tDMaLM8
        LfzQhLpsWOeNHmQqYx7E19I=
X-Google-Smtp-Source: ABdhPJxLB1HYUuROmP8V+ubyXzzB0HnMxdsPjxrumTVmWgD12fwqUh8KLYkkg8BTnKRUCy6o3MMJ+A==
X-Received: by 2002:aca:c755:: with SMTP id x82mr939223oif.83.1619116596702;
        Thu, 22 Apr 2021 11:36:36 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p11sm780397oti.53.2021.04.22.11.36.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 22 Apr 2021 11:36:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 22 Apr 2021 11:36:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhuacai@kernel.org>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-arch@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/4] MIPS: Reinstate platform `__div64_32' handler
Message-ID: <20210422183634.GA108385@roeck-us.net>
References: <alpine.DEB.2.21.2104200044060.44318@angie.orcam.me.uk>
 <alpine.DEB.2.21.2104200212500.44318@angie.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2104200212500.44318@angie.orcam.me.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 20, 2021 at 04:50:40AM +0200, Maciej W. Rozycki wrote:
> Our current MIPS platform `__div64_32' handler is inactive, because it 
> is incorrectly only enabled for 64-bit configurations, for which generic 
> `do_div' code does not call it anyway.
> 
> The handler is not suitable for being called from there though as it 
> only calculates 32 bits of the quotient under the assumption the 64-bit 
> divident has been suitably reduced.  Code for such reduction used to be 
> there, however it has been incorrectly removed with commit c21004cd5b4c 
> ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0."), which should 
> have only updated an obsoleted constraint for an inline asm involving 
> $hi and $lo register outputs, while possibly wiring the original MIPS 
> variant of the `do_div' macro as `__div64_32' handler for the generic 
> `do_div' implementation
> 
> Correct the handler as follows then:
> 
> - Revert most of the commit referred, however retaining the current 
>   formatting, except for the final two instructions of the inline asm 
>   sequence, which the original commit missed.  Omit the original 64-bit 
>   parts though.
> 
> - Rename the original `do_div' macro to `__div64_32'.  Use the combined 
>   `x' constraint referring to the MD accumulator as a whole, replacing 
>   the original individual `h' and `l' constraints used for $hi and $lo 
>   registers respectively, of which `h' has been obsoleted with GCC 4.4. 
>   Update surrounding code accordingly.
> 
>   We have since removed support for GCC versions before 4.9, so no need 
>   for a special arrangement here; GCC has supported the `x' constraint 
>   since forever anyway, or at least going back to 1991.
> 
> - Rename the `__base' local variable in `__div64_32' to `__radix' to 
>   avoid a conflict with a local variable in `do_div'.
> 
> - Actually enable this code for 32-bit rather than 64-bit configurations
>   by qualifying it with BITS_PER_LONG being 32 instead of 64.  Include 
>   <asm/bitsperlong.h> for this macro rather than <linux/types.h> as we 
>   don't need anything else.
> 
> - Finally include <asm-generic/div64.h> last rather than first.
> 
> This has passed correctness verification with test_div64 and reduced the 
> module's average execution time down to 1.0668s and 0.2629s from 2.1529s 
> and 0.5647s respectively for an R3400 CPU @40MHz and a 5Kc CPU @160MHz.  
> For a reference 64-bit `do_div' code where we have the DDIVU instruction 
> available to do the whole calculation right away averages at 0.0660s for 
> the latter CPU.
> 
This patch results in:

arch/mips/mti-malta/malta-time.c: In function 'plat_time_init':
./arch/mips/include/asm/div64.h:76:3: error: inconsistent operand constraints in an 'asm'

and similar errors when trying to compile malta_qemu_32r6_defconfig.
I tried with gcc 8.3.0, 8.4.0, 9.3.0, and 10.3.0.

Does this need some additional new compile flags ?

Thanks,
Guenter
