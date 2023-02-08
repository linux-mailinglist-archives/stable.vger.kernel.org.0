Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82AFE68F3FA
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 18:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjBHRF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 12:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjBHRFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 12:05:55 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3931C26CD1;
        Wed,  8 Feb 2023 09:05:55 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id o75so1549966pfg.12;
        Wed, 08 Feb 2023 09:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NtgcvPhFKAP4Fee6Luz9mWtOfLHAuno8WLgBdCIQtz8=;
        b=JEBlsLZLFhIbkuWyXAdB6SBNj9oUPK5ILJwHvgWZ4kRHfSm+JT2iQdipEfuBubRt1n
         tF8HnPRhxrbiXLPuLBJabjpJhzTWAKyRzPI+4qnWJOURDkHsJQiZIfqRBfMDeCz/LOfF
         FMqfwCncduLlAvCDqJO/mfl6H14BNXsikl3A04xmuk9pX21bvXz8diMakla6A5bkPziX
         lUmqwNNakv+nBu+swpwZSoXtdhc5Au6NZmgy4JWNtBuZOF+hgZcg8VYeyGRrgf0+li+R
         SrncsVCCRL3r1928CByBG3aFwDtemQ05aHBgogqH8b7zloxoP6Bk8jvhO4SbFHTJDdQS
         iEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NtgcvPhFKAP4Fee6Luz9mWtOfLHAuno8WLgBdCIQtz8=;
        b=vmUcBL7FZM6irxJPgw6cEhSnRqzhDBcTfMg1vFyZjjS9tzLrxc5fW261tH/2PvDLcK
         s8eAxe1uuBAt2k9Pjpmm/xyXEO4BsAR9qpnF1M2PNuR1cpwMWMQtLu4eXcWiUj1cC6Kg
         N/0j9bLOKfH/Rx3aF0iEJdfyCH1cP+WaMU6rnIUPuGyknxLQ5AjfbIwNxkug8sbBbjgx
         w45y0rogRq0HjZ87p7RmRq9GHtuDmwop4gvqtOlhlIv/AfGI0RzWhMVa/d6MHnqqEJ7O
         N3JTbhM5IE9DSRa5+tkkISlRnUu3YIML0IcZ5KhG+N7mV0z099YvrCD2Gq6LESDyVNs4
         Hsmw==
X-Gm-Message-State: AO0yUKVE1hd6yjMCh1SSjxDPJ5fHIf3wfFGEYo/iCVvMv0IjbNmDPfUr
        VxbfTTl9rqVVvKLd4mCyyBsEUmE5F+7XDbMi+O1qzgv9yfo=
X-Google-Smtp-Source: AK7set+OevTax1m/xAS2B7en2U+1YOEHnIsELnkB1bu3keFDXH4nPGm41hmXJX57cQ6mAt2eY7s0AzklxdijXEzxb5A=
X-Received: by 2002:a62:1988:0:b0:593:ccf0:a288 with SMTP id
 130-20020a621988000000b00593ccf0a288mr1718573pfz.13.1675875954760; Wed, 08
 Feb 2023 09:05:54 -0800 (PST)
MIME-Version: 1.0
References: <20230207125634.292109991@linuxfoundation.org>
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 8 Feb 2023 09:05:43 -0800
Message-ID: <CAJq+SaB5pmW0o5SNJg_xw93emB7ZtYYLSxjjxtJ9eRQU5KTZDQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
