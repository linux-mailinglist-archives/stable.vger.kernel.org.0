Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CA85737D4
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 15:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbiGMNt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 09:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236384AbiGMNtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 09:49:17 -0400
Received: from sonic312-23.consmr.mail.gq1.yahoo.com (sonic312-23.consmr.mail.gq1.yahoo.com [98.137.69.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE6913B
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 06:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657720155; bh=7gN2eO0nhM4u4WQBVoTr1S4htzfsOtgXWS/54zW1CGY=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=gMnJsCGyPYv9nYZ8E5KGWeRN0Fn7q3an/63OTkVV+Rvt2WnXgvKYHZMPI4ffzrC6eWIbAGEncTP7WyaFPlLZm47CiKh8/DlfRAyp9NCVVmttZ7N139+1T8peRCQhy4FSvvoBF/5NGpPl/nFpMZaplAzFgpbkKrstO0knfefFGaC1LTONJPzjD14jnUCBrYBigziriXm7nhLtKnix5GFN5gpTjGYppZcoMw6zTKDyZGAJhKB8smx3lE60iovKGJrJSNp3FlfupxZGG906VWtTGZ34BDpDbhiZXdLUuwOGHuyhmKcJkbrMJkKQJoP3VD9ssT1B6419fgZUTdCzRiHL0w==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657720155; bh=lx/Fltblve9A3NgLKQ1x8D7S21NiR6VyzfPZIw3Ye3S=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=rjNZtnBuSQpVmf2J0Unvc9P4GcQUFb/FvTYbYGYJbya8K8p5EjK7acH5v8mWqpLuCQG2/aabfuNe2IZtoBaYpPG+upX4eBsS6DQhPRnyo9pt2HXJl9mmd0GK6hcy/5y4okXY8t2V+AaOBXhDY1niwc4wfXskN6R9KTiQCq7MCOreRZBhXY0Br6QpkFQxz1ilQjY+5Dj8I4AzS8W6iesXtjcxlS1XtmH5HnxKw7pUcO8gPprlHCGcZKOIIdvqvOUPXpk+OE2Pe+bMLjsIzZ1G8nQX1PMlC1oj9jfFM7LvoTUn0+OyWUg50JnbtCWT9usgHHX+HlilISB3BvoZKZJj+Q==
X-YMail-OSG: GtMdftgVM1m1ltD7b2xLPsZ9cFn5Cp8KJrCorLRXNd0NFrsD2VNOU2W9CywnHhT
 kj5kuT9B6e9Pmeh0Q8BkYQtZxi5NW9geVncsWMP9f3cQS1O_JrKtagNelbPubX2axK.IBCGnvaX0
 LuAD5vZbaMvo7oD_e0kFHVBDNzNlWGDPw.Y6G2LIKV3BVpWGJSZsYHyQSofPvcu.tACdoogVmRyb
 wENEAam8YYpm1TxoORbHbiZROrWZxJW3plCWUYTuRN0YCQE_LaCz0zMY.5fhDiBCpjAZZufHWsh2
 K1MqKRxPFXZauUY5HJKG2EtXb3x.RiJ.P.aQ4HeAVC7avgeMeIBIovxc.kPEYyJYhZ1xQQFn_hhd
 HkTKzuMG9dCPWx65UEehwWI30Abg4ebTCoyEIIJIwpIaC12JRCAF8dTuOuEPB8SRG4g.uz9i3S1W
 uqsg0Gkg27GP9qwdJBZnNlLMQ1Txp1SNxV75Fq3E.mrj_O9aLeaJnc6AVP0oCZDgLgis3KdzGt1Y
 LI9ov5BhlmBTG0NCXm81Kp7k4nuH0RjnYTCIIfxSexHjKwKEhI2X.w2KCeO5n9wVOS4tA.LSG_R4
 deQyUwDFnRtWo02_XaUbtKtMnisPdcacGH07v1msyX2tUK5M9xTJucxKL9AdCGbRMUr5BrCmBszt
 Vr3GgNaHJwyPfP54LGa9r84hxwkQ.bW9Vnhz3mC9NISOggtogOrXjP2Xl4wk12jWZvM3Ivybc98n
 9Y_78t3RU4LLaGheyTmNcitdjUNl.RQ6K0tDf8I4dBiGiSLOICYvEXAO9E.nQGrNfxfFOuOWzFHL
 dU7S9Vj1vViIQ4clbeqdXxkU2r9b_eRRQOhJAFtWfZk7l5zA2CkJs5JJjE5skqA_XFOgAfLONkbS
 Nw_GRVND52TDRb2yvIKXjNHxodK2Bte915rwiToXm5vK4iRjdGFdapuahUmwMj.2i_Rl576LOR8I
 s3FZzRA_FsPHXGwQYd0Ek4k7B91MAHOkVHZPnKhtNOLhl0opFXUuehVBmVF.DN0_1Gr2FpJ9xEV9
 B2Gm1F59x70ZNzN70upvUGAFxaEVWG_jfTsBnyfiHZSSalmojsw35ZNVb6kMFTNnjr9o6MpcvNYn
 Dkb18snhRfWUnxEZdgLM7oJmqcvKN1cyPQAyL6_IcBZM5lwzine7bJ99gEKsfoH7Hz.mdRa6.kOI
 x6VbQS1FAid.OaTv89Od169BlBtZfDS3f328HL0PA3HhP8XJDrOtViOpiCLrXl3RXxbU2WRkwaQK
 sXCuSbKBZR90f_AQgjjDPlMbb7nWuomZ65Q3TTIWBid9NiVYpvVGKugnbL6lSd0Bx1dy.wRuCs5M
 soA5O_GNb5iDxYvWauCjCRCvZaD6XnYRtPOZNbznqks7XQStulOv4rG7BraPYmYi417rlh1UTPGB
 cFA2y0DIyTnnZUXP78FuwzEYVuyRU4uSdivkB6q2Le4oOboblXiKgx.EjMr3tjAoS2jFOFDE4.BG
 kodCK_.XJlOmswrexW5cZvmAUfmL6UjR4axVC9OMdyx0m0GcVdXxw_4easBWPzN4s_VVV8zOlBj9
 SVoY3BQ8t_UV4VaSKU1NFymJcQxy9R5PVfrgEiwBF5l_PjH0DYQJuw6.NaZHRAbfhHG18J6Y8TTD
 XjkWb5C9ol69N.I8003Do7KauWv4Zqo.OE1zbIDdIlWSnYfW6bxAkzXqjAiCQ3RitSdxDeDG10eO
 Gikdbh.K396qq.hJweDK9zpMTizKiYY3pAYabIjw6YJRd4wzaYSf78tF_Pn1vraNRY2.idOJ413L
 xa4bv1..PBYw.Dc1fjnZcn90HIW7No1l8nwHNoQI_pQzYVNLXJ1SjiGOBUAzxd.uPWZjYr0ojFbg
 SNuor3PSDccDcWDrc2Gd7eQpBYgN_mJ.ImmowAkMTmVnneTpMra6oPImWqZpAm0.FXPGmFN1ik3K
 kbcJYOLr7bdBtbyma.bdW5mbCBvqqQqyxRJMFGIvCA4.RjZkXyZxl6hGhpqn7nI9ZdqrAPqfzNLm
 X04wnSNDW0B4znuI8bLvobhzUxNNntsvqOn6hcNM39etVS8z_VgSKLtButR6Za654wm8FY7LUaOI
 DIH.VrDPn7hHlInc.tDnoDII0LGeExQGIjEv6Z52b1Al269wPv4pPCuUtctVQNRbOcTM8cAZXVFU
 4XZwHQLS1xT5y6QAVKOL_UFHUCLMTa2SdDDCrnpCD8qnxdKjNSyv0ReL3QI2stEDzKct.u.yKPqq
 MIMY-
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.gq1.yahoo.com with HTTP; Wed, 13 Jul 2022 13:49:15 +0000
Received: by hermes--production-bf1-58957fb66f-88chf (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 87132f46a4855ed798a0f1c8397b5495;
          Wed, 13 Jul 2022 13:49:11 +0000 (UTC)
Message-ID: <62e32913-cfcb-e0b0-2bbe-75cc8597951d@netscape.net>
Date:   Wed, 13 Jul 2022 09:49:09 -0400
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
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <1d06203b-97ff-e7eb-28ae-4cdbc7569218@suse.com>
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

On 7/13/2022 9:34 AM, Jan Beulich wrote:
> On 13.07.2022 13:10, Chuck Zmudzinski wrote:
> > On 7/13/2022 6:36 AM, Chuck Zmudzinski wrote:
> >> On 7/13/2022 5:09 AM, Jan Beulich wrote:
> >>> On 13.07.2022 10:51, Chuck Zmudzinski wrote:
> >>>> On 7/13/22 2:18 AM, Jan Beulich wrote:
> >>>>> On 13.07.2022 03:36, Chuck Zmudzinski wrote:
> >>>>>> v2: *Add force_pat_disabled variable to fix "nopat" on Xen PV (Jan Beulich)
> >>>>>>     *Add the necessary code to incorporate the "nopat" fix
> >>>>>>     *void init_cache_modes(void) -> void __init init_cache_modes(void)
> >>>>>>     *Add Jan Beulich as Co-developer (Jan has not signed off yet)
> >>>>>>     *Expand the commit message to include relevant parts of the commit
> >>>>>>      message of Jan Beulich's proposed patch for this problem
> >>>>>>     *Fix 'else if ... {' placement and indentation
> >>>>>>     *Remove indication the backport to stable branches is only back to 5.17.y
> >>>>>>
> >>>>>> I think these changes address all the comments on the original patch
> >>>>>>
> >>>>>> I added Jan Beulich as a Co-developer because Juergen Gross asked me to
> >>>>>> include Jan's idea for fixing "nopat" that was missing from the first
> >>>>>> version of the patch.
> >>>>>
> >>>>> You've sufficiently altered this change to clearly no longer want my
> >>>>> S-o-b; unfortunately in fact I think you broke things:
> >>>>
> >>>> Well, I hope we can come to an agreement so I have
> >>>> your S-o-b. But that would probably require me to remove
> >>>> Juergen's R-b.
> >>>>
> >>>>>> @@ -292,7 +294,7 @@ void init_cache_modes(void)
> >>>>>>  		rdmsrl(MSR_IA32_CR_PAT, pat);
> >>>>>>  	}
> >>>>>>  
> >>>>>> -	if (!pat) {
> >>>>>> +	if (!pat || pat_force_disabled) {
> >>>>>
> >>>>> By checking the new variable here ...
> >>>>>
> >>>>>>  		/*
> >>>>>>  		 * No PAT. Emulate the PAT table that corresponds to the two
> >>>>>>  		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
> >>>>>> @@ -313,6 +315,16 @@ void init_cache_modes(void)
> >>>>>>  		 */
> >>>>>>  		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
> >>>>>>  		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
> >>>>>
> >>>>> ... you put in place a software view which doesn't match hardware. I
> >>>>> continue to think that ...
> >>>>>
> >>>>>> +	} else if (!pat_bp_enabled) {
> >>>>>
> >>>>> ... the variable wants checking here instead (at which point, yes,
> >>>>> this comes quite close to simply being a v2 of my original patch).
> >>>>>
> >>>>> By using !pat_bp_enabled here you actually broaden where the change
> >>>>> would take effect. Iirc Boris had asked to narrow things (besides
> >>>>> voicing opposition to this approach altogether). Even without that
> >>>>> request I wonder whether you aren't going to far with this.
> >>>>>
> >>>>> Jan
> >>>>
> >>>> I thought about checking for the administrator's "nopat"
> >>>> setting where you suggest which would limit the effect
> >>>> of "nopat" to not reporting PAT as enabled to device
> >>>> drivers who query for PAT availability using pat_enabled().
> >>>> The main reason I did not do that is that due to the fact
> >>>> that we cannot write to the PAT MSR, we cannot really
> >>>> disable PAT. But we come closer to respecting the wishes
> >>>> of the administrator by configuring the caching modes as
> >>>> if PAT is actually disabled by the hardware or firmware
> >>>> when in fact it is not.
> >>>>
> >>>> What would you propose logging as a message when
> >>>> we report PAT as disabled via pat_enabled()? The main
> >>>> reason I did not choose to check the new variable in the
> >>>> new 'else if' block is that I could not figure out what to
> >>>> tell the administrator in that case. I think we would have
> >>>> to log something like, "nopat is set, but we cannot disable
> >>>> PAT, doing our best to disable PAT by not reporting PAT
> >>>> as enabled via pat_enabled(), but that does not guarantee
> >>>> that kernel drivers and components cannot use PAT if they
> >>>> query for PAT support using boot_cpu_has(X86_FEATURE_PAT)
> >>>> instead of pat_enabled()." However, I acknowledge WC mappings
> >>>> would still be disabled because arch_can_pci_mmap_wc() will
> >>>> be false if pat_enabled() is false.
> >>>>
> >>>> Perhaps we also need to log something if we keep the
> >>>> check for "nopat" where I placed it. We could say something
> >>>> like: "nopat is set, but we cannot disable hardware/firmware
> >>>> PAT support, so we are emulating as if there is no PAT support
> >>>> which puts in place a software view that does not match
> >>>> hardware."
> >>>>
> >>>> No matter what, because we cannot write to PAT MSR in
> >>>> the Xen PV case, we probably need to log something to
> >>>> explain the problems associated with trying to honor the
> >>>> administrator's request. Also, what log level should it be.
> >>>> Should it be a pr_warn instead of a pr_info?
> >>>
> >>> I'm afraid I'm the wrong one to answer logging questions. As you
> >>> can see from my original patch, I didn't add any new logging (and
> >>> no addition was requested in the comments that I have got). I also
> >>> don't think "nopat" has ever meant "disable PAT", as the feature
> >>> is either there or not. Instead I think it was always seen as
> >>> "disable fiddling with PAT", which by implication means using
> >>> whatever is there (if the feature / MSR itself is available).
> >>
> >> IIRC, I do think I mentioned in the comments on your patch that
> >> it would be preferable to mention in the commit message that
> >> your patch would change the current behavior of "nopat" on
> >> Xen. The question is, how much do we want to change the
> >> current behavior of "nopat" on Xen. I think if we have to change
> >> the current behavior of "nopat" on Xen and if we are going
> >> to propagate that change to all current stable branches all
> >> the way back to 4.9.y,, we better make a lot of noise about
> >> what we are doing here.
> >>
> >> Chuck
> > 
> > And in addition, if we are going to backport this patch to
> > all current stable branches, we better have a really, really,
> > good reason for changing the behavior of "nopat" on Xen.
> > 
> > Does such a reason exist?
>
> Well, the simple reason is: It doesn't work the same way under Xen
> and non-Xen (in turn because, before my patch or whatever equivalent
> work, things don't work properly anyway, PAT-wise). Yet it definitely
> ought to behave the same everywhere, imo.
>
> Jan

IOW, you are saying PAT has been broken on Xen for a
long time, and it is necessary to fix it now not only on
master, but also on all the stable branches.

Why is it necessary to do it on all the stable branches?

The only valid reason I can think of is a zero-day exploit
that can only be mitigated by really disabling PAT on Xen.

Chuck
