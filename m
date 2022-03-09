Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66644D3895
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 19:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbiCISQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 13:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235549AbiCISQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 13:16:44 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573AFD7618;
        Wed,  9 Mar 2022 10:15:45 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id f38so6149496ybi.3;
        Wed, 09 Mar 2022 10:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sDz8T9zb6ypCUEX3xOaIeOdgYtahx3JXRhE56Io75p0=;
        b=j7zVimmQAWZRnSVP+SAw8FANfkWopEvfFCIk6YfAqQAUXovgsJwY2uB+CmPuPJr2tH
         FebOJD7t+BwRksjpXPrYcBJqec3bdTxIRi5xyzOIHCT7YOkiJ7ZGrMAvWbICB44CFUc4
         nIXPZk33WxfdoviKYpB++Ip26KXlpj6WhybqNYVUhrn4R0dW0hXffhNsi90PvO9NSn8I
         0O/8e/dMsIhXU4iGpXdEu/Kf5tBuWv4bcrt4TQcgjG8NFf2nJY/YuFuAVR48sAYG0wJA
         sNysDJQ/jC9cvpcO8qOBiOBV2jVzSZj85DSmrE8yV5tvT7IN+B1OCb0740zvzEul0z6d
         dRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sDz8T9zb6ypCUEX3xOaIeOdgYtahx3JXRhE56Io75p0=;
        b=eVVgnPVUqkueOrxMZr+RjnlZdks7qINpLQKzn2r2OQ2CNy83QHDJkcIPet0+FS6S1N
         DJ7aEs8pZrIAkkOF9RrzOkZXzdg5ZHxlbeOzSx3lxTzvkB1PGHF3DA0SZjGJ85YlqGaE
         35qykNsOiD3eLX10+0omdqASHDiY84//9RTriztUa6Muw81etUQpAX6cRPXZIRc3wZ/y
         8LTNKjFWf50N/IUB0sgd5FBD9jLI28YSLPRTZAlb+qAfVP5Tu7TzFsS/h8uvWY26i1I8
         Bza1apc8YcKxt+6JBbiBS6IZtvtlGsltd+80PvPmGfFSco0ix6FHC8d3gzpMR4ebcJKn
         zmVw==
X-Gm-Message-State: AOAM530SpNeqZGEDTZmmmZZfXMGVI7cEInQDgwsCn/iM9v4lpK9iV/yc
        vO05u9lVGpBQf7z5M94Z3xZ3WNpunLm9Wlob1SkUYh5YR/B33c1t
X-Google-Smtp-Source: ABdhPJyon186DdZxNlgiTp4IznNkh+2++6lG0SWy+eWnl4lbN9MuoPKxH9OB4Ge2VQ1FFNf+vqMwpzHhqNZWyAuuJz0=
X-Received: by 2002:a25:d606:0:b0:629:187c:e514 with SMTP id
 n6-20020a25d606000000b00629187ce514mr902790ybg.158.1646849744473; Wed, 09 Mar
 2022 10:15:44 -0800 (PST)
MIME-Version: 1.0
References: <20220309155856.155540075@linuxfoundation.org> <CADVatmMODnr1vQ3VGLOACT16wLEFA6hFrTzY44VdPO2M7gX+iw@mail.gmail.com>
In-Reply-To: <CADVatmMODnr1vQ3VGLOACT16wLEFA6hFrTzY44VdPO2M7gX+iw@mail.gmail.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Wed, 9 Mar 2022 18:15:08 +0000
Message-ID: <CADVatmMceoHeQqFDEJND_3GmSeQqgefeP0Z9_Zi=UTAVfZ71RQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/18] 4.19.234-rc1 review
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

On Wed, Mar 9, 2022 at 6:08 PM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Wed, Mar 9, 2022 at 4:03 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.234 release.
> > There are 18 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> > Anything received after that time might be too late.
>
> My tests are still running, but just an initial result for you,
>
> x86_64 defconfig fails with:
> arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
> arch/x86/kernel/cpu/bugs.c:973:41: error: implicit declaration of
> function 'unprivileged_ebpf_enabled'
> [-Werror=implicit-function-declaration]
>   973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())

And, lots of failures in arm builds also.
Error:
arch/arm/common/secure_cntvoff.S: Assembler messages:
arch/arm/common/secure_cntvoff.S:24: Error: co-processor register
expected -- `mcr p15,0,r0,c7,r5,4'
arch/arm/common/secure_cntvoff.S:27: Error: co-processor register
expected -- `mcr p15,0,r0,c7,r5,4'
arch/arm/common/secure_cntvoff.S:29: Error: co-processor register
expected -- `mcr p15,0,r0,c7,r5,4'
make[1]: *** [scripts/Makefile.build:403:
arch/arm/common/secure_cntvoff.o] Error 1
make[1]: *** Waiting for unfinished jobs....
arch/arm/kernel/entry-common.S: Assembler messages:
arch/arm/kernel/entry-common.S:178: Error: co-processor register
expected -- `mcr p15,0,r0,c7,r5,4'
arch/arm/kernel/entry-common.S:187: Error: co-processor register
expected -- `mcr p15,0,r0,c7,r5,4'
make[1]: *** [scripts/Makefile.build:403:
arch/arm/kernel/entry-common.o] Error 1
make[1]: *** Waiting for unfinished jobs....
arch/arm/mm/cache-v7.S: Assembler messages:
arch/arm/mm/cache-v7.S:64: Error: co-processor register expected --
`mcr p15,0,r0,c7,r5,4'
arch/arm/mm/cache-v7.S:137: Error: co-processor register expected --
`mcr p15,0,r0,c7,r5,4'
arch/arm/mm/cache-v7.S:171: Error: co-processor register expected --
`mcr p15,0,r0,c7,r5,4'
arch/arm/mm/cache-v7.S:299: Error: co-processor register expected --
`mcr p15,0,r0,c7,r5,4'
make[1]: *** [scripts/Makefile.build:403: arch/arm/mm/cache-v7.o] Error 1



-- 
Regards
Sudip
