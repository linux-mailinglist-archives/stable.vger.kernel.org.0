Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213C6573F93
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 00:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiGMWXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 18:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237388AbiGMWXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 18:23:21 -0400
Received: from sonic315-55.consmr.mail.gq1.yahoo.com (sonic315-55.consmr.mail.gq1.yahoo.com [98.137.65.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE2C4D16E
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 15:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657750996; bh=sW1ejgoubTLnwSxkyhbV7vGRBPUmBbNSxg5+MIbDhoU=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=mGODDA3bNe4GC1bDfrENgyLUL+UWOcwZnVlh5I04dnkev0wlbHWTRzyk4XL4AAUlA2UYTgh9Oggbze+72E0HoGpJ2jHKzxDod7kMhgbLK8gGjAyyY9ewn6+8nwlj7UpJVj51eylBEUyXhDi4WJuxjGX6pQBkT68RLPhbqdeR7p1y81JSIv5fN3Ga9/n/M47VGXIZJSSZPTBGwNiy5aUkIIvVhGY5lznn3Mdhu9vInTcJDv+sunq+4D4RgEW075qOwNBTJNm02KSh3GFx6QCfSmjDW3XyfhNBYnQWSfkr+8SCi0xqbwjae+5xGrMhkNvunTFIY/Qv7SgHpYssO8Z0Dw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657750996; bh=RYvt7qtyrioa0UMf5yztOpqn6jkUS3bTSUzE5enMH8x=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=TI30T7yMzhjU09DzpXew67nijX2TBfP+2ycPeObNwhJz4aoslvm9K1wduvC06cc8abp2qle2/eTh7uj3nwoPGcGpchFgP89Fo/fUhHZlcquEn8gZWB9P5/u7LVL3bmXKmGO1x6kCmBelmwvOSfTBiOs/5fZl7d0ezDyOpIowi6NZ6TySlbGvNmZYrqTzIdOMZbjz7JFJiklHQ/gFO1+E2RpXVmIplk+LJ4/N8R5I38upm74IiCLMq+9MJTUs3FYHCIHqoyVkgCOU5Hh+zrojQfWltN1Jh68lrPQ0tn6hyeIPmQTnK+YdFc5abLrBENStWCFLDmm7MvriK3KKRAthFw==
X-YMail-OSG: KNOgYQUVM1n2RjKzOe7Hc1pLGEFWIMp2pM7hEiX_E99y_3H6Q3_Ny4uz32kSH3G
 hYHDfrTumNu5krn0d0Fh_rjTsebyvOa5fOEpnbkAPejPwkFsB3rohEztZkkWAQxvoQf0ibTuahVX
 wR.uBdlZ8IfjYvVTW0aiKuxsaKpdv1D8lzq6aGwdDnptnoZI.zR2E8YH8EM7gR8NoSkPQpfCmLEr
 Kj3Smc0LGf1Z2kvMvmwvZqRhjDXffBnSNS8C2y.NG23SFURkzRD0HYiBr56lFTWZ_NmLFx8E7SdQ
 ySbVZ4LbZIqVkOVG.GTSwlQ9VYw.is3yUSF7Fw4DDL8dI8FmpDv01u5pMlaydiDhbaWdtX45_19i
 UGY5IIilrxpsUpe6GvtnY7u5AWHz.WJK.NpwQQ7lbn9PsXhWKutB0FhxiOPGS58VYlVdjnF2iQKt
 FIwxlfA7_wSlJygBEkNwFBWbaMZd0.lYDaTvsJq4pIVpTRWjmXgQZ0.HghbAEI_BZ4fl6_gz1hCU
 e1nL0oakYqiBXNJ5.7c5uJGE6x4EYPUSxFlRibYeYeaDXEKM59CpdrjPnFIgyeHpnrpqT.wIdbGm
 yHjCehGxTg8pEhjIOYm9cbUK1BO1LSCTvoTd68GDRyj.J9AxpeG2O3kB1.RSErrUp0fprpBfaROG
 xy2ymm3JSDCYx.OADcmexujp0.0YJdfPHoA0np9lxJGq9CBYUO7ZwJAB6w.K87.IYm92r2EyM51X
 bWqUUYcQMEJUqPot0Ov1_QvpTS62TkKYcQiTd3FpeHvntA29dHaFaFNWZ.VBltsp2oYa7fLNy4u7
 7Wy6Bh4dfCk68.6sgk2CdbdrPjx7A1ip1TYh_YAJi8fpAqlfyqs0Lc.yVJKY1XVbaRV2r3TSr2sw
 UCW50eiryck0O2ER3fxnFfLAOA8QntgCPtF0H1xKBi2zfcxvP2EwO07MDQu_NVEOf.sfJD5mTnl0
 e2z1qDEVa_y7QHhtKNiR4k1qqtp7nYVjM1W9OjQNakwDHyuMrrFvpHVsK9kbnp6O07f7BypUcj8K
 ZVNmnUXjHnxvbrZzsqTVom8NkTfGFuuk5KtlcWbD05IdLRUgNvZH1vJ8Ead4_ofdL.nyOs6bvW.M
 tQuOv_Ot7OW7qQqHjt4chTGW3NIT3fqtu02Nio7WE6bDrLwawBVerJQpq17UXYKWk0aGgJ8sLpU5
 .3wucbPo2gePrjqggTm81q4fKD5OJGqyQPIdcLu2vY.TUcbdiMZr5DtnchB8wKvHOMWu25z2qMCm
 uy49ap2TTcGi0S5_T3QRVcMAZQBoMGFTwfKhpFBDE2V8NvUDyvkycoWAJaEvHctTPWUxrb5_6fI4
 B6KIZeVrDz5kEFE_wCNEGar3h4O_FoaI42F1BKx3EdDR34QbniohkM2rqIScVTtX2zDTys1eRpJT
 4py_LSSkkDHeigxNszvcAXMeoc90swpjvK6xBt7J.2TQefFDZjU36bP5X.lanG2zRwNq4oL9U4y2
 q4kl8gnn11lep29qjae6PKS8HZDDTWSgtRTAHKnwQjqne8EKS_QK618jEFMft5Yqa_uLxHnhTT0J
 5Qfeh4gYDIfaY2ryfL3pct5LMe2JX7lm_RjQEuW73gcrRutrkDgjHImYB5PXOBklK2.vLCak88xW
 i_DmMR74KfbrfSJGB1oQTsmjPQ.L5RPCuTZf_WMbaCJLEZsF8yAUDer7XsaeMm7K5yKhodluLlYm
 8JGP_n47da4ZP8zGW6fSoOmgR.XtM4P_uK1QIP3wkgbGb23.3R_l.WVAMStNpP3mQam8PAwfMEnF
 pXUE4uSqhezLU4uFO_eMmy4HAQI_zuPitQnShyssJ25uqEJNBQWLi_NwbyrDSIUsktJ9qpHtff1b
 stGhWoejsiviIhPk6.RhqTlDkwIG5fUzC4L7H7XMYoXzjV5HUg90VcXFXXPzUBm3OXfaeTd9CXfw
 d4fY9UDl0Qof1Go6qBuOW1yvJ0AXTyfz4HONjwm_lrghkEiWYj8awLvg-
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.gq1.yahoo.com with HTTP; Wed, 13 Jul 2022 22:23:16 +0000
Received: by hermes--production-bf1-58957fb66f-88chf (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 89c21ab9e0ecbc439802f7109841f4ef;
          Wed, 13 Jul 2022 22:12:39 +0000 (UTC)
Message-ID: <ad32874c-9d82-6e8e-d069-615191f9591b@netscape.net>
Date:   Wed, 13 Jul 2022 18:12:36 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, Jan Beulich <jbeulich@suse.com>
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
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <e0faeb99-6c32-a836-3f6b-269318a6b5a6@suse.com>
 <3d3f0766-2e06-428b-65bb-5d9f778a2baf@netscape.net>
 <e15c0030-3270-f524-17e4-c482e971eb88@suse.com>
 <775493aa-618c-676f-8aa4-d1667cf2ca78@netscape.net>
 <c2ead659-d0aa-5b1f-0079-ce7c02970b35@netscape.net>
 <1d06203b-97ff-e7eb-28ae-4cdbc7569218@suse.com>
 <a8d0763f-7757-38ec-f9c1-5be6629ee6b2@suse.com>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <a8d0763f-7757-38ec-f9c1-5be6629ee6b2@suse.com>
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

On 7/13/2022 9:45 AM, Juergen Gross wrote:
> On 13.07.22 15:34, Jan Beulich wrote:
> > On 13.07.2022 13:10, Chuck Zmudzinski wrote:
> >> On 7/13/2022 6:36 AM, Chuck Zmudzinski wrote:
> >>> On 7/13/2022 5:09 AM, Jan Beulich wrote:
> >>>> On 13.07.2022 10:51, Chuck Zmudzinski wrote:
> >>>>> On 7/13/22 2:18 AM, Jan Beulich wrote:
> >>>>>> On 13.07.2022 03:36, Chuck Zmudzinski wrote:
> >>>>>>> v2: *Add force_pat_disabled variable to fix "nopat" on Xen PV (Jan Beulich)
> >>>>>>>      *Add the necessary code to incorporate the "nopat" fix
> >>>>>>>      *void init_cache_modes(void) -> void __init init_cache_modes(void)
> >>>>>>>      *Add Jan Beulich as Co-developer (Jan has not signed off yet)
> >>>>>>>      *Expand the commit message to include relevant parts of the commit
> >>>>>>>       message of Jan Beulich's proposed patch for this problem
> >>>>>>>      *Fix 'else if ... {' placement and indentation
> >>>>>>>      *Remove indication the backport to stable branches is only back to 5.17.y
> >>>>>>>
> >>>>>>> I think these changes address all the comments on the original patch
> >>>>>>>
> >>>>>>> I added Jan Beulich as a Co-developer because Juergen Gross asked me to
> >>>>>>> include Jan's idea for fixing "nopat" that was missing from the first
> >>>>>>> version of the patch.
> >>>>>>
> >>>>>> You've sufficiently altered this change to clearly no longer want my
> >>>>>> S-o-b; unfortunately in fact I think you broke things:
> >>>>>
> >>>>> Well, I hope we can come to an agreement so I have
> >>>>> your S-o-b. But that would probably require me to remove
> >>>>> Juergen's R-b.
> >>>>>
> >>>>>>> @@ -292,7 +294,7 @@ void init_cache_modes(void)
> >>>>>>>   		rdmsrl(MSR_IA32_CR_PAT, pat);
> >>>>>>>   	}
> >>>>>>>   
> >>>>>>> -	if (!pat) {
> >>>>>>> +	if (!pat || pat_force_disabled) {
> >>>>>>
> >>>>>> By checking the new variable here ...
> >>>>>>
> >>>>>>>   		/*
> >>>>>>>   		 * No PAT. Emulate the PAT table that corresponds to the two
> >>>>>>>   		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
> >>>>>>> @@ -313,6 +315,16 @@ void init_cache_modes(void)
> >>>>>>>   		 */
> >>>>>>>   		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
> >>>>>>>   		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
> >>>>>>
> >>>>>> ... you put in place a software view which doesn't match hardware. I
> >>>>>> continue to think that ...
> >>>>>>
> >>>>>>> +	} else if (!pat_bp_enabled) {
> >>>>>>
> >>>>>> ... the variable wants checking here instead (at which point, yes,
> >>>>>> this comes quite close to simply being a v2 of my original patch).
> >>>>>>
> >>>>>> By using !pat_bp_enabled here you actually broaden where the change
> >>>>>> would take effect. Iirc Boris had asked to narrow things (besides
> >>>>>> voicing opposition to this approach altogether). Even without that
> >>>>>> request I wonder whether you aren't going to far with this.
> >>>>>>
> >>>>>> Jan
> >>>>>
> >>>>> I thought about checking for the administrator's "nopat"
> >>>>> setting where you suggest which would limit the effect
> >>>>> of "nopat" to not reporting PAT as enabled to device
> >>>>> drivers who query for PAT availability using pat_enabled().
> >>>>> The main reason I did not do that is that due to the fact
> >>>>> that we cannot write to the PAT MSR, we cannot really
> >>>>> disable PAT. But we come closer to respecting the wishes
> >>>>> of the administrator by configuring the caching modes as
> >>>>> if PAT is actually disabled by the hardware or firmware
> >>>>> when in fact it is not.
> >>>>>
> >>>>> What would you propose logging as a message when
> >>>>> we report PAT as disabled via pat_enabled()? The main
> >>>>> reason I did not choose to check the new variable in the
> >>>>> new 'else if' block is that I could not figure out what to
> >>>>> tell the administrator in that case. I think we would have
> >>>>> to log something like, "nopat is set, but we cannot disable
> >>>>> PAT, doing our best to disable PAT by not reporting PAT
> >>>>> as enabled via pat_enabled(), but that does not guarantee
> >>>>> that kernel drivers and components cannot use PAT if they
> >>>>> query for PAT support using boot_cpu_has(X86_FEATURE_PAT)
> >>>>> instead of pat_enabled()." However, I acknowledge WC mappings
> >>>>> would still be disabled because arch_can_pci_mmap_wc() will
> >>>>> be false if pat_enabled() is false.
> >>>>>
> >>>>> Perhaps we also need to log something if we keep the
> >>>>> check for "nopat" where I placed it. We could say something
> >>>>> like: "nopat is set, but we cannot disable hardware/firmware
> >>>>> PAT support, so we are emulating as if there is no PAT support
> >>>>> which puts in place a software view that does not match
> >>>>> hardware."
> >>>>>
> >>>>> No matter what, because we cannot write to PAT MSR in
> >>>>> the Xen PV case, we probably need to log something to
> >>>>> explain the problems associated with trying to honor the
> >>>>> administrator's request. Also, what log level should it be.
> >>>>> Should it be a pr_warn instead of a pr_info?
> >>>>
> >>>> I'm afraid I'm the wrong one to answer logging questions. As you
> >>>> can see from my original patch, I didn't add any new logging (and
> >>>> no addition was requested in the comments that I have got). I also
> >>>> don't think "nopat" has ever meant "disable PAT", as the feature
> >>>> is either there or not. Instead I think it was always seen as
> >>>> "disable fiddling with PAT", which by implication means using
> >>>> whatever is there (if the feature / MSR itself is available).
> >>>
> >>> IIRC, I do think I mentioned in the comments on your patch that
> >>> it would be preferable to mention in the commit message that
> >>> your patch would change the current behavior of "nopat" on
> >>> Xen. The question is, how much do we want to change the
> >>> current behavior of "nopat" on Xen. I think if we have to change
> >>> the current behavior of "nopat" on Xen and if we are going
> >>> to propagate that change to all current stable branches all
> >>> the way back to 4.9.y,, we better make a lot of noise about
> >>> what we are doing here.
> >>>
> >>> Chuck
> >>
> >> And in addition, if we are going to backport this patch to
> >> all current stable branches, we better have a really, really,
> >> good reason for changing the behavior of "nopat" on Xen.
> >>
> >> Does such a reason exist?
> > 
> > Well, the simple reason is: It doesn't work the same way under Xen
> > and non-Xen (in turn because, before my patch or whatever equivalent
> > work, things don't work properly anyway, PAT-wise). Yet it definitely
> > ought to behave the same everywhere, imo.
>
> There is Documentation/x86/pat.rst which rather clearly states, how
> "nopat" is meant to work. It should not change the contents of the
> PAT MSR and keep it just as it was set at boot time (the doc talks
> about the "BIOS" setting of the MSR, and I guess in the Xen case
> the hypervisor is kind of acting as the BIOS).

If that is the true meaning of "nopat", then the pat_enabled() test we
currently have in the i915 driver is the wrong test for the capability
of the
CPU to use the fast WC type pages for video frames access because it is
possible for pat_enabled() to be false and "nopat" set with its official
meaning, and still have a CPU with WC cache mode capability.

If we accept pat_enabled() as implied WC cache mode support, why not also
accept (!pat_enabled && boot_cpu_has(X86_FEATURE_HYPERVISOR)) also
as implied WC cache mode support? That is what Jan's patch effectively does.
He just possibly places his patch in the wrong portion of the Linux tree
to be consistent with the official meaning of "nopat" and pat_enabled().

We could implement Jan's fix instead in the i915 driver instead if we need
to be consistent with the official meaning of "nopat" and pat_enabled().

I could make that a v3 of my patch - and try the i915 maintainers instead of
the x86 maintainers to provide the fix. But before I do that, can someone
on this list of 20 recipients tell me why none of you have fixed this nasty
regression? I am new to trying to contribute to Linux and the whole
experience is frustrating when all you get is stonewalling from the official
maintainers. So why not just someone step up and do this fix?

In the meantime, Juergen can start working on cleaning up the x86/PAT
code so it can provide the i915 driver with a test not for PAT, but for the
WC page caching mode support that works in all supported environments,
including Xen. Currently there is no such test available. Juergen proposed
one but it failed to accurately test for WC cache mode capability on my
Xen workstation. Until the x86 subsystem developers can provide the rest
of Linux with an accurate test for the WC caching mode, we have to
settle for
less than a pure and perfect solution if we are serious about following
Linus' regression rule and accept a quick fix to a nasty regression while
we wait for a better solution that will hopefully come later.

Chuck
