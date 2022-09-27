Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB6B5ECC04
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 20:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiI0SRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 14:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiI0SRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 14:17:52 -0400
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA6DF8594;
        Tue, 27 Sep 2022 11:17:50 -0700 (PDT)
Received: by mail-vk1-xa34.google.com with SMTP id h5so5352155vkc.5;
        Tue, 27 Sep 2022 11:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=sdsI7o0iULzvQFOQDZ8io03SpfGx5ZxzsPIkwgHTFDU=;
        b=YwwkZJXFufr9hauT+oBibBsTvTNrsYl2J3IlvSbxk2AZ009ioCEw3m+gCXAyzhov12
         94RSvodhG+Ytvn7W1Tbh9E4JVdSr509s/PFeZbjSc1G9f9/GschQg4LHqRX/1B76cq4C
         vUUarXqNaATHOHDYaqCHUs+DYRPQQ2UvJGVPCcCnWrvUNDHJFjDA31EvqjBuHAVRM49J
         bd2jYGI+ESYkrh6K/8A35P73pAqgsW5jEtqTLT1vgmxW2oiuRMRjzeuoRYTTHmSADKwN
         AFJjsvlsdSP7RQ1aAiT37GhsuBuDvpI3w11bHP3dsTqzPuanJQbmCM3L9jw/rh354/1l
         1Ckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=sdsI7o0iULzvQFOQDZ8io03SpfGx5ZxzsPIkwgHTFDU=;
        b=tCEZhPjV0kaOfOnoaPQFRzJzFuIN+fY3mSI+V1Vz5bIo45ZOtzHXZABF1o5jFOMZBV
         Q/+N4bTPeZdgos/4iFd3HEh1xwAjxBto84A78fQQDZHJXCOWPncHrR3SnNu2ZHaOF6oY
         sN5Ar6bT0lukubJ8/YK1x6lEq/pwxeZiJE73qYPgbhaDbboFZSimcQwUexndyRzB0ok1
         vpADyeU2T53vJkjScWc4RQNg82giWXZBHyh10hdfFDHpVkTsCEQM8qgnYhZHVu3koe3f
         mXKuLXmHaq95Oh9ABf+s079fKTl98Tv54JWkzegasjMP8fClY8W6M189w8eS7v0We890
         rtBg==
X-Gm-Message-State: ACrzQf2LGCUacT/x0Mu6Vt1Jq8DzrptKupVbzdMb6gtqNDGI7ykBTebQ
        4byLMLkOG+JEeDq6++5j1rkWwpJ1zG4F1HxAhXU=
X-Google-Smtp-Source: AMsMyM7jl3W3Ddni/T0B7DwHzJOkYUVqn7X9N3JpO6O3aCYBj/RwaNww5sruA6jqOalsvvu9a7mL6R0z4PAFXV2Y44g=
X-Received: by 2002:a05:6122:53:b0:3a2:6cf5:bceb with SMTP id
 q19-20020a056122005300b003a26cf5bcebmr12382322vkn.34.1664302669523; Tue, 27
 Sep 2022 11:17:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220926163546.791705298@linuxfoundation.org> <CA+G9fYu6DQvRuD8b1C93qWjfJJrVGUatvatX0ij9nzZhkcf7uQ@mail.gmail.com>
 <YzLwNqCLQClDpyKA@kroah.com>
In-Reply-To: <YzLwNqCLQClDpyKA@kroah.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 27 Sep 2022 19:17:13 +0100
Message-ID: <CADVatmNvu30rs97g9xt6PAyXzR5QyitgcK2w8s7f1zybrBWaLg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/115] 5.4.215-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 27, 2022 at 1:44 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Sep 27, 2022 at 03:18:14PM +0530, Naresh Kamboju wrote:
> > On Mon, 26 Sept 2022 at 22:06, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.4.215 release.
> > > There are 115 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.215-rc2.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Results from Linaro's test farm.
> > No regressions on arm64, arm, x86_64, and i386.
> >
> > Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > NOTE:
> > Following powerpc mpc83xx defconfig with new gcc-12 build warnings.
> >
> > kernel/extable.c: In function 'sort_main_extable':
> > kernel/extable.c:37:59: warning: comparison between two arrays [-Warray-compare]
> >    37 |         if (main_extable_sort_needed && __stop___ex_table >
> > __start___ex_table) {
> >       |                                                           ^
> > kernel/extable.c:37:59: note: use '&__stop___ex_table[0] >
> > &__start___ex_table[0]' to compare the addresses
> > arch/powerpc/boot/main.c: In function 'prep_initrd':
> > arch/powerpc/boot/main.c:107:25: warning: comparison between two
> > arrays [-Warray-compare]
> >   107 |         if (_initrd_end > _initrd_start) {
> >       |                         ^
>
> Is this a new warning?
>
> I don't think anyone is attempting to build 5.4 with gcc12 just yet...

I build with both gcc-11 and gcc-12 and in my tests only arm64
allmodconfig failed to build. Need to find out the mainline commits
for it.
powerpc allmodconfig build passed with gcc-12 for me, did not have the
warning which Naresh mentioned.


-- 
Regards
Sudip
