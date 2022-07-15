Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4113575987
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 04:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbiGOCTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 22:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiGOCTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 22:19:48 -0400
Received: from sonic308-8.consmr.mail.gq1.yahoo.com (sonic308-8.consmr.mail.gq1.yahoo.com [98.137.68.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A802A404
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 19:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657851587; bh=ikYj4oGExaqVUjXEqqwrkniGmBXQdtogeu3jz7ioOUw=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=QFOscrCN2oVaeycP2RbKLtRi7bImemzW671zFZhpnbsqWt4HC9FMMzPey6mMQwIJEN5/WabaadMuotMims7n3yiLh4VQvJZiVGsTlMUgnGKQv3j7jDb7wfKn/2jBbO4VHE56C/DNKmpPx2Muc1+fYhjGlCpR8Ubsh2EXt0Ei9PPyXMtZL1ALWt6M9zkRkfDQpYzILKE0m4PfxW8vjwlIjGZyhXWtCYFIl2ewpWJY5lrsjls/qWA2frSnD4XmmnVx0xeUwz6X7Kq0eVVtFInX2L6YPvEh8zDqUbkr7pHSsQrmJT60WhxA1hLrFGwwOwSiBl1SrHeQSzXuG4aaoDsEtg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657851587; bh=2tvmpiwH/jUC7q1rvaoVWpN60yRmZ3/H7HpMVZ0HX6u=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=qBQ5x2hvSABvVUR9T6tfp5kzDs4vIUHpmjJukK6R1D293SOiSXflauNRC8h8V7yGA5NUIGjpd9kOasV9Uyo1o+sH2HPxnKlJQGH0NGdtgISVl0IEJ7tZrAV6pXZnNxPQqkgR1uOliRQxaPJd8Ou/O2lKnEM+0XcJZEe2z3tqYGvsTbJtr7XkBc1oQBYxCPW0d6/e9lHn2D5F7tay+QP3/gNc1Ptw+gYTAwZLKFV4KhcGS/JfUdqJm2SvmKQaMdpWWjUqRJo0jPmCQS7zCMNK8B8gp/ZbP/r7JtF9Ejj7R2yNKGIzWnJQwgjTpw6TO7fGfdq/rDFqiYWWDRXO1Iw7jg==
X-YMail-OSG: ApqVZPQVM1m.wsDXoGVxxoB9DGoFc4flSA7teL_IGd3AKzWtk3YLgQV_I29qiDi
 KIdhvF8By5OGwCsQhwz88fQWE4Xyg5YpV2OkAsNbZl0iediYd5KK0tP0uE_2uxWqC6yeUHzNjpoT
 6zJus7ZrCPA9aS9BZsPxbbZOlM5FDHBtPFWcLnSuaox6WtgJt72OJhvM6wcPkfc8d43KwDVDvnFH
 JH0OsckJjHtd_.SXdIZiEJXSTDdm8PZ71JtO0cMP2PU.5cQxyJ0tt8ov9lbLbalGygWMEdRR1v2Q
 IKu0EtemjPuQW9k.Mznx2_48l9OvBJctdXrG8b3IX4u7cQB7u4ZEluB1cP..CO.aJBh375RRZYVz
 lH0YuUcu_4SCWucRUNNWYmZ_TUsN5Qq.EyIXeWXi6gU5m24bh6.pQhxlSHDA_y3EIJ0il1R00He8
 yD19JMqHMzNZeL0XoJ4sQEPqrgLh1t0u1EraisbHbEPWPH4aN4rGiIJlYJm3b7tKUCAtk6H3SnGS
 Sq7iyMy9PGBXiptV1yqxq4t_9Ogf1nTaIaSnujBlb80pcCqYbUQNNpU28OjymzGT0FKPEr1J8hp3
 jTw_oJHZp5evOHpJzJuXNsqDxhDQ6QK2PL7keZgqwMPXm0zbSGoeJ3V6aGAfaXE2eJ9z.MhoBlMW
 1eUpZZF.wfzxpdaqj1ka83puoc6k0PXrrzlRMO.qI04cJxSn0S6WrGhVOHMSxLPn.tEkCk16imCj
 hTj.0.dXsQtvh4S6ODaiX8LKiLbk135orr9Hds7lv.P4.LJy.SQaOc1Kyhrd_dBrVX1miyjZvnas
 wF.7ADKh31NviBWh.5qUUs73Qdd3RU3ZHIS3UhfHixjiCU3ZwJrUJpr_GSwWt4PzJuOFwId0POTr
 qtG_7tzE5L7vXbEF8goVIDY4_YSWfqngUzIydcuz.KWwvkB7raE6DE28qqFcipEIZUS9roExNaGg
 ahXxhkhq.1mN7tB_gXpGP1IPli3LU6aDXphQxowwu.7sv6Uy0fgfwEDEMnv8dmqhGIOKWY8qUUEP
 3h3KUfmQoyvPvexFnmG2VVENhaKkp7fly5tVGdcYgz94FxCTiqtkqsruEncEuCVePpqgMIi3ySMi
 as_Bcd68LeDhwBoGwrj7mmpCuAITvs6t0OYahqQX3FTV7tpz4ITJefXH0Pp7xhQfxgydowiGEXI5
 FrqG3qKZ4fbJryg2O5G8u7z.Iauq3xkWmP5_wUGtl3yxn1KYpUIMGHuhlVUXl01eHii6pUVLUGKC
 IErXK09TeFdDLvsZPsUuqWfa0UNEGSBSKeD1HIjskIiFLQE0tIuDX.xxXuMYRdt._p8s9aphqmgH
 KFBFoqmIsI8xiC1Bh1EiLVRw7d6HSntdZZ2L2w_3_VCenabqMfsXM8B0WQ_Kr2gRGtZZejjBTT.M
 hfAvEkaspRkbwSKzZLE71jso7pGHsVaP8liKErRjqBYlIcEzm1bI4GdDuTBJAb4ZRMnnKn7vxffF
 rdKbc9FEjjGDpR_8PSsSQ4e9a7iVMy8KnV8PJ64CfutNuryMKnQuEpnrfz7CcjSfeMcomKh7ZI7C
 XhDFZEMEbLfgFEPyvmW_jtAhmV3DSL_CrTIwAe28AU.SorZhYnCvsZ8rmHP9rbuPkL22aFX.m70a
 ligBiA.hiAKujwRdnB4xwHdZRdPdJUaNI5.w2pERn0j5.iAvBRljuxCVnOOVN8Z1kyMe5H5cxwWV
 NPHqGzGW7aBzwyoFjLqFOP0XYHS_xymYcSrG3LBblT.D0JSJq0p5UYizPI0lkaUM967RUqlbxce3
 OyBHcrmZeVn0l9fSbEpVymyZtX.s10CXiSzwqSUg4Zhi9D6zBKPKqQNcyBqhNPTkzzP8zSmdcKmf
 Jak8OicvOEK.9qWNEJLFsE2sMs4kOj2wdGtzZjP3_xuIdMBI1cAFMe4rL3h9d1nUw58DJhpBdlI5
 xStANGwAAQWxYweCSe_G7y.qusltHEkeIhsdOv085GnWaNHhlpgDExxR4yugFhtT9hrGOpOhhxTO
 hz7PQfEU_2ITr9.ICrBIWexsKfYAbeSfLQslCyXhuZGj3EX_Ft30TNvNuMZI9PdJfiE9I8oda5p7
 WoMGXhNoePb013uAAP3bMTAgZ6Cg6duvgDKTREuVNKDu6SVPuyeUs0ZO3fqwVCQcwWNhNEb8FY6I
 xuBud4UC4q7cHXLd6vvVjimMaopaeHnppdeJxZCFLszjSRGRY1deIV.B2j.MQObec2QN3IY5qCiZ
 n8Ac-
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.gq1.yahoo.com with HTTP; Fri, 15 Jul 2022 02:19:47 +0000
Received: by hermes--production-ne1-7864dcfd54-xmlhn (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID ba0ca635c88d8bc86fe3ed38195e495d;
          Fri, 15 Jul 2022 02:19:44 +0000 (UTC)
Message-ID: <c0a19463-b46f-e757-c1f9-21d4c2f8bc54@netscape.net>
Date:   Thu, 14 Jul 2022 22:19:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
Content-Language: en-US
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
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <ec4b2791-886f-4d52-ab39-b0c07489c4ca@suse.com>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <ec4b2791-886f-4d52-ab39-b0c07489c4ca@suse.com>
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

On 7/14/2022 1:40 AM, Juergen Gross wrote:
> On 13.07.22 03:36, Chuck Zmudzinski wrote:
> > The commit 99c13b8c8896d7bcb92753bf
> > ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > incorrectly failed to account for the case in init_cache_modes() when
> > CPUs do support PAT and falsely reported PAT to be disabled when in
> > fact PAT is enabled. In some environments, notably in Xen PV domains,
> > MTRR is disabled but PAT is still enabled, and that is the case
> > that the aforementioned commit failed to account for.
> > 
> > As an unfortunate consequnce, the pat_enabled() function currently does
> > not correctly report that PAT is enabled in such environments. The fix
> > is implemented in init_cache_modes() by setting pat_bp_enabled to true
> > in init_cache_modes() for the case that commit 99c13b8c8896d7bcb92753bf
> > ("x86/mm/pat: Don't report PAT on CPUs that don't support it") failed
> > to account for.
> > 
> > This approach arranges for pat_enabled() to return true in the Xen PV
> > environment without undermining the rest of PAT MSR management logic
> > that considers PAT to be disabled: Specifically, no writes to the PAT
> > MSR should occur.
> > 
> > This patch fixes a regression that some users are experiencing with
> > Linux as a Xen Dom0 driving particular Intel graphics devices by
> > correctly reporting to the Intel i915 driver that PAT is enabled where
> > previously it was falsely reporting that PAT is disabled. Some users
> > are experiencing system hangs in Xen PV Dom0 and all users on Xen PV
> > Dom0 are experiencing reduced graphics performance because the keying of
> > the use of WC mappings to pat_enabled() (see arch_can_pci_mmap_wc())
> > means that in particular graphics frame buffer accesses are quite a bit
> > less performant than possible without this patch.
> > 
> > Also, with the current code, in the Xen PV environment, PAT will not be
> > disabled if the administrator sets the "nopat" boot option. Introduce
> > a new boolean variable, pat_force_disable, to forcibly disable PAT
> > when the administrator sets the "nopat" option to override the default
> > behavior of using the PAT configuration that Xen has provided.
> > 
> > For the new boolean to live in .init.data, init_cache_modes() also needs
> > moving to .init.text (where it could/should have lived already before).
> > 
> > Fixes: 99c13b8c8896d7bcb92753bf ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > Co-developed-by: Jan Beulich <jbeulich@suse.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Chuck Zmudzinski <brchuckz@aol.com>
> > ---
> > v2: *Add force_pat_disabled variable to fix "nopat" on Xen PV (Jan Beulich)
> >      *Add the necessary code to incorporate the "nopat" fix
> >      *void init_cache_modes(void) -> void __init init_cache_modes(void)
> >      *Add Jan Beulich as Co-developer (Jan has not signed off yet)
> >      *Expand the commit message to include relevant parts of the commit
> >       message of Jan Beulich's proposed patch for this problem
> >      *Fix 'else if ... {' placement and indentation
> >      *Remove indication the backport to stable branches is only back to 5.17.y
> > 
> > I think these changes address all the comments on the original patch
> > 
> > I added Jan Beulich as a Co-developer because Juergen Gross asked me to
> > include Jan's idea for fixing "nopat" that was missing from the first
> > version of the patch.
> > 
> > The patch has been tested, it works as expected with and without nopat
> > in the Xen PV Dom0 environment. That is, "nopat" causes the system to
> > exhibit the effects and problems that lack of PAT support causes.
> > 
> >   arch/x86/mm/pat/memtype.c | 16 ++++++++++++++--
> >   1 file changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
> > index d5ef64ddd35e..10a37d309d23 100644
> > --- a/arch/x86/mm/pat/memtype.c
> > +++ b/arch/x86/mm/pat/memtype.c
> > @@ -62,6 +62,7 @@
> >   
> >   static bool __read_mostly pat_bp_initialized;
> >   static bool __read_mostly pat_disabled = !IS_ENABLED(CONFIG_X86_PAT);
> > +static bool __initdata pat_force_disabled = !IS_ENABLED(CONFIG_X86_PAT);
> >   static bool __read_mostly pat_bp_enabled;
> >   static bool __read_mostly pat_cm_initialized;
> >   
> > @@ -86,6 +87,7 @@ void pat_disable(const char *msg_reason)
> >   static int __init nopat(char *str)
> >   {
> >   	pat_disable("PAT support disabled via boot option.");
> > +	pat_force_disabled = true;
> >   	return 0;
> >   }
> >   early_param("nopat", nopat);
> > @@ -272,7 +274,7 @@ static void pat_ap_init(u64 pat)
> >   	wrmsrl(MSR_IA32_CR_PAT, pat);
> >   }
> >   
> > -void init_cache_modes(void)
> > +void __init init_cache_modes(void)
> >   {
> >   	u64 pat = 0;
> >   
> > @@ -292,7 +294,7 @@ void init_cache_modes(void)
> >   		rdmsrl(MSR_IA32_CR_PAT, pat);
> >   	}
> >   
> > -	if (!pat) {
> > +	if (!pat || pat_force_disabled) {
>
> Can we just remove this modification and ...
>
> >   		/*
> >   		 * No PAT. Emulate the PAT table that corresponds to the two
> >   		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
> > @@ -313,6 +315,16 @@ void init_cache_modes(void)
> >   		 */
> >   		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
> >   		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
> > +	} else if (!pat_bp_enabled) {
>
> ... use
>
> +	} else if (!pat_bp_enabled && !pat_force_disabled) {
>
> here?
>
> This will result in the desired outcome in all cases IMO: If PAT wasn't
> disabled via "nopat" and the PAT MSR has a non-zero value (from BIOS or
> Hypervisor) and PAT has been disabled implicitly (e.g. due to lack of
> MTRR), then PAT will be set to "enabled" again.

With that, you can also completely remove the new Boolean - it
will be a meaningless variable wasting memory. This will also make
my patch more or less do what Jan's patch does - the "nopat" option
will not cause the situation when the PAT MSR does not match the
software view. So you are basically proposing just going back to
my original patch, after fixing the style problems, of course. That
also would solve the problem of needing Jan's S-o-b. I am inclined,
however, to wait for a maintainer who has power to actually do the
commit, to make a comment. Your R-b to my v2 did not have much clout
with the actual maintainers, as far as I can tell. I am somewhat annoyed
that it was at your suggestion that my v2 ended up confusing the
main issue, the regression, with the red herring of the "nopat"
option.

Chuck


> > +		/*
> > +		 * In some environments, specifically Xen PV, PAT
> > +		 * initialization is skipped because MTRRs are disabled even
> > +		 * though PAT is available. In such environments, set PAT to
> > +		 * enabled to correctly indicate to callers of pat_enabled()
> > +		 * that CPU support for PAT is available.
> > +		 */
> > +		pat_bp_enabled = true;
> > +		pr_info("x86/PAT: PAT enabled by init_cache_modes\n");
> >   	}
> >   
> >   	__init_cache_modes(pat);
>
>
> Juergen


