Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7301865654B
	for <lists+stable@lfdr.de>; Mon, 26 Dec 2022 23:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbiLZWZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Dec 2022 17:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiLZWZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Dec 2022 17:25:29 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9E1E2F;
        Mon, 26 Dec 2022 14:25:27 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id vm8so21448443ejc.2;
        Mon, 26 Dec 2022 14:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xRfFb+jDncZJITtB1Bb9o85UZmJn4oE/UuBZZvsjKV4=;
        b=hi3hPF3S7s96s6ST6EVu//NokVS89sHKDSHNin27/znN2G9WBnNKv9FyarprLZRmb4
         7EHw0VeJ6f1OuBZApL/DDinjsZukwPetLJtQa8Y0VuaH2wSic9s3YzxC2wnvlOiw6S6z
         V7g7wuFOH8YDvOe7rg81a/5O/5jObfsvxlMzOlNLimW8dPLyL2T0f9X9zai+mPW0YJR6
         N32Yqt4zzmaTx2B0JqkzEOzlU35v4U8+YKTsez+sVfTKUDV7LRsqIotvbJVI4OkQKJbC
         jbYnapjRY+vng/W8M2CERGBfzgazhQzfV5spWeoT3eTNhtPHoMkIGZBcKw0v30iLYcby
         GIIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRfFb+jDncZJITtB1Bb9o85UZmJn4oE/UuBZZvsjKV4=;
        b=obH9S+dT0xlGqjmPt4m95OThzb2KJ+Fdt0rrRP/+4ZaVQhvX9DXot4MnG/W4TpM34z
         h/BuYrmqsbJonmLkAP+2nf5hJKApDTnc6zjpovzAkP/XJRiw+08RzpucJLyRjaeTFDLo
         jVslgiNPPsEAZ8ODSxhn/4uH8okVkJCuXdkEBc1eCC+HBk4NhmNFsqC6tZEC3PcxSQiH
         etblnPaKbQm4Z058za1axlCfOTdjD07OB7gj6Xru9f480QXTt/LAIQN6jVOPKOnF0Dw0
         UuRXyeYKnnTgm3PJ8jpFWjPjXE2H/DSFbnfoCsWWrwU15T/bRTPOd87eAD1e8f6PEywB
         98Yg==
X-Gm-Message-State: AFqh2kr4poNK+LpXLk0zTsD7upu8QcR+X9lPwFKrIijzjrgz/yCWooHz
        T2xBaO9OC/dj/iO7BrGHScM=
X-Google-Smtp-Source: AMrXdXvosqkLxKRrJA7QTYeB6J66x/p5JsehQ4MORzG7VTFWag1xwe3xMox5JNrEswCLBce5Zc9Ztg==
X-Received: by 2002:a17:907:7676:b0:7c1:5b5e:4d86 with SMTP id kk22-20020a170907767600b007c15b5e4d86mr16895282ejc.36.1672093526260;
        Mon, 26 Dec 2022 14:25:26 -0800 (PST)
Received: from krava ([83.240.62.89])
        by smtp.gmail.com with ESMTPSA id o21-20020a170906769500b007b935641971sm5253904ejm.5.2022.12.26.14.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 14:25:25 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 26 Dec 2022 23:25:23 +0100
To:     Chuang Wang <nashuiliang@gmail.com>
Cc:     stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bpf: Fix panic due to wrong pageattr of im->image
Message-ID: <Y6ofUzLHZKraIDre@krava>
References: <20221224133146.780578-1-nashuiliang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221224133146.780578-1-nashuiliang@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 24, 2022 at 09:31:46PM +0800, Chuang Wang wrote:
> In the scenario where livepatch and kretfunc coexist, the pageattr of
> im->image is rox after arch_prepare_bpf_trampoline in
> bpf_trampoline_update, and then modify_fentry or register_fentry returns
> -EAGAIN from bpf_tramp_ftrace_ops_func, the BPF_TRAMP_F_ORIG_STACK flag
> will be configured, and arch_prepare_bpf_trampoline will be re-executed.
> 
> At this time, because the pageattr of im->image is rox,
> arch_prepare_bpf_trampoline will read and write im->image, which causes
> a fault. as follows:
> 
>   insmod livepatch-sample.ko    # samples/livepatch/livepatch-sample.c
>   bpftrace -e 'kretfunc:cmdline_proc_show {}'
> 
> BUG: unable to handle page fault for address: ffffffffa0206000
> PGD 322d067 P4D 322d067 PUD 322e063 PMD 1297e067 PTE d428061
> Oops: 0003 [#1] PREEMPT SMP PTI
> CPU: 2 PID: 270 Comm: bpftrace Tainted: G            E K    6.1.0 #5
> RIP: 0010:arch_prepare_bpf_trampoline+0xed/0x8c0
> RSP: 0018:ffffc90001083ad8 EFLAGS: 00010202
> RAX: ffffffffa0206000 RBX: 0000000000000020 RCX: 0000000000000000
> RDX: ffffffffa0206001 RSI: ffffffffa0206000 RDI: 0000000000000030
> RBP: ffffc90001083b70 R08: 0000000000000066 R09: ffff88800f51b400
> R10: 000000002e72c6e5 R11: 00000000d0a15080 R12: ffff8880110a68c8
> R13: 0000000000000000 R14: ffff88800f51b400 R15: ffffffff814fec10
> FS:  00007f87bc0dc780(0000) GS:ffff88803e600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffa0206000 CR3: 0000000010b70000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
>  bpf_trampoline_update+0x25a/0x6b0
>  __bpf_trampoline_link_prog+0x101/0x240
>  bpf_trampoline_link_prog+0x2d/0x50
>  bpf_tracing_prog_attach+0x24c/0x530
>  bpf_raw_tp_link_attach+0x73/0x1d0
>  __sys_bpf+0x100e/0x2570
>  __x64_sys_bpf+0x1c/0x30
>  do_syscall_64+0x5b/0x80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> With this patch, when modify_fentry or register_fentry returns -EAGAIN
> from bpf_tramp_ftrace_ops_func, the pageattr of im->image will be reset
> to nx+rw.
> 
> Cc: stable@vger.kernel.org
> Fixes: 00963a2e75a8 ("bpf: Support bpf_trampoline on functions with IPMODIFY (e.g. livepatch)")
> Signed-off-by: Chuang Wang <nashuiliang@gmail.com>

Acked-by: Jiri Olsa <jolsa@kernel.org>

jirka

> ---
>  kernel/bpf/trampoline.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 11f5ec0b8016..d0ed7d6f5eec 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -488,6 +488,10 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mut
>  		/* reset fops->func and fops->trampoline for re-register */
>  		tr->fops->func = NULL;
>  		tr->fops->trampoline = 0;
> +
> +		/* reset im->image memory attr for arch_prepare_bpf_trampoline */
> +		set_memory_nx((long)im->image, 1);
> +		set_memory_rw((long)im->image, 1);
>  		goto again;
>  	}
>  #endif
> -- 
> 2.37.2
> 
