Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C055767D5
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 21:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbiGOTzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 15:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiGOTzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 15:55:10 -0400
Received: from sonic302-49.consmr.mail.gq1.yahoo.com (sonic302-49.consmr.mail.gq1.yahoo.com [98.137.68.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3609014093
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 12:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657914908; bh=rTI2DdUsIF+W6MCmovjAWoU956VYoKdj5S83w2EQfWg=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=HOxJ+n4eERsCK3x24RUH8IJ+tcaOkGSSrcbJsci9IOGdlzo53BwSF9zS7HXjvB5gOBfKwJ9LDwuTCwlMhOkiHed5HMJC2hQk1alOAxtsEoo794q/B+JOej5zLimZG2GMJnu6P2x2R39tc1hXuBSh5MZNAdbJeZnGQ+4it/1fXWmKGwi8gxBeMLhweqGOra0sJ0RDcLyCYCkULg8RS5kGq5umHn0xMKnexFUbschAop8/97ezmCzuVONYEjLZIumaHdTorOegXBjMxMrVG4gzw61++ZS/I+7+lUeIL21ffuJgsA/9m8q4U7VtsAdQjv/+aASK6eX1GzxjGtgdnY1Ssg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657914908; bh=lCZp2eusSTQ4jHMhLVc2F13HbYW5HTXHXZK4DpR462L=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=A0FDR+bF9cz9mvEzs3cLzHLUjWoUYsJpg0n8mHNpJL5IEaA7iw5iZn6Qrg5hPZxRuzpqomyTRHWScFqcLIorAXcMuFtDsFSfPA9ds1Kr4LxUDDloZL8twaaHAbYCNneQyaMCUKKYSq3X5MOuua4WsVk2C/SFfNUfLogc1DWkTRGTjeLWeY8uRpsK2FYF9EbSY5ZOLd+4/1k0jy7mTvb6EQE7qsqbTp5/q09rEIH7wzNNxrvMDb/3eaVOLsgrbfgzdi1B7MI6ADDy9idlz7zjNwobktkvgnQp5SHIooNhuo9hfNKcIBXUdkwM/HEeoBPTNl6MTXcGjDQqgzuI9y2qEw==
X-YMail-OSG: vHMX3MMVM1klkVJeDUatRuZ2K5KUb.n.e0POhXElXyIu7j9JFzrdeVG6GYk6jFb
 UCKpvryBVGwEQYggLhzjBP8GkJcyZlPAmUM8YWH4ozNAbuxfNPw.TFTPl73HyzyGyXMA3GNt8Wj7
 277uAszpnXxcrrncyhqhWSkmUWIoNBAgtruJV9TuypoTWPWWHfwVSYJE81V0qeKPcc8Z8TcxuvOJ
 3Klw32SwzFRi71eivPG3k7uUKBU2LwWT86VtijBuw3.DWdqLbJvbdehpcoWAqiGd7hAGxwULAkpA
 ZP_SBt8qTbZOGIk.scVTnrKj.EI.eTvPo4LryDTdvgSds7LfCAv5JeOCatLsZJPViuim3LKX5BQ3
 ekgbod3BYbZZO.8zrh66aQtYHnG05kgR6cUdCpFX8eKf3MMs3V.aj.Kfg_hYinh1puvUjbuq6I3t
 .5qQ0_RcDooNW4yDmYCcLO0RUCqmhFl6r8z7Kjx3y4wkQqpQNi65P7aaeyXYYRbxO0DnSf7xOYy1
 HKI7RWUV8Ly9iw1t_3yeVBXHXYRBVhutB2S45ZFj1ynHsqSgOgklA7x.pWJnLYXj99ln1au.f795
 wyo9uKqvRqP0ppmoSIl9TzujmSTYzLGQP0Blz1.pcvt7qjVkcSxhNDN43Gshb0jCSaYq1Bxj7CH4
 ic.ZKuBMuovEt_BXvyff2w4Zz2BIwxbW8Mc5RP00LCmfJ3kQ892zoSy90BTg7b4wSEZhZTMf6BaW
 CFvGhFtpDXiWppgyK7R8cerRzwnKoKSQ0_TPsTbt8yJlmuF2.xlQesR0FlgnCHjHcIbb.jiWUEUC
 NlAN681hbc2RvZO76ZAtjd6XQBd5ejuxY1H5__xr7x2BBOHwNONHscPK8spPwb3MrmX6PFWuEcsr
 .P9gCUM5U3NRDYFQHGmGdpiSNdySyQSlh6WwdvTZ9iUWOSL5C1WIjg222JUo_8KtFD6r5dlzEUh9
 uRtIYeYu0iDHPdC_il_T_o66GXJxu1_MOnSjYc49ZUl729cBUKPfliSHlETrGWMBzThvqRjnDtLk
 H7AvV.ACmDYhM75xusPYCbsScYsB23BzgMKo01Y1HzevJdj5GTNGDkX_uVoHzvkpmHkfFWueoM14
 eO1f.A0h2LwAo_Y0TXp5EM3ceRA6d6w1pbi25nLrbNPDNq9PHt3tfXAd1G31aERw5P3kzcympIYs
 cfyA3Jk1ZOZ5f0C0nzawHeEWAeGxFuXI8Y5hxXpRDu1pdDvKKq3WHBF8Q5LfjEpjQzwBaFS0VtRQ
 z21DG8q5U3sWp4C0TtF2ccRJa205fBc2elTgnbUc5sd3egb9qIaH96_PTTw41gOhevjo5BQ4Xt04
 0zLrLwq8VBVb7R3JNJdPR5i808GCNRI3os61CorFjQe7qtyFtjgYrJ.tKENLRiFtinuJS87qqe6s
 yVOW9u4f4WWxYwz1jdeo017aKTm8_o6perLjzsBqS__3wuHHIhpPkbQY0Qpx57MNcOkdPVlKXxBA
 NGt3YEgjCbrlu8V4OG6uqEw9SmDdS0cur2D666s3ghiC0bRZzMDYqXXBc6C.M0vqN1RCPHeBFeRH
 QkEyxMlDa9uaeTxQA8Hg.Ao7FpM0cx8qFYsVj7oqI_.Br8zIc_hsymugA_DAtq3yPX4_Uce4a5Yb
 _Tk5LMSwrcdWZmCwcsYYrw8UGp5Eki90PY.0wo4KV83EXeSlLbT4gNEfDKPiS4cXjDjF9dMOtB91
 3ulJOmDkEWdYO65rN_Vhgf6L8sS1ymSHoG7sPnTt0W31rzlL859Kjg3hJgPDJD1b3MX4vkoIUBHX
 wlWKgzP7Zldedd_OqY9XsClg7pOYWcXh7AZ5BA9RgqPCZ1mq4nLt9SZAi1AonKoGBJqdfS2MJE9E
 v5NEMG733val9xUTUes8T_g08CqsKiOt1JPLcTCxCkn9jXLpZuU.XNFNI9rAGciSwwlzFrblhjvc
 uY4rUtuBrDtxghPGHCaOahZBduJ2bRQ3l.7Kvu18unePuMXKAA5fXhv4fU7SwMv7Y7r2HFBsiwRv
 XKSf1yn7rzgK1qHjoSlCbTbsZgDxnukl2qvBkZ48giAgtmQxt73AF.UzGkMc_xkoNFo.1P71q41l
 tL27zPcT50XkwFHqeaYXFiBZjKJx5MkHtW20az94sQWTvAikwwKMk7krjq1BhnBWVchx56aw5yJO
 p6yvx3qyFk3G05J8wAlGoPjb9FqV.tlVnk7wLorfrgEflemaq2rZGwd6eW.a7sS5YrkocnobNdi1
 tFdc-
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.gq1.yahoo.com with HTTP; Fri, 15 Jul 2022 19:55:08 +0000
Received: by hermes--production-bf1-58957fb66f-6z4lk (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 967fca0f97858552404598730ce034c7;
          Fri, 15 Jul 2022 19:53:06 +0000 (UTC)
Message-ID: <1309c3f5-86c7-e4f8-9f35-e0d430951d49@netscape.net>
Date:   Fri, 15 Jul 2022 15:53:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
Content-Language: en-US
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        linux-kernel@vger.kernel.org
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <5ea45b0d-32b5-1a13-de86-9988144c0dbe@leemhuis.info>
 <56a6ab5f-06fb-fa11-5966-cb23cb276fa6@netscape.net>
 <d3555a74-d0cb-ca73-eb2e-082f882b5c81@suse.com>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <d3555a74-d0cb-ca73-eb2e-082f882b5c81@suse.com>
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

On 7/15/2022 6:05 AM, Jan Beulich wrote:
> On 15.07.2022 04:07, Chuck Zmudzinski wrote:
> > On 7/14/2022 1:30 AM, Thorsten Leemhuis wrote:
> >> On 13.07.22 03:36, Chuck Zmudzinski wrote:
> >>> The commit 99c13b8c8896d7bcb92753bf
> >>> ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> >>> incorrectly failed to account for the case in init_cache_modes() when
> >>> CPUs do support PAT and falsely reported PAT to be disabled when in
> >>> fact PAT is enabled. In some environments, notably in Xen PV domains,
> >>> MTRR is disabled but PAT is still enabled, and that is the case
> >>> that the aforementioned commit failed to account for.
> >>>
> >>> As an unfortunate consequnce, the pat_enabled() function currently does
> >>> not correctly report that PAT is enabled in such environments. The fix
> >>> is implemented in init_cache_modes() by setting pat_bp_enabled to true
> >>> in init_cache_modes() for the case that commit 99c13b8c8896d7bcb92753bf
> >>> ("x86/mm/pat: Don't report PAT on CPUs that don't support it") failed
> >>> to account for.
> >>>
> >>> This approach arranges for pat_enabled() to return true in the Xen PV
> >>> environment without undermining the rest of PAT MSR management logic
> >>> that considers PAT to be disabled: Specifically, no writes to the PAT
> >>> MSR should occur.
> >>>
> >>> This patch fixes a regression that some users are experiencing with
> >>> Linux as a Xen Dom0 driving particular Intel graphics devices by
> >>> correctly reporting to the Intel i915 driver that PAT is enabled where
> >>> previously it was falsely reporting that PAT is disabled. Some users
> >>> are experiencing system hangs in Xen PV Dom0 and all users on Xen PV
> >>> Dom0 are experiencing reduced graphics performance because the keying of
> >>> the use of WC mappings to pat_enabled() (see arch_can_pci_mmap_wc())
> >>> means that in particular graphics frame buffer accesses are quite a bit
> >>> less performant than possible without this patch.
> >>>
> >>> Also, with the current code, in the Xen PV environment, PAT will not be
> >>> disabled if the administrator sets the "nopat" boot option. Introduce
> >>> a new boolean variable, pat_force_disable, to forcibly disable PAT
> >>> when the administrator sets the "nopat" option to override the default
> >>> behavior of using the PAT configuration that Xen has provided.
> >>>
> >>> For the new boolean to live in .init.data, init_cache_modes() also needs
> >>> moving to .init.text (where it could/should have lived already before).
> >>>
> >>> Fixes: 99c13b8c8896d7bcb92753bf ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> >>
> >> BTW, "submitting-patches.rst" says it should just be "the first 12
> >> characters of the SHA-1 ID"
> > 
> > Actually it says "at least", so more that 12 is It is probably safest
> > to put the entire SHA-1 ID in because of the possibility of
> > a collision. At least that's how I understand what
> > submitting-patches.rst.
> > 
> >>
> >>> Co-developed-by: Jan Beulich <jbeulich@suse.com>
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: Chuck Zmudzinski <brchuckz@aol.com>
> >>
> >> Sorry, have to ask: is this supposed to finally fix this regression?
> >> https://lore.kernel.org/regressions/YnHK1Z3o99eMXsVK@mail-itl/
> > 
> > Yes that's the first report I saw to lkml about this isssue. So if I submit
> > a v3 I will include that. But my patch does not have a sign-off from the
> > Co-developer as I mentioned in a message earlier today, and the
> > discussion that has ensued leads me to think a better solution is to just
> > revert the commit in the i915 driver instead, and leave the bigger questions
> > for Juergen Gross and his plans to re-work the x86/PAT code in September,
> > as he said on this thread in the last couple of days. This patch is dead
> > now,
> > as far as I can tell, because the Co-developer is not cooperating.
>
> ???
>
> Jan

I think I recall you said my patch proves I don't want your S-o-b. I
also want
to add some useful logs with your approach, probably a pr_warn, which you
are not interested in doing. I think it is probably necessary, under the
current
situation, to warn all users of Xen/Linux that Linux on Xen is not
guaranteed
to be secure and full-featured anymore. That is also why I think the Linux
maintainers are ignoring your patch. They are basically saying Xen is just
some weird one-off thing, I can't remember who said it, but I did read
it here
in some of the comments on your patch, and you do not seem to be listening
to and responding to what the Linux developers are asking you to do.

Two things I see here in my efforts to get a patch to fix this regression:

1. Does Xen have plans to give Linux running in Dom0 write-access to the
PAT MSR?

2. Does Xen have plans to expose MTRRs to Linux running in Dom0?

These don't have to be the defaults for Dom0. But can Xen at least make
these as supported configurations for Linux? Then, the problem of Xen
being some weird one-off thing goes away. At least that's how I see
the situation. Maybe Xen can provide these for Linux in Dom0, but
from what I've read here, it seems Xen is not willing to do that for
Linux. Do I understand that correctly?

Chuck
