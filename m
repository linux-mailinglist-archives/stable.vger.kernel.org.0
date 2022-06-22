Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11015553FAF
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 02:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiFVAwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 20:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiFVAwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 20:52:42 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190372F65A;
        Tue, 21 Jun 2022 17:52:42 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id p14so8947539pfh.6;
        Tue, 21 Jun 2022 17:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R51V46L5H474iQWOx55vyXgPirIa+jsNedihdZg+XOY=;
        b=OJmlsdjqYbfvCdREgJsIEucxQfDkXAFRpW2mF/g8caOlahtmM/T3mxdl8wdJghMKwk
         Nrs/O5mx/AtyHq3HdwPxJZIfZ51iX7AA3oGrBns4O5G+MiYAaMASQlLJXeMzPWHV+HId
         oUnVcOblyTii6o/mVIC1jJivqRVEecj/6vW7AlyoNhL3R3Q4ZYlvon38GYU1ZV8ipGsL
         E4lQe6togFkBTyX4NW5Ha/boAACuyVyQRoj8ta1JlYY5K9IywG3+MYNh6w7Y1c0ElT3c
         IjGL3BxYcE+unIXDh65Wsxlmr0fnh4NIPEItIxnmUDRDPd0vz04Y2QOi9iq1Z03xYxWe
         zByQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R51V46L5H474iQWOx55vyXgPirIa+jsNedihdZg+XOY=;
        b=C0WU/x5Y+hzzmnmf9wkDsYj93U+SC0lt1QyaVTtIRxjqJJhBm0dwgnLy7eKy6D7L8r
         tU+T3sWY6r5IbZzxuJV5xH4vhEOolpi0fl9QwQCYDxhIZ2fO0l5kmhzEPQMUN4dxzlb3
         1Wi4iJORyOeicCSolASqGthFdzpuZ84LHRYBN4OlMzXP/VbUFULbTU7AJUS0AXRxY3WL
         PYX1nwFef2OFj3RX3mhqFTFt9wneb4zUk6yDnR7fi9J4lsD0j2OhsFJdzydAOXkAF/ik
         nJYgcVZwZ0H6W086EtE+5f3TjpWuNQOWHwkeKcA6L2nqD3r1S6qlxcE2YMqFbK3o8mXO
         QcHQ==
X-Gm-Message-State: AJIora+yMW/UJIbWtDh3nrwUQcvdpuxbJcTbn4vc5eXP2CEKu89j4gjd
        71P4U13yeOugWi4+HcDy8mWIz6x69CYB4/aDAIM=
X-Google-Smtp-Source: AGRyM1uOKezLX8HGvp/NWDvOuCJk/zWag7uuR+HptNSwxoC+asFKPhBbfBJYfiyhjJPcUMSITSGW3G5PQDo5ARrsdAI=
X-Received: by 2002:a62:388d:0:b0:525:138d:74ea with SMTP id
 f135-20020a62388d000000b00525138d74eamr19118362pfa.19.1655859161552; Tue, 21
 Jun 2022 17:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220620124729.509745706@linuxfoundation.org>
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Tue, 21 Jun 2022 18:52:30 -0600
Message-ID: <CAFU3qoYJspD4xUVPU5Q2qNebXfQpw1=7uTc0fVg3SNEvMB_ewQ@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/141] 5.18.6-rc1 review
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

On Tue, Jun 21, 2022 at 8:47 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.6 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
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

     Total time: 0.449 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 10.870 [sec]

      10.870600 usecs/op
          91991 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
