Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE2DD8639E
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 15:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733197AbfHHNr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 09:47:26 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40538 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732727AbfHHNr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Aug 2019 09:47:26 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so92124780qtn.7;
        Thu, 08 Aug 2019 06:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=C6WFPVXGyocEIIrcTDuM4IDv1J5Bc4drJaACPbDYG1I=;
        b=WN/KRTxGCIva6p3X00xjaE70ElLoP8c9PUb/PtYminSAk1wwVwebUNm6H8xQ4IUCJ6
         iufh+Ex2vRlMS1Rr/9iQO+pa6PbUQfxpern6I2HlRcB0vnhHY3N6tJ+7aCrbx0npAbJf
         h/9QMzlT5n+oPiJp9rPgRLlb61VW5pj9u02chyXjIBKtxCt8ZqWPNZArxeFGdTKkyGUV
         lyNu90kSyzr3BkFhJnIPVAfhFS5t52V5F8ZqYgMiK4Nnf+iyoyD0/eG9g83kTa9kOetG
         RhobiEpwL753m6K7dGmmjV5XFXQUvsJzCBk/cC44ZnyZJGI3UUHhcYfy8/XlMMWrNXsv
         KVSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=C6WFPVXGyocEIIrcTDuM4IDv1J5Bc4drJaACPbDYG1I=;
        b=kDkQJJhGbmSLR+qaJ3mXeGCYXVhmjCfQGmpAbaNAWO8IXxNVeFf52cuGaBG1kIdVI5
         SvWuEg6f9MGS/hGK6+6YDQBtTJYJ/Pa7Wf0itbhE7YaSrnExH3FLGgaU5o0FPAig2jjl
         y6LDkm20nznMNv7bdL2qZWbXKmkfNkCGG6gUGH5mwww1LBhkgXXkqYYe593rHZs3eNfS
         0X28nOm0eBNnhhCui+5QXJhkFX8XKY38bIZ4l/A2c4csM+qTzYTULIAbzWUryzao/QdV
         LIdwrLawHksX4AVQx9kuieckqKxy0JSf5vRoQOenGt6ihntrZSwxH+xg9g/bNCni425o
         loUA==
X-Gm-Message-State: APjAAAWYnl5xupWSIYdjoEl6IM7asaMP3qSiwnnlF4lZseLOerAVi/GN
        +YcQCnJrBdNKTQGz4IUELB4=
X-Google-Smtp-Source: APXvYqwXajS0dWZ56dnedSiwni6MsvOA7HG8BHtpoidglv6YaTkxD0aR893aSrQtzuTTBNCtVsWTlQ==
X-Received: by 2002:ac8:6d0c:: with SMTP id o12mr8563160qtt.74.1565272045090;
        Thu, 08 Aug 2019 06:47:25 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id r189sm42039415qkc.60.2019.08.08.06.47.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 06:47:23 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id C199340340; Thu,  8 Aug 2019 10:47:21 -0300 (-03)
Date:   Thu, 8 Aug 2019 10:47:21 -0300
To:     Thomas Richter <tmricht@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        brueckner@linux.ibm.com, gor@linux.ibm.com,
        heiko.carstens@de.ibm.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] perf/record: Fix module size on s390
Message-ID: <20190808134721.GF19444@kernel.org>
References: <20190724122703.3996-1-tmricht@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724122703.3996-1-tmricht@linux.ibm.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Wed, Jul 24, 2019 at 02:27:02PM +0200, Thomas Richter escreveu:
> On s390 the modules loaded in memory have the text segment
> located after the GOT and Relocation table. This can be seen
> with this output:
>   [root@m35lp76 perf]# fgrep qeth /proc/modules
>   qeth 151552 1 qeth_l2, Live 0x000003ff800b2000
>   ...
>   [root@m35lp76 perf]# cat /sys/module/qeth/sections/.text
>   0x000003ff800b3990
>   [root@m35lp76 perf]#

Thanks, applied.

- Arnaldo
 
> There is an offset of 0x1990 bytes. The size of the qeth module
> is 151552 bytes (0x25000 in hex).
> The location of the GOT/relocation table at the beginning of a
> module is unique to s390.
> 
> commit 203d8a4aa6ed ("perf s390: Fix 'start' address of module's map")
> adjusts the start address of a module in the map structures, but
> does not adjust the size of the modules. This leads to overlapping
> of module maps as this example shows:
> 
> [root@m35lp76 perf] # ./perf report -D
>      0 0 0xfb0 [0xa0]: PERF_RECORD_MMAP -1/0: [0x3ff800b3990(0x25000)
>           @ 0]:  x /lib/modules/.../qeth.ko.xz
>      0 0 0x1050 [0xb0]: PERF_RECORD_MMAP -1/0: [0x3ff800d85a0(0x8000)
>           @ 0]:  x /lib/modules/.../ip6_tables.ko.xz
> 
> The module qeth.ko has an adjusted start address modified to b3990,
> but its size is unchanged and the module ends at 0x3ff800d8990.
> This end address overlaps with the next modules start address of
> 0x3ff800d85a0.
> 
> When the size of the leading GOT/Relocation table stored in the
> beginning of the text segment (0x1990 bytes) is subtracted from
> module qeth end address, there are no overlaps anymore:
> 
>    0x3ff800d8990 - 0x1990 = 0x0x3ff800d7000
> 
> which is the same as
> 
>    0x3ff800b2000 + 0x25000 = 0x0x3ff800d7000.
> 
> To fix this issue, also adjust the modules size in function
> arch__fix_module_text_start(). Add another function parameter
> named size and reduce the size of the module when the text segment
> start address is changed.
> 
> Output after:
>      0 0 0xfb0 [0xa0]: PERF_RECORD_MMAP -1/0: [0x3ff800b3990(0x23670)
>           @ 0]:  x /lib/modules/.../qeth.ko.xz
>      0 0 0x1050 [0xb0]: PERF_RECORD_MMAP -1/0: [0x3ff800d85a0(0x7a60)
>           @ 0]:  x /lib/modules/.../ip6_tables.ko.xz
> 
> Fixes: 203d8a4aa6ed ("perf s390: Fix 'start' address of module's map")
> Cc: <stable@vger.kernel.org> # v4.9+
> Reported-by: Stefan Liebler <stli@linux.ibm.com>
> Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
> Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  tools/perf/arch/s390/util/machine.c | 14 +++++++++++++-
>  tools/perf/util/machine.c           |  3 ++-
>  tools/perf/util/machine.h           |  2 +-
>  3 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/arch/s390/util/machine.c b/tools/perf/arch/s390/util/machine.c
> index a19690a17291..de26b1441a48 100644
> --- a/tools/perf/arch/s390/util/machine.c
> +++ b/tools/perf/arch/s390/util/machine.c
> @@ -7,7 +7,7 @@
>  #include "api/fs/fs.h"
>  #include "debug.h"
>  
> -int arch__fix_module_text_start(u64 *start, const char *name)
> +int arch__fix_module_text_start(u64 *start, u64 *size, const char *name)
>  {
>  	u64 m_start = *start;
>  	char path[PATH_MAX];
> @@ -17,6 +17,18 @@ int arch__fix_module_text_start(u64 *start, const char *name)
>  	if (sysfs__read_ull(path, (unsigned long long *)start) < 0) {
>  		pr_debug2("Using module %s start:%#lx\n", path, m_start);
>  		*start = m_start;
> +	} else {
> +		/* Successful read of the modules segment text start address.
> +		 * Calculate difference between module start address
> +		 * in memory and module text segment start address.
> +		 * For example module load address is 0x3ff8011b000
> +		 * (from /proc/modules) and module text segment start
> +		 * address is 0x3ff8011b870 (from file above).
> +		 *
> +		 * Adjust the module size and subtract the GOT table
> +		 * size located at the beginning of the module.
> +		 */
> +		*size -= (*start - m_start);
>  	}
>  
>  	return 0;
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index dc7aafe45a2b..081fe4bdebaa 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1365,6 +1365,7 @@ static int machine__set_modules_path(struct machine *machine)
>  	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path, 0);
>  }
>  int __weak arch__fix_module_text_start(u64 *start __maybe_unused,
> +				u64 *size __maybe_unused,
>  				const char *name __maybe_unused)
>  {
>  	return 0;
> @@ -1376,7 +1377,7 @@ static int machine__create_module(void *arg, const char *name, u64 start,
>  	struct machine *machine = arg;
>  	struct map *map;
>  
> -	if (arch__fix_module_text_start(&start, name) < 0)
> +	if (arch__fix_module_text_start(&start, &size, name) < 0)
>  		return -1;
>  
>  	map = machine__findnew_module_map(machine, start, name);
> diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
> index f70ab98a7bde..7aa38da26427 100644
> --- a/tools/perf/util/machine.h
> +++ b/tools/perf/util/machine.h
> @@ -222,7 +222,7 @@ struct symbol *machine__find_kernel_symbol_by_name(struct machine *machine,
>  
>  struct map *machine__findnew_module_map(struct machine *machine, u64 start,
>  					const char *filename);
> -int arch__fix_module_text_start(u64 *start, const char *name);
> +int arch__fix_module_text_start(u64 *start, u64 *size, const char *name);
>  
>  int machine__load_kallsyms(struct machine *machine, const char *filename);
>  
> -- 
> 2.21.0

-- 

- Arnaldo
