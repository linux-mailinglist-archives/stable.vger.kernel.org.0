Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202D3572607
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiGLTlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbiGLTlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:41:23 -0400
Received: from sonic305-20.consmr.mail.gq1.yahoo.com (sonic305-20.consmr.mail.gq1.yahoo.com [98.137.64.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E56FDB2D0
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 12:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657653490; bh=on6J7csCU3PcwxCxXr0iZWS/WY1846nNUPISliedjE0=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=FQHPbLPJ33tHYchaTw08ToyCPILhtoV6HxbTwP9Wyk1J3fMbImmh84W606a0h3lei+847d+RgLa5yB2ZgHH12B27lbA9mbTzEm4eJtrQhkk1uCheZj5bfn9yUQt5v3bjXK7Fse3PoXbV2BGRFgtCRGB/gnNVA/grMuik7+/TZNdYE7fwVyqiSl+L080f3Jm8PAmwuikXOvxuZjvEExLdCSCeR2A2noeBUPJ3quvfiU7LpbYy8W67QP51wfnakJbPg+bk73KAOp2AzgkLtlW9LignEm5UsMZq9QvNiND4M4qIwcqJq5R3ld6GL7RJcgkneTailaDjtBb5541M7uQpyw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657653490; bh=PL+4xfOMQnU+wxM7A5UDt/OlMtG69yUxOWd+m3+vF0c=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=Zd/LOoBB4jdEgIET55uod5LFgfErz2/FjoWI6zoLnMJ2bqICCLJHf8AsDUofinqTMdkxtejM2A2UBhYjAUVSa0Uc5GDMacN6/NYr4QFdt8foAVHJMXUsGPhTPaBTVhpnhp0/iNHlP58bCPD0TGyd8eMGwOgpsuiilGeQkIzAcvIZMyYVONOBGUyLfD5F2AxSfdeZeVSdlxZXYnRcqa4TEvYvJO8T8j2WE8tHtAN6iTLcUjPU/L3oyuwt2TPgCnYcX98BZQi4ZvTo36nk6Ll0y+Dabu+degoyFjRbSwgSK2UVMMgAETkuULOCYA/bMRrd4zkU+eQGdxliKmFQKMjZLg==
X-YMail-OSG: 6uRzXoEVM1ktpBqV3wppqty5gdSRKu0q0pxT.ZTSrG6UTmg48JCt46.bH2t67rt
 bUtJyP_jQfLlVqIpjowOUcOILv31G5LGY70QiIYX_rIaD6AvueBgV7jAtmsOnXw5vhe_2A0.HSsG
 EnJSL7j.FwYBXbrnScGO9EO.KOi0Zm6Uzp9oSnG0zvjSuADpDyCp4Q6r56BBjW0tDYc3RwuDWx1n
 IygOyeWC_CHQdWyICh9vorcCWdboPzEUgWdA1ScuNES06biqCInfPr7VOX.PYBUU5rK5fx7iRkFB
 RZVyuqz9tVY3qD1s5Gb9csRlsbs745Gf3EoCV77xTt0uHW836jbCRspCljDEVJEOpzahOGPYj9D0
 V3sK5pr_X6zsXtqEvULmYElu7hyKv_LLO3XidvIyzt8v9QSjjVZht.smPWeLt3_rwpOtUggOWuFC
 hwkJ5NKM6o1Kr.vryGVczN61euXm77Yelm6OXrdLJRX.M5Yd4vSWIXTNgM5_Vs_GvYTBfuY7Dtq0
 HqaK4lTOm2sNoTw2XnWN0u4t7Rd1c2FSwK2Wz.m2s8qmSmqvltm8ivr4DmBE1k4oG4zqs3z5Ysou
 .BfRlyjmphB.oS_OCww2kVNcJnRSStMdHV.JSfWMkzbyB5IwkUR.MEsZ32fn.3RZIISM6359lJDY
 eprFMneLgYzV.DR7ShnebbB3gcFbaCO2I3gUlpnMSAZVwCy3g3sMyHlV44LYs2VxQXfEfeyaqJ6G
 YSNs7LP.7_RNFf_h5g8LSLbUIN9XCs9LN8d1fKGieq9QuJus4U9bj7ssx5czLk5dgBtEFmlRCqsL
 yVTIRNW.EKN3gxjZjqb.arGLqBmfuqJOb3jIw2ELer3qIsZk5Ws6Xa1q8S_SqJ9G1OcYUj91YSas
 GtNwF9fjQiql_FqrEeAxQoAcXw2hD1_fExlsH3XZ33HHlImvj_UER2.N.oJMMH5JxjXx8c5TllDK
 eWNfE64MRoeC5lBdXCBPnfTF12kmFKv3DvcWKSdz2PcQeD58SMJFuppAdntSarsC1xNYGwRSTH4v
 9ZUiJNKaMwFDu.xqeAsUuAZ2pNwLSgUgulnX3zRAilRO2jqgUM_z6zhJl4u3b8q9oe2arhueCPpM
 iJkQQKoBJ_r7WWZ_YadGIbMmu7yJ63ZiTCUGCLZeQfjtRtkTGZUx.bYZXfCbVzVCwn.NtxXoERbw
 tUcP.X6WabKMovZWJfqhm3kMwmDh_c9c6UKm60PZTYcUFHLy.fB4el9XGfPfYxBSfJfmu8RUGe6L
 oXpSKnWABoTU6bHyaK8Syx26dYzLx_iDtWyUBgU6gd5Q9AKOgH5ob5wxENOi83UD2s3fB4IZeWhM
 d_JT0cdEOZYs8vioy40Su4VUBwoDZXLrG6LnGSgpusJJrhPyHBcXa.pWCGlaL202V4HkPg8AGlVV
 IikE2_jFcCsKl46S2gri43PmOav3xeLt6KBqJKYntpT.kx2xzvDF6RUs6VyQjw6ORdSgi2pnJQBf
 EGotPFji14gv9uR2tVVKu4WZj2d_dLris2pPSnyPKkSOh1bpbhpWH0fD__m8AiwZuyPtoO9f.JAC
 ikrTiIrLvh8QUGqzrHnlfK.WW6cXXzdbE5iSvZAsSi9dI3k5cSGFhmKOg3pHhGW1r.54iEecu4gE
 9Ed98ZTFGaDYTL33KsUY2S6.vvt2KdIfVZRmV9VwfC5UtOdkb6APQGTII6nuemi1vuGvvFsKUSIb
 _DfFsIpPCM9zwSOhx3tLsnAVEQ0EDbCff_Q1PbF6ZqUIPjDhRGvJSSI2gNOu1CMctFSf7rB8jhUn
 xmeIeybuDo9px2nkSAVvpQmzJjpaGlSYMoyKhuezaDwXhNT4OXZFe7bIDEQrMq1sT2tjj2wKVN9z
 0YmSoAzBy8ykrSKyeHAgxVKBcE2LY.t0llAka.WyCtF4aYTOACL.0Ps7.iU1E2HOm6i19w3qkfee
 J35VAsLO2h6jS3HxQrsouujsWfQodPXAfekI._1WzHZpl8gwWJhAakjsNuBWLNxzIWxI.ijFIlmg
 TCYMMT9JLTyqRtbi0y_oiyfVzGUMnI9J9lXHQ4g8Qxd9AtpTWE6vhFUgIdmIviFMWDWbyssifBC_
 RrNeAT1B9mqxl6RYFG2isMxCcrBRzGCe6z.VucfwHCj1I6Mlhepo6x0APTHD0HYKm8QB.xcPe5Bh
 njJ1jKAB1E3kep8wG7JLLaV_Y7JIi.5smdDOt9AZWyOhCKEHkE866LeNCxJH5BC_cP1tMZTgBxDt
 RMw--
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.gq1.yahoo.com with HTTP; Tue, 12 Jul 2022 19:18:10 +0000
Received: by hermes--production-bf1-58957fb66f-hznx2 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 1f77b89044160acfa604b1a362430e8b;
          Tue, 12 Jul 2022 19:18:08 +0000 (UTC)
Message-ID: <b24d7fe6-c1aa-5d3a-5c68-98dfb57bdc40@netscape.net>
Date:   Tue, 12 Jul 2022 15:18:05 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] x86/PAT: Report PAT on CPUs that support PAT without MTRR
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
        Brijesh Singh <brijesh.singh@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jan Beulich <jbeulich@suse.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
References: <2885cdcaccffd287ef69c7509056ddf183a38a0e.1657647656.git.brchuckz.ref@aol.com>
 <2885cdcaccffd287ef69c7509056ddf183a38a0e.1657647656.git.brchuckz@aol.com>
 <388a3838-1681-dba4-dabd-a7f27817bf34@suse.com>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <388a3838-1681-dba4-dabd-a7f27817bf34@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20407 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/12/22 2:27 PM, Juergen Gross wrote:
> On 12.07.22 20:20, Chuck Zmudzinski wrote:
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
> > This patch fixes a regression that some users are experiencing with
> > Linux as a Xen Dom0 driving particular Intel graphics devices by
> > correctly reporting to the Intel i915 driver that PAT is enabled where
> > previously it was falsely reporting that PAT is disabled.
> > 
> > Fixes: 99c13b8c8896d7bcb92753bf ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Chuck Zmudzinski <brchuckz@aol.com>
> > ---
> > Reminder: This patch is a regression fix that is needed on stable
> > versions 5.17 and later.
> > 
> >   arch/x86/mm/pat/memtype.c | 12 ++++++++++++
> >   1 file changed, 12 insertions(+)
> > 
> > diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
> > index d5ef64ddd35e..0f2417bd1b40 100644
> > --- a/arch/x86/mm/pat/memtype.c
> > +++ b/arch/x86/mm/pat/memtype.c
> > @@ -315,6 +315,18 @@ void init_cache_modes(void)
> >   		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
> >   	}
> >   
> > +	else if (!pat_bp_enabled) {
>
> Please put the "else if {" into the same line as the "}" above.
>
> > +	/*
> > +	 * In some environments, specifically Xen PV, PAT
> > +	 * initialization is skipped because MTRRs are disabled even
> > +	 * though PAT is available. In such environments, set PAT to
> > +	 * enabled to correctly indicate to callers of pat_enabled()
> > +	 * that CPU support for PAT is available.
> > +	 */
> > +	pat_bp_enabled = true;
> > +	pr_info("x86/PAT: PAT enabled by init_cache_modes\n");
>
> Wrong indentation.
>
> > +	}
> > +
> >   	__init_cache_modes(pat);
> >   }
> >   
>
> Any reason you didn't fix the "nopat" issue Jan mentioned?
>
> I asked you twice to add this fix.
>
>
> Juergen

Sorry, I did not see your request. I will resend with the fix
for "nopat" and the other style issues you mentioned.

Chuck
