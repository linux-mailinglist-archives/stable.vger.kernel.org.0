Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D170458740E
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 00:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235402AbiHAWp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 18:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiHAWpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 18:45:55 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9501025C55;
        Mon,  1 Aug 2022 15:45:53 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x10so11089208plb.3;
        Mon, 01 Aug 2022 15:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AtOQ8tHmPtgKCDJS9j7o/E1QD8d/xlqEfyE4sVh4ZB4=;
        b=NSVz48WbXAo0zzkalJT+7YY9YPZ10DnH17bP4Bs95wcBV3icqXPcTXHjG3B6OjmgIj
         MSdYB+HouNhwQrwqM+lhpuZsxdhoM48cuXHAh31BVNS+DNFSVCGHqjnGvT90DmiyN7kJ
         7GwWh8GcUnAD6+NlxFNjHij+gSTeHW8qhpnQVm6la8b3y14b3T3lOdqlxYk6O/HNxJLY
         kNXWl5UxxUyFpR5HozTifPz/61ep8k2CPaz21O2zRtx2jSaU5m6Dr01alzFv6hRE6GHC
         7j8X7J6yMCUa+7po524merGg9RkI9oaisX+pHGfB01IMIiMf70WRwdVSidhvCm4cXhP6
         jIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AtOQ8tHmPtgKCDJS9j7o/E1QD8d/xlqEfyE4sVh4ZB4=;
        b=KNoNxBP2vICoLm6EBPGTLLkW+ggHd+A+CszNICklbd+vEi2kqXcZO5E5yYcV8jpWfd
         bnY1Mx/KJ96gPRZlskug0igYM8AxcSSIn1bIvAb0pYaWgB/bQewMeE5JYTtHXW+NSG8K
         247giiN5AnSq7zZwQIMTEb/aUWlF+MMmG1fIraqegG0DcFj2Hu+Cphe4eAgm/ukUC2xv
         8qeKPUg6EOI7uNLjuqoS5JCkpiyqIiAQFl0WAaqKgpusdo4xF5O7VwwgNanjnkR9USVo
         4ccIZyPGcVY7Eb4Y3wGoBjzKWjdd7t0wbcBUWd1w+j2nCmMCcRLGVwvMKCQE5kv5VR9A
         ccug==
X-Gm-Message-State: ACgBeo0PplD5BakB5ezI3h0SyPojt6BqU1Y4VrQFC9z2LHv16jE3Kav3
        R2MwerwW8bi6OXTI9G1s9TQiizcY0O/IB0rD2Gc=
X-Google-Smtp-Source: AA6agR48Cj0HIlSuKrodOPmWWeTupADHJelVeA4OTdExNg4BQCR7YGngCoM2yYZJ8St9BPI3p2vDG1D4LMviCWNRGuI=
X-Received: by 2002:a17:902:8c8a:b0:16e:ceb1:d90a with SMTP id
 t10-20020a1709028c8a00b0016eceb1d90amr12397511plo.170.1659393952926; Mon, 01
 Aug 2022 15:45:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220801114138.041018499@linuxfoundation.org>
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 1 Aug 2022 16:45:41 -0600
Message-ID: <CAFU3qoYROXFxSTVAo_BLsYYEo7N874KY3F9XQeq1b4Xzf3PDzA@mail.gmail.com>
Subject: Re: [PATCH 5.18 00/88] 5.18.16-rc1 review
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

On Mon, Aug 1, 2022 at 1:37 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.16 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.16-rc1.gz
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

     Total time: 0.718 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 13.324 [sec]

      13.324520 usecs/op
          75049 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
