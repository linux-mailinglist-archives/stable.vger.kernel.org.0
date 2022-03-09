Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291F24D2C92
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 10:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbiCIJzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 04:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiCIJzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 04:55:01 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED63D0040;
        Wed,  9 Mar 2022 01:54:02 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id e186so3171987ybc.7;
        Wed, 09 Mar 2022 01:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+14GjQ8VFEaJ8dUWynMaVtyaYThCk9kMBQ49ijA4dTw=;
        b=VKmwmgf92bzfY8cmDqUGOnt1/KSNzaBsPztW7RcsPFS5ihfrbE3LZXxkU76GStXok+
         nEtgfYFyngw0vww/JnP9DWYPihbigEDOZbSoCsRUPPrRbhseN0n7E1oXUffK4aszigYa
         v7TQDrqYjqQGATxbamW4uZ9U6l2jPnM/XbaLGItllOfa1ff9x8jN6uM2BJRP/860pIQp
         cBk9vMb64VaT36V2KEOhLQmb35S4ZdklzQcZ3KSQZNjcNNmUcel+JVbc3bsS+n+4rV/D
         aV1SpOk23uiCu/iplJ4XNdkevjYkP7mZrX4cPmw0UYyJISDCeZvji/KEM5SNL9anmot5
         21LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+14GjQ8VFEaJ8dUWynMaVtyaYThCk9kMBQ49ijA4dTw=;
        b=5nrNzkpah+Gs9H/YGV/7SBfBePeYzHN5PpoRju41nCEERz3YrQd3W++r+1KHfxoEKg
         zSPp7QkzP09CAFNlorlbYTkp6uSUGSsjNuqZdfujc/sc1SAZ4a2f7VhO9PF/RCKncyaE
         AjA4NLlSIjQwXmLL82nJO5AmVtSKVTZ44xevg+7qEHUxaEefzxBLmqTCoEDt/n2B7JEU
         O5S1e6glQCQTtUjUY56rIsvdbE9puYqKy/twy/XNH3Vc1GY7mwrdDaXI3uehPe1Y2ZqD
         gKW83H+yxwYd9rsczcSPj8R7EdWyUCWhtabcoNV7eT924a5oZsjj50WMHDRnprfMmfpF
         WNyQ==
X-Gm-Message-State: AOAM530yYYZtPmZfNZ2rsWkhKu4QqBz6NISD/qFlPQUYhzCPs79n3wKc
        eNEee+yPxtj9W0rjyjoSXQvAyqpTICvwjAcL+WY=
X-Google-Smtp-Source: ABdhPJxmoGUidQHzeLMAoMH3lomCve4BKJC5Mqd1btsoVspGABW7oWKXkAbRZ8Q344/XkqB1JKs/1Bukd0nOxFFcmvw=
X-Received: by 2002:a25:7504:0:b0:629:308e:9d95 with SMTP id
 q4-20020a257504000000b00629308e9d95mr12948405ybc.106.1646819641703; Wed, 09
 Mar 2022 01:54:01 -0800 (PST)
MIME-Version: 1.0
References: <20220307162207.188028559@linuxfoundation.org> <Yid4BNbLm3mStBi2@debian>
 <CADVatmPdzXRU2aTeh-8dfZVmW6YPJwntSDCO8gcGDUJn-qzzAg@mail.gmail.com>
 <CA+G9fYv74gGWQLkEZ4idGYri+F9BFV1+9=bz5L0+aophSzDdVA@mail.gmail.com>
 <YifFMPFMp9gPnjPc@kroah.com> <CADVatmMs_+YN3YAajL95fy98iEgoeb-7qXA_ZJ7K3QsdHGG=oA@mail.gmail.com>
 <8f97b76e-fe64-ad9e-fa46-9874df61c35d@roeck-us.net>
In-Reply-To: <8f97b76e-fe64-ad9e-fa46-9874df61c35d@roeck-us.net>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Wed, 9 Mar 2022 09:53:25 +0000
Message-ID: <CADVatmNXDx4-vrsyZBeRs8HHYfS3j8OPpS4CGnhQc=uyijgwvQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
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

On Wed, Mar 9, 2022 at 12:53 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 3/8/22 14:27, Sudip Mukherjee wrote:
> > On Tue, Mar 8, 2022 at 9:05 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >>
> >> On Tue, Mar 08, 2022 at 11:08:10PM +0530, Naresh Kamboju wrote:
> >>> Hi Greg,
> >>>
> >>> On Tue, 8 Mar 2022 at 21:40, Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> >>>>
> >>>> On Tue, Mar 8, 2022 at 3:36 PM Sudip Mukherjee
> >>>> <sudipm.mukherjee@gmail.com> wrote:
> >>>>>
> >>>>> Hi Greg,
> >>>>>
> >>>>> On Mon, Mar 07, 2022 at 05:28:50PM +0100, Greg Kroah-Hartman wrote:
> >>>>>> This is the start of the stable review cycle for the 5.15.27 release.
> >>>>>> There are 256 patches in this series, all will be posted as a response
> >>>>>> to this one.  If anyone has any issues with these being applied, please
> >>>>>> let me know.
> >>>>>>
> >>>>
> >>>> <snip>
> >>>>
> >>>>>
> >>>>> Mips failures,
> >>>>>
> >>>>> allmodconfig, gpr_defconfig and mtx1_defconfig fails with:
> >>>
> >
> > <snip>
> >
> >>
> >> Ah, I'll queue up the revert for that in the morning, thanks for finding
> >> it.  Odd it doesn't trigger the same issue in 5.16.y.
> >
> > ohh.. thats odd. I don't build v5.16.y, so never thought of it.
> > Just checked a little now, and I was expecting it to be fixed by:
> > e5b40668e930 ("slip: fix macro redefine warning")
> > but it still has the build error. I will check tomorrow morning what
> > is missing in v5.15.y
> > Please delay the revert till tomorrow afternoon.
> >
>
> In case you did not get my other e-mail: You also need commit
> b81e0c2372e ("block: drop unused includes in <linux/genhd.h>").

Thanks Guenter.
And, I have now verified that both gpr_defconfig and mtx1_defconfig
passes after cherry-picking these two commits.


-- 
Regards
Sudip
