Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6021D4D1F36
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 18:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348432AbiCHRjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 12:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245683AbiCHRjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 12:39:22 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CEE4A918
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 09:38:22 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2dc585dbb02so146558447b3.13
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 09:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=73XbkgqmbcCp8jrsRpjmW22XYnfqvjYIpXZBS4eirQM=;
        b=MM9a6dodSSdEECe1wyp0Icbc69wzcVLsyT7PY2rfd49dzp8onjx0/ypojzlSYhjgc9
         HLR/ZYEviD2rC+Oo/JOHMiFFR+/5TMV9bnwsq1CY3UiNovS8zkjkCwEo/cERekGm++Rf
         D++AXWigBpzAZSE1LOmhlU4G8mSCgxDLfbXD6/u7mBpCc5iwyCaXwdNEHoFU/nUVgp1L
         VCvh/4a+DMYv8mP75N7//TwbYB9as3mPpBzBY9Wi01RnH2y7DVFXQoSIzqVVW1+4qJuF
         Z11ABjNXtu1Vf8hdiiys3g/6h0MXv4oNCKY+injER0wj4DwtsZrEF6vNs3Qymwy7TiF2
         BGmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=73XbkgqmbcCp8jrsRpjmW22XYnfqvjYIpXZBS4eirQM=;
        b=my02LfNEZUi3EiPK1z8Dcj017NdF5zNA2VR/nR+ZqB0Xfu17oWC1JPezzhPXkZv7hb
         6t9NQvl65kBi3glQgAk1eSZDlZjhsIWpaDFjHQMXPlcHy85X+UoWndicbBikP/270Pki
         P6YDb72MJ3dwdcoY+twMVP1vbgmvXjnB2uog3Ks88Bk218bJ/KH7w6onbZn06MZQmzfa
         2hCKOhEWwH8p4LmnyklpSpTpOuta+wxAIH5z32xYlzeylpYXkmGavUQqm5qJmavaEiHt
         Sj8nmLqCf7JCj2U8FytgIgmj14UETIZk3wQj2yADXECLuOoHhU+00HzOyYkkwce7aAd/
         Lv1g==
X-Gm-Message-State: AOAM532H3lVEczTAZF/bttoe+PAbqkaPWs+vxRGTcsChXaUKTIH/mwjI
        komYbhieXQVhQ1Ox3shEVJ52PQWAD5a0QM1XIG9UqA==
X-Google-Smtp-Source: ABdhPJyiQb+hevD4MsEfkOJACYI9vqWCrwvXESLQpiKn9owxsdu0PnJ8iDqkTXLbv6Yv3c21WxGVX3f99zFgkxdd74w=
X-Received: by 2002:a81:e90c:0:b0:2db:d63e:56ff with SMTP id
 d12-20020a81e90c000000b002dbd63e56ffmr14332324ywm.60.1646761101606; Tue, 08
 Mar 2022 09:38:21 -0800 (PST)
MIME-Version: 1.0
References: <20220307162207.188028559@linuxfoundation.org> <Yid4BNbLm3mStBi2@debian>
 <CADVatmPdzXRU2aTeh-8dfZVmW6YPJwntSDCO8gcGDUJn-qzzAg@mail.gmail.com>
In-Reply-To: <CADVatmPdzXRU2aTeh-8dfZVmW6YPJwntSDCO8gcGDUJn-qzzAg@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Mar 2022 23:08:10 +0530
Message-ID: <CA+G9fYv74gGWQLkEZ4idGYri+F9BFV1+9=bz5L0+aophSzDdVA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, 8 Mar 2022 at 21:40, Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
>
> On Tue, Mar 8, 2022 at 3:36 PM Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > Hi Greg,
> >
> > On Mon, Mar 07, 2022 at 05:28:50PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.27 release.
> > > There are 256 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
>
> <snip>
>
> >
> > Mips failures,
> >
> > allmodconfig, gpr_defconfig and mtx1_defconfig fails with:

LKFT build regression noticed as Sudip reported.
   - mips-gcc-10-allmodconfig - FAILED.

>
> And, here is the bisect log:
>
> # bad: [7b9aacd770fa105a0a5f0be43bc72ce176d30331] Linux 5.15.27-rc2
> # good: [8993e6067f263765fd26edabf3e3012e3ec4d81e] Linux 5.15.26
> git bisect start 'HEAD' 'v5.15.26'
> # bad: [6d4f8e67749d97f83f377911e874ca116be71fbd] drm/amd/display: For
> vblank_disable_immediate, check PSR is really used
> git bisect bad 6d4f8e67749d97f83f377911e874ca116be71fbd
> # bad: [527ec9ffce51cb10a3172380aba30066ee2d056c] Input: ti_am335x_tsc
> - fix STEPCONFIG setup for Z2
> git bisect bad 527ec9ffce51cb10a3172380aba30066ee2d056c
> # good: [96039b910c5a933221faa9aeca4f2fb2fa4976a1] arm64: Mark
> start_backtrace() notrace and NOKPROBE_SYMBOL
> git bisect good 96039b910c5a933221faa9aeca4f2fb2fa4976a1
> # bad: [4778338032b338f80393b9dfab6832d02bddb819] MIPS: fix
> local_{add,sub}_return on MIPS64
> git bisect bad 4778338032b338f80393b9dfab6832d02bddb819
> # good: [ba52217d4edd5824427134cfdfa9c2ab4390d77f] drm/amdgpu: check
> vm ready by amdgpu_vm->evicting flag
> git bisect good ba52217d4edd5824427134cfdfa9c2ab4390d77f
> # good: [9eeb0cb7e2d675e3bbecc08302e3bafe21c61c52] NFSD: Fix
> zero-length NFSv3 WRITEs
> git bisect good 9eeb0cb7e2d675e3bbecc08302e3bafe21c61c52
> # good: [8e68b6e3bdce82f387619e7fb6e85e6be9820182]
> tools/resolve_btf_ids: Close ELF file on error
> git bisect good 8e68b6e3bdce82f387619e7fb6e85e6be9820182
> # good: [238d4d64ad4da4acefedd73094be0d1051897810] mtd: spi-nor: Fix
> mtd size for s3an flashes
> git bisect good 238d4d64ad4da4acefedd73094be0d1051897810
> # first bad commit: [4778338032b338f80393b9dfab6832d02bddb819] MIPS:
> fix local_{add,sub}_return on MIPS64
>
> Reverting 4778338032b3 ("MIPS: fix local_{add,sub}_return on MIPS64")
> has fixed all the 3 build failures.

MIPS: fix local_{add,sub}_return on MIPS64
[ Upstream commit 277c8cb3e8ac199f075bf9576ad286687ed17173 ]

Use "daddu/dsubu" for long int on MIPS64 instead of "addu/subu"

Fixes: 7232311ef14c ("local_t: mips extension")
Signed-off-by: Huang Pei <huangpei@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>

--
Linaro LKFT
https://lkft.linaro.org
