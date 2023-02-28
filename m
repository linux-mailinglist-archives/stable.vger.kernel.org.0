Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD9E6A604E
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 21:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjB1UWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 15:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjB1UWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 15:22:22 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F2734F7B
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 12:22:06 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id oj5so7105707pjb.5
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 12:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677615726;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ojztN1JHgLgNPqjg633jufqvjWU5kAhQkRoQqn8IJ4o=;
        b=pjBFe543ePXy/CPW2DG7kBV0BB7XxaEWy+IPlMO4jSFcoCGuuUWQpgoTCY7iHoKIe4
         D1reToK6ASaQdT/KKAECA5OXeVor1Ljho/+bEHdO1a8oozLm3YQqcSboDahmPS2Rd8QK
         fjTrh4vDLEamvT39R6q6/sXo6Ti+uRF5D2iKkXXBmByIe5okjlr8J9UWiu4xHluhj6Z8
         fAmK+mIImfeqBt2oKI1s0/ZURo5kMmd05gQDfrAN7Ypv4OkY2Py9kHF95XvZOOtNhNPU
         xMTly6hQyzFzO4jbo+vdhdOk18BAo6BOYEfj1+0Oe/96S0+Itnz1YrmoyzhSB1MgPyZd
         c2ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677615726;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ojztN1JHgLgNPqjg633jufqvjWU5kAhQkRoQqn8IJ4o=;
        b=2wlMqaj0lsxwaVroWJO2pGWhPIx6mDBGIaXnF9zHRvLDdOWRR11GVHIw1UYv2zY29O
         gNE/t+yZIX1kWgp7Pt0PgBuRTPbcLum1xUtif3x41EMU7NHhDo3aKao4gRu8X5KzY8pL
         hVxmyuB4HiMdw92x/kFDd7B7H5LDcY7xs8Vg/wm9jp2GP7dDdJKkBn9E1ntr79GocWdN
         mSic6Qlgs4nfjBKljxV2vfbGKJE5f41MsEQIY+T4b647f/36LWiYoPzbNyExyc/JCRGH
         E8BJYhrM/OAvQtvwhWvuA/UMjaP+qDscDYxF0+CwGBnj1OEFDW8cyftI6b5/5bPwn0/F
         iKNA==
X-Gm-Message-State: AO0yUKWmzggo35O867B/JAG9Akm9OTUf/vffYEnWYHGycxCmvnvxjfAg
        qCT7PkJ0EdWfdo5qu1+OBKMZ/3LSVdFDsHe7xWI=
X-Google-Smtp-Source: AK7set/vQWvEhrNuCSEQGKsDL6VvzSHE/4CkmJOQtIq9lcePxK1oevvJS8nzKio/wj5OhTbr2WefWA==
X-Received: by 2002:a05:6a20:8f06:b0:cc:fced:f715 with SMTP id b6-20020a056a208f0600b000ccfcedf715mr5673011pzk.22.1677615725439;
        Tue, 28 Feb 2023 12:22:05 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h16-20020aa786d0000000b005a8f1d76d46sm6637021pfo.13.2023.02.28.12.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 12:22:04 -0800 (PST)
Date:   Tue, 28 Feb 2023 20:22:01 +0000
From:   Carlos Llamas <cmllamas@google.com>
To:     gregkh@linuxfoundation.org
Cc:     cristian.ciocaltea@collabora.com, masahiroy@kernel.org,
        vipinsh@google.com, xujialu@vimux.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] scripts/tags.sh: fix incompatibility with
 PCRE2" failed to apply to 5.10-stable tree
Message-ID: <Y/5iaTgPlb1pwql2@google.com>
References: <1677610177155186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1677610177155186@kroah.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 07:49:37PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> 6ec363fc6142 ("scripts/tags.sh: fix incompatibility with PCRE2")
> 7394d2ebb651 ("scripts/tags.sh: Invoke 'realpath' via 'xargs'")
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 6ec363fc6142226b9ab5a6528f65333d729d2b6b Mon Sep 17 00:00:00 2001
> From: Carlos Llamas <cmllamas@google.com>
> Date: Wed, 15 Feb 2023 18:38:50 +0000
> Subject: [PATCH] scripts/tags.sh: fix incompatibility with PCRE2
> 
> Starting with release 10.38 PCRE2 drops default support for using \K in
> lookaround patterns as described in [1]. Unfortunately, scripts/tags.sh
> relies on such functionality to collect all_compiled_soures() leading to
> the following error:
> 
>   $ make COMPILED_SOURCE=1 tags
>     GEN     tags
>   grep: \K is not allowed in lookarounds (but see PCRE2_EXTRA_ALLOW_LOOKAROUND_BSK)
> 
> The usage of \K for this pattern was introduced in commit 4f491bb6ea2a
> ("scripts/tags.sh: collect compiled source precisely") which speeds up
> the generation of tags significantly.
> 
> In order to fix this issue without compromising the performance we can
> switch over to an equivalent sed expression. The same matching pattern
> is preserved here except \K is replaced with a backreference \1.
> 
> [1] https://www.pcre.org/current/doc/html/pcre2syntax.html#SEC11
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Jialu Xu <xujialu@vimux.org>
> Cc: Vipin Sharma <vipinsh@google.com>
> Cc: stable@vger.kernel.org
> Fixes: 4f491bb6ea2a ("scripts/tags.sh: collect compiled source precisely")
> Signed-off-by: Carlos Llamas <cmllamas@google.com>
> Link: https://lore.kernel.org/r/20230215183850.3353198-1-cmllamas@google.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 1ad45f17179a..6b9001853890 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -98,7 +98,7 @@ all_compiled_sources()
>  	{
>  		echo include/generated/autoconf.h
>  		find $ignore -name "*.cmd" -exec \
> -			grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
> +			sed -n -E 's/^source_.* (.*)/\1/p; s/^  (\S.*) \\/\1/p' {} \+ |
>  		awk '!a[$0]++'
>  	} | xargs realpath -esq $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) |
>  	sort -u
> 

Hi Greg,

This patch would be needed in 5.10+ branches. Instead of backporting it,
I think is better to pick the "xargs" fix too. So can you please take
the following two commits for 5.10 and 5.15? I've verified they both
apply and work as expected with new PCRE2.

7394d2ebb651 ("scripts/tags.sh: Invoke 'realpath' via 'xargs'")
6ec363fc6142 ("scripts/tags.sh: fix incompatibility with PCRE2")

Thanks,
Carlos Llamas
