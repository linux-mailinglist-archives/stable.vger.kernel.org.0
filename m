Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8717852292D
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 03:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiEKBvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 21:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiEKBvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 21:51:00 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBCF4B420;
        Tue, 10 May 2022 18:50:58 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d25so684579pfo.10;
        Tue, 10 May 2022 18:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gDEht+gkZiFkbTmjk2YIJFInJDJINDJuhv19NAbiPEI=;
        b=kJP+MLdy+ZDkYB4W4jB7vih5rEYiuEhzvE0wbq/MKspTIXFKGVsFJKAlsZq/dQYfLa
         He08B6vK4RpECvZUiGdE+rTwsejMkIiwlS226qSnLV+HMisXLRlhu7TrL7svyLZxyrhr
         +Jd0O/URbOA5cRdynLkgFEmoCMJ1ntssdddlcRlGecNTxq5bKKrlYknhWw5NX6kSuhi6
         z2I2b4jTY7SeFQu4bgEs4RzaYn8y1LGg58K3UdARrfL0YE3pVG2gW1dyB4rz/Q04l/I2
         rjdr5wqUlQDmXNjeyczCDuaCTGg8zdF2yD1JGXwUTFYYbXxlZ+ZyDiwFsJyCJNIY/yIx
         T41w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gDEht+gkZiFkbTmjk2YIJFInJDJINDJuhv19NAbiPEI=;
        b=0pG1NPjhx0NloGQEOkbmVPAINLV6GuVXMmer9h3R94HOgH/PJR6jzMIyLadzRgZNDK
         CJiDnWKGkOIqUbyCepByB5jRXn+oZUUyNxs9YVVyOnsa/6I+DJh9MquR95Iv4m6x0JsU
         zKobxQVwAb+tBSW+W0taU+ebpNZbcVddxhkAYs+TEJ47vCAeOOMo/SPqGLHhBhRcSHj3
         UXqi9S+NpedtC6HpP1+I3/ctdZgzm7c8JdUnQwQNpNI6YX0vJu+mwH6isEoA1n0a63nT
         jaqUvcpROVAcY9xr9omiURFxqFkhrZPjto28NRQK21JPUp7uhTNQuhkDl7w618HxWsiA
         HkDg==
X-Gm-Message-State: AOAM532u4GIls2zfCAeqx9MCZu+5WHjkOttgODD/3a/qIWOs66sVQRBs
        8s3IIAlBNlRe3DkmhvKwp0dcmwqvI2WXVDWnra8=
X-Google-Smtp-Source: ABdhPJwHLWCu0w3nBjf8E2zmucAMqA0ssK6lbH8hS3PAX6kZ6GBj4x6mIXJvCnP7581tIsNxItrsUnDK6zYX6HY2nbI=
X-Received: by 2002:a63:114c:0:b0:3c2:3346:3c2b with SMTP id
 12-20020a63114c000000b003c233463c2bmr18865428pgr.226.1652233858137; Tue, 10
 May 2022 18:50:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220510130741.600270947@linuxfoundation.org>
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Tue, 10 May 2022 19:50:46 -0600
Message-ID: <CAFU3qoatKAhtpF2h62P3jM=F77UgHGuaRNUrBWs2CrwBvCRzZA@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/140] 5.17.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 10:21 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.7 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Hi Greg,

Compiled and booted on my test system Lenovo P50s: Intel Core i7
No emergency and critical messages in the dmesg

./perf bench sched all
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 0.589 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 7.285 [sec]

       7.285558 usecs/op
         137257 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
