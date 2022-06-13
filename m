Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CC454A251
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 00:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbiFMWzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 18:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbiFMWzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 18:55:47 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E598731502;
        Mon, 13 Jun 2022 15:55:43 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o33-20020a17090a0a2400b001ea806e48c6so7423203pjo.1;
        Mon, 13 Jun 2022 15:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dUSq7Wl4LxVynny/k4FMaMVpbODQJXtViPWhWYBw4rs=;
        b=BwkU4pYqwWtiWb7Tf40s77Xf2lNsscn+gIpFYEfmr/B3on2MHh9XUL9Pyf8c6XsnMr
         ATjeUXtQqpb8LkB9DDlamQrZtR1COHaz4C9liE1PSdhknUiOL/5YYmiD/ZJAUDBB2mq/
         1K1WzR3DSTuvp6g/+bFjykJ7RXB59SfKOGP3MTKDlEfH2+6UVG2PfzQ5FFEaLnDkuLDZ
         POZU38x/pJBis1FYp2BbxuoU8Smz1F7uWloeOFZAycBzVphnRcfm3I3i8EGDEmeZankU
         selk14fxOclVmoIFNtn1wQcyP0o8iWICyCm2Hwt2LoZU9YkCfA+vkFHNnKua9rAQnn4q
         x6qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dUSq7Wl4LxVynny/k4FMaMVpbODQJXtViPWhWYBw4rs=;
        b=LepG8PLN5vrZnFiOTRgceSmAyI9o/BxQOhVB77QJ3oUGu82cRGP7na16FX7OZIOeXj
         HbeBA4H2QwzRQPMwCUXYdUo3SzspkXgOia+RTbGFa5v6muAlEMVCK/Us7kbEk725a8SW
         mQcF62M2bYLKyvhH1dhkL2EOM4vagPf5A7xuHyq5LujSXQQ+iuyEqzp+UUDvxTzx6utO
         MwCzB/TwhfJZZuGv4OXVB/KwSY1s6kLffCAK0g5xhHoyBz4BMjWTjuXWJxObfAG/MQ0z
         m0366vdGC1cwZOhJ0HzitHxKwbcKIMvMrniEU4ktdCy39sHaskaFx63w6EEoGImP+Nrx
         IFrQ==
X-Gm-Message-State: AJIora8IoPSoL8yDN0oZGf6jbcqAHAlBkW2inSOOGvJPeAk8Dw0rtSlC
        ZkCeUDjazhiIBM927GA9Atax6GMZd9cp44mi3NxDSwX5Sw4=
X-Google-Smtp-Source: AGRyM1uoks0WrpT0jzBEMWubAkmGZs2Svoz5s0FXpEraPTyqCydNnV4u8aNGTTIWciKXk53ExBzphJ8RYWet8X6UCAU=
X-Received: by 2002:a17:902:8ec9:b0:168:c341:847e with SMTP id
 x9-20020a1709028ec900b00168c341847emr1550672plo.170.1655160943378; Mon, 13
 Jun 2022 15:55:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220613094926.497929857@linuxfoundation.org>
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 13 Jun 2022 16:55:32 -0600
Message-ID: <CAFU3qobUZH2cW3sRVHmZvHi8XwyWT7g_NpjchjG-wLh4SjcsUQ@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/339] 5.18.4-rc1 review
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

On Mon, Jun 13, 2022 at 10:15 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.4 release.
> There are 339 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.4-rc1.gz
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

     Total time: 0.444 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 7.007 [sec]

       7.007223 usecs/op
         142709 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
