Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9D76E7276
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 06:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjDSE5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 00:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjDSE5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 00:57:13 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06FF1FCF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 21:57:11 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f048b144eeso100495e9.1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 21:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681880230; x=1684472230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCRs4ZT1NMucVRTV4T7ESOYqv5BN2PQbexcodDRyfMQ=;
        b=uxDD6c2HREJe0YlUGLQhAW6jUOghV2gl3yqQyLE8D1DCSkAH6obgYK9hLOC1PRYiFe
         O2LOQR+g0im6/ZRyhdfLrK0YStnrbw3e0mn/Ln2Y5Y+eez9XdTEXkjdGKHMTq6tADWlR
         VX9gpE2Vy8L6UYq7g8EdXlMnWZVvLlcG4Nqi361M0rCXB9Hp6Bz9SB+jtUelKZQhH2rB
         MTwoYPmBx/6r7EtA8RV93lYtuHCcUKVQvgtWJY8bCHxH8M23lmmdX6ELT1bA9vpclQ5+
         CSBFMgY0Wz5CPYZwWP/h6+5LOWFvZwG9g9eESlKKtexygzJJuYpZ3zoRu40jm2+2jBNA
         tyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681880230; x=1684472230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LCRs4ZT1NMucVRTV4T7ESOYqv5BN2PQbexcodDRyfMQ=;
        b=KMjUyEKGWd9VK+BUSukfg14OCU0cXspIhc4SMVCh6z2KMiumhEHtx4u/31NPRsSKoE
         OrDacfBohhIVM02hEFE2omzRXRPdWhoH7DJBDljrZYmsRIz3lYambUDUpWxxjecnoigP
         YGGyyw49nUqbm3QJLkn90xnqrNWzhthGTbBxyMOaYEstH0Syrq7zUJGKRrGR5ghD6Jt4
         82Qg/XlfpuXqrFFwafddZCqdi3oixjT9fAgqlRNnLslNCjSqVTMwFgaYAsIAzUPtNO9n
         mtHGMI3dxBN12d+JMRno4WPe10EYORix3bbPhYkTfCOlwfpkrMOAFrPr+JO9iwe6XC5C
         qczg==
X-Gm-Message-State: AAQBX9eCT/+6Rqo45alkoHLr2Gd950iOFH4zNjUnq0A+Tj6svCOU7LRb
        /jjk/ZwClxjoQonHtWzxr5BBP9MZiht4F1QQWmsFuA==
X-Google-Smtp-Source: AKy350Ym9AgVWLy367+bnRhY6AG1ScJrgNkD1/7T5WwvBqykfqn/+ktGpoxXbQm1J15J422IZEIzWeru3nZngskvhk4=
X-Received: by 2002:a05:600c:1c9e:b0:3f1:6aff:60e5 with SMTP id
 k30-20020a05600c1c9e00b003f16aff60e5mr113901wms.0.1681880229465; Tue, 18 Apr
 2023 21:57:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230418120305.520719816@linuxfoundation.org> <CA+G9fYs9sHnfhn4hSFP=AmOfgj-zvoK9vmBejRvzKPj4uXx+VA@mail.gmail.com>
 <bd46521c-a167-2872-fecb-2b0f32855a24@oracle.com> <20230418165105.q5s77yew2imkamsb@oracle.com>
 <ZD9rfsteIrXIwezR@debian.me>
In-Reply-To: <ZD9rfsteIrXIwezR@debian.me>
From:   Yu Zhao <yuzhao@google.com>
Date:   Tue, 18 Apr 2023 22:56:22 -0600
Message-ID: <CAOUHufa9-AKwwx7oVpQkV355TTmVSfi8roBKEsRjRNbeuGUkbw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Tom Saeger <tom.saeger@oracle.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Waiman Long <longman@redhat.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, Tejun Heo <tj@kernel.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 10:18=E2=80=AFPM Bagas Sanjaya <bagasdotme@gmail.co=
m> wrote:
>
> On Tue, Apr 18, 2023 at 10:51:05AM -0600, Tom Saeger wrote:
> > > Tom Saeger identified that the below commit moves it out of ifdef.
> > >
> > > commit 354ed597442952fb680c9cafc7e4eb8a76f9514c
> > > Author: Yu Zhao <yuzhao@google.com>
> > > Date:   Sun Sep 18 02:00:07 2022 -0600
> > >
> > >     mm: multi-gen LRU: kill switch
> > >
> > FWIW - partially backporting (location of cgroup_mutex extern) from:
> > 354ed5974429 ("mm: multi-gen LRU: kill switch")
> >
> > fixes x86_64 build for me.
> >
> > Regards,
> >
> > --Tom
> >
> > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h

...

> Yu, would you like to provide formal backport?

Are you suggesting backporting the entire MGLRU patchset (>30 patches)?

I do have the backport ready for 5.15 and multiple distros have taken
it. But I don't think Greg would welcome it. I'd be happy to be wrong
though.
