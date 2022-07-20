Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E47257B0EB
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 08:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiGTGSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 02:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239357AbiGTGSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 02:18:12 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58175C95B
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 23:18:10 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id x91so22485727ede.1
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 23:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PBIQz6lZYVQ7K54F1V+i9jVuLt4C7Tnpp1TdtlJR3Uc=;
        b=XP84ylPq6gm/1WxH71tLtKih88lMGxSiFkzJOuoetPLDY2XsREhNBrb26XBaQYDo/0
         QiTHZhnixK2j+Wz5zy5ZVvjytb262YnYQW5gSM3YGkaJd9s1wLHdMc493AVnYFeZvY+F
         jUVdjLYMeYTS85X829WcGIErDPV1L5JUOFtQpEkGecFGYq5P2uWNk0cKzinibpL8jn4/
         VbdTJNv/ubLqAtB5HqzFBGurocJ365ViyQtFsT4LHPJrL75rTcrvm4PxGGz9feI4zir3
         XR2BhmX/wew/io5BXnp71W8zIhIp6XYLRaltp+U9yi/TtMHysRPkWNBbswDsRVQYyuat
         r/PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PBIQz6lZYVQ7K54F1V+i9jVuLt4C7Tnpp1TdtlJR3Uc=;
        b=eUiAvbxg9MpOZKibdVTU+vMtSldYuWVc63wZomfKupLqDBRs8BM6zqKaFb6fbbjl39
         Ue/Iv/OMoMIPl7JGrkuOW1PpV09gfIW+UlUEP3onpnaRTnNkwfxXQKMI+o8O0gzpTYiS
         /pVPXoK9zE8NR1JR/zlWKTKMpeFHPuJFAPT/5Ld3xhJrPvyvucFvBsS1CIKc6KPXAl6B
         RlWg0h+6IJDchYxJVjFnxkWtpID5PUflv/HiKReHhFndBWi8HoRMcYIpUyPan2L3dVOo
         tE98GUAkSSoGywE2w9LIAlYCtYo+erGwRwlTt3WtnXgji2zIx7cRziptOw1JlrcemcLS
         K7Tw==
X-Gm-Message-State: AJIora981i33VFSBdJBgXNC9Q8S+d7hCot690m3I8fd5A/MoQHctj1xR
        mo4+EcWdNRawTy37TCuoVD6klGxQAZ0kQ3CDzXAmAw==
X-Google-Smtp-Source: AGRyM1tkiPvJTd+T4N4kZ6UDIRaJtBPNUXPOixXueGeMxidwioaNwZhNwN2X1zjIqWcqb2V8B8u5EbDiSBS36pdyfCQ=
X-Received: by 2002:a05:6402:2812:b0:43a:9041:d5db with SMTP id
 h18-20020a056402281200b0043a9041d5dbmr48426526ede.208.1658297889123; Tue, 19
 Jul 2022 23:18:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220719114714.247441733@linuxfoundation.org> <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
 <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
In-Reply-To: <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 20 Jul 2022 11:47:57 +0530
Message-ID: <CA+G9fYu9=Xd0f_dtjuMQgpnUr1P04MEZR4u-_WszKVic_xWECQ@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Tejas Upadhyay <tejas.upadhyay@intel.com>,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 20 Jul 2022 at 01:03, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Jul 19, 2022 at 10:57 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> >
> > Details log:
> > ------------
> > 1. i386 build failures with clang-13 and clang-14
> > make --silent --keep-going --jobs=8
> > O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=1
> > ARCH=i386 CROSS_COMPILE=i686-linux-gnu- 'HOSTCC=sccache clang'
> > 'CC=sccache clang'
> > ld.lld: error: undefined symbol: __udivdi3
>
> Looks like the one introduced by aff1e0b09b54 ("drm/i915/ttm: fix
> sg_table construction"), and fixed by ced7866db39f ("drm/i915/ttm: fix
> 32b build").

Daniel, tested with extra commits as suggested by you and i386
build pass.

     ced7866db39f ("drm/i915/ttm: fix 32b build")

- Naresh
