Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D65B56262C
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 00:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiF3WfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 18:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiF3WfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 18:35:15 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA77D3617B;
        Thu, 30 Jun 2022 15:35:13 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d17so720972pfq.9;
        Thu, 30 Jun 2022 15:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oq903PnHKKlk1Ub56OWJWTUqpJFgTB4U8dVesJCDYhY=;
        b=XC/60iKkyB3VNU/plYph/3DIl8BGVWPGt7xmCH+b2/zLrFpZaLFlojk8RKVHz7FAmY
         Y5F5kWKBpy4B3CWF5irWznclz1S3IqSeIfKN5uDagFCuoI1XPzH6M64cPHXo01AMFMiF
         F4tcYhO4fROYXs5fQrrOsgCGQ4uwI2uUqc9TwAVau654PI2eLUlaegTZ+X6XJ3ZQ19+A
         d+TerxuFa8qEyldo1alMwOH2CqS+4+gdZcCZlXZsW2Fa5lwhFwe+f/WiEH34BFwGuxGU
         ZyUW+8JpiUuk7xpF3yxIWRdp/F3rEV9BadJhI23FSFrldwjt4ftS7HtTBc/Eh+eKbje3
         5AYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oq903PnHKKlk1Ub56OWJWTUqpJFgTB4U8dVesJCDYhY=;
        b=iMInTnqxMnH1DIgjQMfR3e8tA5UIeVt1NAUOAA6UirFgsbxYlZ0y65jaBuhs+S3CFj
         /zFTkzrw1fLuIZJUzy/rpHI9EV7rKJYUaIuBUosmyMLJSBQYH8l8ugC3OUFSXc/OHV5y
         pXeAPdpBrhtARiL0f2lTtZ2eQ+5KuU7Ak6A/FaKOtgxHeG9cTXujaPfRPyMvpP+r5QM3
         ASGs/ZxsmdonLgpUPhk7kaAkWdgwuIZs+mVoLB0+eSaUz5GKHQxFlbatQb1bXtKp+ZYd
         L090R9/7406cAodno/STDAw/2538LTeE+HY6/JGsh+rzS7Bt7nN1/DJY/+lzlQfwW71Q
         uz2g==
X-Gm-Message-State: AJIora/vKZZV089fSr5eHhmaxtURhNCFstPeWR150HYCrlAaTd39OvNJ
        7EfANYjFRwgaOvgZ9c2vLRrIAPqi2v5BKppdOqM=
X-Google-Smtp-Source: AGRyM1vHY1TFeqvYFGhjyqbGjePgg/3axKeOkGQxbtUeN97+1ZkHd8B1vDjAI5RlIzm/phTxnFBF5wmwrmCqCS4UDHE=
X-Received: by 2002:a05:6a00:13a5:b0:525:1da8:4af4 with SMTP id
 t37-20020a056a0013a500b005251da84af4mr17740573pfg.43.1656628513139; Thu, 30
 Jun 2022 15:35:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220630133230.239507521@linuxfoundation.org>
In-Reply-To: <20220630133230.239507521@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Thu, 30 Jun 2022 16:35:01 -0600
Message-ID: <CAFU3qoarEHyiqb+vaLLhsyaQeZ2k2P5crq+Hxar8AQfWd0k=gQ@mail.gmail.com>
Subject: Re: [PATCH 5.18 0/6] 5.18.9-rc1 review
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

On Thu, Jun 30, 2022 at 9:17 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.9 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.9-rc1.gz
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

     Total time: 0.427 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 10.046 [sec]

      10.046035 usecs/op
          99541 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
