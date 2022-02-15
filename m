Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03AB34B60A6
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 03:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbiBOCCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 21:02:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbiBOCBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 21:01:15 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B18141E2B;
        Mon, 14 Feb 2022 17:58:41 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id r144so22130896iod.9;
        Mon, 14 Feb 2022 17:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MpC0HbFx2p3TGQJ1EFs6Qo70XuFPuwRTWe9faO3oyE8=;
        b=k+g258VzTeS11yd/XrsPqAGybZ/1+tU3X4dCuKmZTwZAcpIkq1msesy42xuDExxsVM
         3d+2p5jTm41zdPxFpVn/wp8E7cMVu+lRE9+AJjf9HuNZ9yEvX8BS1GJ++Dkem2A6mfca
         OCbXW2GIbBcGI13j0dUAQGgYc8l77GhamnKu33hV6gGAseMu3zQwgEA1klPFBOAeAZ8b
         qgQSKpDjTPBSAMnMg/tNcmeF6gt60Gc5EVGQ7JQKxG5LJLFffd0N8HsyXTGgCcFIqz9X
         YSe0Q6YL6Cu2/Iby3vc0ouAQJKLJ8vSapM4VOdet0fChMyJ7caI5Y8kz9kDDzrK91p6Z
         zJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MpC0HbFx2p3TGQJ1EFs6Qo70XuFPuwRTWe9faO3oyE8=;
        b=5HlGXGAGGGqPRFmtOarFywDjyXMV0uKlzgbm7mlQ9aR5iw8mfajTubloah766KhdVI
         4U4pPnhDQkqB+BN0YFQlR4ZXIzgJjYQyaghIAyV+akKzZirO3z32WTOfvyVXTI+Sny1H
         fbnexd3eHharaoeZr/f8EH/wqMEA4y+TQWBNJdOFIL8Jas9r0PGimaQAr5GUotUtds2K
         /liGbnuUh53IfZ9oYeX82dRFknM7s+qndY5qBbs+PJprJUoTd64KO1qb0ujWVaLBEAAF
         uejDkC/NPXLkvc3XUxaVrsIbxnSo63YZuZhGD8xKBMmnJxfHlzfhMPfxdaZXCsSVXzsR
         3Mjg==
X-Gm-Message-State: AOAM532pvCa/oWSVPsQnW7QhB1joxGHkHDR9qHuP+w33s5w/Yuvmtgjc
        2tenytRVXTrTE1tWsGxfGDOphzNW9CVcJSdGZCMVKutr3ZxI6A==
X-Google-Smtp-Source: ABdhPJxtWNyq+ixqkJFqqn5kgcn0Amxa9OlctSHR2PVokh2YURyq4KP5yPq5dlOf0BVCUzzI1PjB/LDn/YWQJDoKE74=
X-Received: by 2002:a02:2b03:: with SMTP id h3mr1131758jaa.196.1644890321137;
 Mon, 14 Feb 2022 17:58:41 -0800 (PST)
MIME-Version: 1.0
References: <20220214092510.221474733@linuxfoundation.org>
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 14 Feb 2022 18:58:30 -0700
Message-ID: <CAFU3qoarsN9cnxhr26+aRsH7Ewu15gEVdLhRwiVTMmH=4Xgr3Q@mail.gmail.com>
Subject: Re: [PATCH 5.16 000/203] 5.16.10-rc1 review
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

On Mon, Feb 14, 2022 at 8:02 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.10 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.10-rc1.gz
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

     Total time: 8.687 [sec]

       8.687780 usecs/op
         115104 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
