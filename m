Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371F84FBF9F
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 16:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347529AbiDKO4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 10:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344802AbiDKO4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 10:56:06 -0400
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F173B288;
        Mon, 11 Apr 2022 07:53:52 -0700 (PDT)
Received: by mail-qt1-f169.google.com with SMTP id t2so16347614qtw.9;
        Mon, 11 Apr 2022 07:53:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JY74z8nf9kn7EhlEKevWF8Q7bJAxY2gdWGAAwrQ1H9w=;
        b=6OyrEpWlhfbRnULTmTyH2Rw6EkZ7yEPM4rDek2XFBFGb3FR/OiDeAeUmI238RdsRRa
         XdOYc6lM1f3wtLHcHggBjebeEek9m1bk90rOPNEcyj0DRwxQv6Fn5BUbaDViHltNjvRS
         CcUnNqNWEbI9BGNCr7YyCIDXa5CiGQ7NJ3gYmtEtz7E/YW6WoeApsCoQfTb3HGrU6aL6
         i9J/wl5aZBUuKIDFlygxq3BMV362bMAd7LNPWVlhZu/q3aA0YIhf6hMYnIM1+caPmnuF
         KAQ45Ivzn4QjuE0ZA5u51Cmx3pjs3H5E+uEs7LDFU7jqHIMvKRhHN6GWC0ksfkaanLFa
         yojA==
X-Gm-Message-State: AOAM531UF5mPLqMnOGCVwbDxFC6sRDXCc8V58xjJHG7JWcw0Lm5s0xrr
        14GO9yaLMqRY3SYi1PuN9qjOTigwXqd2aQ==
X-Google-Smtp-Source: ABdhPJxmFqsRfoaxvHZ24LL4AehajGJudItI2VzCuYtuaQzRvssTTU4ftSFqq6nLFarAznZHx/6Sfg==
X-Received: by 2002:ac8:5544:0:b0:2ed:de3:f3d8 with SMTP id o4-20020ac85544000000b002ed0de3f3d8mr10822429qtr.273.1649688830783;
        Mon, 11 Apr 2022 07:53:50 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id x6-20020ac86b46000000b002e02be9c0easm23529721qts.69.2022.04.11.07.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 07:53:50 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id z33so27947808ybh.5;
        Mon, 11 Apr 2022 07:53:50 -0700 (PDT)
X-Received: by 2002:a25:c049:0:b0:634:6751:e8d2 with SMTP id
 c70-20020a25c049000000b006346751e8d2mr23338907ybf.6.1649688829903; Mon, 11
 Apr 2022 07:53:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220406133122.897434068@linuxfoundation.org> <d12e1f2e-bcad-e7d5-5d14-e435340ffc2c@gmail.com>
 <374de447-0d28-6b85-6abc-687d9a444b66@gmail.com>
In-Reply-To: <374de447-0d28-6b85-6abc-687d9a444b66@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 11 Apr 2022 16:53:38 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWz4_Q7+rgk87dnF-+MpZ1vjdExcfydBBa_=DjixqMkHA@mail.gmail.com>
Message-ID: <CAMuHMdWz4_Q7+rgk87dnF-+MpZ1vjdExcfydBBa_=DjixqMkHA@mail.gmail.com>
Subject: Re: [PATCH 5.17 0000/1123] 5.17.2-rc2 review
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bagas,

On Fri, Apr 8, 2022 at 10:13 AM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
> On 07/04/22 18.45, Bagas Sanjaya wrote:
> > Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0).
> >
> > Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
> >
> > powerpc build (ps3_defconfig, gcc 11.2.0) returned error:
> >
> >    CC [M]  arch/powerpc/kvm/book3s_hv.o
> >    CC      kernel/kexec_file.o
> > Cannot find symbol for section 11: .text.unlikely.
> > kernel/kexec_file.o: failed
> > make[1]: *** [scripts/Makefile.build:288: kernel/kexec_file.o] Error 1
> > make[1]: *** Deleting file 'kernel/kexec_file.o'
> > make: *** [Makefile:1831: kernel] Error 2
> >
> > Reported-by: Bagas Sanjaya <bagasdotme@gmail.com>
> >
>
> Oops, I didn't do make mrproper before powerpc build.

That still sounds like a build system bug.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
