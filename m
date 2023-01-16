Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3831966CF3B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 19:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbjAPS6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 13:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbjAPS6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 13:58:49 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8116124109
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 10:58:48 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id k18so7161479pll.5
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 10:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMdqQ9WKyEOKQ2nD0q5t9awURcXqCIpB7f7QhoNXh7w=;
        b=eQxeSlNM8DqlBq2Qx+xzIvO2vXE7sRUAOMnZYL6y9wLHQZ6+3Yt18SkihJVUvYI5hi
         MONR+Q6Qzo3J2UnVq8YuNZHQkD0H29AwFYbpuuPAPy1j0eSHsdBLiBgnJHKrB4k1SEaV
         lh4A7l2hwvngf7P2f0Guw5zK91C14nUH5W4DICYKX6IRnQioOKXuuAxQbnImj7cFosgx
         0bJw87uQhEYEBkeNsbqvsA9As7SPgCHJjYCiVs04Z3i8wfltTN9+Oe9gVh1QtWqQ5cfe
         htglaIAJa6OlYqo/6b7sXhtRogyD1d9sHFUxUXQQQnU4B8ca8OJq/rEdIaWqN8sUdOIc
         A7NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wMdqQ9WKyEOKQ2nD0q5t9awURcXqCIpB7f7QhoNXh7w=;
        b=z0PsM6EX32f82a2g88lrAVJMWeNGb3u5dsBhqsJ9UIuLoWqRMb2FzqQoAr+s57W78b
         CR1MhT3tQ2+rNSud/dClMR8nE28PLwsNl+8FBCaXFAgS5AIYK8Au/bonNHSyxkZxAi5V
         2D4COrB/6XvOZRIdblqM44v4dITBWmw33AZ1kogsAIM1OY5HP4keAjpR3R98YtS3v3s0
         NIZrfkMjymJrBL2wjvFAEPDZuw5L20xQM+9ShQwwVEVbeqy0cbfC7LgaSanE78I1Awv4
         q7U9Cv9OYp1M1LDXDtJIR4Nulxm8xq0VYFoKHNv6YW4dOIlUorxdl5kqYvz9rhf7OGr7
         z9iA==
X-Gm-Message-State: AFqh2kpYCcsxiQXjg5Hodbo0RJV5K6xTCnqrgX6RTQCotvlQk5p2shTw
        DmMSv3OhBCcJvXyyDjI5Exg2f/Q3GUu44fuHw1GtOQ==
X-Google-Smtp-Source: AMrXdXvgQkJvZx20Qrm73O1WBO9QQPkNVWCNRY+MTHZzXqBOArJ7mPlGB32zLAUDQ/LLu4EgwsOEmrr1jY0zaGg48Ew=
X-Received: by 2002:a17:902:cf0e:b0:189:7441:1ada with SMTP id
 i14-20020a170902cf0e00b0018974411adamr70720plg.13.1673895527893; Mon, 16 Jan
 2023 10:58:47 -0800 (PST)
MIME-Version: 1.0
References: <20230116154743.577276578@linuxfoundation.org>
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Mon, 16 Jan 2023 12:58:35 -0600
Message-ID: <CAEUSe786JgSDJOtCU_tB81ddYxJk_sSfgzM33r7iFccsU7O5QA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Mon, 16 Jan 2023 at 10:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.164-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Preliminarily,

| /builds/linux/drivers/gpu/drm/msm/dp/dp_aux.c: In function 'dp_aux_isr':
| /builds/linux/drivers/gpu/drm/msm/dp/dp_aux.c:427:14: error: 'isr'
undeclared (first use in this function); did you mean 'idr'?
|   427 |         if (!isr)
|       |              ^~~
|       |              idr

It's currently failing for arm, arm64, (not i386) and x86, with GCC 8,
10, 11, 12; Clang 15 and nightly. We'll test the extended set of
architectures and update momentarily.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
