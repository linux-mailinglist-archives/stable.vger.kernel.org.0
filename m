Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FBC573190
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 10:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbiGMIvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 04:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbiGMIvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 04:51:47 -0400
Received: from sonic313-21.consmr.mail.gq1.yahoo.com (sonic313-21.consmr.mail.gq1.yahoo.com [98.137.65.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3EAED15F
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 01:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657702305; bh=po3rx7P0xH4Jlb2d4rjh2HEZfPtZkC0jo6hclr/31Ic=; h=Date:From:Subject:To:Cc:References:In-Reply-To:From:Subject:Reply-To; b=pnNhMykCudIQCeG1Ivwma7FjuZI/nYsICueZD0V+SPLbZ0nHMHAnUL02mQXSkVheDTXY3llaAGpMxLh5CiTvC0plnrug3CEAQZW68uIX+zd5Dba/NsThqRpnm/n3o9UF+99jJJXFI509DXX8LFI8pDdP1rjqWNtn2qoxOzhsT82asSY+Q8frRE6bBu8LOYERHxUAFNxFnXi/wc2a/SBigLKp1aJdaEU23wD/k+V8aaQDyeR1EuFG+CkQEE+gdjiTfPdXtGW8gHJA/vp8uDnqH6m9oUbA/6sAMP2Zo8abPQ1roK4vZtBAAS+jz8UcnJjNBIjd0lHvdfOttpmWxp+wPA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657702305; bh=fGPTfMaE5NgiHToEptF5sfYGWt3cD/iaWiWa4l+tKZM=; h=X-Sonic-MF:Date:From:Subject:To:From:Subject; b=E8J+PHRrL5LyYlsRtVX+/vx08U7QWF+pyFTsTq8BaI0L6xLrFy6GRhlmnvnooz2YVl+2VrjRrZ1hsZEntcZcEm3A9jVi/UOXSdQRH9O9rjy7mlSAzqgk7SuIyNCrP5bWIJUntkH4WQdYgpZ5Kj8cSsGkh4UDigRVaD444YTVTpQsdG1iuQNGQ8vYTxTzVI7n8j2Q6KDxfKmSsw/k9CYbzJIgjbodktbsTHwoWtDS/sZrOwLb2KyCSHR82cIGp1/rOjLHfDneB8qOhG9PK6ngSgHek8sXVc6EVrC6Zq9XsC9/wTsrdvv674D5+Ng5PvV0Lrj0xRrxRpJ63CDRwG8efA==
X-YMail-OSG: iJ9rad4VM1lLyKmHFAUcS8Po3ixAgb7f4Xmvk6q3hJALY0SSa0T8Q.dHr72lWpv
 vfb7vkE4pbC7a7JGUdWhdkg3RHU1WWnfz6OuZ8k5.Ivx2Vk46UQJVfydVNI_pz550UekQr1DlmtA
 oM.4Jpsiqn347yHp4fm2KeG8cp177qsIROeOV2jtOAKKZhZP2suIOT5VuTigqQQovnEZgz2E3OO6
 4NK0DkuLPcaQliK0u0i7zPklOBsL2PmLRqd2Ynx1y5TiFlVTAdFEgzPpYFfXXIoJNCt7Nl5GmFrT
 vbC32MJc8Vp6luZT..3ueD.FULplxLwqc.8_Ubhw2hBmdccITaAWNpoypEEMvjU5Kdwm6MIGi5yh
 TQRWAy3mfSVfiwMK5rq4ITp2FB6Rd74i3wJerSYhU45emur6fcwFeqxUQfX5PAyD8gktNGmD6X3C
 PFBxIRhaZHME62ThXBO4YK7I7bQBETb_hlwk8ut6y2IChsLYOj2..zj9LCAyY4mFD2bjBy2YAilW
 0srbAWGl1N0CLUdKPvFOmsW537QSN74wUoBiWMfAzLyEUlFRO.kGNy24lfQWROqnZceCi9q6Qwp_
 rZ.aZyQcqdQ2ruKockRShLKMEXsP_jAojVnfw8JsSnRkDROyH0geEuFEuEEauzjzGD7hnQgs1vV1
 l9O36OXbfjpWgSJNatllmZnka7yKCwcCBnKck0_JmBc6qPZiZIazSdRXWJ157Y_xIZyEQ0jpnuYc
 IRAG4HcSi7DqGXPU.Tg9K99DJf7kITzrkdGNd9jaIW_W1_gDDnyFm2PY44aXroa4MygwzE6iX6k3
 2suczaMjhTN1JywGwZ4_0LhTfmird2sINcBZ6bjbTt5G3mOAB06O5.TsWtpAL4m9gvYBiFWNzU_x
 K.tcXy7rJVsS4PnXLONP_QUyKdPjxYXLXT_YPjeSzfpieyDYKb4trejzrCfsHC6y7hnEVJGcjL4i
 myB08ECETL4gNCcqAHweUbDYrrgsTu5RngdNR3Yy5XWNa6Dna8Z4PDt_L.WNCXWWptBln0gPCfcc
 kaXwcf1OzNEG1xBeWpZJMrK2du0mDknVbeV9xlLuWLsce8iyJRq0fdydPifY5oibSZujq7tr2Fwx
 hny9PhbYpRJTB7bW3lU0fWmd16F2gi7HvRI6S9O6K153BkArYRX3YiQlpwL8quVAtzHIk6_X_Q85
 DwwiuvUl9KEv47yrx5TuN2B.vyl5GRLUlG.Ty2pkkWtclDrIxNIwumn4QrTzweQ7bdR0V73bGcvF
 lCH7cGv1WG6PMOC1fA1AKAbOccfF6Kn1ueWuh3wpmwC2tJ8pAW4_2CbL03KrdEv4H0ucxeE5KhyQ
 x8ApAcbBtD.w8KHdYm.Y62hqSBvDL9ojEAOomkZ7FRmAznNDYIik20jso0p2OHqCGpJLYQ6og4Mm
 4EvNWTPOWXmS9miaUm3q5dF1GkMtPyzOM_2fn3bce3j..u4ArhFMjLPckH_ks2kLjFiixgNbUO9t
 k2eqXbtI8O.bAL8fpVAd.BV8B3xJEldHM6jDRfPYfztQv0duj.HggLJwHTCfqm1z3zzSc2AfWJFE
 ovj5T6OGNjJyHx59xHjOjkDtnvnGKIOasx8v5BQNt6StRp3pny409V._bgZDW5Mh3ZdLrGpNb85A
 NXGwDH46ymLykow.l6LMIdQzcPGYT268kgD0L0PtxEdLT6fIG0Gb08hccKthqVUiAQ3XRY9x9UCg
 Iwwf6JvGJv8ZgdcB9g_2_g4JrDo9uvGA1E7iKpYtCFzm4dlNcyPLKwtRSP7KDVOyE8TEWOeXthnJ
 GBcck1YUSgwQqZMnFidMRaAUFA3fO0Bn.JUkWBGos1ibS.MNJN25SrJcN0gM0vaNQGiSGBf60il9
 6aJ.Mz6iNqnUveyrahI6EuJDpxsXXZWXTWKLIXhIiPkuvFnRLYiA18obmIZu6pwcF3uELGPbr_eA
 zJ62N3.i01Y3LRZqYSWZvTA6dfum6x5DznBFXbsPpvM99fUK_BsbPaEycsn3n5ofnLz46_RbpSV_
 fOGavJ42Ey4SmnX381Q3zroWFtaWSR8RK.Ghvl6D7QUSv51GmEt4WCt9FPgPaHrQvHWCZZSVWSHa
 lPoBPtLGwJw_cHwZRdulQ26FEvexq2tHHE_Dd64qPPvV64sxN7dSrIZSIwPyuYvNk8ydKjcbQf1b
 BNkYachARiSVeH85htb4EM5o1AWCAQtZ1_0433Ev0AvmSJZUvCEIjSg1tOJCj6DCPVjVMjmGbvGo
 -
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.gq1.yahoo.com with HTTP; Wed, 13 Jul 2022 08:51:45 +0000
Received: by hermes--production-bf1-58957fb66f-hgp8q (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID ee28fbef4544e32e715de306ef9fc732;
          Wed, 13 Jul 2022 08:51:39 +0000 (UTC)
Message-ID: <3d3f0766-2e06-428b-65bb-5d9f778a2baf@netscape.net>
Date:   Wed, 13 Jul 2022 04:51:36 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Chuck Zmudzinski <brchuckz@netscape.net>
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
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
        linux-kernel@vger.kernel.org
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <e0faeb99-6c32-a836-3f6b-269318a6b5a6@suse.com>
Content-Language: en-US
In-Reply-To: <e0faeb99-6c32-a836-3f6b-269318a6b5a6@suse.com>
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

On 7/13/22 2:18 AM, Jan Beulich wrote:
> On 13.07.2022 03:36, Chuck Zmudzinski wrote:
> > v2: *Add force_pat_disabled variable to fix "nopat" on Xen PV (Jan Beulich)
> >     *Add the necessary code to incorporate the "nopat" fix
> >     *void init_cache_modes(void) -> void __init init_cache_modes(void)
> >     *Add Jan Beulich as Co-developer (Jan has not signed off yet)
> >     *Expand the commit message to include relevant parts of the commit
> >      message of Jan Beulich's proposed patch for this problem
> >     *Fix 'else if ... {' placement and indentation
> >     *Remove indication the backport to stable branches is only back to 5.17.y
> > 
> > I think these changes address all the comments on the original patch
> > 
> > I added Jan Beulich as a Co-developer because Juergen Gross asked me to
> > include Jan's idea for fixing "nopat" that was missing from the first
> > version of the patch.
>
> You've sufficiently altered this change to clearly no longer want my
> S-o-b; unfortunately in fact I think you broke things:

Well, I hope we can come to an agreement so I have
your S-o-b. But that would probably require me to remove
Juergen's R-b.

> > @@ -292,7 +294,7 @@ void init_cache_modes(void)
> >  		rdmsrl(MSR_IA32_CR_PAT, pat);
> >  	}
> >  
> > -	if (!pat) {
> > +	if (!pat || pat_force_disabled) {
>
> By checking the new variable here ...
>
> >  		/*
> >  		 * No PAT. Emulate the PAT table that corresponds to the two
> >  		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
> > @@ -313,6 +315,16 @@ void init_cache_modes(void)
> >  		 */
> >  		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
> >  		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
>
> ... you put in place a software view which doesn't match hardware. I
> continue to think that ...
>
> > +	} else if (!pat_bp_enabled) {
>
> ... the variable wants checking here instead (at which point, yes,
> this comes quite close to simply being a v2 of my original patch).
>
> By using !pat_bp_enabled here you actually broaden where the change
> would take effect. Iirc Boris had asked to narrow things (besides
> voicing opposition to this approach altogether). Even without that
> request I wonder whether you aren't going to far with this.
>
> Jan

I thought about checking for the administrator's "nopat"
setting where you suggest which would limit the effect
of "nopat" to not reporting PAT as enabled to device
drivers who query for PAT availability using pat_enabled().
The main reason I did not do that is that due to the fact
that we cannot write to the PAT MSR, we cannot really
disable PAT. But we come closer to respecting the wishes
of the administrator by configuring the caching modes as
if PAT is actually disabled by the hardware or firmware
when in fact it is not.

What would you propose logging as a message when
we report PAT as disabled via pat_enabled()? The main
reason I did not choose to check the new variable in the
new 'else if' block is that I could not figure out what to
tell the administrator in that case. I think we would have
to log something like, "nopat is set, but we cannot disable
PAT, doing our best to disable PAT by not reporting PAT
as enabled via pat_enabled(), but that does not guarantee
that kernel drivers and components cannot use PAT if they
query for PAT support using boot_cpu_has(X86_FEATURE_PAT)
instead of pat_enabled()." However, I acknowledge WC mappings
would still be disabled because arch_can_pci_mmap_wc() will
be false if pat_enabled() is false.

Perhaps we also need to log something if we keep the
check for "nopat" where I placed it. We could say something
like: "nopat is set, but we cannot disable hardware/firmware
PAT support, so we are emulating as if there is no PAT support
which puts in place a software view that does not match
hardware."

No matter what, because we cannot write to PAT MSR in
the Xen PV case, we probably need to log something to
explain the problems associated with trying to honor the
administrator's request. Also, what log level should it be.
Should it be a pr_warn instead of a pr_info?

I will agree to implement your approach of checking the new
variable where you suggest and limiting the effect of "nopat"
to not reporting PAT as enabled via pat_enabled() if there is a
consensus about what we should log to the administrator in that
case and if Juergen and/or Boris agrees with it.

Chuck
