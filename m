Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF295225BD
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 22:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbiEJUpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 16:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiEJUpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 16:45:04 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2B22A28F6;
        Tue, 10 May 2022 13:45:02 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2f7bb893309so193180737b3.12;
        Tue, 10 May 2022 13:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BrRJYBjS3oQOjizWwUlaoTbPU5hZi97x1mqlvUymfoo=;
        b=XQfxFjb6eCfUJ/OGp0e5FtspQty+u+fX95U2bLklHVuQI+I4OnEZmBWN2Yd5UXoN03
         tWUwhDAumcnvaSVWzgHH9SZF8rWlu+IKYeX9TmLl3qsE0RSTuy+jBY0Oxiz1nMGarjQc
         NhnNps6uBvtGsjaIsPclMz9+pRXyGY9pXJgB+tretpXCX3VtbNDAH5K1Dnt4NqeXkGjq
         vOe78g3VIdGSPYSHTLT8AQpdzZFm4ENroeD3cPI/3MI42X4DpKlRou8AdsYBP1GN/QIs
         Nvm5t/iY6T2SRLJrVTahz7Vf0bTktj6dnQZY8ezx7umP526yIkIjzv9Lc9cbF+dafQNe
         UL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BrRJYBjS3oQOjizWwUlaoTbPU5hZi97x1mqlvUymfoo=;
        b=CFJftJcZkXtg/ym0i5ChwmhUPEIZQL6AXbF++/e2SwmUddhqlX3FY7timCgjf6k0Yv
         xxY+pludES16EdvpCYjOfs9RrlWs2oP47+8Z98A0kBIX2UbS78802EZo3ahiVzwrI6kL
         Ekne0/aa2PFC3dA1tNyRe8D9q2igYD2bikd+FKPQoId1vxomeW1HhsMk2TLnALLSQrSl
         vvMilO/XM05tUrWSIjUZvo6ZuGeOT1QCRcHoKbuTt52j9JCdAHbi0n9iCP1VKy3fkkBf
         Txxgp8trrPMrGYZ/Zc7xg6xhJ8btQeiXQ2Q3b4HtIqT9cWo2kOU8qOuHz+mANdnyMvxA
         5b6Q==
X-Gm-Message-State: AOAM53243hi1GMHICWLQ2UBbkL1G2GOn6MpBxnmaPVKJ2pIGWf+A+wA2
        TvHpKJPlOJF7L22k/FvyaZJhOj1NgXuiIlSGnZk=
X-Google-Smtp-Source: ABdhPJwnewgoQKLhIkzPf7D369Q+CSf7gvEBJNCOhwvaZqVd7IKm197Kq3ivHnsUA6DUpfxqeryq5cfLDxtupFAHVX4=
X-Received: by 2002:a81:50c5:0:b0:2f7:b5e4:218e with SMTP id
 e188-20020a8150c5000000b002f7b5e4218emr21854329ywb.361.1652215501936; Tue, 10
 May 2022 13:45:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220510130732.861729621@linuxfoundation.org>
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 10 May 2022 21:44:26 +0100
Message-ID: <CADVatmNyky-XXaeAiQ5ypZ7+7F7fzLshB4bNWt5v3RdnXStsOg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/70] 5.10.115-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
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

Hi Greg,

On Tue, May 10, 2022 at 2:25 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.115 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.

Just some initial report for you.
As mentioned in the mail for 4.19-stable, it will also need
d422c6c0644b ("MIPS: Use address-of operator on section symbols").

But apart from that, there is also another failure.
drivers/usb/phy/phy-generic.c: In function 'usb_phy_gen_create_phy':
drivers/usb/phy/phy-generic.c:271:26: error: implicit declaration of
function 'devm_regulator_get_exclusive'; did you mean
'regulator_get_exclusive'? [-Werror=implicit-function-declaration]
  271 |         nop->vbus_draw = devm_regulator_get_exclusive(dev, "vbus");

This was introduced in v5.10.114 by d22d92230ffb ("usb: phy: generic:
Get the vbus supply") but I missed testing that release. :(


--
Regards
Sudip
