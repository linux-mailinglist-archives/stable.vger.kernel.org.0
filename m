Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFB74E3637
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 02:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbiCVBzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 21:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235114AbiCVBzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 21:55:11 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7DD403C7;
        Mon, 21 Mar 2022 18:53:43 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id d62so18717712iog.13;
        Mon, 21 Mar 2022 18:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sK2XIvRwJokvHYWTYU8uFheWkP/r57FKGT/u90S+b7g=;
        b=lTt72ls24quxBHbAnkJ66ieUrqlisTV/ofKJhlcTRmcUX/3Qx0yeQY8oi/taaFxus4
         YIpurMnsydk2PDDKqNOQvmj77kVEjPXJ9osEWXLFz+7y+hk42qea2gmpfCDNrdMx3qUV
         s0EnUHGMQB4xRt7cvInxrIOFORjVNOsQdtPFYDvUXkV/Xct5TFnyZv4uqBvpbF+HamJN
         ccdj7mE5qNn9ZoM/zlKobHYt6mEi6EJgJSFNBzEEMr9RjSGoZs7xEMB77tGj9LRMcn8S
         ZbvKh1xh8o+2bPz+ok3OwQL7Q0p+1yqvKGLzjdk1kgYJuFN3ePe27n60lxDUaf50yOfa
         Mlfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sK2XIvRwJokvHYWTYU8uFheWkP/r57FKGT/u90S+b7g=;
        b=Vz+7ntnQvWMonnXIlfPj9a5RphLyJaoO2/ho+ZoSn2dGKCcfdIAUA/zIEXC4wK2QoB
         U6yJ3Fjv3FMnly0kaWcIBjEgEB57pA519XvUhDBSrZ+ymlJze3Dv7ao4/04bn3KUsdGy
         voo7Xqv4a1Pi0qLsht0/JHuLBzwbQl2wdPs1uvehNxBh9G6xCfro5H5hUdu346NCfinY
         WKaNHcELZT/Jxb0wLnXgoDUfYCVOVuOUUrspDCpITcUZgX7IS2eqpO3salYxGixGVDN1
         gjjyYIDuaF+sCEwlzLWZphnIwvhTzaH4rlogcJ7qdfOkbilCjOjPKQBW/zUhgoOeC5ac
         QWiQ==
X-Gm-Message-State: AOAM5339oyDQ4KR+gufZLxxzZi5fK+n/L1TUxTWouj1uYybTbzx0gAoM
        fS+DD8KI/ZYOIL4OI00toX2eQvJ/DUxU83fSj/GtNJHFpjE=
X-Google-Smtp-Source: ABdhPJxG3s0zrvk6SlN/ZoCg+PIfGO+7Bmxr8y0wnLeCq0+ZII9ygMee+efZE3rZeMSwYYA2s/AoTbpPDFGRfppu/qs=
X-Received: by 2002:a05:6638:2692:b0:319:c4bb:995f with SMTP id
 o18-20020a056638269200b00319c4bb995fmr12807550jat.42.1647914022662; Mon, 21
 Mar 2022 18:53:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220321133221.290173884@linuxfoundation.org>
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 21 Mar 2022 19:53:32 -0600
Message-ID: <CAFU3qob+SSec3Qj7U030t+Vvfg05boEkLATGHZXEjgDv+hiNwQ@mail.gmail.com>
Subject: Re: [PATCH 5.16 00/37] 5.16.17-rc1 review
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

On Mon, Mar 21, 2022 at 9:51 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.17 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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

     Total time: 10.436 [sec]

      10.436791 usecs/op
          95814 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
