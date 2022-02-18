Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2C64BBAEB
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbiBROuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:50:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbiBROuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:50:19 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0CFE1B60
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:50:01 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 27so2853672pgk.10
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kcMM/QY8/JYHp5O/bMIZ4DVF6TOb0BklgL7v6D5F5xQ=;
        b=lchJ9qjsYYftNffhSPrvdlTY6kzeCxh885tq9ZYRDkL2EEtY3oBwTFQ+ZOAzTJZjuK
         1w08xR7o1j+AyZeuO9gKYxO3wen7Kq5e9dNLdpcteQ+x7GUw15XxZm750K+GD0+QRigT
         FQgwrcFYD/jxdeXxNVKZ/aAFY1G8NDLrrmbcKjYNd5lFoEr+AD2dps3f7dp4jsq6EjCM
         0uPjpaWIJJ6Amk60f7ILcwuDmN8s9raWRI5zSFu3kpnd4dTTieyklW+FoAajJfdXoLZQ
         lTEc5t51yFf2pobj611WfU+yhcAB2+uorMI4cafu98/GzvZ1uNcwuRzKUryNt3uvrYC/
         G36w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kcMM/QY8/JYHp5O/bMIZ4DVF6TOb0BklgL7v6D5F5xQ=;
        b=a8szcOfxJpnjyFH6dzQdTUE3gJJ8glxfTs/GermVYKipxDOMXwL5HIYuzSUP58fDoA
         tm/HBjQ0hf21n33aAPTvP5YCYo3zX476+ewcFZundhI8edwAAqlWqIvA0DYQ5DTdadQD
         15zlaCGF+mnHeWulAgCM7a96sn/i9NP7S1HZ9SqcZTNPHT/8o3zedzjgWhiwA7UfNm4w
         M+kt1gAEaHKQWxpgk82M4BSvHIzI59+cP2677FFG3pX1MyrAi8nmkhn43yVl4yCF6Il2
         7yMXaonoLdH0Sxh9FhSAx7IvbUnnQUgSHqM02rA+5qJOjtJCcTe0K0gcKs8sRufXUCvd
         /U1w==
X-Gm-Message-State: AOAM531N6awe4F1cxV4wiVMyx8AYQwLVFEaTpPD74Wqrp1S0IcEqFhbM
        NSrlfU31G6Lq47DVCd3kksOx2uXxXLcPXczNoKDWkg==
X-Google-Smtp-Source: ABdhPJwIFzi+R5Soq37EODzziuKd2yZpO3EcgQFvZMeM3UYwDT1gH3USnGQpDknjaNMcJq9ZHCIa84vn0RUowsVl5U0=
X-Received: by 2002:a63:44c:0:b0:373:a7aa:9267 with SMTP id
 73-20020a63044c000000b00373a7aa9267mr6330270pge.107.1645195800697; Fri, 18
 Feb 2022 06:50:00 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYuDLxwN97GdYhyQ2kz=WD1ASKE4HzDC1GKfrhPvk2xaXA@mail.gmail.com>
In-Reply-To: <CA+G9fYuDLxwN97GdYhyQ2kz=WD1ASKE4HzDC1GKfrhPvk2xaXA@mail.gmail.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Fri, 18 Feb 2022 15:49:49 +0100
Message-ID: <CAHUa44FAh89fRQMB7XgjDrwjv-7iye721CHi6jDe8VchLwZijg@mail.gmail.com>
Subject: Re: stable-rc/queue: 5.15 5.16 arm64 builds failed
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Lars Persson <larper@axis.com>
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

Hi Naresh,

On Fri, Feb 18, 2022 at 3:36 PM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> While building stable rc queues for arch arm64 on queue/5.15 and
> queue/5.16 the following build errors / warnings were noticed.
>
> ## Fails
> * arm64, build
>   - gcc-11-defconfig-5e73d44a
>
> Committing details,
> optee: use driver internal tee_context for some rpc
> commit aceeafefff736057e8f93f19bbfbef26abd94604 upstream.
>
>
> build error / warning.
> drivers/tee/optee/core.c: In function 'optee_remove':
> drivers/tee/optee/core.c:591:9: error: implicit declaration of
> function 'teedev_close_context'; did you mean
> 'tee_client_close_context'? [-Werror=implicit-function-declaration]
>   591 |         teedev_close_context(optee->ctx);
>       |         ^~~~~~~~~~~~~~~~~~~~
>       |         tee_client_close_context
> drivers/tee/optee/core.c: In function 'optee_probe':
> drivers/tee/optee/core.c:724:15: error: implicit declaration of
> function 'teedev_open' [-Werror=implicit-function-declaration]
>   724 |         ctx = teedev_open(optee->teedev);
>       |               ^~~~~~~~~~~
> drivers/tee/optee/core.c:724:13: warning: assignment to 'struct
> tee_context *' from 'int' makes pointer from integer without a cast
> [-Wint-conversion]
>   724 |         ctx = teedev_open(optee->teedev);
>       |             ^
> drivers/tee/optee/core.c:726:20: warning: operation on 'rc' may be
> undefined [-Wsequence-point]
>   726 |                 rc = rc = PTR_ERR(ctx);
>       |                 ~~~^~~~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
>
>
>

It looks like 1e2c3ef0496e ("tee: export teedev_open() and
teedev_close_context()") is missing. I noted the dependency as:
    Cc: stable@vger.kernel.org # 1e2c3ef0496e tee: export
teedev_open() and teedev_close_context()
in the commit. Perhaps I've misunderstood how this is supposed to be done.

Thanks,
Jens

> --
> Linaro LKFT
> https://lkft.linaro.org
>
> [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.16/build/v5.16.10-87-gb5b4ed62d295
> [2]  https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.16/build/v5.16.10-87-gb5b4ed62d295
