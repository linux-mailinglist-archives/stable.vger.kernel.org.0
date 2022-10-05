Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C195F5D00
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 01:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiJEXCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 19:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJEXCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 19:02:39 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51D085599;
        Wed,  5 Oct 2022 16:02:36 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 63so342057ybq.4;
        Wed, 05 Oct 2022 16:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L7ufU5NJZ1m5iRvOEgBPFkIANRERx7whw7EOLnWZahg=;
        b=k8uPcu7u+JSMjPJ10LB7tmG2Wunjo9xJkXKMm2Err/usFhtZr+sEaiQ/3LNWCwo9M3
         HV/Gu/eODY/YWme6iPaHG7GjSCHSx7FpyBWNxbDJTXCNHANHK2qNuSw80SCmtbOdB7Al
         e3vlpX/lK+GEaOLx8/pyHhcdAxVmnEM0J4fU05J6nk+xrR9tGx9xZxlLBGKzNm61+pdS
         c7RwBrI1J5NisiK+mIIjCAiuKDTNiSjt13x4EGtgibV6U9in0e2kJCnIBBmkofd2QsTi
         Wadppnhar/U2fyRSNpF5qYJbhkAmRQHHigwz82pEMXMWtOYNb/9VOvOeq9K7KaeI3kgF
         midw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L7ufU5NJZ1m5iRvOEgBPFkIANRERx7whw7EOLnWZahg=;
        b=NxUc5XqIuw6mNNXJ73SJUdywa4YzP14pY5SQt93SJMU2oBbUNZjQZdqYQLVxfriodu
         Mr/gV39lrgFMI6sh88de2zMgw3IGsOGUAZZL4XAfp3vB+zyhnmbO6iq2VwDaOt1jVVkS
         2lhc7e4SAp3c9lFXuYet+fAQw9Lt1k2+6yqZ90L7v1ovusDDgI3NDgy8XksY72x0fnDT
         LB+YeYyklNu40ADKyzt5aci/YTim4XKh00iS09sR27b8IShroWwsz5CIhouxizw1cj6F
         qVDjqKfgfU1AQPbLxN0mZM2xkiUjmZzRnQWfk8iP9qBnBL/IIQIbclsvpM3ZccThXYIt
         PzHQ==
X-Gm-Message-State: ACrzQf0PiITVc1TvU9s0w0QZ2xCNZ0TafGiFe/2JCPe8E+O+o4N0rDOe
        d40bfv5J+i31wljjLFFp1s6qGoUfRlnF8rFAtaE=
X-Google-Smtp-Source: AMsMyM6TEfE8Y2LkWYa6/+BHsh/IW88Rt1oi0UVBNQpoo2Nkmg+SgLGCHDnE1by2VXt60s37ZBKH3wEwB874AnG6wYM=
X-Received: by 2002:a25:1042:0:b0:6bb:f807:aa04 with SMTP id
 63-20020a251042000000b006bbf807aa04mr2202432ybq.639.1665010956061; Wed, 05
 Oct 2022 16:02:36 -0700 (PDT)
MIME-Version: 1.0
References: <20221004131750.2306251-1-roberto.sassu@huaweicloud.com> <20221004131750.2306251-2-roberto.sassu@huaweicloud.com>
In-Reply-To: <20221004131750.2306251-2-roberto.sassu@huaweicloud.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Oct 2022 16:02:23 -0700
Message-ID: <CAEf4BzaeOknT5d_ziidov3UXMZD40WCVHFamqC2_eH9nAUNUYQ@mail.gmail.com>
Subject: Re: [RESEND][PATCH 1/6] libbpf: Fix LIBBPF_1.0.0 declaration in libbpf.map
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, mykolal@fb.com,
        shuah@kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 4, 2022 at 6:18 AM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> From: Roberto Sassu <roberto.sassu@huawei.com>
>
> Add the missing LIBBPF_0.8.0 at the end of the LIBBPF_1.0.0 declaration,
> similarly to other version declarations.
>
> Cc: stable@vger.kernel.org # 5.19.x

there is no need to backport this, libbpf has its own release cycle
and it is released from github mirror. And also this doesn't have any
effect, this inheritance between versions in .map file is mostly for
humans, according [0] (and I checked in practice that it doesn't
change anything for libbpf).

So it's good to fix, but no need to bother maintainers to backport it
to stable branches.

  [0] https://www.akkadia.org/drepper/dsohowto.pdf

> Fixes: e2371b1632b1c ("libbpf: start 1.0 development cycle")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  tools/lib/bpf/libbpf.map | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index c1d6aa7c82b6..04fab9f1fdd7 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -367,7 +367,7 @@ LIBBPF_1.0.0 {
>                 libbpf_bpf_map_type_str;
>                 libbpf_bpf_prog_type_str;
>                 perf_buffer__buffer;
> -};
> +} LIBBPF_0.8.0;
>
>  LIBBPF_1.1.0 {
>         global:
> --
> 2.25.1
>
