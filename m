Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD80573BB2
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 19:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiGMRB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 13:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbiGMRB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 13:01:56 -0400
Received: from sonic314-19.consmr.mail.gq1.yahoo.com (sonic314-19.consmr.mail.gq1.yahoo.com [98.137.69.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A399E24F28
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 10:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657731714; bh=NU1NSviOHW2bermSXqhjQpM9qBZCU0Z3Kd/YzNWxavI=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=aEWKX12vXsYr1pymabk9KossSuVjhxAFI1vZXffSGTInXnLxR8pZs3yGj1+UjschIsqBd/GF51LZ0ZM1iz4kfS142zwK0MuIyZNa56TLqT0TyFOi4uTjNxieUXDe5IIMYjuBrq0PNKycLKJSIDL6j6/vLuRPa+g3wqdsErPh+iVScX9L/YS9OYLkp9hEaH1SZvkpGqqgAUYuyfVbtVgULHSXQiBNaBuxzztKR6BaaelRRl2rK5FD9SCy0gL9DZrNG3xTbk3SPQOPkeSSwaKA1PrO4M9L4r33MZgio7OKEWxaGLKoUqd4idgrgVwN7wyz7cNpx2WEJ+dg+tKfaSEfMg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657731714; bh=Bfz87iYQ9oTnfukf9wdP1ZP5eWZeKuJ1N1Ld/zusYU8=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=gBVnCeZHEb1/LdzivKXS43b72lPO5kzqh6IrgCSEx3EFhqqDuztAtX3bPf2iUT+zp230j34gB5NzajWKxNCK/e58g4oT35zMz9iDJHJ1VfQyRcBOkFXOXyXeWGMzlbCrmKsl+kWCDxKWh+Ya0DAbeilkhpZOe5F/16gjAOZy2PCmhekHaSAA1Jrlml7kdRzaS/gvfOuAqQARMhpEr6ZJbsnBgsvA3e7CdMeqLR2ouRZtoysTrLuQpZQ3yvH5DIWAwG15+CEvofH7l9OXhzGuXrfO6Tm8MFtvNseL+0yKx9zXiCgNmFIzhGsmAq4FBnDx+aLyJmEhwmaJEu+RkLbddA==
X-YMail-OSG: 5KbDXZsVM1km7N4ZHR1DikLmAmfBvGEpUeMMAWSXDPk1CmOq9kjbqdp0GhMqGDY
 pdKxijSWq8DOhHpEeikVZy1aXfwu9dt_1E3B8bCPZVq.hoh06gpkyXXoTH0EVK6Kygl.krk.kkwZ
 XujsjXmjAqQlmlGhBc4ZGyq1M.12VzF.RG6TtMh0fFbSeYb9OHjf7OJ7RFTGM.bNsJ8Fr7AAEj6l
 tnDcFnAqIXB9HBlrtjsw5BCgpjpP4rlrX3nH.IT1ykoARrDrTKkQAO93Zg.eUhChsFYQedJp2D2K
 iOUqx8nis_95jcwsw3gkNySy08HuEiFOmZ7ajGNF3bVQMZv2bpE7khe0.PMJQL2jTb84MbCLTDtC
 kBQmwQ.uGJjlZv.2t6DNxY2Ra4ZYZV0BPM5iwJU438YeNpKHT8GCpPu0OuddRVlo1vdBzENzR60U
 9B9kk0f5ECwmAJQAL8imed6Q.O13IkT_aqbCwGrVKTRMoaZsOAtFsAsJMp.6r1gtX1A359vsPLoI
 8SahK3hemKzgRwGhh4i6OM5V75m6iS8Doe3xOUg8MRyCIpJU14Jx4sD1r2hHe4u5ax_CP5sxNpAa
 w_Qehl8yZpZnoDcYle.Ure.Fo_D5C6yA_foR85QLSlXvQhesrhEnIRTVxflatpfCxuaKztWL3ubW
 h9R_RBsH9Alrlup7pP8Juns17PJ.GZ3XCLPG9jVGticdZyZP77.g48enJ4ZZ4Vfd590jYCoEWMxy
 TW.T9s0nCLobg1n3XOUQX8hLtBTzZccDYg9LeU1BzZf7jVNCxblM3R8M7DwRLNOQ5W_8Gf9fMVL.
 84b8ByZyw_8xeZkCzD6puWDLzfzBFa9nrxDfPIMhNp0fgAY0NHifUjGbPOxXCevLkef7ErRbnoPw
 jVLwGtc0mzn._FloHmLSK4fxS_iLotxCDQV.XvMeT8NmOKmNKV7s70RwXB27uk5i2O6u_Gq9ekmD
 pmWKMTn94_AD1BMiEzJGpL72150uieSAlektdaSM_igKPaq7WOdYWJ4pwyCKbX6LOHZxvyviFwbk
 qVVNgiXGKKqPzqOyoOJuBRhlNcQhNyjTtISpZ7lgEvZYTF3vNbYWL7CkoQcFztXm8HvnDE5.7Wfg
 9B6OgVxuWhci0qodjsgV1CXDQN3j1PeU2.jec5vwgHqRHQkVGLcmGQPPArlTr5YqADTFcxCqG2Ma
 OjvL0s5DWNmH2Oz4Q.tuK9v5cluOepH5cnXTSb39SXuwgeTCgJqI.q8zTdWYlBbcp7NbCW0EUxyt
 HRUCukJqcFVGUsUJTX16jylCZRCDwlHZ_taJ7OEprAs_IFQNr1pzVYVEiI8Ckp7ZLu1Qt0l.WATG
 O30D2Ux9wkK1CwIcfGv3HzNXJN0x8qwmcMDLjXJaTcWkLHFPUXyoWvvWapRLaRv8KNG9TGk1xWkc
 .2XIOg7rKY3HDLk55W8GxnqtXvkeInKI1kisrkHXzcgpExDxK4HKWuoriNAkB3XT.JWY_2GY0e8E
 ut8P_IpX0i0pdpqhhdmy3KJSWnRra2SodwDXmEad9kp7BDeLA00Q_MjQcPEdMR_2CXGcI0l5JD05
 DEZ2iCMoE4Exb9uqXNDRV1Xz2J34Zn08B9n8HegJfFec5ccErfTLjIymGzwEjrKZEb3QZ0_NocLH
 YB3Y_2I.jgRQzibbYvdWk78q0uZWxwVmxURwjWuZP7X2Juy2P2ZIn7G2F5nUVrDW1eIlTMxs5ns.
 8IZbFXn5dCftlRDFHh7PQhv6n_hUzFdhwGvHxE7udQSffyb38MrikufUdNrBCPFy6BWv71d4HUHN
 25FYZgktRvIs58v_7Yvuy6zLDG62TV4vvrVt7TWVp41co7Xfxk6r9LKgN0qDChWdTcbmSeufw95d
 ZrKtWd.haJAaUr61KKhrCxGFk.IjzeL0A6h6hvxvQLoGCoYpU6nyTAb.sgtXHy8kyA1vP373DSJ4
 pUOMovc0diGJMLNp7y4cdhuq6pWwWLYdqDDcqVbEWuWTw.kuen2ybh5p21MtLqKx7KxwnhbtQHsn
 wKnGBlHvm5vHUGaF_FP3L5TD2ArZoHYAtXbOoE3wSBNU9nn5uU4GK1YlfhSn0sWWXs5WeyXgmKk0
 sr5LbjZPDgqzwmXTt_1juBevNbBHiG3bmBDq5hOLHwzmtmvZtfdejZrJeSVEsd7Za22848z8W0pS
 5bUZnuiYY4cD8kuSi8Ur4EY9NSCoZ_9hS4QyvlLf6lCYIkgfWlY3Eb5MGbTE0rllo8GaqEiJg2Qf
 v6w--
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.gq1.yahoo.com with HTTP; Wed, 13 Jul 2022 17:01:54 +0000
Received: by hermes--production-bf1-58957fb66f-h8ftj (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 70b07e2b31dd12d124cfd72e82275b60;
          Wed, 13 Jul 2022 17:01:48 +0000 (UTC)
Message-ID: <3b903a7b-0405-84d4-5a3a-822e2ef51b2e@netscape.net>
Date:   Wed, 13 Jul 2022 13:01:47 -0400
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
>
> The question is, whether "nopat" needs to be translated to
> pat_enabled() returning "false". I've found exactly one case where
> "nopat" seems to be required for a driver to work correctly, but
> this driver (drivers/media/pci/ivtv/ivtvfb.c) seems to rely on
> MTRR availability, which isn't supported in Xen PV guests.
>
> Other than that the "nopat" option seems to be a chicken bit from
> the early days of PAT usage, which probably isn't really needed any
> more. So I wouldn't be worried to drop "nopat" having any effect
> on the system in Xen PV guests.
>
> On bare metal it should still work, of course, if only for said
> driver.
>
> >> Or perhaps, Juergen, could you
> >> accept a v3 of my patch that does not need to decide
> >> how to backport the change to "nopat" to the stable branches
> >> that are affected by the current behavior of "nopat" on Xen?
>
> Note that it is not me to accept such a patch, this would be one
> of the x86 maintainers (e.g. Boris).
>
>
> Juergen

Thanks, I think you have given me enough information to try a
v3 without a fix for "nopat" that you might be willing to give
your Reviewed-by to.

Unfortunately, I am not optimistic about coming to an agreement
with Jan. I do not want to sign-off on a patch that makes the
kind of changes to how "nopat" behaves with the attitude, "I'm not the
one to ask about logging." We have to give the administrator accurate
information about what we are doing with useful logs, and I
cannot sign-off on Jan's approach without giving the administrator
a sensible and honest message about what effects, or lack of effects,
the "nopat" option will have with his approach. Perhaps Jan will change
his mind and sign-off with me on a v3 that will explain with a log
message the limitations of the "nopat" option using his approach.

I am just against not being open about any issues that are present
in what we always call "open source software."

Chuck
