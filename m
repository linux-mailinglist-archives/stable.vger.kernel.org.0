Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80C75A952F
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 12:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbiIAK5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 06:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234344AbiIAK47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 06:56:59 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E3FACA08;
        Thu,  1 Sep 2022 03:56:57 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id 123so8044683ybv.7;
        Thu, 01 Sep 2022 03:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ySjRx9EiLtDb+jiYSjMGVVtxd7TNBgsAeUe7zB2i7b0=;
        b=J924zAxFzeRKsSvSIwzzN0MWsHSXuXofjgUb1YM7vhpazMju53+TbfYNNqywjKLh2Y
         z6YmENDzFzjT8i87zornN0IaPmVEIjPXMtzkZPToSUtfIo09LEGzAzYQU0jT/3FTj3Vo
         /RgdJWvfVAMKT6Ub49J10Vr8+jOh9dueRLv8TdaAdxXOGcqcHqEMEORKAv0HJk4Jlfsb
         FNqktrQofknQdSy9zy3+LFsIWu0IR567G+8Jj2placPQHz4alz91v0McM9aqsD3Kew/m
         KtVN8/7Nx0AilFXIlXf+gUDbjoJ+1IJj5pQmutDSiOKbmmbrRBxyU5b//yr53Aw8F0j2
         z57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ySjRx9EiLtDb+jiYSjMGVVtxd7TNBgsAeUe7zB2i7b0=;
        b=JbsDtaKE243y6HrnI4W8SYUUIYKHHmexg1EzNMOi3XuEExtR3uCxZE6107d0vcX9md
         U63A0M4DDuGTXkl9msc1aL70kKvS+9HT7HxQWXMQJ3CCC61T+eMdOHSxchv31v9V9+ch
         33LvDNtYQSxMe883FAwAVLmCS/j1hVyy8Q3+CiPcoCC+R39AmEUb6hct9lc73IszbYIJ
         eiPvgnvQMIidiwv1nbIo1geziE7XztB9JSWBNRtA77elV7tZ7GapEWtUlWXI3cIDEMPC
         d0iUuMS0iLpX74/YC64nQxJAehGz1cEZW8jxgQu/RZE9zwnzds+xKJ3TfajU2s+etR+A
         zrqQ==
X-Gm-Message-State: ACgBeo03aQznvNXpUzdRm+il4meGA3AJb97Av/HkWNkj0Q7VopZiB1mU
        LiAIR6SVdLZDmGdoV8JdqRVEkhtT+7gaODQtHmU=
X-Google-Smtp-Source: AA6agR4qVqRdcyxMrmMVnY3SusWM/mlHEXED98DAr5cfcB1cKm0l+uwvJPjFj9+JEE68skEo/Z24B2hOwb+f+gqPVus=
X-Received: by 2002:a25:3b46:0:b0:69c:a60e:2e57 with SMTP id
 i67-20020a253b46000000b0069ca60e2e57mr6795788yba.364.1662029815992; Thu, 01
 Sep 2022 03:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220829105804.609007228@linuxfoundation.org> <CADVatmOLoaGgAW951JqEk3v88EA7mn3qur84Xd30QJWP21+eVg@mail.gmail.com>
 <YxB/ZPFEQG9zS+wa@kroah.com> <CADVatmPxfdEA3yi9KGHtvmQA2n-mA=ekBidqU+keGrBsL+rFeQ@mail.gmail.com>
 <YxCJzr0XCd+6/JW4@kroah.com>
In-Reply-To: <YxCJzr0XCd+6/JW4@kroah.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 1 Sep 2022 11:56:20 +0100
Message-ID: <CADVatmPMGmvabWb0S21P8Xycu5ZYe+imyR8tbG27qX28VuyUtg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/136] 5.15.64-rc1 review
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

On Thu, Sep 1, 2022 at 11:30 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Sep 01, 2022 at 11:22:53AM +0100, Sudip Mukherjee wrote:
> > On Thu, Sep 1, 2022 at 10:46 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Aug 29, 2022 at 09:11:28PM +0100, Sudip Mukherjee wrote:
> > > > Hi Greg,
> > > >
> > > > On Mon, Aug 29, 2022 at 12:00 PM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > This is the start of the stable review cycle for the 5.15.64 release.
> > > > > There are 136 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> > > > > Anything received after that time might be too late.
> > > >
> > > > My builds are still running, but just an initial report for gcc-12. (I
> > > > know v5.15.y still does not build completely with gcc-12).
> > > >
> > > > x86_64 and arm64 allmodconfig build fails with gcc-12, with the error:
> > > >
> >
> > <snip>
> >
> > > >
> > > > Introduced in v5.15.61 due to 2711bedab26c ("Bluetooth: L2CAP: Fix
> > > > l2cap_global_chan_by_psm regression").
> > > > But v5.19.y and mainline does not show the build failure as they also
> > > > have 41b7a347bf14 ("powerpc: Book3S 64-bit outline-only KASAN
> > > > support").
> > >
> > > Ick, ok, what to do here?  I can't really backport 41b7a347bf14 to 5.15
> > > easily as it's huge and a new feature.  Any other ideas?
> >
> > Yeah.
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=b840304fb46cdf7012722f456bce06f151b3e81b
> > will fix the it for mips and csky failure in mainline and v5.19.y. And
> > I just verified that it will fix for powerpc also in v5.15.y. So, we
> > just need to wait for now.
>
> Ah good, thanks for pointing that out!

uhh.. I can see you already added to the stable tree, but its not in
mainline yet.


-- 
Regards
Sudip
