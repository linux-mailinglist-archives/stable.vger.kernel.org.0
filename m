Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352AB4F624E
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 16:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbiDFO4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 10:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbiDFO4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 10:56:14 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F940274E56;
        Tue,  5 Apr 2022 19:30:28 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id b17-20020a0568301df100b005ce0456a9efso846892otj.9;
        Tue, 05 Apr 2022 19:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4sbayUrtu9SPTQh74j6dzSP4lUUqB5Lj6BgXL8JmuD0=;
        b=foQKaSZCdYphHYiQmcmf23s6ShUWoPPrg6ZZbXuM1ztEdeAz9irZJRqLvOKJ+mL/1O
         omKQrLXPiscHqohp9h2+rBlC0gHFWYmgj8aBhaEg7klZFDyoEYNAt65dz+xjEPPtxL7n
         iDCxwA50T6SYEpRTsscjK9J8W5bp4jVEU/D9JzUNQPTmUvpo6Ri7fl6ZYU62NgjEXr53
         X/jBmoF68XHH7u7JDIGgE2ngc8TUd3RppSFYTr2gJWVwYb4Q+CdxArllhjf365NK3VS0
         /QidljM5qXmYznPOFwX0T4vEgCzr2ZqnLhAJCWy2Aro3TkDWZamXPIS1LcGR1Dia/t3w
         KpEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=4sbayUrtu9SPTQh74j6dzSP4lUUqB5Lj6BgXL8JmuD0=;
        b=2/KsG4hXMZfNv71gglyTHTTvoAUFyjtfXsD6Cha7XEUoWVE7qA/O4bjXI3c3DvXSvx
         Th9DGj5XbYB+kEM22yoR/Ol8SCmOL5N6YKbm2O9Qlqw+yRxOKJGrdvftz+YZ2NpZDTQo
         /GWo5zbuOFZNfe+7BPdYC6s8X7dKzSAIvjasGW/1hdobuEptB0S/FtnhxmJ8z9aTuf8B
         30o3D+bvB6TAlSVpXEkCsdCK9zZKtm7bGHo6JfTzN8tmgzEz87HnO/EWc9xQrrGLoGa8
         HxjdcTEJsGBVpYBhyReLqnGKAFUs0MOJ58Pcnu3xlmiH8ByiTmNUU1wm9hQDGgkAkctj
         axcA==
X-Gm-Message-State: AOAM530YhhPe3boBIkl2ZhUjiCEeNUUCmPQLT6zturD/0KJyuEh+al1Q
        Z7+UsWLGDo54+w8vGLskbr9UilSdUf4=
X-Google-Smtp-Source: ABdhPJwBgU5JVD9hO/V7syHU7jxzDiWvkGp20+ZxDz1WkoYz9eoL6xRSdY7v7AKX2OCVuceuyJKP/w==
X-Received: by 2002:a05:6830:1418:b0:5cd:8cd1:11ca with SMTP id v24-20020a056830141800b005cd8cd111camr2359334otp.310.1649212227404;
        Tue, 05 Apr 2022 19:30:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id fz16-20020a056870ed9000b000dde87bcdfdsm5958167oab.53.2022.04.05.19.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 19:30:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 5 Apr 2022 19:30:25 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
Message-ID: <20220406023025.GA1926389@roeck-us.net>
References: <20220405070258.802373272@linuxfoundation.org>
 <20220406010749.GA1133386@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406010749.GA1133386@roeck-us.net>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 06:07:50PM -0700, Guenter Roeck wrote:
> On Tue, Apr 05, 2022 at 09:24:54AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.110 release.
> > There are 599 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> > Anything received after that time might be too late.
> > 
> 
> s390 tests crashed. Other failed qemu tests did not compile.

Bisect points to commit 93fe2389e6fd ("tracing: Have TRACE_DEFINE_ENUM
affect trace event types as well"). Bisect log attached. Reverting the
offending patch fixes the problem. Copying Steven for comments/input.

Guenter

---
# bad: [45fdcc9dc72a44448666a2bcff4030a659e29e46] Linux 5.10.110-rc1
# good: [d9c5818a0bc09e4cc9fe663edb69e4d6cdae4f70] Linux 5.10.109
git bisect start 'HEAD' 'v5.10.109'
# good: [93a35ab24592dfddafdb9f184e9399aad6d88a18] drm/amd/display: Add affected crtcs to atomic state for dsc mst unplug
git bisect good 93a35ab24592dfddafdb9f184e9399aad6d88a18
# good: [c8816508edf3558f597bd20a01403b060d690700] regulator: rpi-panel: Handle I2C errors/timing to the Atmel
git bisect good c8816508edf3558f597bd20a01403b060d690700
# bad: [5e7fb97064ee7794db7ac938583c3d095980e55f] scsi: qla2xxx: Fix disk failure to rediscover
git bisect bad 5e7fb97064ee7794db7ac938583c3d095980e55f
# good: [3d65639a786b4587e64fb813a79a8f27b83dcaab] ARM: dts: qcom: fix gic_irq_domain_translate warnings for msm8960
git bisect good 3d65639a786b4587e64fb813a79a8f27b83dcaab
# good: [8bb857ae514a06d96a6ca81ff306acf5783d6cc6] media: Revert "media: em28xx: add missing em28xx_close_extension"
git bisect good 8bb857ae514a06d96a6ca81ff306acf5783d6cc6
# bad: [0042f52f784f847927f1ff234b3f97dd97ad8e48] powerpc/lib/sstep: Fix build errors with newer binutils
git bisect bad 0042f52f784f847927f1ff234b3f97dd97ad8e48
# bad: [690ee20444960ce5592465bce043ac5cd4ef8028] media: atomisp: fix bad usage at error handling logic
git bisect bad 690ee20444960ce5592465bce043ac5cd4ef8028
# bad: [93fe2389e6fd4c545920f6bd013b36f9328b636e] tracing: Have TRACE_DEFINE_ENUM affect trace event types as well
git bisect bad 93fe2389e6fd4c545920f6bd013b36f9328b636e
# good: [1fe212d441b683685c2900bd4353f53f7f608db9] media: hdpvr: initialize dev->worker at hdpvr_register_videodev
git bisect good 1fe212d441b683685c2900bd4353f53f7f608db9
# first bad commit: [93fe2389e6fd4c545920f6bd013b36f9328b636e] tracing: Have TRACE_DEFINE_ENUM affect trace event types as well
