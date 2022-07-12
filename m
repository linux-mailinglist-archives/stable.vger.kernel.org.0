Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C975726BA
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbiGLTxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbiGLTx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:53:28 -0400
Received: from sonic309-21.consmr.mail.gq1.yahoo.com (sonic309-21.consmr.mail.gq1.yahoo.com [98.137.65.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256C2286D0
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 12:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657655310; bh=pgrpjNqb385gEEgRLF0Q/rt+9pomAz4bgE3sZ8LNtkM=; h=Date:Subject:From:To:Cc:References:In-Reply-To:From:Subject:Reply-To; b=cGK1XAumi8ewsF02TDfEwvDxKjXEE/9dyYBYKSwydfPHvLpmv8AXuXlWouC0txtVox6a4tuf1/ZEbNeprbOdN+MpnPWHSKsPYE/tpoM28eGUdjY3ncxa/bzZ8sMq5o+dWSvZJUP/jGYd0S/+TZhfmjWlgZWJVb55iBqtty3fD9nmfsWhp1HpoDnN2TdrQ7FY9bzAb2myFGBkPzucdxIHKcXwsfEvbQjC+nr2qS6D7ct5pS/pKLdWW/hlrgyZ8vO32M7qBJNQD9K4n9KRi++dS42Z+KvuweDe/fmNU2/KkzFwIXybY0uOsmJ2kD5Obl/+4bUEadN4MNT+7HbbDUBJyA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657655310; bh=h/lH+nNJqzfnjk2ZuaQqpRQOd5bw1El5erq2VjEJbzC=; h=X-Sonic-MF:Date:Subject:From:To:From:Subject; b=iPoSOZtBsKACXCciYie15Rq8Perhe6oJ9HL/fN+KRuNjcGdFPEcN+EoXh3BzdpvtY0ScMF6y4RLSKBZDrvsJ9zfzGvPWURZ/b4kUhDA2mDukGb+6SBLyANhSjXNWK3MlowYA+9XOL/IjiulZ7RiAZzj8U8nMGQom5V+SLO+UWV8qdv11xFnmJPBFWdflBDbDTKICnyASpNHt4Gws3kk6HW9p4phG8ZE5MSQRmKzCHJuBAtIoheYusTbPh7afmKfo7o7pEFL/t351W5lrjVqwsyrwkiLN2wSRw1kYiJ+azATUSQJJHmohC/2SZ87bey1aMP5Cb87Vi9TvwnBmyKh/cQ==
X-YMail-OSG: f0kMs3UVM1nloicb8jexJ_OKjrYz7NLzq7Mukf1rrF8mhZWIkQCqPlJdj4i0JKh
 AMAlWciZnf_KHh1uRKHdBbMokQcd4tFlOuJg.l65dnPLR0KUgrcIVzjWorOdJ6kJKI8AXML91uRm
 45oG2eXHRcibvH4vEbZqrU2mY8c7z8RFCk5TPn1A_RZy5mDvsofRlX9AYOdhI9fIo7z9fwpYQdFN
 YOKlXLEKpbYmFPqG6RbMKC0dw97_IhoI0W7gZJmHc.3Mie6RSEQcMh7NVZmH8WQ0PY31ysm0yGeo
 vTFemmChWd0LrAnPsfBnkyZ3sPGYpQU3LXcbQy2IcSTVTQGcVMlLr3tjxE4Uqj7e2vqo.wqpyO7s
 nuGiIfeXv7Qk3ZFIzdSb4u1U5tlIxVj4Og6C1TeUlZV7U8adjXgsmbAz7TwZ7VbQ4r.bxRDGyFzw
 bMwogHOS7KfGXMWUK3X3qs0EGYNw5vLxagG0q8Asqj6I4CTTUkJHiTIg5k_8iTpPNjCUYfKbUJlM
 dD3TRvPlq1e_xTaxFnwY36M0dHAMnW3vqyrrMCjfe3vNKU3WwIeHwR.5_OXu.X5mJp.Vfxe74kay
 D6F9wY7C25HRAAwqkOnCysejo3cnJ5dIMARt4uWQHzxaX7769MICz.zqi8JUQhTKnYtTu_Cs9wFZ
 a45o90eHUYtGK43u1hnDQjI_r_IjZj6TIHotzI6J5n8XvPm3g7PzHi3s4rFYezL.pm46nKCvDs5g
 o60ItcLaxA9LhN1UnsaEGZgb.U_2iE5qutFYBvDzTSeWlP4moO1wFOG0bZE1iQYg9rbC5ReuN3de
 _1.ehlOZjUvgkRwHA3i531N_ULmhK8itT5OIxzWDpjFkafTuKO6Qi3WzNdclTsVyC7JhjYCy6qqN
 FVkBtPge0IPtFiwJ9NRaXy2AR24lOEqGpZgqcQwz_Sm_QL7n7tEGooTSbUAknIGX77Usl7fMIZlu
 z_H2qW.SooXOMW9FCd1RtdT5Iz2sAildSVwLc0gow6.sRw_bjM2c2G.2O08TfhiCTgnRx7LAsACL
 z4NZSj4xnJs84hcZtsZzYR7AQSE_Ei48EilayTo9V1HU.5evMR6TA2HFbgJ4DUS7GqCTCMzQYbos
 TR8sBMFABKtxhV_NkprZM7D7k.XTtYEu37JR5xcBpO54tWu.UjBdKOxRAWZ8.0RFdDoTjqygsJtr
 POa6jvslWrRoQ8QiFJxKqUYcVia20_y49p4I51eDiY..LKD5ZhqicoJFiyHqbJK1EthG1agLC850
 25m0gKFZ86CJrP1T8oBwyXnc95KSFt2xVMpAomwCutUjVk38qdhUfLiTtH831Hz8ima0NJfO1hZX
 EU1WaPHpEVLpV9N_p88VO1HMeK_gwqfImVi.HdIfRp2KTzOVBZKB_GRj9bqJYUG6xMJJ5VnLIscU
 pGR3QT9a_vs.aOInnjOEYK.S2v3uL0MjFuPCEWS1QL58lubW0aDr2I7wHwagr1UEySspAFPUyO.I
 T8p_OvXKHGvoSjF6lXujTAITwdwY8oaPkRmbXEaGrm7Gwm0eUtozmp8LM3KM6i294.1TQeS76952
 Wbd4VpkZMBBbCsc2IH08bjEE_h8EWmZRdZ8HpuCQjMRoQNMeJIcg7.Mc2_MVl9NB65SrobDbuMo3
 2K8s99RpsUpDGDm3.Bp.YcpAW8i3tCM5MrE8fjAjQnZGSMyKb7fdPl027JxFlFEHZ8ECRsVWEdrp
 JQwFz7OajkuTtY.f0JBydVLtdRR0R8emJGqOVeQ_6u9ZBhi4fEk9jJV0imkWQOrgCXim83E.uy4i
 MhwWiXLjexdrDqvOjv2PnsiNvAHd6VLk239OS4LGpc02FNN.lRx8xXH0OtxROc1qL.MZRQG6_Uf7
 FzNS_YDwA5pjPXlpQ8l9CMRf3.9Ts2chwfpgHgXJVfyk2yGriwuJr3G9Gi9ssjxcGETZeNmWMDW.
 ciGrTJhCsKi6UEzWPyI7iw9aFENrCz5yYRaMMsvbZmN9WrSX7v60cCFDZgJlsK02Q_ZU.9mg61LK
 I5OOLbc2Z9Acbpa2HvOdjpfw_vQeRNKPtt1ZVcyGKc_IgR9r2ATBxZzja5OWj4YHmV2OQqKAKqNC
 QY5Ft157jRfoxt7zcyunB6CMYsNrMWbT1rcwEmLxyk6vWikvw51aJkMJGv.cIStEKBAycwJGhrg2
 0PWzfs3PpPrwATELsM9EQaS9YbkfOJscmdXyussGcSV5vPXbJ7bIp.lg6XjZHhBHA92SwAGX4ZSm
 SwmY-
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.gq1.yahoo.com with HTTP; Tue, 12 Jul 2022 19:48:30 +0000
Received: by hermes--production-bf1-58957fb66f-fvhff (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 971ea9941bc8ae4c927179b995a77a93;
          Tue, 12 Jul 2022 19:48:28 +0000 (UTC)
Message-ID: <32c86239-c434-369d-b6a7-f6f88cf5430a@netscape.net>
Date:   Tue, 12 Jul 2022 15:48:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] x86/PAT: Report PAT on CPUs that support PAT without MTRR
Content-Language: en-US
From:   Chuck Zmudzinski <brchuckz@netscape.net>
To:     Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>
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
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
References: <2885cdcaccffd287ef69c7509056ddf183a38a0e.1657647656.git.brchuckz.ref@aol.com>
 <2885cdcaccffd287ef69c7509056ddf183a38a0e.1657647656.git.brchuckz@aol.com>
 <388a3838-1681-dba4-dabd-a7f27817bf34@suse.com>
 <b24d7fe6-c1aa-5d3a-5c68-98dfb57bdc40@netscape.net>
In-Reply-To: <b24d7fe6-c1aa-5d3a-5c68-98dfb57bdc40@netscape.net>
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



On 7/12/22 3:18 PM, Chuck Zmudzinski wrote:
> On 7/12/22 2:27 PM, Juergen Gross wrote:
> > On 12.07.22 20:20, Chuck Zmudzinski wrote:
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
> > > This patch fixes a regression that some users are experiencing with
> > > Linux as a Xen Dom0 driving particular Intel graphics devices by
> > > correctly reporting to the Intel i915 driver that PAT is enabled where
> > > previously it was falsely reporting that PAT is disabled.
> > > 
> > > Fixes: 99c13b8c8896d7bcb92753bf ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Chuck Zmudzinski <brchuckz@aol.com>
> > > ---
> > > Reminder: This patch is a regression fix that is needed on stable
> > > versions 5.17 and later.
> > > 
> > >   arch/x86/mm/pat/memtype.c | 12 ++++++++++++
> > >   1 file changed, 12 insertions(+)
> > > 
> > > diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
> > > index d5ef64ddd35e..0f2417bd1b40 100644
> > > --- a/arch/x86/mm/pat/memtype.c
> > > +++ b/arch/x86/mm/pat/memtype.c
> > > @@ -315,6 +315,18 @@ void init_cache_modes(void)
> > >   		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
> > >   	}
> > >   
> > > +	else if (!pat_bp_enabled) {
> >
> > Please put the "else if {" into the same line as the "}" above.
> >
> > > +	/*
> > > +	 * In some environments, specifically Xen PV, PAT
> > > +	 * initialization is skipped because MTRRs are disabled even
> > > +	 * though PAT is available. In such environments, set PAT to
> > > +	 * enabled to correctly indicate to callers of pat_enabled()
> > > +	 * that CPU support for PAT is available.
> > > +	 */
> > > +	pat_bp_enabled = true;
> > > +	pr_info("x86/PAT: PAT enabled by init_cache_modes\n");
> >
> > Wrong indentation.
> >
> > > +	}
> > > +
> > >   	__init_cache_modes(pat);
> > >   }
> > >   
> >
> > Any reason you didn't fix the "nopat" issue Jan mentioned?
> >
> > I asked you twice to add this fix.
> >
> >
> > Juergen
>
> Sorry, I did not see your request. I will resend with the fix
> for "nopat" and the other style issues you mentioned.
>
> Chuck

I will also re-compile and test the new patch before sending
v2 and unless Jan objects, I should acknowledge Jan as co-author
of the patch since I will be using parts of his proposed patch
to fix the "nopat" issue, so I also need to get his sign-off before
sending v2. Jan, how should I obtain your sign-off?

Chuck

Chuck
