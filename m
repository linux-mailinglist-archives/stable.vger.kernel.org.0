Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54D7B863A6
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 15:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733231AbfHHNts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 09:49:48 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44467 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732727AbfHHNts (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Aug 2019 09:49:48 -0400
Received: by mail-qt1-f196.google.com with SMTP id 44so61113026qtg.11;
        Thu, 08 Aug 2019 06:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BJR6qeJXxoFFGSFwXNKEUG5cs5VPmvvEARn7vgHEr5Q=;
        b=UoZl+e9cJy/Dj5F6qfIHH4cKJ43rqRY5SS9Q7l/NTrivqVMud95qp+Mlv9pSxP47mw
         mjGQdBMjO+J71NuNQSh3F3TMgJu9CXEAOMoP5HaE5Q5tApUIrYPaPxgpekk0oQXlBeuQ
         ZsdG7GPlSFM8ajGRs9BXfAcY86h9EJ2u/dY+FLzM52FidEJ0E1WFxfKIa1lJzHN3rZAE
         6Fk+xwVdbydwKV0Pu8VNi5qF2Fjq/hO/NZ+bGWrKlm/og1nunNUd5J5cM6usHWrvMLDI
         8n/C3tr78NPhG0nRuCnW9RJPKD9q4uuuBn6i+q66S6PGWqycjtPmceaH3CgCTFXy39Bb
         HOtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BJR6qeJXxoFFGSFwXNKEUG5cs5VPmvvEARn7vgHEr5Q=;
        b=oy+wEtYrkd2/Fz50G4gouW72afZAQub2utFlCmg46W94LTKqxEJ3Th+90VQL+Kxah8
         ARwjNVh0135YiQZAKJaW0+A0ICBrkzB39cNTo8Np5W8s4eC0OzFMx1T7aAtxuU+19l6+
         KGNTs6bkTXqDEtGThMmrYqS2HdRD60No4W63zL+hQLhYtXcI6VmtuCsa5v6XAhUzXp5q
         ST4o82TFD3Q7viMasHZ1x5JGlLtwHNBkR5WKh2qwZcnf79ofhZhwv1hvLqdZO6o1VUbS
         hS5UmgxXolo8K/Em2S+7r9y51kQCRQj2hB9R6w4iBBIOZtQ0zINQr1odJZ/VWQ6DMog8
         nOHA==
X-Gm-Message-State: APjAAAW4xi7K3m1ltLIbIsDAL7qcg66QnWZexoRfqQB22GRhwxlQAgj5
        J/gF1tihd0kd0W1NadOio0dxRUih
X-Google-Smtp-Source: APXvYqykKN3c6mqJ7uxzkWdSt/aHfTWep3daUc17R/ezCWKD8U6+sKP6VOiPGJO9sOd/oStRgcdVrw==
X-Received: by 2002:a0c:af8a:: with SMTP id s10mr13433300qvc.182.1565272186872;
        Thu, 08 Aug 2019 06:49:46 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id g2sm37053218qkm.31.2019.08.08.06.49.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 06:49:46 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 0928440340; Thu,  8 Aug 2019 10:49:43 -0300 (-03)
Date:   Thu, 8 Aug 2019 10:49:43 -0300
To:     Thomas Richter <tmricht@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        brueckner@linux.ibm.com, gor@linux.ibm.com,
        heiko.carstens@de.ibm.com, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] perf/top: Fix s390 gap between kernel end and module
 start
Message-ID: <20190808134943.GG19444@kernel.org>
References: <20190724122703.3996-1-tmricht@linux.ibm.com>
 <20190724122703.3996-2-tmricht@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724122703.3996-2-tmricht@linux.ibm.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Wed, Jul 24, 2019 at 02:27:03PM +0200, Thomas Richter escreveu:
> During execution of command 'perf top' the error message:
> 
>    Not enough memory for annotating '__irf_end' symbol!)
> 
> is emitted from this call sequence:
>   __cmd_top
>     perf_top__mmap_read
>       perf_top__mmap_read_idx
>         perf_event__process_sample
>           hist_entry_iter__add
>             hist_iter__top_callback
>               perf_top__record_precise_ip
>                 hist_entry__inc_addr_samples
>                   symbol__inc_addr_samples
>                     symbol__get_annotation
>                       symbol__alloc_hist

Thanks, applied.

- Arnaldo
 
> In this function the size of symbol __irf_end is calculated. The size
> of a symbol is the difference between its start and end address.
> When the symbol was read the first time, its start and end was set to:
>    symbol__new: __irf_end 0xe954d0-0xe954d0
> which is correct and maps with /proc/kallsyms:
> 
>    root@s8360046:~/linux-4.15.0/tools/perf# fgrep _irf_end /proc/kallsyms
>    0000000000e954d0 t __irf_end
>    root@s8360046:~/linux-4.15.0/tools/perf#
> 
> In function symbol__alloc_hist() the end of symbol __irf_end is
> 
>   symbol__alloc_hist sym:__irf_end start:0xe954d0 end:0x3ff80045a8
> 
> which is identical with the first module entry in /proc/kallsyms
> 
> This results in a symbol size of __irf_req for histogram analyses of
> 70334140059072 bytes and a malloc() for this requested size fails.
> 
> The root cause of this is function
>   __dso__load_kallsyms()
>   +-> symbols__fixup_end()
> 
> Function symbols__fixup_end() enlarges the last symbol in the
> kallsyms map
>    # fgrep __irf_end /proc/kallsyms
>    0000000000e954d0 t __irf_end
>    #
> 
> to the start address of the first module:
>    # cat /proc/kallsyms | sort  | egrep ' [tT] '
>    ....
>    0000000000e952d0 T __security_initcall_end
>    0000000000e954d0 T __initramfs_size
>    0000000000e954d0 t __irf_end
>    000003ff800045a8 T fc_get_event_number       [scsi_transport_fc]
>    000003ff800045d0 t store_fc_vport_disable    [scsi_transport_fc]
>    000003ff800046a8 T scsi_is_fc_rport  [scsi_transport_fc]
>    000003ff800046d0 t fc_target_setup   [scsi_transport_fc]
> 
> On s390 the kernel is located around memory address 0x200, 0x10000
> or 0x100000, depending on linux version. Modules however start some-
> where around 0x3ff xxxx xxxx.
> 
> This is different than x86 and produces a large gap for which
> histogram allocation fails.
> 
> Fix this by detecting the kernel's last symbol and do no
> adjustment for it. Introduce a weak function and handle s390 specifics.
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: Klaus Theurich <klaus.theurich@de.ibm.com>
> Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
> Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  tools/perf/arch/s390/util/machine.c | 17 +++++++++++++++++
>  tools/perf/util/symbol.c            |  7 ++++++-
>  tools/perf/util/symbol.h            |  1 +
>  3 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/arch/s390/util/machine.c b/tools/perf/arch/s390/util/machine.c
> index de26b1441a48..c8c86a0c9b79 100644
> --- a/tools/perf/arch/s390/util/machine.c
> +++ b/tools/perf/arch/s390/util/machine.c
> @@ -6,6 +6,7 @@
>  #include "machine.h"
>  #include "api/fs/fs.h"
>  #include "debug.h"
> +#include "symbol.h"
>  
>  int arch__fix_module_text_start(u64 *start, u64 *size, const char *name)
>  {
> @@ -33,3 +34,19 @@ int arch__fix_module_text_start(u64 *start, u64 *size, const char *name)
>  
>  	return 0;
>  }
> +
> +/* On s390 kernel text segment start is located at very low memory addresses,
> + * for example 0x10000. Modules are located at very high memory addresses,
> + * for example 0x3ff xxxx xxxx. The gap between end of kernel text segment
> + * and beginning of first module's text segment is very big.
> + * Therefore do not fill this gap and do not assign it to the kernel dso map.
> + */
> +void arch__symbols__fixup_end(struct symbol *p, struct symbol *c)
> +{
> +	if (strchr(p->name, '[') == NULL && strchr(c->name, '['))
> +		/* Last kernel symbol mapped to end of page */
> +		p->end = roundup(p->end, page_size);
> +	else
> +		p->end = c->start;
> +	pr_debug4("%s sym:%s end:%#lx\n", __func__, p->name, p->end);
> +}
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 5cbad55cd99d..3b49eb4e3ed9 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -91,6 +91,11 @@ static int prefix_underscores_count(const char *str)
>  	return tail - str;
>  }
>  
> +void __weak arch__symbols__fixup_end(struct symbol *p, struct symbol *c)
> +{
> +	p->end = c->start;
> +}
> +
>  const char * __weak arch__normalize_symbol_name(const char *name)
>  {
>  	return name;
> @@ -217,7 +222,7 @@ void symbols__fixup_end(struct rb_root_cached *symbols)
>  		curr = rb_entry(nd, struct symbol, rb_node);
>  
>  		if (prev->end == prev->start && prev->end != curr->start)
> -			prev->end = curr->start;
> +			arch__symbols__fixup_end(prev, curr);
>  	}
>  
>  	/* Last entry */
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 9a8fe012910a..f30ab608ea54 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -277,6 +277,7 @@ const char *arch__normalize_symbol_name(const char *name);
>  #define SYMBOL_A 0
>  #define SYMBOL_B 1
>  
> +void arch__symbols__fixup_end(struct symbol *p, struct symbol *c);
>  int arch__compare_symbol_names(const char *namea, const char *nameb);
>  int arch__compare_symbol_names_n(const char *namea, const char *nameb,
>  				 unsigned int n);
> -- 
> 2.21.0

-- 

- Arnaldo
