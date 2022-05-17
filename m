Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A50F5296E7
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 03:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiEQBqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 21:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237880AbiEQBqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 21:46:06 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3139027CF3;
        Mon, 16 May 2022 18:46:05 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id bh5so4273941plb.6;
        Mon, 16 May 2022 18:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EPzXnjqGBoKUSwMfOnRB4WealJxyf+zAfiRWCAG8cJI=;
        b=jJiuUNa5v8rogNVYljE2jP8mNUf7yu2SAtnYwjlSgtZR7lXQq/cy/I7PTqOjUrQ/Xg
         bnnbmf5EzLoBO1UviRKV++IflXu3P5FoQxvKI2aLhaafAUJxwCvMOg7saOuhTw/cH3Kf
         cggxDMlLT6HdnpDMQF1qQqyso8vAd8UHbQreGG0KYVEDswn8LPrPuZgMa7fe67jp5INX
         zVqMCr+ka6rq6V6xD2XNLBYLnVu/QidFNXHyBoccTkTq6GiS80Ft86dSfMZQ1gFdMCJ8
         dWyaeQonJrc/XCxa7+xDaNVgdJWqI5Tft0rC/HuQXZQ6rJaicz9QIYsI05Yo3LZxzXvG
         NIxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EPzXnjqGBoKUSwMfOnRB4WealJxyf+zAfiRWCAG8cJI=;
        b=S07RIgS/XEZu5P9Uz38FSGBDLuaWH80c7aeJb7SXXHGAFTw7bGWApBJGcc4Us+rILp
         N7YZdxDNnhLzz/eMTceYmmiZWgca0w4U2JmQgfng1LOESomIuugS9/oW1+9hOrjakO6C
         r7AivOmONMCbAEGzm3VndKh0FSdFqmg74c7b9I69GMgNFb//7lJGCSzUqTycN8d0vpeN
         K+dmcgffSsnJ1JYIgf5aaItk/z1uBmeCGwiRNTEYL1VsPLw+ZMU4fkXImKRhqH8eVdyC
         YP3S7hL0jni35fPYWaRDUn/EtPXZALRXlGtA0swf3KMPP0Po9RJE1odeBg2Amgg4tAId
         QU/w==
X-Gm-Message-State: AOAM5303ON9FxhhkOyuCtF5OB5yj3dGjVLf1lgbNwxMdZs29TEhRxfOI
        yQvUrBBubMkWMH34iVebs6aTWxgym92X9aVhCkcM0NWEASs=
X-Google-Smtp-Source: ABdhPJy6Wce9xA6NUB7pq4rf3jfiGgaWIljqAiscSttVZawINcOjbSzgSuTCIgND7606T2IiV+PWDuyR49HGz64IzYo=
X-Received: by 2002:a17:90b:1e4b:b0:1dc:7b66:55d6 with SMTP id
 pi11-20020a17090b1e4b00b001dc7b6655d6mr22558088pjb.80.1652751964635; Mon, 16
 May 2022 18:46:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220516193625.489108457@linuxfoundation.org>
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 16 May 2022 19:45:53 -0600
Message-ID: <CAFU3qoYWAoffx9vDAb1qppCtXq8Rx5X53HyniKpGY8e8NVmC9Q@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/114] 5.17.9-rc1 review
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

On Mon, May 16, 2022 at 2:21 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.9 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.9-rc1.gz
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

     Total time: 0.439 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 11.491 [sec]

      11.491534 usecs/op
          87020 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
