Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A34F573985
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 17:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236586AbiGMPCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 11:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236704AbiGMPCN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 11:02:13 -0400
Received: from sonic314-19.consmr.mail.gq1.yahoo.com (sonic314-19.consmr.mail.gq1.yahoo.com [98.137.69.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D824198B
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 08:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657724531; bh=2qU4AMVOzVh77LUM46UewjiYNReN14GbnEXIQ1mw9vo=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=gclZJ41efqOPK58T/6vj8hjsBOrEKzvbj0HjjwAGeILZZaFVknY3syb4E4nzyOmrhuLQWR7dj0RZecq0wEONUqwsg4Q8hojTb2SLuKjkZtMOy9s0Hof1CSdznLWRxAb2kKDDpkN7EvFXSGp+2PEr+ccqtlsyUCipoB+afPAAD1ChPYeEcRzSqELPc8d38Wld8K47Yrq+CgBhQRP8bnYxfE2AGAsEPhWe1qCHO6qyZkSW87wO464lBOtEkGYVGl82itB3hpxTWJqDE307bn25qSlgqsWsu5i4EA9PHjf7gk6eJAWISoHZiJZb/bonbbe/GTCqrF/yygyiFfSrRLV42Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657724531; bh=moTNlFIVM88uUvO9QiA7OwTnLAbYXJBSXWVEVmIUCe0=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=X/Yd3yNqBTRP3KvTmhK1J5iW0aOGCIxX3ZR7Gh6M9oKudfbSXVi81DCe3ImNOuMPsU1TChIWAkVG2Fr8dBTGCLncTGxm6H1+FshcrcN9dyOY+/Iru/Vo7QEoxirNhQV7Bbjyx3QsQzY8SBidVPWj0AByQi5toNH9bWflZdgoM7gxMkZulkWVIWjQevUGJi+7SbVD+Dpo+xmwf97asxsh5F4mCpo1TmVCopSmiSyc/mgJQmIsRHZsFu+uoDoUI8uk1gwwvIU5qcrmPeb+WDK67UGicobWEQezdsZR6gwPNSOUeyRmG/61S4N7giJ7N+Uhv7j9VsxIUxb5ctFNn04mhg==
X-YMail-OSG: qj0zHmYVM1nzHDV.djN2D6d0ziBgk39W6eLdzdBOwV3cBAch2depb_OulmFpDo3
 hy9TS3Yi8WzQURpRy2XQF9od9F4IoRdg0BCQ.ZqY1mraIb_Uqu9JVmWz0ruoLcy1Ni8VWfy3LBG5
 03qVBkkVB8tfjnmcbzpsqco2DLPOl5UBskIauYm66xKH0v4GPspscRqEAREyD1Kc4jk6.SLuVOAR
 8FxUaT5lq5PgxaD62iaXMszSPnJdBObzl4TUAs5k01iIIFCKzrxqS49vD_fxsmFQ.BOjRP7v9f3E
 ybrZ74jMRIM3Y6AQ3qaPJmCkgzoVjoYj8K2XtWjJU1uzpSQvRzOZm4hfzZLQlKpUZu9z.Rdwmc9s
 gIDy32YVorkXKRiFqOEyEiIUztkyh4AyzUoiDvOi87mzz6sqPSVT7crwLrOMSlZift8GJSrB5f9C
 K27JjP9o3d4DnICCW7dWzmAvzH6PfnTl3JyUvAQlLdS_s0EVdMExIH5G22EzYwF8.43KDu473SMg
 b5mfsyYdcOu_Qy.y9UB3uykYrQ82fourZUoF2HwuBOvheugC4RVOmXQMTOPM.RG3SxvpPZhHwvE8
 9IhPpJe.d.NkgW4tCbLAHKxDSqOB_GqKvKrCIP37Gyqga5rqngUtYy6.xiBMlyc7.tKT.utbEDpS
 6wLdepQ39MGNZKEkb9FpnL7KAwrZNCPeokG.mG141f8Jr_eQjLWf4UWg2Oh_fpwYQrBeyw0.KqGT
 E_2maAjib5OJZH93pDv45UEfrZzlTTNQMPX2aBRuptOFbRl70r6mZ_pwD956x1b2dShm1_woHCvy
 43lM2EDUKKJasYU7f8Ss9BwCobJAiHKXR9WsaEGPGW7C3viMqyT7EXc1Qzu1CtONLs4r8Cac.XVP
 akHvtKAWs7d34ad_T_M70PEYfgXYVq724AzLdZ2CWeqJ_XRAKHNc8FAhEA80nUePAyNzYZuOoPEN
 LJDDLSttPN5ec7OszVGxir0aQUDt8Ct8uAilVXQ6skQk9kcTztP2VuqFhxzPWD7rnvruXEANcfxy
 e9ZJwu9T53jfiUezyqy1edHFZXRDkrRVbiOP_npOOZe0Ql9ATP_weCPXMF5xP9NBfajUsFmQdUmO
 7Y0udarIBFP_Za9P4BeYaKfxEBDMSHbc8RAsdqWejvZpmYlkcswQiraF1UBjaL2hvPtYEbNFR5ZE
 cjWBkyVfx15rrQ8hqFsh9j7LCc1zQkhKuj25o0GlwBdxuiQFtW80IZPt9vX9erX73_LVe1gXvWz6
 ROnIyNMrmg8rx9XKcludYLCW1XPjwzZczdeS7mPpW6TT.jarajIiDo_W5Q_kc5LQnydfh6ExSkfU
 wpraA1uSJr1DbREEYKmJc8RurkCrHPnM9MoxwDnsTr1aiEy6kNvbha84tgeEuGreaSqZDVPJ5hRM
 fOR91Xi85AyyEB9aPL8FYbrm6TzF2UHwCCvzWxWzcTrcSXDa.D7inS9Pzefit.4GAMc..ebQW8aW
 1TdsNi9vEwMJxJ6magoJeKniuzWqEf7WTUAI_WA3FBErHRLV6X9Hf.RiourXMTC6WiFMJVzR5Kbi
 N8eBi3QVGpH1BvBQ1_kndts40_tkeXY1PHRiWOVE6vONvR_yknU83_oYqesBkMcg_VeWzCxuXSb8
 3epXYC0SphyEitHp00IGQL4toQlXX4lhWiEdpi7F.znFmBcnXWWeaTI6WlcO0qvbGvXRDDhWnzau
 Y3tsgUs2u9BoDLLbeiL7OkJ9rzyma0jqO4HiMqVGI_ifDkQLY5wlkaDDvN_PnvOI2tKR1jIv8UHQ
 oQu7TIPMq8wRwAASfsJB9I5mYg4xWiDQcsvvfIA0Rlj5dF6zxUjYOT0FShR2mWEbUz7UVLCrvlRh
 _ACOiqu.KS114L9T9BlIDv3J_GOPYH8u6GVQdVxezuMdCXSngM7ibb33UWAoOAsR8YyoynZVcO84
 MLCLqdiHc1DGtLuIAqCyXsKF5GvYu9IiOI1FcOVHGiCl6Z4g-
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.gq1.yahoo.com with HTTP; Wed, 13 Jul 2022 15:02:11 +0000
Received: by hermes--production-bf1-58957fb66f-m4t8w (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 057c4b2c2f02905ae1f89a35d0a975ca;
          Wed, 13 Jul 2022 15:02:07 +0000 (UTC)
Message-ID: <dc0ee2d8-fc88-e4f1-6867-43d3ca3732b2@netscape.net>
Date:   Wed, 13 Jul 2022 11:02:06 -0400
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
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <e0faeb99-6c32-a836-3f6b-269318a6b5a6@suse.com>
 <3d3f0766-2e06-428b-65bb-5d9f778a2baf@netscape.net>
 <e15c0030-3270-f524-17e4-c482e971eb88@suse.com>
 <775493aa-618c-676f-8aa4-d1667cf2ca78@netscape.net>
 <c2ead659-d0aa-5b1f-0079-ce7c02970b35@netscape.net>
 <1d06203b-97ff-e7eb-28ae-4cdbc7569218@suse.com>
 <62e32913-cfcb-e0b0-2bbe-75cc8597951d@netscape.net>
 <dbfd3a14-781e-c66e-b11c-e21ba4134067@suse.com>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <dbfd3a14-781e-c66e-b11c-e21ba4134067@suse.com>
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

On 7/13/2022 9:52 AM, Jan Beulich wrote:
> On 13.07.2022 15:49, Chuck Zmudzinski wrote:
> > On 7/13/2022 9:34 AM, Jan Beulich wrote:
> >> On 13.07.2022 13:10, Chuck Zmudzinski wrote:
> >>> On 7/13/2022 6:36 AM, Chuck Zmudzinski wrote:
> >>>> On 7/13/2022 5:09 AM, Jan Beulich wrote:
> >>>>> On 13.07.2022 10:51, Chuck Zmudzinski wrote:
> >>>>>> On 7/13/22 2:18 AM, Jan Beulich wrote:
> >>>>>>> On 13.07.2022 03:36, Chuck Zmudzinski wrote:
> >>>>>>>> v2: *Add force_pat_disabled variable to fix "nopat" on Xen PV (Jan Beulich)
> >>>>>>>>     *Add the necessary code to incorporate the "nopat" fix
> >>>>>>>>     *void init_cache_modes(void) -> void __init init_cache_modes(void)
> >>>>>>>>     *Add Jan Beulich as Co-developer (Jan has not signed off yet)
> >>>>>>>>     *Expand the commit message to include relevant parts of the commit
> >>>>>>>>      message of Jan Beulich's proposed patch for this problem
> >>>>>>>>     *Fix 'else if ... {' placement and indentation
> >>>>>>>>     *Remove indication the backport to stable branches is only back to 5.17.y
> >>>>>>>>
> >>>>>>>> I think these changes address all the comments on the original patch
> >>>>>>>>
> >>>>>>>> I added Jan Beulich as a Co-developer because Juergen Gross asked me to
> >>>>>>>> include Jan's idea for fixing "nopat" that was missing from the first
> >>>>>>>> version of the patch.
> >>>>>>>
> >>>>>>> You've sufficiently altered this change to clearly no longer want my
> >>>>>>> S-o-b; unfortunately in fact I think you broke things:
> >>>>>>
> >>>>>> Well, I hope we can come to an agreement so I have
> >>>>>> your S-o-b. But that would probably require me to remove
> >>>>>> Juergen's R-b.
> >>>>>>
> >>>>>>>> @@ -292,7 +294,7 @@ void init_cache_modes(void)
> >>>>>>>>  		rdmsrl(MSR_IA32_CR_PAT, pat);
> >>>>>>>>  	}
> >>>>>>>>  
> >>>>>>>> -	if (!pat) {
> >>>>>>>> +	if (!pat || pat_force_disabled) {
> >>>>>>>
> >>>>>>> By checking the new variable here ...
> >>>>>>>
> >>>>>>>>  		/*
> >>>>>>>>  		 * No PAT. Emulate the PAT table that corresponds to the two
> >>>>>>>>  		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
> >>>>>>>> @@ -313,6 +315,16 @@ void init_cache_modes(void)
> >>>>>>>>  		 */
> >>>>>>>>  		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
> >>>>>>>>  		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
> >>>>>>>
> >>>>>>> ... you put in place a software view which doesn't match hardware. I
> >>>>>>> continue to think that ...
> >>>>>>>
> >>>>>>>> +	} else if (!pat_bp_enabled) {
> >>>>>>>
> >>>>>>> ... the variable wants checking here instead (at which point, yes,
> >>>>>>> this comes quite close to simply being a v2 of my original patch).
> >>>>>>>
> >>>>>>> By using !pat_bp_enabled here you actually broaden where the change
> >>>>>>> would take effect. Iirc Boris had asked to narrow things (besides
> >>>>>>> voicing opposition to this approach altogether). Even without that
> >>>>>>> request I wonder whether you aren't going to far with this.
> >>>>>>>
> >>>>>>> Jan
> >>>>>>
> >>>>>> I thought about checking for the administrator's "nopat"
> >>>>>> setting where you suggest which would limit the effect
> >>>>>> of "nopat" to not reporting PAT as enabled to device
> >>>>>> drivers who query for PAT availability using pat_enabled().
> >>>>>> The main reason I did not do that is that due to the fact
> >>>>>> that we cannot write to the PAT MSR, we cannot really
> >>>>>> disable PAT. But we come closer to respecting the wishes
> >>>>>> of the administrator by configuring the caching modes as
> >>>>>> if PAT is actually disabled by the hardware or firmware
> >>>>>> when in fact it is not.
> >>>>>>
> >>>>>> What would you propose logging as a message when
> >>>>>> we report PAT as disabled via pat_enabled()? The main
> >>>>>> reason I did not choose to check the new variable in the
> >>>>>> new 'else if' block is that I could not figure out what to
> >>>>>> tell the administrator in that case. I think we would have
> >>>>>> to log something like, "nopat is set, but we cannot disable
> >>>>>> PAT, doing our best to disable PAT by not reporting PAT
> >>>>>> as enabled via pat_enabled(), but that does not guarantee
> >>>>>> that kernel drivers and components cannot use PAT if they
> >>>>>> query for PAT support using boot_cpu_has(X86_FEATURE_PAT)
> >>>>>> instead of pat_enabled()." However, I acknowledge WC mappings
> >>>>>> would still be disabled because arch_can_pci_mmap_wc() will
> >>>>>> be false if pat_enabled() is false.
> >>>>>>
> >>>>>> Perhaps we also need to log something if we keep the
> >>>>>> check for "nopat" where I placed it. We could say something
> >>>>>> like: "nopat is set, but we cannot disable hardware/firmware
> >>>>>> PAT support, so we are emulating as if there is no PAT support
> >>>>>> which puts in place a software view that does not match
> >>>>>> hardware."
> >>>>>>
> >>>>>> No matter what, because we cannot write to PAT MSR in
> >>>>>> the Xen PV case, we probably need to log something to
> >>>>>> explain the problems associated with trying to honor the
> >>>>>> administrator's request. Also, what log level should it be.
> >>>>>> Should it be a pr_warn instead of a pr_info?
> >>>>>
> >>>>> I'm afraid I'm the wrong one to answer logging questions. As you
> >>>>> can see from my original patch, I didn't add any new logging (and
> >>>>> no addition was requested in the comments that I have got). I also
> >>>>> don't think "nopat" has ever meant "disable PAT", as the feature
> >>>>> is either there or not. Instead I think it was always seen as
> >>>>> "disable fiddling with PAT", which by implication means using
> >>>>> whatever is there (if the feature / MSR itself is available).
> >>>>
> >>>> IIRC, I do think I mentioned in the comments on your patch that
> >>>> it would be preferable to mention in the commit message that
> >>>> your patch would change the current behavior of "nopat" on
> >>>> Xen. The question is, how much do we want to change the
> >>>> current behavior of "nopat" on Xen. I think if we have to change
> >>>> the current behavior of "nopat" on Xen and if we are going
> >>>> to propagate that change to all current stable branches all
> >>>> the way back to 4.9.y,, we better make a lot of noise about
> >>>> what we are doing here.
> >>>>
> >>>> Chuck
> >>>
> >>> And in addition, if we are going to backport this patch to
> >>> all current stable branches, we better have a really, really,
> >>> good reason for changing the behavior of "nopat" on Xen.
> >>>
> >>> Does such a reason exist?
> >>
> >> Well, the simple reason is: It doesn't work the same way under Xen
> >> and non-Xen (in turn because, before my patch or whatever equivalent
> >> work, things don't work properly anyway, PAT-wise). Yet it definitely
> >> ought to behave the same everywhere, imo.
> >>
> >> Jan
> > 
> > IOW, you are saying PAT has been broken on Xen for a
> > long time, and it is necessary to fix it now not only on
> > master, but also on all the stable branches.
> > 
> > Why is it necessary to do it on all the stable branches?
>
> I'm not saying that's _necessary_ (but I think it would make sense),
> and I'm not the one to decide whether or how far to backport this.
>
> Jan

What conclusion do you draw from these facts?

1. Linus' regression rule is a high priority in Linux
2. Security concerns are even a higher priority in Linux
3. You and I have been trying to fix a regression for the past two months
4. The ones who can fix the regression have not accepted our patches.
5. I have been asked to help backport my fix to all stable branches.

Chuck
