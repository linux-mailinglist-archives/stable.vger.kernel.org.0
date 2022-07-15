Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5F8575A86
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 06:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiGOEmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 00:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiGOEmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 00:42:43 -0400
Received: from sonic317-21.consmr.mail.gq1.yahoo.com (sonic317-21.consmr.mail.gq1.yahoo.com [98.137.66.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7823A78238
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 21:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657860162; bh=PdXtmKC/fMFYRiHLmCdqe073IqBMbeVVyHRlJzaM88E=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=D9ej/y6R1UgtrKbFyb5WwflsOaoHe3KWTnpSXldMMMHi/aTXaN5et6s/ppHcdnBv9g/lAhjVieYrOwynMfivnZM4t4HVN8WCdl5RfSUe1zxF0QLx5AIdLyjJ5moqkHdTTAHYDeWO7/yGx1Dx1SxFMnOW957rwzMR2xnE/RpgLu2/zOoddszoEm0PHcSkyrQIHN8nN5qheiy5RZKsQnWZbs/2bmsR4u2u1DlBphhRSn5Ir12e2wHPNOolwPhV/mrCYL2i0QS9+4LBSwYc8QaBspa+aFVClqZPP3zhxMx4b5OkHF8s8gL9wKUliQsBxP8c6l50CFfYeaSTWiZ4vdpflg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657860162; bh=Io+PiMS/j1k6QqUwRDZp1H+ycGnjKn1PqrkBhFpVQZk=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=rSu4N88zCLEu9IOajFNBTzCGo01XRJ270e3GVxKrp6b+ua7Zc6rTRy9eMfGEE0gC2LsQ9V4ZXMOAlWjU9T2kVkGuidluaoaEySPpOJfVoBorsa7GlAkwbsYWg4akIipF6ni6v+qCiX6DKLjn14z9hoWSWzm3aPx7I9Z37n7BLjedyRmrnGjoadlCp6gE2OuC/27aQL8JbFbZBM2Wl2yjtvbmsioNVZbQZ/qLh4/yfaVte2VcXJw0GX44h1Wnyk3YyQaaiTGRH4SDLiJBbeeg8mpjnocaaXMG9XVdexkki+9BQswVmFIEsQYgx9H4/i0baF5PhTifdBuDtR8EBSKHiA==
X-YMail-OSG: Fgzng9wVM1kGWsn6SvqtrQ61hNeMGMssO5ecVsDJXa2.aDHVw_o9sICVMT8sWwN
 KA3dZ8ZKB.gmSaXIepaZoQ3wcXWpCX14tTrU9ZOO2SvMbqDNFszAkdAkstd3R47bvffcDpT2EDos
 ATq.iab5u7phl1cjG9zaeg3ZXZKHZuuylnGpLeZPF3cOt2kXBxYs09C5viBPpaBy4C5FkTvxiXDJ
 8ufqLqOAT2rd3SaSvzY0awYeSsG2M7Rj7_gsO2zCZ.jhZ6ceCrXguX.7LBb1i82gMk7RHFBtyOP3
 VLCHLnErxQiQcJW8pH.hWXE3RgKa3WRu.e0VGqTBH4DF.YVKss0d5xjXkCLnhmLz22PYyNc1D0xM
 kKOCqdlKh9Q_p39Zwct204_bSOyUdJBxb80QEc.uuj3wswtqqpVrhgFolDaJKD.FkQtkkN6VG5MQ
 p3G9b_UmSWAKoFMT1q4L4X1IacHoC5fbsNfK66PJ2__.L8QAORZ.NF5X8xg_t7NuRrlDekaebbUf
 clrq50Rwuk.6bV1GhcCLDLXav9PW_bXjiVRdoRUn4s2uSo7yb5n8eMDO0za0tr01ArxPnqpCqhN.
 gNngEaD56kpXB85B95Vd3sPdkUnh6RsFsnqwVwBT6CcMZqrehH7xSzI2Mhu7YGXJpQnTS3hekpnj
 u_g7q1O_m8OTNCyg5bncPhAc1QGASRCCpab5g3cyx7gSyXO5BSvgWtGVJdfWSmnml1h4NioAgqBg
 aKU_plszWMO0J6vdilDbAOHhA_PWc6qnJELdHLBJKz4G4Vo9Z5eRtftV_JztUrXmECFanEp9_VV6
 fMcSKlDN5zrBxYhTb_taJ2MJ0tF_5qYc0_tNldCt_xnEf3dTV2o.51Aklli2RB5z3YmRnog3gCo4
 sV6iolJGoMU.0B6MxMid2g.8UJPb87EMJAjktEX8dNVpVgy41mDtZFmfi214B8mUhexgwyBGMrhF
 RGpY_17OysIh2Zqg_CeN7_5fd0hJeevDVkbDvyRlb.SPm9zjyy9HWpiMGft1e0nzLYdy7l4ddkBF
 7c35HtZcUYsfOxkamZdWIibgSFepr4DvxvuLYgWOepUCmrIHCBN5Nazs.pwA.8XjtWejxnUMbcR5
 FpCEgZuW5POXEol3kenqg84tx_aqSJMQZaXYWxbpPRlaqA3TjvQNvtHja4zJMrSJpd_8f4l15veA
 9Cpu9VkKSFlQeiSRFIqQnio1hi8mKCXTsheRivTskEeQZALwYdWcPZp18G7Y4wQT7TRbwqrxPjD.
 1PhbhuBw1q9AUigm0PGDDBQRYYrGAZAf7ks436METF0bNxD4W1v0VqcTqVbrPDwz7PHz6Zl8teD_
 GbAEsXBCYmbJi.HMZToRjoOwTcS7mgsgEJjJkk5sMamLJzwb2pIAlPPhjs6lAj5l8D5vL6jcI4RY
 ZxD1BbDb4WU4uHnkxFBxfR_qKkfj4dKR5C1Ti02RyyvkPk1zEmmmlUQGbHuG1_B.lBYx8JoaMzPC
 cDC5FRcT.wXksOZyDj.XS.RXBljdGzsYnXdTJ9l1bm7avcrAZxMKe_ohC3TMDy4iwUX5jAuqupWW
 i.OmUm9Cyc879HT4pE7La4iWXbn19QJsL1G2BhsY5Vy8u1Y_dhomlQwKxulVfzjBAFG089XhAu4L
 ysQSYfvmKoJny2y_xJZELXijlp2jfmwVJs86V9RQsHRPbnVWLXPsvDevfrBtVoc9DkRHyJnQ31nx
 WM9mFMZDmxN2RCI8t8FOPVeu1zAA6IDIUkjEn4Qq6m0YLmD3D.fbQRL4vGeKvyqN3g4kGPcsoPWQ
 EpwbocOBmkwEIHSa98ShiT0kb.J._Viy0BDxUXckTdb2qJNqJw0I5LodWAdlIcjgQ7K5pBhzn3Gb
 Ei6y206BzUAou02D6CfN3YO3GlxSRSf0OP1jwAZrMwM0HMY4KrybVRhJmVA5UgQcmsDiBqpmDOZd
 VscCSTJe2XeLQVQxtUbyEbIF64PXKhHziKpICeRN3zKaowGmJy0PxSZ4rPhS83kg9077m4YVacjn
 J31Qd3fCw5wKkJ4A_EbxVdaU8SE6cRCjVoUK4uqSoW9g5vWCIr2wh0qUkJ_yir8LXaz1_luWi1d_
 4ScrhZpEapXWZJ0lWQWWj697RlYWG8KPBJKle75FK6V1w7WuD2i79A7iBLqpRhwzUbJ098EhqQpj
 nJPSDXcBz7xdtaEPnYNeDsIFaptZ8yKvoR2zxXXxr5kKW.jrLnKqbH6X.46.67Q52uU2pq3PWmBY
 vHBlgSv134Q2zctbXVPxOx0I9
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.gq1.yahoo.com with HTTP; Fri, 15 Jul 2022 04:42:42 +0000
Received: by hermes--production-bf1-58957fb66f-88chf (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID ed1b76fa43d6095b5b2fe5d241aa346f;
          Fri, 15 Jul 2022 04:42:38 +0000 (UTC)
Message-ID: <a3b96d2b-0848-26f9-79e1-0b050e6f8fbc@netscape.net>
Date:   Fri, 15 Jul 2022 00:42:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
Content-Language: en-US
To:     linux-kernel@vger.kernel.org
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
 <c0a19463-b46f-e757-c1f9-21d4c2f8bc54@netscape.net>
 <fa6f1dd4-02b6-779e-2ee4-12644d1b3c3f@suse.com>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <fa6f1dd4-02b6-779e-2ee4-12644d1b3c3f@suse.com>
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

On 7/15/2022 12:22 AM, Juergen Gross wrote:
> On 15.07.22 04:19, Chuck Zmudzinski wrote:
> > On 7/14/2022 1:40 AM, Juergen Gross wrote:
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
> >>> Co-developed-by: Jan Beulich <jbeulich@suse.com>
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: Chuck Zmudzinski <brchuckz@aol.com>
> >>> ---
> >>> v2: *Add force_pat_disabled variable to fix "nopat" on Xen PV (Jan Beulich)
> >>>       *Add the necessary code to incorporate the "nopat" fix
> >>>       *void init_cache_modes(void) -> void __init init_cache_modes(void)
> >>>       *Add Jan Beulich as Co-developer (Jan has not signed off yet)
> >>>       *Expand the commit message to include relevant parts of the commit
> >>>        message of Jan Beulich's proposed patch for this problem
> >>>       *Fix 'else if ... {' placement and indentation
> >>>       *Remove indication the backport to stable branches is only back to 5.17.y
> >>>
> >>> I think these changes address all the comments on the original patch
> >>>
> >>> I added Jan Beulich as a Co-developer because Juergen Gross asked me to
> >>> include Jan's idea for fixing "nopat" that was missing from the first
> >>> version of the patch.
> >>>
> >>> The patch has been tested, it works as expected with and without nopat
> >>> in the Xen PV Dom0 environment. That is, "nopat" causes the system to
> >>> exhibit the effects and problems that lack of PAT support causes.
> >>>
> >>>    arch/x86/mm/pat/memtype.c | 16 ++++++++++++++--
> >>>    1 file changed, 14 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
> >>> index d5ef64ddd35e..10a37d309d23 100644
> >>> --- a/arch/x86/mm/pat/memtype.c
> >>> +++ b/arch/x86/mm/pat/memtype.c
> >>> @@ -62,6 +62,7 @@
> >>>    
> >>>    static bool __read_mostly pat_bp_initialized;
> >>>    static bool __read_mostly pat_disabled = !IS_ENABLED(CONFIG_X86_PAT);
> >>> +static bool __initdata pat_force_disabled = !IS_ENABLED(CONFIG_X86_PAT);
> >>>    static bool __read_mostly pat_bp_enabled;
> >>>    static bool __read_mostly pat_cm_initialized;
> >>>    
> >>> @@ -86,6 +87,7 @@ void pat_disable(const char *msg_reason)
> >>>    static int __init nopat(char *str)
> >>>    {
> >>>    	pat_disable("PAT support disabled via boot option.");
> >>> +	pat_force_disabled = true;
> >>>    	return 0;
> >>>    }
> >>>    early_param("nopat", nopat);
> >>> @@ -272,7 +274,7 @@ static void pat_ap_init(u64 pat)
> >>>    	wrmsrl(MSR_IA32_CR_PAT, pat);
> >>>    }
> >>>    
> >>> -void init_cache_modes(void)
> >>> +void __init init_cache_modes(void)
> >>>    {
> >>>    	u64 pat = 0;
> >>>    
> >>> @@ -292,7 +294,7 @@ void init_cache_modes(void)
> >>>    		rdmsrl(MSR_IA32_CR_PAT, pat);
> >>>    	}
> >>>    
> >>> -	if (!pat) {
> >>> +	if (!pat || pat_force_disabled) {
> >>
> >> Can we just remove this modification and ...
> >>
> >>>    		/*
> >>>    		 * No PAT. Emulate the PAT table that corresponds to the two
> >>>    		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
> >>> @@ -313,6 +315,16 @@ void init_cache_modes(void)
> >>>    		 */
> >>>    		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
> >>>    		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
> >>> +	} else if (!pat_bp_enabled) {
> >>
> >> ... use
> >>
> >> +	} else if (!pat_bp_enabled && !pat_force_disabled) {
> >>
> >> here?
> >>
> >> This will result in the desired outcome in all cases IMO: If PAT wasn't
> >> disabled via "nopat" and the PAT MSR has a non-zero value (from BIOS or
> >> Hypervisor) and PAT has been disabled implicitly (e.g. due to lack of
> >> MTRR), then PAT will be set to "enabled" again.
> > 
> > With that, you can also completely remove the new Boolean - it
> > will be a meaningless variable wasting memory. This will also make
>
> No, it is making a difference with "nopat" having been specified.
>
> In the Xen PV case we will have pat_bp_enabled == false due to the
> lack of MTRR. We don't want to set it to true if "nopat" has been
> specified on the command line, so pat_force_disabled should not be
> true when we are setting pat_bp_enabled to true again.
>
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
>
> I'm sorry for that.

I accept your apology. A few days back you indicated Boris was willing to
go along with the approach I was suggesting. Do you have any idea why
he didn't give me an R-b for either my original patch or v2 or at least tell
me what I would have to do to get his R-b?

Chuck

>
>
> Juergen

