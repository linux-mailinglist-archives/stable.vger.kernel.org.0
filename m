Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153335759B5
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 04:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240896AbiGOCxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 22:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbiGOCxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 22:53:45 -0400
Received: from sonic309-22.consmr.mail.gq1.yahoo.com (sonic309-22.consmr.mail.gq1.yahoo.com [98.137.65.148])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21713E0CA
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 19:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657853623; bh=nRV6iAnQ79cAVUulUzKd9r0uGj8vG1wTg/tfSrpm9Vw=; h=Date:Subject:From:To:Cc:References:In-Reply-To:From:Subject:Reply-To; b=sipFMQdUJn/hdysSQLEyNfx16pFDg2bpiPQYUmh2qLgnprjdpmDXaeJTMlUdUx3RF+2lWokk9iCqe+vStDt5yHG8rIL2APmWTWwJ0XFTxkfJrFIvVUFqn854nnqfhnO341sUAR3KOmPACJS1Rm7wEoUWBKntXfxs6AqXwAuOQbO33/+qrwSGhqbt+nKr/K/ybmG0jMOiyXQSyBCvz1YYwHvFx4SVXtbMrk5o/lDFFVMfhVLNFvh8Ac27R84M1N5ccBEmfa08WkxpwZNwICmef52IFAgrOp7XhmB/zgEidBYsCaqLXw8DTXIzkYAHA8gol46hzk7t5XHWdssx/tW+oA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657853623; bh=zNVuMCa/AAnwR+dpImS0D5d8UXGJXDiMkIRe2FiJnP6=; h=X-Sonic-MF:Date:Subject:From:To:From:Subject; b=eMwfQe0xvjeAQ6bBCCJlQ5Lw2ZMIvLR8b8aHCV65TLySkvM7nZUG0RfNex0oeh3w+UyHAtyS6yeBdFhc+1MOYEYy0MEj3SacoFtZFhPKUm2QGQbqQxQFIXb8z/yO2zU4N+9FbGxvkpwM6DUk+uuZ1llor4JTVeYC9Jt53tw4uJkMFNPpoG3Ok82zVQQc/qBkLaDGrSZSKLrE0GYqGG1HdNmCX+FJyUr62JKhE7q3PxvdjlMmDC7NtZkAZvkzqX8XlkXIaaekJZqhV4pD7GzWkHU689yKsDWmmEw0evQD75FGgW3q2IDbw+8bIhf+UHfQdaHwW6EwgWo+tDR3gO3CdQ==
X-YMail-OSG: TB5Ll.UVM1nYThAvfPo6v2qNfDlUusmCkMRtK6o7DjTMKp_RE29vE07kYbwtu_f
 ayeQGpwaA_TsYailnCw5aHiwOYytzX_XTKZ1GwRqTotYoxuZsxHV.ztTlHV6uCdPqNGz1_9_s3ot
 3kqKl9LL3lToA2olNXhzMAHlQKUx5jIAoynmHCZQRCDvabImFKx3HZZAImCq0fkzXm2eQ19a6ABx
 At9PzO.hlQdoUM8QYgyOdwI8oSHEyQ118BtmYEbxvtjZujqn5bzJTgzTkI1cwgnECKUaGa8VeVvF
 zck9VRQ4uH_3IW89hun_mM68Bc0Sn51oW3DvfGxbryHFQqCcRqR.ShMfvThcVAhQCT1EH6mceTk7
 R3KA6Vy_l_PIhERfYKHRrrQGe0tB5w6CNkkK9cVa3HXkHWM_2zBjFHnxYheGBoYSllJMQjozHXq0
 UZvjHP9_3.UnI_BvJ2zR4cIxB4U7z_P4dhXP7tpuDLnLaIAcHezvBBe6lBgjl0WSORW5lzmk1a1e
 t0BC.O1OcrVhQuV4xnKHj.rNozhDYH8EFn8rEZvNm9lZqr4H6z29WHKPmlFoCSCK.oWNA.sguOUN
 dWCZLjGiK4io.TiLGDQ6CUoS0AMY9N9PRUHhORoGYkEOECgBwfF80HL8GZDNPy5.h6mxaF7trYH2
 EvmqfTmvkvJlft6BJexwxXvX8pln2YGS10hQGNqCic51xDKCV59WVc_GXVl6TkXIukmUsrwOQqXo
 .jvycop0zrgGxgD2OdmLs62ISZuQ_6xaJv8WvvOTYjH2pW_wxOB8ybMuwyxVOIaxK_ApnZr71qm4
 vLh9GpvKHeFIWButrneMn.yrmd9dSYvNTYQbMUMxrv_H4NISonjltepU7hb7XUIh6Luzr2fAIH5t
 7P7ngkv2PUBhZr2thT..cgohYqlo2fhY.XCIqryLsrIjFr843WXjreOeOuUUxMFyli2K2hePwo5x
 CNe2YKi5Fv4Nq3Qvnt57pogVi8uiBDtezZsC6tuacvSdPvOb5dqadQsNhV3CmIUR8GQpiGG5EBWm
 LqxzUMhsINrBrTx2i4snIAMgqGkhuxQ9U3QbAWIlTibsRIZD2OH93wD2Dbw6uGC2btKExrpF_IKt
 UGWhilNU7uiTJCk4gkyZwOjF5atCf7AbJXqdNjTigd0qjTnVuPY0cpNMRzLdCHGPlwO9QdqwCwDC
 R_ZLqaxWcK3fwa55pHu1pEg8KGC4hXquzLgp60lp_U.lvhrls9ZLTji0Ehwc1dAjZ79b6Wd5GJIs
 vHibVLOpdALqxIiTKUYzA255IM7peSOb6G0ONTDC7aJmUEBIM209MuQUzkIbyqRCw9f2M7Uc_O11
 RbeP9VITMghaqTDfP_zKtVpnzW9_BEK3eo0MvbDY1DBDMvRB7hGmHvhYgiGMYZ3oo4HYa3M18Uii
 QvZQ95r380aqPBAESGZ4Nu9vr6kQlh_jsw_zLjuptJUmrRysgCYXoyeDJIOnnjg_O0519kX.97Bf
 u_7X3c4lp.wMSITuCfQlneUQ0dtB7lIeQTDmVjrsI89Okho1kYm.tV.EJgOn5eKF6xhHq7Wl0FqH
 aJMIqWhYtfiMrGZF8QNCvHfKF_kE2YMAggt_oXvBBfsAGqeJROvFLz4Mln_VNANH8fSi1rSKRsHr
 W7I0OUW7s3d2y4GU4NaOGtQrDCQVbfY.lrTWYG1jKJA6vfMfrmC5DJzdx6M1.pZHFwuhoGRhYcmj
 SUjmMCagW3HDzVD5lDcjHPW5597xTOnNLKhY3M6sWslj8pfvvXAzHA0K8eA_b4FAJaXZgQWwsltX
 eL9ED0WDoBHqKncxfru6evYkDq_7kLipy_wjWGvdxTFYAX1wEOOf4gJZ1iOptrCmpQWAlEbYClKZ
 g97W3FxrllxJpCPoc7gOllX3zoaCBosnBztoMd88iFaKMdtbTsgGEM7DPybb83DZ10uv1eO0bUHo
 5hH5v2Vcf_7jR9h97EHatfuWmJ1jxz9CUU_9ZlBu2dGHrCZNfbUBHsQF5nOICbwO3PzvcUeHFL6J
 Zzdj5NEKn21w2I1fYGDtSzXeBQ_9A6anvnKbr.bg7O31qM2pPpnswbtYyEFGpbL220vMDTMdOGMN
 1Ef9icJCnrrw74lJ7QL2MApzCg1BwKWJYPS90krSROYrw_wfJQgPd7BVJ1BLd3x1ZAjnIbCu1SOe
 2W7TwX3AsV9OjL9QcGTW.Lo7jGoFNY7zQHOKp7ESX77sgMHq5ximbWzQAre2DT57SREI7s6gJzmt
 _nw--
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.gq1.yahoo.com with HTTP; Fri, 15 Jul 2022 02:53:43 +0000
Received: by hermes--production-ne1-7864dcfd54-hwfdm (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 0c5cc85777bf3bf7cde9ad4fd0cf95dc;
          Fri, 15 Jul 2022 02:53:37 +0000 (UTC)
Message-ID: <364742fa-160f-cb45-b868-a2a6527a716a@netscape.net>
Date:   Thu, 14 Jul 2022 22:53:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
Content-Language: en-US
From:   Chuck Zmudzinski <brchuckz@netscape.net>
To:     Juergen Gross <jgross@suse.com>,
        Chuck Zmudzinski <brchuckz@aol.com>,
        linux-kernel@vger.kernel.org
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
In-Reply-To: <c0a19463-b46f-e757-c1f9-21d4c2f8bc54@netscape.net>
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

On 7/14/2022 10:19 PM, Chuck Zmudzinski wrote:
> On 7/14/2022 1:40 AM, Juergen Gross wrote:
> > On 13.07.22 03:36, Chuck Zmudzinski wrote:
> > > The commit 99c13b8c8896d7bcb92753bf
> > > ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > > incorrectly failed to account for the case in init_cache_modes() when
> > > CPUs do support PAT and falsely reported PAT to be disabled when in
> > > fact PAT is enabled. In some environments, notably in Xen PV domains,
> > > MTRR is disabled but PAT is still enabled, and that is the case
> > > that the aforementioned commit failed to account for.
> > > 
> > > As an unfortunate consequnce, the pat_enabled() function currently does
> > > not correctly report that PAT is enabled in such environments. The fix
> > > is implemented in init_cache_modes() by setting pat_bp_enabled to true
> > > in init_cache_modes() for the case that commit 99c13b8c8896d7bcb92753bf
> > > ("x86/mm/pat: Don't report PAT on CPUs that don't support it") failed
> > > to account for.
> > > 
> > > This approach arranges for pat_enabled() to return true in the Xen PV
> > > environment without undermining the rest of PAT MSR management logic
> > > that considers PAT to be disabled: Specifically, no writes to the PAT
> > > MSR should occur.
> > > 
> > > This patch fixes a regression that some users are experiencing with
> > > Linux as a Xen Dom0 driving particular Intel graphics devices by
> > > correctly reporting to the Intel i915 driver that PAT is enabled where
> > > previously it was falsely reporting that PAT is disabled. Some users
> > > are experiencing system hangs in Xen PV Dom0 and all users on Xen PV
> > > Dom0 are experiencing reduced graphics performance because the keying of
> > > the use of WC mappings to pat_enabled() (see arch_can_pci_mmap_wc())
> > > means that in particular graphics frame buffer accesses are quite a bit
> > > less performant than possible without this patch.
> > > 
> > > Also, with the current code, in the Xen PV environment, PAT will not be
> > > disabled if the administrator sets the "nopat" boot option. Introduce
> > > a new boolean variable, pat_force_disable, to forcibly disable PAT
> > > when the administrator sets the "nopat" option to override the default
> > > behavior of using the PAT configuration that Xen has provided.
> > > 
> > > For the new boolean to live in .init.data, init_cache_modes() also needs
> > > moving to .init.text (where it could/should have lived already before).
> > > 
> > > Fixes: 99c13b8c8896d7bcb92753bf ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > > Co-developed-by: Jan Beulich <jbeulich@suse.com>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Chuck Zmudzinski <brchuckz@aol.com>
> > > ---
> > > v2: *Add force_pat_disabled variable to fix "nopat" on Xen PV (Jan Beulich)
> > >      *Add the necessary code to incorporate the "nopat" fix
> > >      *void init_cache_modes(void) -> void __init init_cache_modes(void)
> > >      *Add Jan Beulich as Co-developer (Jan has not signed off yet)
> > >      *Expand the commit message to include relevant parts of the commit
> > >       message of Jan Beulich's proposed patch for this problem
> > >      *Fix 'else if ... {' placement and indentation
> > >      *Remove indication the backport to stable branches is only back to 5.17.y
> > > 
> > > I think these changes address all the comments on the original patch
> > > 
> > > I added Jan Beulich as a Co-developer because Juergen Gross asked me to
> > > include Jan's idea for fixing "nopat" that was missing from the first
> > > version of the patch.
> > > 
> > > The patch has been tested, it works as expected with and without nopat
> > > in the Xen PV Dom0 environment. That is, "nopat" causes the system to
> > > exhibit the effects and problems that lack of PAT support causes.
> > > 
> > >   arch/x86/mm/pat/memtype.c | 16 ++++++++++++++--
> > >   1 file changed, 14 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
> > > index d5ef64ddd35e..10a37d309d23 100644
> > > --- a/arch/x86/mm/pat/memtype.c
> > > +++ b/arch/x86/mm/pat/memtype.c
> > > @@ -62,6 +62,7 @@
> > >   
> > >   static bool __read_mostly pat_bp_initialized;
> > >   static bool __read_mostly pat_disabled = !IS_ENABLED(CONFIG_X86_PAT);
> > > +static bool __initdata pat_force_disabled = !IS_ENABLED(CONFIG_X86_PAT);
> > >   static bool __read_mostly pat_bp_enabled;
> > >   static bool __read_mostly pat_cm_initialized;
> > >   
> > > @@ -86,6 +87,7 @@ void pat_disable(const char *msg_reason)
> > >   static int __init nopat(char *str)
> > >   {
> > >   	pat_disable("PAT support disabled via boot option.");
> > > +	pat_force_disabled = true;
> > >   	return 0;
> > >   }
> > >   early_param("nopat", nopat);
> > > @@ -272,7 +274,7 @@ static void pat_ap_init(u64 pat)
> > >   	wrmsrl(MSR_IA32_CR_PAT, pat);
> > >   }
> > >   
> > > -void init_cache_modes(void)
> > > +void __init init_cache_modes(void)
> > >   {
> > >   	u64 pat = 0;
> > >   
> > > @@ -292,7 +294,7 @@ void init_cache_modes(void)
> > >   		rdmsrl(MSR_IA32_CR_PAT, pat);
> > >   	}
> > >   
> > > -	if (!pat) {
> > > +	if (!pat || pat_force_disabled) {
> >
> > Can we just remove this modification and ...
> >
> > >   		/*
> > >   		 * No PAT. Emulate the PAT table that corresponds to the two
> > >   		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
> > > @@ -313,6 +315,16 @@ void init_cache_modes(void)
> > >   		 */
> > >   		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
> > >   		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
> > > +	} else if (!pat_bp_enabled) {
> >
> > ... use
> >
> > +	} else if (!pat_bp_enabled && !pat_force_disabled) {
> >
> > here?
> >
> > This will result in the desired outcome in all cases IMO: If PAT wasn't
> > disabled via "nopat" and the PAT MSR has a non-zero value (from BIOS or
> > Hypervisor) and PAT has been disabled implicitly (e.g. due to lack of
> > MTRR), then PAT will be set to "enabled" again.
>
> With that, you can also completely remove the new Boolean - it
> will be a meaningless variable wasting memory. This will also make
> my patch more or less do what Jan's patch does - the "nopat" option
> will not cause the situation when the PAT MSR does not match the
> software view. So you are basically proposing just going back to
> my original patch, after fixing the style problems, of course. That
> also would solve the problem of needing Jan's S-o-b. I am inclined,
> however, to wait for a maintainer who has power to actually do the
> commit, to make a comment. Your R-b to my v2 did not have much clout
> with the actual maintainers, as far as I can tell. I am somewhat annoyed
> that it was at your suggestion that my v2 ended up confusing the
> main issue, the regression, with the red herring of the "nopat"
> option.
>
> Chuck

Actually, what your change does depend on keeping
pat_force_disable, but after all the discussion and
further thinking about this, I would prefer that you
give a R-b to v3 as simply my original patch with the
style fixed. I think it is wrong to confuse the regression
with the "nopat" issue. If you and Jan want to do a patch
for the "nopat" issue, that is your decision. I am not interested
in that. I am interested in fixing the regression. Also, I am
not included to formally submit v3 until Dave, Andy, Boris, or
someone else with more clout here on Linux expresses
interest in giving this idea an R-b.

Chuck

>
>
> > > +		/*
> > > +		 * In some environments, specifically Xen PV, PAT
> > > +		 * initialization is skipped because MTRRs are disabled even
> > > +		 * though PAT is available. In such environments, set PAT to
> > > +		 * enabled to correctly indicate to callers of pat_enabled()
> > > +		 * that CPU support for PAT is available.
> > > +		 */
> > > +		pat_bp_enabled = true;
> > > +		pr_info("x86/PAT: PAT enabled by init_cache_modes\n");
> > >   	}
> > >   
> > >   	__init_cache_modes(pat);
> >
> >
> > Juergen
>
>

