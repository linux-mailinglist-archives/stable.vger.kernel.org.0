Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6B75AB6D7
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 18:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbiIBQvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 12:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235888AbiIBQvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 12:51:05 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94841FBA42;
        Fri,  2 Sep 2022 09:51:04 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id m3-20020a05600c3b0300b003a5e0557150so4724919wms.0;
        Fri, 02 Sep 2022 09:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date;
        bh=QNATVCSeiSY8b75vPLlOSvE1KC8ElZ9730A2GbauztE=;
        b=DBw0hnGscpeLLkgdLirle7B7G5XLmURBG/4p4Y1Z1gyr1fhoPDF0vR7JdquCpNNXa9
         y7e4He97VXUnpZa4zZShfPWbslJXwnoE8Lwyiqyl2QvZVdDIane86eyBl6zOVltyDseZ
         CmdC422o0BlQuOR6IJUoPl6Q71Lyjj5ixW/Ot3sJSG/Y1ftB6fhAvTMMZHfbRq8m9BaS
         RSEKCMhkKyx1UNgMtTwHX6mzoM099MSKKVvBCnoN8H9nnBUj6ubKQBFW/G9wUyXQGcw5
         rhOVUiqMf2PFZVVjZ8Rt1BReXwg8DmloFcy+ox3CqG7T/04IRTgWAWS/7qYBq22xbi1Q
         AP0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date;
        bh=QNATVCSeiSY8b75vPLlOSvE1KC8ElZ9730A2GbauztE=;
        b=F0o4uCneIxZizne41uQXQYj0QzYG8h4B3qt3Mm/dSWff+NvcA0zZav5NgfIDlX9jBE
         r9e81aBKCHXIltHbzWuR/fPULbj6XKjM0hkYCCnxLnsQEfMB78pvn4a/Q5Mh4+FWQKpB
         wQlhgJFH5PbvsW8Dc8Fd5sYd9QMiX7qhm2t3FRrIKt9yRr+IRYY9DWbEYYHdT2TboIyn
         bMaBRW+eAxECdMJgLcPXiEoZQu2gytWtQp9OKQIPxXzILybqh/CLG0Lknc4Rp6yxeIKe
         6JSWAs5Bp2cGccEjFKWHVTIYL3U6oDdAKNasy7XbpU++XKPQhF3jCTrJkioTBCyVzNQb
         im+g==
X-Gm-Message-State: ACgBeo30Jxo3WtsXftxqMBsGAHDU19VW3Ou4OUj/cb6XJK7qm9tGDwBm
        19UJzhlI4ufqUwL66NNPAaJdN4uZ5/t0AIop
X-Google-Smtp-Source: AA6agR5R6dqEnTClgH+rTMkn+MLQpf3/fQz3XI9sjZjdWXmKBkCwdqOl5sPiLxjwbHwyIZx74NK81g==
X-Received: by 2002:a05:600c:3509:b0:3a6:1888:a4bd with SMTP id h9-20020a05600c350900b003a61888a4bdmr3528396wmq.191.1662137463007;
        Fri, 02 Sep 2022 09:51:03 -0700 (PDT)
Received: from krava ([46.189.28.51])
        by smtp.gmail.com with ESMTPSA id j4-20020adfe504000000b00226cf855861sm1905254wrm.84.2022.09.02.09.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 09:51:02 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 2 Sep 2022 18:51:00 +0200
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH bpf v2] bpf: Add config for skipping BTF enum64s
Message-ID: <YxI0dO2yuqTK0H6f@krava>
References: <20220828233317.35464-1-yakoyoku@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220828233317.35464-1-yakoyoku@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 28, 2022 at 08:33:17PM -0300, Martin Rodriguez Reboredo wrote:
> After the release of pahole 1.24 some people in the dwarves mailing list
> notified issues related to building the kernel with the BTF_DEBUG_INFO
> option toggled. They seem to be happenning due to the kernel and
> resolve_btfids interpreting btf types erroneously. In the dwarves list
> I've proposed a change to the scripts that I've written while testing
> the Rust kernel, it simply passes the --skip_encoding_btf_enum64 to
> pahole if it has version 1.24.
> 
> v1 -> v2:
> - Switch to off by default and remove the config option.
> - Send it to stable instead.

hi,
we have change that needs to go to stable kernels but does not have the
equivalent fix in Linus tree

what would be the best way to submit it?

the issue is that new 'pahole' will generate BTF data that are not supported
by older kernels, so we need to add --skip_encoding_btf_enum64 option to
stable kernel's scripts/pahole-flags.sh to generate proper BTF data

we got complains that after upgrading to latest pahole the stable kernel
compilation fails

thanks,
jirka


> 
> Signed-off-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> ---
>  scripts/pahole-flags.sh | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
> index 0d99ef17e4a5..0a48fd86bc68 100755
> --- a/scripts/pahole-flags.sh
> +++ b/scripts/pahole-flags.sh
> @@ -19,5 +19,8 @@ fi
>  if [ "${pahole_ver}" -ge "122" ]; then
>  	extra_paholeopt="${extra_paholeopt} -j"
>  fi
> +if [ "${pahole_ver}" -ge "124" ]; then
> +	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_enum64"
> +fi
>  
>  echo ${extra_paholeopt}
> -- 
> 2.37.2
> 
