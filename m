Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058344D4729
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 13:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238897AbiCJMn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 07:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234267AbiCJMn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 07:43:28 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84613CF5
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 04:42:27 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id g26so10564839ybj.10
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 04:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=WK8i5sBKc7rjDEmwJNbOr2Iyg5EWo3YPVf77jlOHAck=;
        b=Cv+IzRuXBe02qx0FrX2bC8lVIx0PfQiGok4wkWH7feYZvGs6xn/tb/LryKwBf0JSBv
         4/9HNyZjJvKzukSE1/FoXaMYsdlJslWvDAV5go5i4WP+eOkcwik868lpwN+l8hAgY+np
         iKxEbRVIMO5T8lP1rH9uZEbvBU3n9T5oJQg7P7w1nkcrDL9ERnm8xr4BH2ATzkryVej4
         hCoNAHYsydBs97RJk8ppiRgRpHP2kP+OhSXeWboNQ9wrOUZ79oeObKILcQnERMtPyDXT
         G8cTZ/twmjvpZuigjZUktykZkf2ulduC3GTHZFXq/SOM1mN01dau5x9OiPqjiquIWNOq
         MuKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=WK8i5sBKc7rjDEmwJNbOr2Iyg5EWo3YPVf77jlOHAck=;
        b=zeWYgAOGATK5TAzhHYxj0X6VwhAx4BKo0wtOxEBsuh1gzmbbvosBMvn2K68Zh8ZqXZ
         sq+3Wc+GH2bvJNvv9EPRbElKWm2iOdiO15WZj4JoCrXOoBWsp1ChMYooZdFkh/YQDpUs
         wjfr6562vtBS8Jk00gQIXug1Ons4qNQc/fhPh2QsH6YTYQm4/Kp7A5gUEH0UqK18HEcS
         IEAxTzw18n2+wv231SAz6KEjsZ/B76VqvINat8gfgYy6M+BmdtcttOI/RKvU0lNWTqnp
         rIjhOm6/UwBpwjmjMhkYYl4+8tvzPqUAFi0KBjh11x1DVQ+I0PyVaScpFJa/zrGulsz5
         bbXg==
X-Gm-Message-State: AOAM533yaPNAWZT3H8HQhLoGXsuMA9qpulVocaDChNJ3nQBWOEj+UU7j
        ypzRqh6EOuGFG6NQO9dDJUMpNrDD17hoej++UtG12mfibN1vr1Uy
X-Google-Smtp-Source: ABdhPJwfdKwsMFDazkHKwV7hrnVNjL2bPpKNR8dVwSamoZcZlOeeFTtjEZTSuRoanKzbWKZq9do6eDek8FEADJcNKrw=
X-Received: by 2002:a25:5090:0:b0:628:b76b:b9d3 with SMTP id
 e138-20020a255090000000b00628b76bb9d3mr3707977ybb.128.1646916146575; Thu, 10
 Mar 2022 04:42:26 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 10 Mar 2022 18:12:15 +0530
Message-ID: <CA+G9fYu5TTXufJUW64=uFTntnB021xvQaO_t5Ay4mcUr-7TYTQ@mail.gmail.com>
Subject: stable-rc queue/5.4 x86 and i386 gcc-11 builds failed -
 bugs.c:973:41: error: implicit declaration of function 'unprivileged_ebpf_enabled'
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc queue/5.4 x86 and i386 gcc-11 builds failed due to following
errors / warnings.

metadata:
    git_describe: v5.4.183-21-g73e4e04ab074
    git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues
    git_sha: 73e4e04ab074c2edbda9422d6b9bfb2dc5779ce3
    git_short_log: 73e4e04ab074 (\ARM: fix build warning in proc-v7-bugs.c\)
    target_arch: x86_64
    toolchain: gcc-11

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/build ARCH=x86_64
CROSS_COMPILE=x86_64-linux-gnu- 'CC=sccache x86_64-linux-gnu-gcc'
'HOSTCC=sccache gcc'
/builds/linux/arch/x86/kernel/cpu/bugs.c: In function
'spectre_v2_select_mitigation':
/builds/linux/arch/x86/kernel/cpu/bugs.c:973:41: error: implicit
declaration of function 'unprivileged_ebpf_enabled'
[-Werror=implicit-function-declaration]
  973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
      |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

build link [1] & [2]

--
Linaro LKFT
https://lkft.linaro.org

[1] https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues/-/jobs/2187397024
[2] https://builds.tuxbuild.com/26C6fI6Q6XHWjKODxadjUgYrxAb/
