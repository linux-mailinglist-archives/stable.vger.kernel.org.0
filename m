Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AFD60C71B
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 11:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbiJYJBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 05:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiJYJBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 05:01:11 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3236E15625D;
        Tue, 25 Oct 2022 02:01:10 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id y69so16199456ede.5;
        Tue, 25 Oct 2022 02:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wLIAvmAFWA52Brg4JWhyZq0dx28rQeW46BFdke4ZXzQ=;
        b=Xapotkqqbc4nmBLLTFWP8tn3kN2CT/ecfjCvSAUptRmHFb3A6/bCY2Gks3tTFbsXF6
         D20bWElWxiZWhgr/b7kvPGdBuHWHcDmcDniWRjN3TTwBZvenzbRDmIk2VGl8bB8MLOhw
         g6I1fKMyYdD1mjfvVVeBmeB8m9XOQXoQ+6FDQBifk7klDnR1Qw1gqzaBVKf61u2LurWu
         +5CoVabaHNjlQ+yhtygaz6NZx4jfzfayP41VqRNZaHWyNs8bhipGqI0KKmVOP7b43PrQ
         fJOagP4Cu1qtmVknbLuN2O57HF7UnJf7k9kNROvgWo25PJrDNuuDZ9TbIcFA/VvTSWGm
         9FNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wLIAvmAFWA52Brg4JWhyZq0dx28rQeW46BFdke4ZXzQ=;
        b=cnA0e3YJEc3aMqB3KUbL4I1/4dMbFhcL1j7f/Bt8X7rgaTAR9p6VU8uY0cWBacTJqU
         yOQ3+DOHPp3cO1MoRs6H3fELagn09f9013Mu2+dwjHGQS4+rhmjzCUvLARVHKUUAQcAz
         8UY6Y057IciZFePa1PhFMN9vdDaPHtBi3yTbk4qMDVt9SFIf3qOYbrHn91y7O7VzSLFe
         3LlkPXWubzRhB3jqLpYYMOMujHpawhXeCszupolrM0oEzTvQHbJ55gJsT6WAyXxw3r+A
         PFu4lQ46Wx8hJk0xUQkTaxe8nlTb6ufSZh4hlO6HkMLgpm9rTQnWz47k/Iwmb/DcvwA5
         W8dw==
X-Gm-Message-State: ACrzQf0Ed+bEbuorP9xuN4FytjgQafedgf90c9dCMa4VG5pdlTnOltII
        yNApd8pCnHxpt6ooiQG0v8U=
X-Google-Smtp-Source: AMsMyM5kss7w95bR0b1CfblNA/LwLPIWVPSYkdln0JiD9EXyZ5hx5Jh4FMc9FVHvc4BtHwOavQIUDA==
X-Received: by 2002:a05:6402:4445:b0:461:b506:de51 with SMTP id o5-20020a056402444500b00461b506de51mr10297577edb.388.1666688468539;
        Tue, 25 Oct 2022 02:01:08 -0700 (PDT)
Received: from krava (2001-1ae9-1c2-4c00-8b88-53b7-c55c-8535.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:8b88:53b7:c55c:8535])
        by smtp.gmail.com with ESMTPSA id x10-20020a1709060eea00b007415f8ffcbbsm1055728eji.98.2022.10.25.02.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 02:01:08 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 25 Oct 2022 11:01:05 +0200
To:     Chuang Wang <nashuiliang@gmail.com>
Cc:     stable@vger.kernel.org, Song Liu <song@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bpf: Clean up all resources when register_fprobe_ips
 returns an error
Message-ID: <Y1el0SXrk8paN1Zm@krava>
References: <20221025080628.523300-1-nashuiliang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025080628.523300-1-nashuiliang@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 25, 2022 at 04:06:28PM +0800, Chuang Wang wrote:
> When register_fprobe_ips returns an error, bpf_link_cleanup just cleans
> up bpf_link_primer's resources and forgets to clean up
> bpf_kprobe_multi_link, addrs, cookies.
> 
> So, by adding 'goto error', this ensures that all resources are cleaned
> up.
> 
> Cc: stable@vger.kernel.org
> Fixes: 0dcac2725406 ("bpf: Add multi kprobe link")
> Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
> ---
>  kernel/trace/bpf_trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 1ed08967fb97..5b806ef20857 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2778,7 +2778,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>  	err = register_fprobe_ips(&link->fp, addrs, cnt);
>  	if (err) {
>  		bpf_link_cleanup(&link_primer);
> -		return err;
> +		goto error;

that should be taken care of bpf_kprobe_multi_link_dealloc,
through the fput path in bpf_link_cleanup

do you see any related memory leak like report in kmemleak?

jirka

>  	}
>  
>  	return bpf_link_settle(&link_primer);
> -- 
> 2.34.1
> 
