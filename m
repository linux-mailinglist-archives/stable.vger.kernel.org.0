Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E1157AF7C
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 05:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbiGTDab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 23:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbiGTDa3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 23:30:29 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A72B26566
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 20:30:28 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l23so30745136ejr.5
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 20:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uq+CEfeFYTQCzdlC2ldokm/plXttdcR69IcQSj54K78=;
        b=ryHTxf9An0NOTcMq4CjxA2ZaxrUCXv8Tb9rlL1XXoej3sNZzL/BvO3oP2vgE/A/wGN
         V9jLHn/eq6pkACp/Y5DXFSPIjqsfTB/Zbh1IqiRSpoHiY/+t2sKNvKaWhslCNiWe4rla
         59ltgyzsNYlvpKx3lQ38WRN5xDuNzIfNr87m4O62f6gs5tPQQYZG0iNBQirZ0AblFN9P
         H96ViGnw51QFtJ9uCB+tCOhauqdpXJ5ryYWWeQ0g25iHYXMNz8HfbvOWk+t4q+bIUsVo
         5UNcgZvIXjk0/ytrOtY2sh6dqSecxWhfNxA/cjpnUIb2sKSbz7KD565MopIwrTfRmtYX
         904w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uq+CEfeFYTQCzdlC2ldokm/plXttdcR69IcQSj54K78=;
        b=kJxTgcsTkyu8qqGU8gxkN2ZNmzd7GfIvRWOBnEU2coxp2IFpVS86teT6V9A29oTukD
         SAPDEQsJ6EULK2VDQxGSHZZ2pWSBydKRpSaavqKZvWUtuvWh+QZkpvzwpgjelPkBm67I
         gWkTdEiC768vB9X16LX3N/O+Exf0hJV3QYyxkSh3HnBCS2I+q0D6PMnkUFYMyDDZp5s7
         5iSihnq3/VSxkJFMNlNn/CtHL+EzNCq0KjB94JjYp+vu7th8zaszHn0QWG+lsB42P7R2
         TMf0Z5Be30qvJn7VruqJ9k9N4KXTjtx7qi7mbPzf7LLsoMvPaVdfUMKyIIFwqKXh4Rqq
         jpAA==
X-Gm-Message-State: AJIora9wqf14Kq8CN36RsvAiDiZ0eRgd/hNHeSXfcB66qlRrwtb98Mur
        ZfMODZbrTIFW6MykOreRL8f+5pM4k4zQaXxNvBb5NA==
X-Google-Smtp-Source: AGRyM1uPjosqBbmAcRWTVLe7V+ipRcW6WS6yW8SiNKpU8tOvXCauUu5iy6m+Nz+BWzfzGSpjMKtIu8VPCeZVi44qR9U=
X-Received: by 2002:a17:907:2d23:b0:72b:7c6a:24c with SMTP id
 gs35-20020a1709072d2300b0072b7c6a024cmr32959233ejc.44.1658287826918; Tue, 19
 Jul 2022 20:30:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220719114714.247441733@linuxfoundation.org> <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
 <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
In-Reply-To: <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 20 Jul 2022 09:00:15 +0530
Message-ID: <CA+G9fYsJBBbEXowA-3kxDNqcfbtcqmxBrEnJSkCnLUsMzNfJZw@mail.gmail.com>
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

Hi Linus,

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
>
> > 2. Large number of build warnings on x86 with gcc-11,
> > I do not see these build warnings on mainline,
> ..
> > 'naked' return found in RETPOLINE build
>
> Hmm. Does your cross-compiler support '-mfunction-return=thunk-extern'?
>
> Your build does magic things with 'scripts/kconfig/merge_config.sh',
> and I'm wondering if you perhaps end up enabling CONFIG_RETHUNK with a
> compiler that doesn't actually support it, or something like that?

I see the diff of the defconfig file from the previous release.

The new config is causing a lot of warnings.
        init/calibrate.o: warning: objtool: calibrate_delay_is_known()+0x2:
              'naked' return found in RETPOLINE build


Following configs have been deleted in new defconfig
CONFIG_RETHUNK=y
CONFIG_CC_HAS_RETURN_THUNK=y
CONFIG_SPECULATION_MITIGATIONS=y
CONFIG_CPU_UNRET_ENTRY=y
CONFIG_CPU_IBPB_ENTRY=y
CONFIG_CPU_IBRS_ENTRY=y

--- good-config 2022-07-13 02:22:04.000000000 +0530
+++ warning-config 2022-07-19 17:37:17.000000000 +0530
@@ -1,15 +1,15 @@
 #
 # Automatically generated file; DO NOT EDIT.
-# Linux/x86_64 5.18.12-rc1 Kernel Configuration
+# Linux/x86_64 5.18.13-rc1 Kernel Configuration
 #
 CONFIG_CC_VERSION_TEXT="x86_64-linux-gnu-gcc (Debian 11.3.0-3) 11.3.0"
 CONFIG_CC_IS_GCC=y
 CONFIG_GCC_VERSION=110300
 CONFIG_CLANG_VERSION=0
 CONFIG_AS_IS_GNU=y
-CONFIG_AS_VERSION=23800
+CONFIG_AS_VERSION=23850
 CONFIG_LD_IS_BFD=y
-CONFIG_LD_VERSION=23800
+CONFIG_LD_VERSION=23850
 CONFIG_LLD_VERSION=0
 CONFIG_CC_CAN_LINK=y
 CONFIG_CC_CAN_LINK_STATIC=y
@@ -317,6 +317,9 @@
 # CONFIG_X86_X2APIC is not set
 CONFIG_X86_MPPARSE=y
 # CONFIG_GOLDFISH is not set
+CONFIG_RETPOLINE=y
+CONFIG_CC_HAS_SLS=y
+# CONFIG_SLS is not set
 # CONFIG_X86_CPU_RESCTRL is not set
 CONFIG_X86_EXTENDED_PLATFORM=y
 # CONFIG_X86_VSMP is not set
@@ -467,16 +470,6 @@
 CONFIG_HAVE_LIVEPATCH=y
 # end of Processor type and features

-CONFIG_CC_HAS_SLS=y
-CONFIG_CC_HAS_RETURN_THUNK=y
-CONFIG_SPECULATION_MITIGATIONS=y
-CONFIG_PAGE_TABLE_ISOLATION=y
-CONFIG_RETPOLINE=y
-CONFIG_RETHUNK=y
-CONFIG_CPU_UNRET_ENTRY=y
-CONFIG_CPU_IBPB_ENTRY=y
-CONFIG_CPU_IBRS_ENTRY=y
-# CONFIG_SLS is not set
 CONFIG_ARCH_HAS_ADD_PAGES=y
 CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y

@@ -4318,6 +4311,7 @@
 CONFIG_SECURITY_WRITABLE_HOOKS=y
 # CONFIG_SECURITYFS is not set
 CONFIG_SECURITY_NETWORK=y
+CONFIG_PAGE_TABLE_ISOLATION=y
 # CONFIG_SECURITY_NETWORK_XFRM is not set
 # CONFIG_SECURITY_PATH is not set
 # CONFIG_INTEL_TXT is not set




--
Linaro LKFT
https://lkft.linaro.org
