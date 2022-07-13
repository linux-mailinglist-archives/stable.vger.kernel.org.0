Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3346572A56
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 02:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiGMAnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 20:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiGMAnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 20:43:16 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878B46EEBA;
        Tue, 12 Jul 2022 17:43:15 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so1002022pjf.2;
        Tue, 12 Jul 2022 17:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pWi/ITrU9+1q/g+LldOfAE+sN2PBiYJyiUG/tbEyBz4=;
        b=aa6KGZH7zgMVUG6mKOoVEtJh/ygmJTJQy07v16lqFVJ0ldQBx0RVAFuC/q8PYqDrEt
         CSfI2YpBsLjbj2/83+aGqWbs9XRHcBv2p7Y8bOXOUaATzvzgqUcGloWUkcETq2QX9+6U
         u4ScRF1B99EJlpvny13x4x4K3emMKaVk0cyOzrfuJLfN1wy+msZSZHmPoLNELFzOW0nT
         EVAVzaBpTfrZWD/UJRXWtmE6EgE1jj3ozLt0h13Yzx8XwyzruGwuaYTr6O07ILxhyKSP
         QnQ/hkjHQ7ILVE/rWCDs76F9n+LbwhAJVBfSrXm3ieTh2bRc10dGABScdfg0FKIT+RiS
         bnPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pWi/ITrU9+1q/g+LldOfAE+sN2PBiYJyiUG/tbEyBz4=;
        b=QTVKDH7VtH25/tAl2cj69dMQniPXLeTwyBp9Xe6HSSc0eHN6UWKa5iWFKEGe088CDj
         23h2erNAetiRdJHX5SFzL+OZlHkYGXlWKKEdQkA4VOuGL9FEKMIoPJZVlcWkoz4ItWub
         PqGpZaDw9AYtANNMCb/ps86hcukrQSI86oaCDVgClId66uuWWIR3c55IXjH98Lda7MEc
         G0cUjnY2PMvB5/GgJMYf/WRZub+SpbLduxiPeTyw/QD27dr/PFjdlqJGo0/M0sVv+NCg
         I/2zSdnPxelE2YmNlzXPphy0DFxrTAL96i0MnHkFYN69pjhqSEFy8/HD2Ry5RMmQJzO2
         SO0g==
X-Gm-Message-State: AJIora83baSmrXEmywutlz2v50ZqhEf29+IMKpNSUETYULwd4z8DATkr
        lJutqrfQSSTCrVOySx2y2JcIlmPfVxsos+IOWpA=
X-Google-Smtp-Source: AGRyM1sN7m9IP3OC6ev1JdLNOa8JL2XTdH6ZOv9F28RfT8K1LqAzWnsFfl2qKMAVaAwkn97Z7IP2dYfjHQfwSgOiszk=
X-Received: by 2002:a17:903:2654:b0:16c:5120:f379 with SMTP id
 je20-20020a170903265400b0016c5120f379mr891063plb.3.1657672994875; Tue, 12 Jul
 2022 17:43:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220712183236.931648980@linuxfoundation.org>
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Tue, 12 Jul 2022 18:43:03 -0600
Message-ID: <CAFU3qoaV20obXT8nkanMjD6A63Fz4GNkC8VVmpMW4fAVdX2HVw@mail.gmail.com>
Subject: Re: [PATCH 5.18 00/61] 5.18.12-rc1 review
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

On Tue, Jul 12, 2022 at 3:34 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.12 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.12-rc1.gz
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

     Total time: 0.669 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 8.228 [sec]

       8.228933 usecs/op
         121522 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
