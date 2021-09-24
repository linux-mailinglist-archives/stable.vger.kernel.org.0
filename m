Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19578416D90
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 10:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244659AbhIXIVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 04:21:07 -0400
Received: from mout.gmx.net ([212.227.17.21]:57777 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244581AbhIXIVG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 04:21:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632471485;
        bh=C777DmMNW5eFDnLiRSawdY+pQLiqLPZy/xITCio022Y=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=iBnmuJjEIdWjIMXv4M764Ql30gX9rM+bLX2x305od8qctpqHa/t86lw2sQh4GxIU3
         b7Y6grtcw+QV2f0V+sBUNz5fYUaZyKrkXOzJtcJqQ0noFj/aQjVpqQ1ZzLjBNeFZX5
         AvgqoiwrTh+nytOtUbqajzzskW4HfAy/Hhx6ZOfE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.164.225]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N95iR-1mxdyU18OF-0168Pm; Fri, 24
 Sep 2021 10:18:05 +0200
Subject: Re: [PATCH 1/3] Revert "proc/wchan: use printk format instead of
 lookup_symbol_name()"
To:     Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     kernel test robot <oliver.sang@intel.com>,
        Vito Caputo <vcaputo@pengaru.com>,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Tobin C. Harding" <me@tobin.cc>,
        Tycho Andersen <tycho@tycho.pizza>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Stefan Metzmacher <metze@samba.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Michal Hocko <mhocko@suse.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ohhoon Kwon <ohoono.kwon@samsung.com>,
        YiFei Zhu <yifeifz2@illinois.edu>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        x86@kernel.org, linux-fsdevel@vger.kernel.org
References: <20210924062006.231699-1-keescook@chromium.org>
 <20210924062006.231699-2-keescook@chromium.org>
From:   Helge Deller <deller@gmx.de>
Message-ID: <16ebd28d-9d99-d217-c62f-03d7c158ac84@gmx.de>
Date:   Fri, 24 Sep 2021 10:17:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210924062006.231699-2-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:juNbC6f/1V5binVA0KJ+XuiJKiYMyApey/Ddho5X3mMoBMfQwDk
 TuA2vwTlZ22jHEaxbKGfwAnXqMNEJcq7lcTE1z6JlIZfoqoB6wwJKwPPPnvo4ASROGCGJ9S
 2FexoaDzFAtZ14qC0PhsAK2wZDuJh2HJzMF2UFSOv+z0v3j/3h/jleoXbMW9zOIScnf9ata
 /QBIa5jJW66aBl8CifzMA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XPWXjf+Xlr0=:vwBxSfjavDx3REh940xA63
 Hs1OcsjOsenOWFYHMemjan1JseBv+dLI6jVHYABszdCOPNnRuIs9a1fuTNal/oe2JsEDClm0R
 Ij9zv17urwqhMSNRORqPVZ5eYknWjXljLtsckeaXskXjwOr+i8Lte0S5SKyCWkS1n1UQHX4Xd
 7C6wqnXKARnbzyrkiVGlTVe6pm+kjgcZttYxhUfp+y3MoyGMw37XrUxHByBynTRuA6c21ledO
 OhzCHC/lACgaQYIYYxadSbhCVOU6IiUrCBBiW1np27Mz0ImwFno/oWO+9etzoHKaRmNl/0Hmb
 IZWE/abNUQuqMEUPpPw93i/fydM+hgId5Vkq+uSwX6k6OSuMlEClf3SHvNWXIhfD5km45RebJ
 VqFjvx1zW0xQu+gmljFuAEoWH0oSQR1AKGCge3DsAsYKODoQaFY6G3aGVhbMDP7rsGX2YvxEi
 cOWufHhrCqbqkhKqpgtyotx8y5xfbDWFieJIGobKUPfjJS/z0vJqXLeL+JB4+8Nxm4EbgP71S
 HRsi/X4mLgAZ3V0yv6WJUXbJf5U2l9HE4ozvk4hFVcB0tP9XhSSLceLGMV/u2+GCLzII3/imj
 lF3JXXngzziQAQldL+6wKK+Qz9ImV64LaQQSMNF6Gedt6quESPLU1GfEOtpMq9jlOqtbdQs2+
 j2LtXE8ZtJHTMBe131eBMg8m2fAaidASyzQr/zAWn362fvNKnwFzFT9EhIgH8d3BfAYBTRtnu
 EUlx+AHHMmmP8cdCXoDRz8zuLc0oyD1bZUhTY36DJ4vXKDwYe3qYfKJqXTF4YUWhXVO9tdHFT
 pxvKMfFExEIQL2Ro/naobDhuIw3h8GfDfXMj12Q4DBqg5ppmFpATx0OND3CtoGhEqtLNoVhPp
 6Eth3irNiSGv1yZlZL9hWcJS5FJ58T2eXccp5fM+NEafWC08GERPpF305TK9Zsq5o8dd2iHsi
 CS61OnJApUnywQRVbs7k5IFL/7S+yyTZ9UyyhXIP8ixTBrs3dzzG7sU5svUuyRYMgpu8sfuMp
 scTjV1wGCDFSVnozCCt7Cy+XPHPOqOb2zZ9jk8V0LTI7zq3jLVqey8M4BYQs6iat52LqJUY44
 hOEEO/8sARmMWY=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/24/21 8:20 AM, Kees Cook wrote:
> This reverts commit 152c432b128cb043fc107e8f211195fe94b2159c.
>
> When a kernel address couldn't be symbolized for /proc/$pid/wchan, it
> would leak the raw value, a potential information exposure. This is a
> regression compared to the safer pre-v5.12 behavior.

Instead of reverting, another possibility might be to depend on
CONFIG_KALLSYMS before using the %ps format specifier and print "0" otherw=
ise.
If it can't be symbolized it's most likely not a valid kernel address
and as such wouldn't leak anything....
But well,
Acked-by: Helge Deller <deller@gmx.de>

Helge

> Reported-by: kernel test robot <oliver.sang@intel.com>
> Link: https://lore.kernel.org/all/20210103142726.GC30643@xsang-OptiPlex-=
9020/
> Reported-by: Vito Caputo <vcaputo@pengaru.com>
> Link: https://lore.kernel.org/lkml/20210921193249.el476vlhg5k6lfcq@shell=
s.gnugeneration.com/
> Reported-by: Jann Horn <jannh@google.com>
> Link: https://lore.kernel.org/lkml/CAG48ez2zC=3D+PuNgezH53HBPZ8CXU5H=3Dv=
kWx7nJs60G8RXt3w0Q@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   fs/proc/base.c | 19 +++++++++++--------
>   1 file changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 533d5836eb9a..1f394095eb88 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -67,6 +67,7 @@
>   #include <linux/mm.h>
>   #include <linux/swap.h>
>   #include <linux/rcupdate.h>
> +#include <linux/kallsyms.h>
>   #include <linux/stacktrace.h>
>   #include <linux/resource.h>
>   #include <linux/module.h>
> @@ -386,17 +387,19 @@ static int proc_pid_wchan(struct seq_file *m, stru=
ct pid_namespace *ns,
>   			  struct pid *pid, struct task_struct *task)
>   {
>   	unsigned long wchan;
> +	char symname[KSYM_NAME_LEN];
>
> -	if (ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
> -		wchan =3D get_wchan(task);
> -	else
> -		wchan =3D 0;
> +	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
> +		goto print0;
>
> -	if (wchan)
> -		seq_printf(m, "%ps", (void *) wchan);
> -	else
> -		seq_putc(m, '0');
> +	wchan =3D get_wchan(task);
> +	if (wchan && !lookup_symbol_name(wchan, symname)) {
> +		seq_puts(m, symname);
> +		return 0;
> +	}
>
> +print0:
> +	seq_putc(m, '0');
>   	return 0;
>   }
>   #endif /* CONFIG_KALLSYMS */
>

