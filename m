Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E38A69840F
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 20:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjBOTEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 14:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBOTEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 14:04:00 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF632C655;
        Wed, 15 Feb 2023 11:03:58 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id r17so13394268pff.9;
        Wed, 15 Feb 2023 11:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6JQaHVGzKqqN/rCfFJ1z8PwWnyDbd3wsfGz9fkN1qoc=;
        b=GCO968mmt3mnc3Z/hiDLjNxUcwosT+FFnenFoUEKMoMQqJVeaDBsV7lAX7MH2lUYzc
         iFpu+qHshJAWp9ZhMyuG1P8zDKAxT7FLnI6aXShOxIReFTIgaBqhmTjBByFcDs7x/Roo
         El3xBLAvEMP02c90zlKc4FYaR59ja8Z3gBR/Aq17/ET+HEGstVCoxBFLcJjwrMHpYUze
         1D7rzENumYM7erA4gh3P5Cqh3+jiqUja3CRmhLFYyTa8Ihk45/berp/8ralnz+vAfzOy
         tH851wnCcbsW3Eo4Nf1FYzjOmTlYwupAvoyl8O6m1T9hKbobZOwjWCckSzfa1psH+ful
         HyPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6JQaHVGzKqqN/rCfFJ1z8PwWnyDbd3wsfGz9fkN1qoc=;
        b=qU3ETt9HDJryv3cqSiCGFm4X4EFb9rmpjBxaJxRkEOOrEOyFuPeOYAA9rZhNUpOhUM
         6bGCH4f/qEjA3f+AYvZBnM5yxhVOox1RRFJBHAOPVP1gDAkeu2u/dKTuJtIqC/L+F9n3
         3gAxE7fJk+jEbyhhV3SLU7GQ4qq/8aaZVYqpMPzULSWQaNjU5MqULHH4O+CtXgYUS+up
         +GYb2tuSIkoaYxtIiIRnQlsnf1vJP/bKZmyYQX2aCTdZl76vsLBXcBb2z07dTx1WXplv
         ANa700bm1sGMqDIMO3bKDWKKDGD6DjDixvHJvKbxah4onK1PKLqo5iFO4amZNuOPwBAw
         1qEQ==
X-Gm-Message-State: AO0yUKUbZ2javlf9GgxqgY9bxntyHc6JAk8YLiAhmuoCak8QFdAUU9of
        ZLDtLOHq9/Lwj6GK8tHOg5xQYtfISKoilBqFewE=
X-Google-Smtp-Source: AK7set+EOaHXrqqUKR4rzgfzoqZlIV0XPvx+6ZUhukUamfJDXPHbqKwUAfa7PuuS8Rzu4DqyZip61l+ZEWDD+QAg/o4=
X-Received: by 2002:a62:1dd2:0:b0:599:234e:7e82 with SMTP id
 d201-20020a621dd2000000b00599234e7e82mr554552pfd.53.1676487837796; Wed, 15
 Feb 2023 11:03:57 -0800 (PST)
MIME-Version: 1.0
References: <20230214172549.450713187@linuxfoundation.org>
In-Reply-To: <20230214172549.450713187@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 15 Feb 2023 11:03:46 -0800
Message-ID: <CAJq+SaC52Y8ZgQQwoZ0Wzj-JHUtC1rJNQkQNKt=-8kFRkOXELw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/134] 5.10.168-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
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

> This is the start of the stable review cycle for the 5.10.168 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 Feb 2023 17:25:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.168-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
