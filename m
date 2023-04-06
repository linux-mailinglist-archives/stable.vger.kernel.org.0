Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA866D8DAE
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 04:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbjDFCu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 22:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235166AbjDFCuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 22:50:16 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CFE9EF6;
        Wed,  5 Apr 2023 19:48:39 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id z10so22959475pgr.8;
        Wed, 05 Apr 2023 19:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680749319; x=1683341319;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MHuPzBxJToh2F/SQs1hc1tHUZRPWSYggD2FMkgtFvfU=;
        b=RTKcqTfW0bcbhj53/JSrPCwNJD1Ba88spY6/ybnuphWun2+rmFQmK1uLk0wbkc1kKa
         jZNdcK/zr3w9CBlghABXWIglBm9pYljqfr/0THmtze44cp/qPaitadt/6tdH+khAbuMZ
         QJwp0IwE9qDS0MVsFJvlrnx9tZuMss2F5AR2Od1swe1Vl7P0pacrSTYOYDL+p/IwwWHv
         5Civ59SUpKkTNlbKT5UJWcYwmZqnhAz8UIII9XKvEo2diUqzmauRDGATGkt9zQ18Hcwd
         25A9NIXzLdL5/IGyZGxHwB8HtzwocoE0QBs6TwAF7bxtmHKTDRTYWqoOoacrZRTbq2vE
         REwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680749319; x=1683341319;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MHuPzBxJToh2F/SQs1hc1tHUZRPWSYggD2FMkgtFvfU=;
        b=qE4E72dS1+pKJkVfZdrIM+HNHSflIha5unZwKcsef5KwNH1YxLmwFsQUP1D66VJBYg
         KeF+DhJVJFm2GkOshB4EkENfs6VtfBg3fC3Yru6tWvwDW1vbYaj4as45RzWKlnnmbH8y
         1ouD9Tz+BC6N+NDYJo3OYMTLmKoxJW8blHSeYsLEtWXH0Jn0BCKA29souiXjNvH8Gkfu
         1t7E8Pi3SASDxxxBFAV1U3YwN+cBjgg6MbD8s1haGh5xdbBWDeP1gXepwN39P+0v+T+4
         V4oRxc6dKkzprcwYRAlij/O4O7Zk0KacOiAXNLZuEasO6Trjh0xm4Igvpq6pRphP/Ulp
         s3SA==
X-Gm-Message-State: AAQBX9eVPlImD8sL1saxItWRXw2xS5FTiPwOv22svxkDYWWenZzvEaqu
        mlipF7F3pxA33qm1NZhppVV9uh4eHLA5jUma2ME=
X-Google-Smtp-Source: AKy350bfpkuIo+RGLpDcjFpvKCAEt+1deus7O3fF9RbKJsscdxuSKlJ3KTv9GDz4ZMdQyeQE61+I0jn93WpfMURtvuY=
X-Received: by 2002:a05:6a00:1394:b0:626:2343:76b0 with SMTP id
 t20-20020a056a00139400b00626234376b0mr4514179pfg.6.1680749318969; Wed, 05 Apr
 2023 19:48:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230405100302.540890806@linuxfoundation.org>
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Thu, 6 Apr 2023 08:18:28 +0530
Message-ID: <CAJq+SaAc05wRYVQVRHP0zPZfYbHb5nz80JHfU-74MSa+X8_sRg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Apr 2023 10:02:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.23-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
