Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A276A220B
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 20:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjBXTG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 14:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjBXTGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 14:06:24 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C8A55047;
        Fri, 24 Feb 2023 11:06:20 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so229316pjz.1;
        Fri, 24 Feb 2023 11:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mWEnmoAM+fydC30L/SYccqR/3unahEyglhtexpvnYHY=;
        b=ZJfuPIMP4hE/aZsew3a8Dyna0EjbqYmwSJh/0oo3Qb57UDaO7fK0EERSDrC2x5t6LV
         M/g+eJBurFS7ggeng2fC5YazSccATiiSfsMDkZI/q4It2R4MSacpohboKexg2HD/ANRD
         YiWoRkVrY622zGNE5tRmihvvG5zXFnceB3tTUlUH/ucnP1C6GxqufBKj0/hOs9bQGYrG
         0hrtibh9ONBMmEtWaOYAz9c6tgdVh2KfUR1smq5+YO8ZOCdo7V9oVBD6RcO6ATzXXJ58
         A2G0pZA2o7pewqM39cIVv79pZ/6DSTdXwQnmOkBbXQ/ZZ1lRKwsTiY+jOdzy1XmKAwqF
         uwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mWEnmoAM+fydC30L/SYccqR/3unahEyglhtexpvnYHY=;
        b=KsWLRq5qF0/8behN4nTz37lOdC2FQ2qMZ2E9ao2/2CZGnmVeTxj/Xv+sO6i9/3tazW
         d8p4yShp826GlFYu+Nzvf58J+f/GzLMeAxCL8JSC+PLiiWZYLQ/yH2dVO1xagWLYJXF6
         Csvy4lc0+pAPdleKxAUsg8I7KwOX8qf5FSeKXVgU8djAEp1KgmkPVemKiwgeH9nBzyEC
         X3P3rDsFgTqqyLLBXf/+iB58sXFfcHRvRHhp3IIA9z6DBq7og+MsmcBKtvNhDU3VKp1v
         vOoOvsOkfQSMcVk7p+DGUA1pcV+r90EMmAoBMksUNIeFrpsQeSBnXe0fUQnBDh4LOCNJ
         r3FA==
X-Gm-Message-State: AO0yUKVgn8W74wPGggQi9PIk0sGEii3RyoTtZHolRrt1pDAI9xct7Fa2
        PSP0WRComsGuCmikPp/qrAeYQnvkja+nBruCXpw=
X-Google-Smtp-Source: AK7set/EUePO3CtYPyTFvcjXEHJAOrDQAynwXfQNdGtSYzbyYsG0toXFg8QPwqh2OEIvcWAzFuZsarXQ/EV/s8FAHZ4=
X-Received: by 2002:a17:902:ab1e:b0:199:2451:feaf with SMTP id
 ik30-20020a170902ab1e00b001992451feafmr3491268plb.3.1677265579543; Fri, 24
 Feb 2023 11:06:19 -0800 (PST)
MIME-Version: 1.0
References: <20230223141539.893173089@linuxfoundation.org>
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Fri, 24 Feb 2023 11:06:08 -0800
Message-ID: <CAJq+SaBTme=ui06N_09Pyc2nLSOwnvzZj0dSibODUgA6zL=vYQ@mail.gmail.com>
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
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

> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.1-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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
