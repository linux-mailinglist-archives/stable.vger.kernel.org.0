Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70ADC4F7BC5
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 11:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239237AbiDGJiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 05:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbiDGJiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 05:38:03 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15B1642A;
        Thu,  7 Apr 2022 02:36:03 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-2e64a6b20eeso55434667b3.3;
        Thu, 07 Apr 2022 02:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=za2aziVpAdaW5Hl82CH4d72w5w85rNVvkNBe33KHkZ8=;
        b=Fg1eJGA3tdXOKmj5aiauxcPzDtyusC/lcV1g58u+g/sq3fKK2keOy00OhGC5o4DZNz
         7cZ5LgtSvGYSIFTY8b9I+x0adUTpG67SBpjBDnWNIcxo8C8Fi6R7hknxyL6R8ywt3wkd
         gFuEAlNqUw3gcf8drosoSOhntp+up9jDoB+ApH7D4eGquYXLPBSk/ZnvHCCkBaYQYJHf
         ikz8Mrg55M17GDDLZP0jBPMQtCDCf429rUrFrlQ1KlrLnk1/nROqE3yxEYVn3SzsPeiw
         LVyUsiHAl4X7d28T6iL/BFyUnxOpfG8N5CSaavQc7Cdig0kaI70FRF6T000bXsUMjRus
         +6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=za2aziVpAdaW5Hl82CH4d72w5w85rNVvkNBe33KHkZ8=;
        b=d8ZNB7JVu5TX/G2ktE2a8ryUcJTrEhmfoW9938DPPALb/BHbHDvKEfbqFpV6Ro3SFP
         VHq/C2U2BMTvSyonwxGJwpVISfi98bE+oAQCSqjPAp9ODZmq+0sDT0TYO3VpN4PkeEbp
         NxuQwhhCRozGF0sJJk4KXjHYJ34XxZiNLpvzJEH2ZYgkODFhbqRjQM5dx0M7vIbTE9SL
         8DJ0wzDLhuywQHSUlgQlHxNe0E+AfEqgvz3Ie0cl2H9wjs8B5iK4h41uRen6OzxKU75y
         BjiSyD3mSjN+vyv/yKyyU0ire5n4exvVnhlBeerz6CqibEsfpMoGwQ+uOLZLF03CdU6f
         Xipg==
X-Gm-Message-State: AOAM533kS4h3+6ZHD2QHP4UMP0y4P2omoc/BJ8rNbaU5WzTTNaS2/PFy
        4VTsogFKUPP/+wR3jZg25qI8S2XaWWufhk569WQ=
X-Google-Smtp-Source: ABdhPJw/VanDLpPbX5gVfPRWTr6tADK9bZYKLIAUlItLLJmPQwzeIKCF58bZhNfSDoZa0aIf0woNzZLYg1NSXv2N5dg=
X-Received: by 2002:a0d:d746:0:b0:2eb:4ee1:5e7e with SMTP id
 z67-20020a0dd746000000b002eb4ee15e7emr10986105ywd.478.1649324162976; Thu, 07
 Apr 2022 02:36:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220406133013.264188813@linuxfoundation.org> <fce71421-6afc-9f8c-31a2-a71fccb3259d@roeck-us.net>
In-Reply-To: <fce71421-6afc-9f8c-31a2-a71fccb3259d@roeck-us.net>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 7 Apr 2022 10:35:27 +0100
Message-ID: <CADVatmPpDpcX-0NYBUgVjNtgB_EjXL7GO5bfuTH2yGR6DB5_jg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc2 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 7, 2022 at 10:10 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 4/6/22 06:43, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.110 release.
> > There are 597 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> > Anything received after that time might be too late.
> >
>
> I still see the same build error. This is with v5.10.109-600-g45fdcc9dc72a.

45fdcc9dc72a was rc1.

rc2 is f8a7d8111f45 which is v5.10.109-598-gf8a7d8111f45


-- 
Regards
Sudip
