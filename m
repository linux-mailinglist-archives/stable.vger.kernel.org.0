Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83146574C6E
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 13:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238628AbiGNLsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 07:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiGNLsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 07:48:07 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A015B054
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 04:48:06 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ez10so2889082ejc.13
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 04:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dQ0fCq0ZyyLcCu2RaWJmjAKVYgnq2Ry9Qz7y6l9Krms=;
        b=K/nOeGDGN++Gsq4Rj5Uy0wMI4/nxZVXiUITEjCOaFaWl+/RPljyJ0JK4g5RhkelyN1
         1QhYynVk/wFdutgWXpEGdMFXfxeRESAHAiEg17dSzeC5l9W8qq+2JM2/JAIUQCJRblJ4
         knckvzkZveeCYfSXnyxrn3AO9w+Vv1zA2Gi0NWSzQWdXw1i821Hn+Eadw2Bohis11GjP
         QdgLEiOPpibD1jELa+gIGfB6Zbyd844Q8dnlecbComnMHcUhdX96BdEMwCWUCWCkpTEK
         f0ZOXf//d0XKiIweLQ9WoopzZnncaFiF4hZkoxr2KEvJ7vMWEiPtvWFBDdGuuYf5QM66
         BELg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dQ0fCq0ZyyLcCu2RaWJmjAKVYgnq2Ry9Qz7y6l9Krms=;
        b=0rThACyb4tI/Tu9rj9dSu1rCRx+Ku7a89w4kk6QDnO8J8mbk8r5DGkRkXm7T4Fw2o3
         J6wH7zhgZMS67zpQsGQaxePm/SVBs4KkprrsKEBVE2ucCqHoNw0alvJufQglcsvfIVJB
         yhzf4vUnEW/lJYmGKusz/B1Q4QXXdSQr0Og2Lnj+xhBg9LVmNaDlvwFunTXJsqcmODeS
         c0cTng5oPZH3lKovJMbb36SeRaRbZDJEaj/hRf+7ZA+SQbh6HwlGCNhiAIkzKjgzBVhq
         PTdz4XieAHj5yDr1NPFjQYB6/dIyfLpQcTEerOBy53rWkHHyyKiNhMVg/zoVa1iDujn4
         E2Jw==
X-Gm-Message-State: AJIora8cy1c64/nKh/AI4CXJokesl7jlsQK8xlLWEXKJazIu3Sxsresq
        u5OLCr6hfgGjcr6CTW0H7R0kBJ/71WSl/voGs/9PNA==
X-Google-Smtp-Source: AGRyM1sAmuGPOa/LunsNi0GiSrbOj8H+RlLYQEoG2ZcAko018Odq3/IonxMSKHyCcOiCXMz3XdUqUewDhN1ftX+VmXc=
X-Received: by 2002:a17:907:7294:b0:72b:1ae:9c47 with SMTP id
 dt20-20020a170907729400b0072b01ae9c47mr8209782ejc.253.1657799285189; Thu, 14
 Jul 2022 04:48:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220713094820.698453505@linuxfoundation.org>
In-Reply-To: <20220713094820.698453505@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 14 Jul 2022 17:17:53 +0530
Message-ID: <CA+G9fYs0E4tAty4hFBCNOYLK9zwCQAZ=nWJHx2a1NvvGLYScDw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/131] 5.10.131-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 13 Jul 2022 at 18:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.131 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 15 Jul 2022 09:47:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.131-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
FYI,

With rc2 the perf build issues got fixed.

but we still see
Kernel panic on x86 while running kvm-unit-tests.

- Naresh
