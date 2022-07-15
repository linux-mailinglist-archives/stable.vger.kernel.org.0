Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC72D5759BA
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 04:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbiGOC6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 22:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiGOC6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 22:58:19 -0400
Received: from sonic301-20.consmr.mail.gq1.yahoo.com (sonic301-20.consmr.mail.gq1.yahoo.com [98.137.64.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEFE402FE
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 19:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657853896; bh=m9WtjFON2B2diYQ8onMXGAxyEnFHSnd98fWeZZfI1Vo=; h=Date:Subject:From:To:Cc:References:In-Reply-To:From:Subject:Reply-To; b=uMJNQltaYczYEmV/q+XCTACUcdSwmQOqv5EJevLC3LMt6Z6cUmQ+l7oQNNyxS9L1YI4yvS3AjVljb+3p9hTlnXIx9kBF6rE9gb9TGmdR57r52Fg96XgIFOieX/jHM1Km4ZextVuLM7XvKl7lyYrER/QN7aF38uk/lmMYCZiUpUZjnTEZ655NiQO6uqLHJ0KoRZTZ7/Pa/NJ5koRQG2gZlIN2p1Q7Y5XmbRPKBqkJTIr6tCmHsb5BfGhyFKkWChMraLaLahGhvyoXw5ow8UscclDXWQcbR+bLjV6achvcDvFKPXROnQnuMNAuPY/CQpi9OH6TcDhSNzktNwzqduIJJg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657853896; bh=Xrn+9aaEmbHNmDSKMSRN7UhoTyUP9tPDcEfCdsCLjNa=; h=X-Sonic-MF:Date:Subject:From:To:From:Subject; b=Llle1/nWWVdOE1sX6CimvAn7UgvBeWLT6E5v3ig4dxYsKg4XOoJ+5nThcOCz1PbLKouvbrBqa2Z7YKkv6AyPxiDYv9CVDRVZRI5tiWBaiL5B9c2T9/rSVWcxxAWPY0G3F3fxldhRnd+ICBq0BfEI3R094gyBQXaYTSPpoizi94n9D9fjxwDLabPXZM26afeXwNFPjmxWkHGoKqnTcLXOzucXcDDucaXa712vBApxYnQVp3Y/M5bxOjDaX+/qhO1ZdCFnisoU+rUg5oFmnZ+i3K27BgacK1PKdxspOAvJIypyeJMCyRxsAPxhqMzjC5zAGZpSMycFee2b4Kep7WPYxQ==
X-YMail-OSG: TbIwLbgVM1ns_ZUQz3sJrAf2KJBf3iE6PK8r1xkCzI0ZuOSRvhhsJ8wWrT2KLWf
 UES80omEwKD.0AD1peXiUpAA7E_JKXuCJr8azDLeocnKbOfhDhZLHCIX5ECaNUUeI0TlAZYT3k6S
 K2cREfNTthUYKEfnvkmK2vz_LJtzCxk74BScnM6d1kweHI5iCh7XN7m_6zVjSmisCfUL6ipwW8r4
 gBvZSr52zVMdw6qUMLhiTL1ETQ3bNih9awcZgbm2rqk3D1cUbWORiQxI5SQZVkYzwqxHCV2a8ZbT
 8i2m3nV0OphykoHhPv6jhwLsYkQfE2wqUDwpsLyIf37uK1MiaaA5_gI_gnU_NcWatP4Msd5Huh7Z
 pBbCt5ZdEiUnABPPp0SY.ieU7.yiqalqR89RXIUSWJM6BNTtzyem3KULxpa140zrWanOUD52BX8i
 CDsXjMN7reg7InA3OpxGQBub5HyGvQ8sIyKUfvqWGfbJTEy8Np2aKl6jCqX5lH6SHUv9ln2g4pUU
 SNpzvQildU_USD9mobxfpY66zMKXuMGNhzepmuE0Drlt5JAtFntr_7yEde9tp.XcFttT0sVadRF1
 T3uclNwje3QLnqKH7e7yQST9UlSRHXexy.qyG73NlFq6rvT17cNOkDNkjw0bXdgFJCeSdR.asVmO
 wT4q9m1MFspdUgwtYJqi4_anvgeyXRZfeKwRlWEnt9yit6ZtN6wK2sodmDgV3ldvtCzu2BLgCWjg
 LD84tWjI0_.U_h4JEJNxqgu.3io5PVtwFr1s7aQbvZorziYaT6kfZ9eTg.81TIc05UdpE_dTkUim
 u1rvZczRZ4rintfgPrxAvB6lQ2AmGfZ277FeU9XYHsGn3D_60dqDJ8ARCBWTeHNH0gk2gSnFwFvR
 OViFUQQ.g8cHB1OWsp4D7CdOuuay2b61XcQ2w0pfYGQpqYXf06yVaTCGJSYe8XOdZZtiySCEci9_
 dLwXeWunOpSpW7avx3TMg1yOnI4HLeBbLm1RKSrsApwuRZZErlgnWeZq0qjsL.UefVgS7m7CMZ_v
 9RgE6Nn2JkIrIaGSHxdY1Cq7v.Eh2H3WnJvLNolemC0opgezRw_mTrhRCfnCOXsgkYNnROO4QmIM
 1HsPT_GPh9G5r.2ikL_g_.tF7WJrOnoBLJcO82I0y0T5UOY2rCJYZhXmXigebb51l86Puge3F7SN
 S9TpCnSj5CegyDWtXg15_U_.MUWGmaHwHWxoPiZ61EZB1rrkc06j1vwqhZ29msmC2EQeuoAyGOXI
 U8TP_FLaTiU7_yJJppRozZfrIK2BSnguqNIC5G2rvvRgooYFVG0ZEf7YPadeUZKhHmjjMUZ2KRCK
 JZoW4fB0itihfcjDPgSqTLtAxrlEgd5bG3Ka4SLrbaTn1JT9F_4KSsF5TNPryi531h5x_3qXE.uD
 fFju.gtMUZUct4Gck0rTzTiGcP88YlEtpUB5G9FLAYUROf3ziLhWplgi87nLPo7OiNXuh9DX3lyC
 bdOg.XKBk0sI7sBxjGrPLHt3R9GZb1RIEQb.xXQTxEjPpUT2g9BKpa_nPVkMLgL.D8C06d8_lXo4
 W.rQEKGYUu0gH3SE0aXTa_kijcgRkh0qnoo6gYdV9B30BlFoqsyZQhfeF0LIcdp7nce_Vm6GRq0j
 BpZWaPsks.qMfMZO0jVxvueUg2gJT3m.BlGpf4FfSZEQhUQY7oWtNSFsTGsQ92KBV1HT8.h8Gah5
 gpMrGgY4mxMs5ZKC3C3NYKnSQTbUsm4IAQBQA7OQmAQdnUEeCLPRq5Ao2BanK6sENpGHlpE3ri6o
 i9nlDcrsh8FKUGGNMSYa7c5jwK2CRicCZaefpdJ6FRWsWGFTeBHx0iHtHy_yMFbJmHnIjnNbmgyX
 qCFztZ2tgr3d0COZxZkRg8yRpDyqea7.CV9GgJypuGdbx5Iwq_86p8sbBtRLin_2ryDFoQfeiKmG
 cr_BUEyzodfYwSX4T74s7uwfEWoVkPbwdUGKVJ1iY6oZsdGCWhh_h4g--
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.gq1.yahoo.com with HTTP; Fri, 15 Jul 2022 02:58:16 +0000
Received: by hermes--production-ne1-7864dcfd54-s2f4b (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 80211909ddb51aab8fb5f5b0cfa4adfe;
          Fri, 15 Jul 2022 02:58:12 +0000 (UTC)
Message-ID: <81f3e88e-a13d-f89d-6010-516f4286e0e1@netscape.net>
Date:   Thu, 14 Jul 2022 22:58:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
Content-Language: en-US
From:   Chuck Zmudzinski <brchuckz@netscape.net>
To:     Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org
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
        Jan Beulich <jbeulich@suse.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <ec4b2791-886f-4d52-ab39-b0c07489c4ca@suse.com>
 <c0a19463-b46f-e757-c1f9-21d4c2f8bc54@netscape.net>
 <364742fa-160f-cb45-b868-a2a6527a716a@netscape.net>
In-Reply-To: <364742fa-160f-cb45-b868-a2a6527a716a@netscape.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20407 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/14/2022 10:53 PM, Chuck Zmudzinski wrote:
> On 7/14/2022 10:19 PM, Chuck Zmudzinski wrote:
> > On 7/14/2022 1:40 AM, Juergen Gross wrote:
> > > On 13.07.22 03:36, Chuck Zmudzinski wrote:
> > > > The commit 99c13b8c8896d7bcb92753bf
> > > > ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > > > incorrectly failed to account for the case in init_cache_modes() when
> > > > CPUs do support PAT and falsely reported PAT to be disabled when in
> > > > fact PAT is enabled. In some environments, notably in Xen PV domains,
> > > > MTRR is disabled but PAT is still enabled, and that is the case
> > > > that the aforementioned commit failed to account for.
> > > > 
> > > > As an unfortunate consequnce, the pat_enabled() function currently does
> > > > not correctly report that PAT is enabled in such environments. The fix
> > > > is implemented in init_cache_modes() by setting pat_bp_enabled to true
> > > > in init_cache_modes() for the case that commit 99c13b8c8896d7bcb92753bf
> > > > ("x86/mm/pat: Don't report PAT on CPUs that don't support it") failed
> > > > to account for.
> > > > 
> > > > This approach arranges for pat_enabled() to return true in the Xen PV
> > > > environment without undermining the rest of PAT MSR management logic
> > > > that considers PAT to be disabled: Specifically, no writes to the PAT
> > > > MSR should occur.
> > > > 
> > > > This patch fixes a regression that some users are experiencing with
> > > > Linux as a Xen Dom0 driving particular Intel graphics devices by
> > > > correctly reporting to the Intel i915 driver that PAT is enabled where
> > > > previously it was falsely reporting that PAT is disabled. Some users
> > > > are experiencing system hangs in Xen PV Dom0 and all users on Xen PV
> > > > Dom0 are experiencing reduced graphics performance because the keying of
> > > > the use of WC mappings to pat_enabled() (see arch_can_pci_mmap_wc())
> > > > means that in particular graphics frame buffer accesses are quite a bit
> > > > less performant than possible without this patch.
> > > > 
> > > > Also, with the current code, in the Xen PV environment, PAT will not be
> > > > disabled if the administrator sets the "nopat" boot option. Introduce
> > > > a new boolean variable, pat_force_disable, to forcibly disable PAT
> > > > when the administrator sets the "nopat" option to override the default
> > > > behavior of using the PAT configuration that Xen has provided.
> > > > 
> > > > For the new boolean to live in .init.data, init_cache_modes() also needs
> > > > moving to .init.text (where it could/should have lived already before).
> > > > 
> > > > Fixes: 99c13b8c8896d7bcb92753bf ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > > > Co-developed-by: Jan Beulich <jbeulich@suse.com>
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Chuck Zmudzinski <brchuckz@aol.com>
> > > > ---
> > > > v2: *Add force_pat_disabled variable to fix "nopat" on Xen PV (Jan Beulich)
> > > >      *Add the necessary code to incorporate the "nopat" fix
> > > >      *void init_cache_modes(void) -> void __init init_cache_modes(void)
> > > >      *Add Jan Beulich as Co-developer (Jan has not signed off yet)
> > > >      *Expand the commit message to include relevant parts of the commit
> > > >       message of Jan Beulich's proposed patch for this problem
> > > >      *Fix 'else if ... {' placement and indentation
> > > >      *Remove indication the backport to stable branches is only back to 5.17.y
> > > > 
> > > > I think these changes address all the comments on the original patch
> > > > 
> > > > I added Jan Beulich as a Co-developer because Juergen Gross asked me to
> > > > include Jan's idea for fixing "nopat" that was missing from the first
> > > > version of the patch.
> > > > 
> > > > The patch has been tested, it works as expected with and without nopat
> > > > in the Xen PV Dom0 environment. That is, "nopat" causes the system to
> > > > exhibit the effects and problems that lack of PAT support causes.
> > > > 
> > > >   arch/x86/mm/pat/memtype.c | 16 ++++++++++++++--
> > > >   1 file changed, 14 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
> > > > index d5ef64ddd35e..10a37d309d23 100644
> > > > --- a/arch/x86/mm/pat/memtype.c
> > > > +++ b/arch/x86/mm/pat/memtype.c
> > > > @@ -62,6 +62,7 @@
> > > >   
> > > >   static bool __read_mostly pat_bp_initialized;
> > > >   static bool __read_mostly pat_disabled = !IS_ENABLED(CONFIG_X86_PAT);
> > > > +static bool __initdata pat_force_disabled = !IS_ENABLED(CONFIG_X86_PAT);
> > > >   static bool __read_mostly pat_bp_enabled;
> > > >   static bool __read_mostly pat_cm_initialized;
> > > >   
> > > > @@ -86,6 +87,7 @@ void pat_disable(const char *msg_reason)
> > > >   static int __init nopat(char *str)
> > > >   {
> > > >   	pat_disable("PAT support disabled via boot option.");
> > > > +	pat_force_disabled = true;
> > > >   	return 0;
> > > >   }
> > > >   early_param("nopat", nopat);
> > > > @@ -272,7 +274,7 @@ static void pat_ap_init(u64 pat)
> > > >   	wrmsrl(MSR_IA32_CR_PAT, pat);
> > > >   }
> > > >   
> > > > -void init_cache_modes(void)
> > > > +void __init init_cache_modes(void)
> > > >   {
> > > >   	u64 pat = 0;
> > > >   
> > > > @@ -292,7 +294,7 @@ void init_cache_modes(void)
> > > >   		rdmsrl(MSR_IA32_CR_PAT, pat);
> > > >   	}
> > > >   
> > > > -	if (!pat) {
> > > > +	if (!pat || pat_force_disabled) {
> > >
> > > Can we just remove this modification and ...
> > >
> > > >   		/*
> > > >   		 * No PAT. Emulate the PAT table that corresponds to the two
> > > >   		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
> > > > @@ -313,6 +315,16 @@ void init_cache_modes(void)
> > > >   		 */
> > > >   		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
> > > >   		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
> > > > +	} else if (!pat_bp_enabled) {
> > >
> > > ... use
> > >
> > > +	} else if (!pat_bp_enabled && !pat_force_disabled) {
> > >
> > > here?
> > >
> > > This will result in the desired outcome in all cases IMO: If PAT wasn't
> > > disabled via "nopat" and the PAT MSR has a non-zero value (from BIOS or
> > > Hypervisor) and PAT has been disabled implicitly (e.g. due to lack of
> > > MTRR), then PAT will be set to "enabled" again.
> >
> > With that, you can also completely remove the new Boolean - it
> > will be a meaningless variable wasting memory. This will also make
> > my patch more or less do what Jan's patch does - the "nopat" option
> > will not cause the situation when the PAT MSR does not match the
> > software view. So you are basically proposing just going back to
> > my original patch, after fixing the style problems, of course. That
> > also would solve the problem of needing Jan's S-o-b. I am inclined,
> > however, to wait for a maintainer who has power to actually do the
> > commit, to make a comment. Your R-b to my v2 did not have much clout
> > with the actual maintainers, as far as I can tell. I am somewhat annoyed
> > that it was at your suggestion that my v2 ended up confusing the
> > main issue, the regression, with the red herring of the "nopat"
> > option.
> >
> > Chuck
>
> Actually, what your change does depend on keeping
> pat_force_disable, but after all the discussion and
> further thinking about this, I would prefer that you
> give a R-b to v3 as simply my original patch with the
> style fixed. I think it is wrong to confuse the regression
> with the "nopat" issue. If you and Jan want to do a patch
> for the "nopat" issue, that is your decision. I am not interested
> in that. I am interested in fixing the regression. Also, I am
> not included to formally submit v3 until Dave, Andy, Boris, or
> someone else with more clout here on Linux expresses
> interest in giving this idea an R-b.

I meant to say "i am not inclined..." not I am not included..."

Sorry for the confusion,

Chuck

>
> >
> >
> > > > +		/*
> > > > +		 * In some environments, specifically Xen PV, PAT
> > > > +		 * initialization is skipped because MTRRs are disabled even
> > > > +		 * though PAT is available. In such environments, set PAT to
> > > > +		 * enabled to correctly indicate to callers of pat_enabled()
> > > > +		 * that CPU support for PAT is available.
> > > > +		 */
> > > > +		pat_bp_enabled = true;
> > > > +		pr_info("x86/PAT: PAT enabled by init_cache_modes\n");
> > > >   	}
> > > >   
> > > >   	__init_cache_modes(pat);
> > >
> > >
> > > Juergen
> >
> >
>

