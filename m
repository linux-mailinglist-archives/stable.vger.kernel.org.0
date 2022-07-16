Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26AF576D83
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 13:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiGPLev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jul 2022 07:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiGPLeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jul 2022 07:34:50 -0400
Received: from sonic308-33.consmr.mail.gq1.yahoo.com (sonic308-33.consmr.mail.gq1.yahoo.com [98.137.68.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E4B1F2E8
        for <stable@vger.kernel.org>; Sat, 16 Jul 2022 04:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657971288; bh=LEI6S1S45c0ysUsshBMGHEIFmmv3MJEhsY6+MP0Z5zs=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=Aj3lS59QpKn7iZ0gu1MOr37rgo48nRFJsUSPgOf5ll1wdJegWI54r58e6bjdfzeGzt0m/e7Lcd0zi979wv7CyjMku0ttz6bSDS4tA33g7SF0t6ENkgNJ+rtIr81NNBSpJlnIQkeeiulUlgWLV//1+UlzcPdEw7YwDxzeffC8fxjTRgb0+L+5lDzUv+F9kasQA/pazxPZQTqzdpJqN31keotHeqnQlOMHeH/trlmfpMkrSQJmQlHS84l+cDH9PocyG+6dgZvLfQNESObZNT9FFRjDsaeeXSNIRxlYZrlt7/B3ViIMYvzPntiM/RNOgvXkHklrL+97pNvWQaJoZuyv/g==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657971288; bh=P+xRlcqAf7oAGWwcEzcEHvfoMpdDoaZHpquMHbj+jBb=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=pxa7gcl/n4iqc/++FiDk5cpDKdfp451G2HdLmOZINMA9OAVzDWQKEwc2Js924ahR8kyRfIg456poTplfiqC96N6cjOxOJKABHhGVoytu1NKK4DOZjuh36X/DekITU+dMfKXRJOqHk3r7Rkh68cVSUFj+YxM1Jt6KBYmfeQI5ISSNWUvLGAqhW1y2oEVkj34QX819MB3ks2nOFm2IqeS+OepWxaVQUt4Wx5WxNVqF6BVY5Gs3vtB4VLq9aSjt4NPQrPLQBPKu0LDaX61qJBw4GTwD1/yUzsd8xknW5/2BVowLJq/mWOZLoNpeqq6/Z7sAI5tL4H3qoapRDi21AukPHw==
X-YMail-OSG: 5v5_HrEVM1lgnRTJCZlWRbByKxEcIclSxi2uREnsMN7EUy9Ha3Mry9KtjmJWRfk
 umPMoBMmcW5SmJ9Wwde2GtauvclJVmOvWDLgfAfPEg7rAp_lI5ne7qPBVNFtkbwYvRYm79cfE_wM
 Riu0Z1dD6_gYLZUp.ResqetLyc_ke2K43RG3k5FX5clO1FG1_JT1gzLeT7mGqDkcT8X.IPmUD1Yf
 zUFtSel3fDPH8PvEU_j3Fuv1aGjPRgyks7PVeJGX5Oa1rZdB5aagu_OemEbrCgdSO0G7Af.jDG.j
 GvPOYNmVtVpiW5d4WkWdLhFFI950bdpoE2Ixvr_vlVaNnWCgsgi1AW2qzpk6nwuinYn4jvqHFJ0C
 LwPek_NwTQacopX3FPL6oqa0w3ilLt9tE09mXWUm9RPDj.bejGOpEhaIHvAX5h63iItRQZ.LU7cJ
 hY60lVxNP5vo3x9QjFgvEUzY4jeCpFZTu9ZpH7AyRENh3XJAtxnuooR4LOghi226S02VrBSyNS9p
 m8t0Xxvj_5_tprFmz244KkATOWr4BZwLKd5STBiMOhfwSPdRMQ7jgZAHB5807ziYggRnmK8tnZRj
 SvafG4jvYRZy3OD0rrGbe3oqMUdHlUf.FV1cIYq1xlzzpb2o_r7yLgoYTfgGpEHr8DYaAocAcYwP
 eoNqO3qNrQC.xIaSLJJJMtQmbLTZFOi.R8KPxxS3FCjbeNM9AQ2La8aHtiDf_90LjeEiNAJf0EKu
 iPVyA3Rk8WOuBJK2cDZBF_YXNUmfF26og8cQtFcfI4z8t4u8AfxY5Kq0zFfbihbBOVEVKuaorjhs
 ZAosoBYqyByYeMIJz4JT0kivrYkeb7U5IxokclSY82d33bCk94uL2elwmaVNnDfrCVJiHPv0Bfr4
 Awg1NIMgY10PUCztzFTdh_w3VFhXsTRNR5m0foUDEG2RssG3lLtqiwN5zxjDiDkQa9a65ovZo9ge
 4zuizc4Cy0nbkgzY__VEPAMFpmo8SCOnh6OurwA1ii7iuErG2ZtXvzF0vXGf2kcsaUfjiO0xeZe.
 560Mc7iXQt3cMr4LFMte8bKQ.LwYqPU2vfWiiAcvsvglvnqc4Kb6F3CVZTXf74WVbapnC1vVOqYg
 FqImS8nBRG60WWa2jW.kx2yurax.IUKxlRW7xbqxrNLKORZM5ETiQdssCOWEPKca37Z5xLzLC.6P
 NHibWL8JvoqxMIWEdLTg1zMUHSiA00qeAzYMbd9Ke6x3qQ7naDNg1QfOtiIxmRsaA9A3tPdTjgwX
 2LUMnvbLcK3Dd.iApERlr6rN12RBVhMqO0jFuv16EpbttWjCZTWQ0sZ87NTmUllsic2ki1cdAoOY
 e1ntJ0PRHH9bddEqfzRhx3SW_As4Ysva.hEQBqFBwAG.1u8OWzoUJt71fFfIcYZBgmtlJew0gGWu
 422b5LvwTKL7vczaU2oMiOzV4geeQDA7_m18x6hdh.4VQw4KtcoAhq5XjMThz3eiBQABmG1ajChR
 08CbIQaKUEYM58Iom3vBiNeJecvlvfVNaZVWq5aWMryrf9QXKSMTSTiiRMzDFefS72lNlMmYXQKJ
 UN6TBLyHDQsaF9huOo7HPV9hrK1BzPw.JOjfQxLa7q4MeCpHI0F3CYzGolvJ_usRRA0tnXF8x6TP
 vZaWyKIP9OjUJG3_GlQDa0FovYZqDrPn1VFxr.HnQuFi2vSz1htyR9JH5lJQknu2GVNzzzThPZUn
 7w9NxfVniLsE.xJS1g5yp9nWFFPnDP.TnBqJ1RTNmvwFMoKNC.NtPqbqhSdijesr4yB9ZMZd_3SM
 VCn8NGOSZ3VegcgWrHyDrHaEz8vJYd2TyfzP1Q7yaodSxmesZ2QwXfIJUY6XSYd3OvMxdI6Sjz8L
 lxaCyFU34djb7wp_o07dwUYNN7qqiyGW42roPwiKupRH9QcMSiCUM4CpMVtulsqBAUV0UOidXEot
 ofAHzUbplstQbd7x5qnKF7XHQNx7q0USrliecmrIoVk01dXSa3UKaEpKgPaNi15J9HPPWTB4LclV
 YxqSlKTgDzddz2sD1IXx8WQTagXmwC2XH55r6gmm6TyfDjBBSiYM4DOsNd7Aw.rYKy952e5trj4m
 dL64NJZ_mV8ICZZ9oU9hEiA2Pdf1SWTxAv7sKqX8ye2gUGMclPCBKOj4VQpi0o6Ri0l1FLgOE84c
 sYJJrWmrDLakLc6CnJGmcSyRSeJGW7s4Ftw9L23Kqa25wy0OoYbwUJSnz9jUntYIhtx.AwVJHChO
 ybFblTUzWbzGxnXObLfaX7yBlkG9qZA--
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.gq1.yahoo.com with HTTP; Sat, 16 Jul 2022 11:34:48 +0000
Received: by hermes--production-ne1-7864dcfd54-hwfdm (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 624a151775341492620246c559b32b79;
          Sat, 16 Jul 2022 11:32:46 +0000 (UTC)
Message-ID: <7bf307c7-0b05-781b-a2a3-19b47589eb8a@netscape.net>
Date:   Sat, 16 Jul 2022 07:32:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/3] x86: make pat and mtrr independent from each other
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     jbeulich@suse.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "# 5 . 17" <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20220715142549.25223-1-jgross@suse.com>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <20220715142549.25223-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20407 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/15/2022 10:25 AM, Juergen Gross wrote:
> Today PAT can't be used without MTRR being available, unless MTRR is at
> least configured via CONFIG_MTRR and the system is running as Xen PV
> guest. In this case PAT is automatically available via the hypervisor,
> but the PAT MSR can't be modified by the kernel and MTRR is disabled.
>
> As an additional complexity the availability of PAT can't be queried
> via pat_enabled() in the Xen PV case, as the lack of MTRR will set PAT
> to be disabled. This leads to some drivers believing that not all cache
> modes are available, resulting in failures or degraded functionality.
>
> The same applies to a kernel built with no MTRR support: it won't
> allow to use the PAT MSR, even if there is no technical reason for
> that, other than setting up PAT on all cpus the same way (which is a
> requirement of the processor's cache management) is relying on some
> MTRR specific code.
>
> Fix all of that by:
>
> - moving the function needed by PAT from MTRR specific code one level
>   up
> - adding a PAT indirection layer supporting the 3 cases "no or disabled
>   PAT", "PAT under kernel control", and "PAT under Xen control"
> - removing the dependency of PAT on MTRR
>
> Juergen Gross (3):
>   x86: move some code out of arch/x86/kernel/cpu/mtrr
>   x86: add wrapper functions for mtrr functions handling also pat
>   x86: decouple pat and mtrr handling
>
>  arch/x86/include/asm/memtype.h     |  13 ++-
>  arch/x86/include/asm/mtrr.h        |  27 ++++--
>  arch/x86/include/asm/processor.h   |  10 +++
>  arch/x86/kernel/cpu/common.c       | 123 +++++++++++++++++++++++++++-
>  arch/x86/kernel/cpu/mtrr/generic.c |  90 ++------------------
>  arch/x86/kernel/cpu/mtrr/mtrr.c    |  58 ++++---------
>  arch/x86/kernel/cpu/mtrr/mtrr.h    |   1 -
>  arch/x86/kernel/setup.c            |  12 +--
>  arch/x86/kernel/smpboot.c          |   8 +-
>  arch/x86/mm/pat/memtype.c          | 127 +++++++++++++++++++++--------
>  arch/x86/power/cpu.c               |   2 +-
>  arch/x86/xen/enlighten_pv.c        |   4 +
>  12 files changed, 289 insertions(+), 186 deletions(-)
>

This patch series seems related to the regression reported
here on May 5, 2022:

https://lore.kernel.org/regressions/YnHK1Z3o99eMXsVK@mail-itl/

I am experiencing that regression and could test this patch
on my system.

Can you confirm that with this patch series you are trying
to fix that regression?

Chuck
