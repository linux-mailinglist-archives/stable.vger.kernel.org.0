Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5594D1CD8
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 17:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348210AbiCHQL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 11:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348216AbiCHQLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 11:11:25 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933EC506FA;
        Tue,  8 Mar 2022 08:10:28 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2dc242a79beso196646427b3.8;
        Tue, 08 Mar 2022 08:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rKTCr+Og+sv9jUdP0DwOyofew83xNo3e9HNzBgkZFCU=;
        b=CNP9MSLV8F9EMIaBfN+SPUUjOSXAQiMSDSRUNUsWzrtvpIaoxkqD0SK26zoDRBBJd6
         mmlDvUyUGZhmsiIhpuZM5VyyRjRrho4NVqzbRYcazg6qqZyhYE3estKDevx9k2unZw88
         NV0m61L3tbKNh1OLLWl1xxD0y00dD7IKXYaSrllS8cJ4mzeh+2mBskWD8f5PTEjPckDD
         /1DdifV9Ep4hg/ovtHjrFTRtvDE4U86ymG9e+0oHIlaa0FuL/rlgbDfDOTddbv97LASz
         mebZq6PwtoCnxrDo5exoxmSEDQfNeLVWnsdER+o360b9cHFbkNr040tEKs7LRu5K1ynb
         HyJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rKTCr+Og+sv9jUdP0DwOyofew83xNo3e9HNzBgkZFCU=;
        b=qt/JJsALBcs9BIbuw60ETbGckSJn21f2Hj51CYlEAINWfXx5u2t0SS3Sj0klFRvW4m
         N0skaq57RDNB5aCfx4cnnNxfiB61QyAT3yzqCYWhW5SWiSnZkHl8zvhV05fZ9gCcwqwA
         794wV0GjYuz3q4mwCVEAkZgK/cyLvBCFnLb/Nsrc7gynUuUf16/iOOp9pMtvTNbPrRdK
         s6hdS9GPfM1c4n/Pto9aYamzKpVvo9QBo2Vhgu4uAf73b2jZrkFfl754OG82UF/smykk
         LcSVJ/IdQLSwXhEFvWzZa2z5B2MnA0ES7ToiKGQJfJ7C2Ozen5oeC2xoJ00CDiULVs7D
         M8Nw==
X-Gm-Message-State: AOAM530cxnzUCKShOi1oVcqFXTXtCH5fwnLsqbVDccx6xCd2HzaDTzrW
        CrXVOhilPLzjuXErGLMFOmMmKgc8gWT3DWRW2PI=
X-Google-Smtp-Source: ABdhPJwrIeggD3PCTymggq9Gq/D99TWUJYcaJJQ0yB2mYPT+Y2wpKYg884AglLmVS1Qlq7w65ZAUrluNoskJc6rsnvk=
X-Received: by 2002:a81:5789:0:b0:2d7:9ad:44d0 with SMTP id
 l131-20020a815789000000b002d709ad44d0mr12777631ywb.488.1646755827825; Tue, 08
 Mar 2022 08:10:27 -0800 (PST)
MIME-Version: 1.0
References: <20220307162207.188028559@linuxfoundation.org> <Yid4BNbLm3mStBi2@debian>
In-Reply-To: <Yid4BNbLm3mStBi2@debian>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 8 Mar 2022 16:09:51 +0000
Message-ID: <CADVatmPdzXRU2aTeh-8dfZVmW6YPJwntSDCO8gcGDUJn-qzzAg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
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

On Tue, Mar 8, 2022 at 3:36 PM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Mon, Mar 07, 2022 at 05:28:50PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.27 release.
> > There are 256 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >

<snip>

>
> Mips failures,
>
> allmodconfig, gpr_defconfig and mtx1_defconfig fails with:

And, here is the bisect log:

# bad: [7b9aacd770fa105a0a5f0be43bc72ce176d30331] Linux 5.15.27-rc2
# good: [8993e6067f263765fd26edabf3e3012e3ec4d81e] Linux 5.15.26
git bisect start 'HEAD' 'v5.15.26'
# bad: [6d4f8e67749d97f83f377911e874ca116be71fbd] drm/amd/display: For
vblank_disable_immediate, check PSR is really used
git bisect bad 6d4f8e67749d97f83f377911e874ca116be71fbd
# bad: [527ec9ffce51cb10a3172380aba30066ee2d056c] Input: ti_am335x_tsc
- fix STEPCONFIG setup for Z2
git bisect bad 527ec9ffce51cb10a3172380aba30066ee2d056c
# good: [96039b910c5a933221faa9aeca4f2fb2fa4976a1] arm64: Mark
start_backtrace() notrace and NOKPROBE_SYMBOL
git bisect good 96039b910c5a933221faa9aeca4f2fb2fa4976a1
# bad: [4778338032b338f80393b9dfab6832d02bddb819] MIPS: fix
local_{add,sub}_return on MIPS64
git bisect bad 4778338032b338f80393b9dfab6832d02bddb819
# good: [ba52217d4edd5824427134cfdfa9c2ab4390d77f] drm/amdgpu: check
vm ready by amdgpu_vm->evicting flag
git bisect good ba52217d4edd5824427134cfdfa9c2ab4390d77f
# good: [9eeb0cb7e2d675e3bbecc08302e3bafe21c61c52] NFSD: Fix
zero-length NFSv3 WRITEs
git bisect good 9eeb0cb7e2d675e3bbecc08302e3bafe21c61c52
# good: [8e68b6e3bdce82f387619e7fb6e85e6be9820182]
tools/resolve_btf_ids: Close ELF file on error
git bisect good 8e68b6e3bdce82f387619e7fb6e85e6be9820182
# good: [238d4d64ad4da4acefedd73094be0d1051897810] mtd: spi-nor: Fix
mtd size for s3an flashes
git bisect good 238d4d64ad4da4acefedd73094be0d1051897810
# first bad commit: [4778338032b338f80393b9dfab6832d02bddb819] MIPS:
fix local_{add,sub}_return on MIPS64

Reverting 4778338032b3 ("MIPS: fix local_{add,sub}_return on MIPS64")
has fixed all the 3 build failures.

-- 
Regards
Sudip
