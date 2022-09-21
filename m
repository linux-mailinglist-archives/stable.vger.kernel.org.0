Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B767E5BFF14
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 15:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiIUNnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 09:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiIUNnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 09:43:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A4D40569
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 06:43:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 471AEB82FC1
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 13:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117FAC433D7
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 13:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663767818;
        bh=Gmuw7RYv066IxRae4zmwgZqYaBan3eu2R7Ak+x42SkI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=epzRSJ0jyAlPZ16JH3+XPj16W+fgflBh69EoIUoCn+iYNALhGhq0EGN7hyvK6/xnz
         tCrpO2MgL9f/JKcaFVIpdYkwWnKD81N8BqNwoKaIfVpULQLmOvz2ZVdroMjawrta0o
         ltKZ/KorHpLGLupVh7L0N+yDipDQXa6ThxHz29DxoZb9DXxNv+/aKxvEEYH4WGYHYT
         oaAootsA0LfuR1MUG3VujCM5P1GmGhokDptfnnqRKL295GKdkC9Z7vl9faJN982WEV
         SSAWusvTxydhhjpXEPqqtH0teulP5+KXcoBUaMngLqObOmac7yPzK5i/UYTPtLUnEo
         byWIA2B/BIBDA==
Received: by mail-lf1-f51.google.com with SMTP id o2so9259584lfc.10
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 06:43:37 -0700 (PDT)
X-Gm-Message-State: ACrzQf10mcexbRdDAbfV0HO59fE1cPls345QFNXPJ3qxyCJQ0YgpI5Ub
        0EWBQCMIBJANavmL1GZQGy9BKB5H2b6sK7s+eQUAng==
X-Google-Smtp-Source: AMsMyM79gcUQDdS+aheFYCBSJgkOeTa2g6z7vtIVxydF5XAVlYV8l3YcMmi9Yn+KvZ/xQuuFPV3NVrj9PpUfx7TqFJ4=
X-Received: by 2002:a2e:920a:0:b0:26c:f7b:95db with SMTP id
 k10-20020a2e920a000000b0026c0f7b95dbmr9324650ljg.156.1663767805783; Wed, 21
 Sep 2022 06:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220920075951.929132-1-roberto.sassu@huaweicloud.com> <20220920075951.929132-3-roberto.sassu@huaweicloud.com>
In-Reply-To: <20220920075951.929132-3-roberto.sassu@huaweicloud.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Wed, 21 Sep 2022 15:43:14 +0200
X-Gmail-Original-Message-ID: <CACYkzJ7or3+zwZShXC7TdzhSbN4O9wEk6KEkbRBFh85=HZ87PQ@mail.gmail.com>
Message-ID: <CACYkzJ7or3+zwZShXC7TdzhSbN4O9wEk6KEkbRBFh85=HZ87PQ@mail.gmail.com>
Subject: Re: [PATCH v18 02/13] btf: Export bpf_dynptr definition
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, mykolal@fb.com, dhowells@redhat.com,
        jarkko@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        shuah@kernel.org, bpf@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        deso@posteo.net, memxor@gmail.com,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 20, 2022 at 10:01 AM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> From: Roberto Sassu <roberto.sassu@huawei.com>
>
> eBPF dynamic pointers is a new feature recently added to upstream. It binds
> together a pointer to a memory area and its size. The internal kernel
> structure bpf_dynptr_kern is not accessible by eBPF programs in user space.
> They instead see bpf_dynptr, which is then translated to the internal
> kernel structure by the eBPF verifier.
>
> The problem is that it is not possible to include at the same time the uapi
> include linux/bpf.h and the vmlinux BTF vmlinux.h, as they both contain the
> definition of some structures/enums. The compiler complains saying that the
> structures/enums are redefined.
>
> As bpf_dynptr is defined in the uapi include linux/bpf.h, this makes it
> impossible to include vmlinux.h. However, in some cases, e.g. when using
> kfuncs, vmlinux.h has to be included. The only option until now was to
> include vmlinux.h and add the definition of bpf_dynptr directly in the eBPF
> program source code from linux/bpf.h.
>
> Solve the problem by using the same approach as for bpf_timer (which also
> follows the same scheme with the _kern suffix for the internal kernel
> structure).
>
> Add the following line in one of the dynamic pointer helpers,
> bpf_dynptr_from_mem():
>
> BTF_TYPE_EMIT(struct bpf_dynptr);
>
> Cc: stable@vger.kernel.org
> Cc: Joanne Koong <joannelkoong@gmail.com>
> Fixes: 97e03f521050c ("bpf: Add verifier support for dynptrs")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Acked-by: Yonghong Song <yhs@fb.com>

I tested this out and it works, however for the BPF signing use case
where "bpf_dynptr_kern" is added to struct bpf_prog_aux one still
ends up defining the __ksym extern with bpf_dynptr_kern.

But let's discuss that when the series is posted.

Tested-by: KP Singh <kpsingh@kernel.org>
