Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C420D510D57
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 02:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356436AbiD0Aod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 20:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244560AbiD0Aoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 20:44:32 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3753983B;
        Tue, 26 Apr 2022 17:41:24 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id z16so264082pfh.3;
        Tue, 26 Apr 2022 17:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cHuB79ILJjenVIZkylgDtsChvSa1mafCrWbCMZD3kAE=;
        b=MHXSGD5YQ3T+tkCFxPGTee84+gjDFzOLq/3s7K00T1Yk3F2LBRwT6mFC5RSrJkDf40
         jiMq5HzWIQT82dfnegmng5CKufVYqb3ehZaylkwHJPTi4eFUW0qiwl5avCiZt+g39SW/
         Jd+UbCR1USDo3sNmI4yrFpdAtP72rKpFuo4TVcBRRTjM7mJzPZWdJlT1Lc/WKoWtmtb0
         MLvfJBzGtvaDz3AgNLcTa/XlleGRYnBDX2YHDLEsnGUY/rIdSmFET8I+2rzD/AdZLg5m
         TePgucauul6IWvyIEukPLdM6tIxA0ey/88gXvDQYxNIQv7Whkt+9+B5BT5Wli42G6q/V
         8pYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cHuB79ILJjenVIZkylgDtsChvSa1mafCrWbCMZD3kAE=;
        b=Qo/dYCJ16Kx9gF03tZOiY/SlIFPUqCpbIDeRZ3bSPVYVLKZoaphGRZwT9eqfl9hGOI
         n/in9wuiXl0/8PatT4i9+vybieXH6KdG3uHzJnFVvyRpeiHDwdpIFZ/Soj1oVu3EB7s4
         3Ps1N0TZGkqi1znCKaKw8NNbo+JoaNWyXHxOphxzyXBES9+7yK0YOS0h2FbKA0TQje9Q
         j07XOlbjSEA1FKSYobMVtE8MbxYXy16EOk17n/zdiwmrru5c3l706l+2bD3fYmNmgulz
         4dkTelp1wj8ptwZxl+0KKCPDW8GCYLp9OLe8ZUItBNuAKrIhny/+OhnaBah5pSrMluDc
         KJGg==
X-Gm-Message-State: AOAM5330l3qI/EhNPSp3LvDKea89fqJvHbOMntZUtlGWpUEUv0GMXV9K
        XPQdSw5XNtTnYSMrdI28o4WpJmAQj+2WaBp0Wqc=
X-Google-Smtp-Source: ABdhPJzUnPBN9l/Y2AdbUDIDPvneXyP48DwCYsX+xUU1j44Q6NNL1ZFE5aT3mE3lVvIRb6Rl1XXrTt9dUtcLvo8ueAs=
X-Received: by 2002:a05:6a00:8c8:b0:4fe:ecb:9b8f with SMTP id
 s8-20020a056a0008c800b004fe0ecb9b8fmr27136771pfu.55.1651020083481; Tue, 26
 Apr 2022 17:41:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220426081750.051179617@linuxfoundation.org>
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Tue, 26 Apr 2022 18:41:12 -0600
Message-ID: <CAFU3qoZEOuhr=2vkn=edio76Z7taXX2hy7P0gYzfskD0rjPGng@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/146] 5.17.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 8:20 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.5 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.5-rc1.gz
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

     Total time: 0.450 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 11.670 [sec]

      11.670850 usecs/op
          85683 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
