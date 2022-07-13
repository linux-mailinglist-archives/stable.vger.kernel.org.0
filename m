Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9585734F9
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 13:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbiGMLKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 07:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235028AbiGMLKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 07:10:48 -0400
Received: from sonic316-8.consmr.mail.gq1.yahoo.com (sonic316-8.consmr.mail.gq1.yahoo.com [98.137.69.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68514EDB70
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 04:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657710646; bh=TlDx9+/0Iba5/WcaUGXAstvmAgLHzxw7AUpcCHFdh6w=; h=Date:Subject:From:To:Cc:References:In-Reply-To:From:Subject:Reply-To; b=crgIlXcuAdJ1/pl0GYJacy0NIkgAkWAoCtagJ1DwJGqgDa7iY4mztTJwZNuQm9so2EUiSHP/Kwk1MkcGEq6TfrhSEmLfMOgMBDS1t81fRUzy/Bqjd0amQEmPfwhShxwm4+mmXGZxmK0yygmUmTK6Hyed8bUaN0kow3ztL85rqCcgYRhnLo4dPK1FpOu1AP/zoHbuV64b08lj3v1UzNEmfNfS1zEW3V09srgqFwfkJy2sedPccketNK6e/2ysFulJ1F3xLRUznQHWZ7XLaywfYQamAfoVjdaR6UHQPl9Gi1ULyLMN6+l0wgnTV8kkmftr+Uus0FID5zGou5YDoaavSw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657710646; bh=+Z/nMLz7K0U7xHXBrCjQgbdLS2XQac5YLav2vbaoCA/=; h=X-Sonic-MF:Date:Subject:From:To:From:Subject; b=LgYPTSesXtUUGlCFmR4smQD9GCg+cBLkEQjbKeZLBgrvWzcoobk8uAijtfofoLRSht5ZOeTZTBnv1mtq0Lv1a8rhEhHlwkuIYfZLTnZTyh/MGhJx6OAqkIGg8rY8siUlu8WUtmsJJVbQ/v+n5M7O+PKStz6omTtDmd8hYXNzmXViJflqsbkXvbYBVwUF1g5vooS+Q9fEgM2cnex93Srb3jy0x5boh8t37haAdVbBtbX6rYaOxENLPbel7eNCmvC4W+tE5sc7IBiMb+L7zpAQx6k8S/8kes92FwneIfMJQb8AiHuELVBfeUYOM7ILLuvE5VROSqQ/XcgsDApdN5dziQ==
X-YMail-OSG: YKABTcAVM1ndxzDKVm1ZW23kpVYI0hp7.vRJng3VaX8dn3DoH7gsBk1Qsx1G_Pa
 gUqboNLOnZIxv6fDnpV6BUc8_vTO.yUJw4zPcYIXK84gSo8OBdXxsMCD6UjAmqf0dN1U0MCeTELt
 3h6GAgMLYnjH_VVtMwPEmHfD3L3zn9xMkrnjBCxLEeTzpqPCiorcCjnIoWsYnBoIgv18exvo.aS4
 Lyeou8sHq8DsPIaaG3YcTYZMfS_z2siyfDwV6OQPKk8HnMtdAdO.x9nOZXawSO1vlasrELk..W4.
 gtG81qIHJUvDoSv_N7RvfilVeKle5UvALDwWnC8MxYy0sTsGy4ftNyfrpIH0.YLC7RweJTcu1Y.4
 yJHqOersPl_E4B2bJujPp9u7e4yEZnul9_VOjV0EdQZHQEk0hdiqx399oKX7XcUgRqJd5IousN5S
 8.6ztR0AqZTOY3XW0NaRCv7zVqubGUyvMKN504lUe.SpdzijtsF2eS0udw8q2QFX9cT3hwruXGJO
 3pJsIVbKQyY6h.XpPffiP_7kAXhWeI_bIEkTTFb1NT97N1Dz2Z9aGG9trSkTnHYrmhBJaMssgTjj
 EI233U8qBvr3XuZ21PH.gqycVRZ9KUXbOOsAVIqhYsfoIhmGF8INLiSpi_khFfifFOiU7fSzSjSx
 U1FqNJNyCqTmjqRmGDJz8l1IA9NR9hBzjp.LqcCZ.PuwJMzPXWnsq.b4hbCznuRT8YbiXW89Fs7b
 xW5oiAosDi0dIvj1pMHbhihcGHaaaoL5TPBqJlronJ2KCvMIrrb_U2xKIaOSjQZv0jVNT.9A6ECn
 OeqxSxJE616vyLONfs1YkQlAxsxl_UnzcRIJL4RNA5nDhP4Z4v.Nt5YHO.P6U193dKyYhC7yZ1JX
 S7OAYRJ5NQeqsCslBrrdHlf_5pQPYoLc7BKj_r7Z9VAnZOo58S0XIZPIQGomNmNhODLup7uyJfAq
 vhVuO9X.4GOZpFuZ85Ik.3WqlstQrTQNkkBKgWCQLDXFO59x18Kgr0Frk13U3NjEIb5KYRvcRndm
 Q.hTefgUNtyFP9RKpIo1w08JDGeEJd1ThfMjbvXs4fKZpA1yNfM.OVNesuPbCFwkVXM5EhHx7iy2
 8hdIBFQ.k0BPbcmHYyGUmHqVUQBB.eZ3aakXlB0piy27sa2FEnY8P0yMBOczqBr5Tgcwxzm7pgiF
 sF7GRiZp0ZPXMZFj2xE_bWR4UhP2w36CWzefVxiAFt2Bl2KVi7.HJMr.2xRkl0K3upDtYh7h5R3g
 qBHjCenX4Rz5gHIOKxKb1Cv9uYpJ5GsVcDixqmmqjFDRwoc20im9wQZNbt2q1ud3IF8I76zbBguO
 mg_AnDC6R03xuSSoXjkenwrwcT.ti71QAi6t5wwK4kaCA9sliFSfixEuC21IFYZNut6E17jajWp9
 QkkxTYEcfi1hcKaSLLcotFVyTmGqyW6SMkqYPDIpBjPNVtwB.KdlgsxsCprbCZhWjgucHmM6SKFc
 sDcyo770iMPVyPXYYUSDuAS4b48wdQx0j2jSG9ogHRmWUUvd5WWkhV30m.4Ikpwt_TCLdbfn.M7K
 q3ENN3rIAeH4mjJc7ugpOfHlWTHY4_ITnQYsYn86ZYe3P573oJMmVMFVC5MrcsK86Syt0OLJPUxk
 W47YuXy85XGAUd7MhZ.SidSQYX4NFXT_yzC.HeQbaMH01IaJXe2bvqF0pL8TlCvRm2GjoQ8wjZ0J
 Nb3jpIMPBjGbCtH_X8CiFDrb.tcsFWXkudn4tJNXpE.SZTYdU8cuSPRz2H7Q0xBvZe_9mZxNWSPZ
 LPMNV.01BKyxtRNEm13yjvHrHA_4pFZcbFdtr_CpXuvB_muAJWP3wmZHGENkeKB8N1gfDjBGVf.j
 xjtfkdm3DYn4xE1jvHT7WXqNVZfnrxI713ajEbfa5RcpuSahGYTeVQBM3sML4piEJkx_OAr6naAD
 1D1mV1AAR7VM7mSRcyMv5K2FvXDA9lK5X0Ey5D4XkXFGe5fv.zpXLOrgRaOFlinzKeVJqghUa9md
 d9jOK1LfvsEQQODc4dYlJqmLfrzlyMcDN..UmB0KsViNluWX14Un0m4X_OSSzAaAMiyCJuEcENZU
 1xW0C6Yb71.6VoJqgHpX5mMUmFk8mIHqk3khsvZzEgamy25P8tfS7FqsAqIN7zbG7jEGC8dp73SS
 sJE6AEqE3vbeidCCsEz_a_rCHYYrph4JmQKQ3Ml4QFwtB9PmyKmj8WbToU_GZD4TioLU2xwodsQ_
 umLmlD_owKQ--
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.gq1.yahoo.com with HTTP; Wed, 13 Jul 2022 11:10:46 +0000
Received: by hermes--production-ne1-7864dcfd54-xmlhn (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 4fa3c1912e1ef88022aac278b4afb76f;
          Wed, 13 Jul 2022 11:10:43 +0000 (UTC)
Message-ID: <c2ead659-d0aa-5b1f-0079-ce7c02970b35@netscape.net>
Date:   Wed, 13 Jul 2022 07:10:43 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
Content-Language: en-US
From:   Chuck Zmudzinski <brchuckz@netscape.net>
To:     Jan Beulich <jbeulich@suse.com>, Juergen Gross <jgross@suse.com>
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
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <e0faeb99-6c32-a836-3f6b-269318a6b5a6@suse.com>
 <3d3f0766-2e06-428b-65bb-5d9f778a2baf@netscape.net>
 <e15c0030-3270-f524-17e4-c482e971eb88@suse.com>
 <775493aa-618c-676f-8aa4-d1667cf2ca78@netscape.net>
In-Reply-To: <775493aa-618c-676f-8aa4-d1667cf2ca78@netscape.net>
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

On 7/13/2022 6:36 AM, Chuck Zmudzinski wrote:
> On 7/13/2022 5:09 AM, Jan Beulich wrote:
> > On 13.07.2022 10:51, Chuck Zmudzinski wrote:
> > > On 7/13/22 2:18 AM, Jan Beulich wrote:
> > >> On 13.07.2022 03:36, Chuck Zmudzinski wrote:
> > >>> v2: *Add force_pat_disabled variable to fix "nopat" on Xen PV (Jan Beulich)
> > >>>     *Add the necessary code to incorporate the "nopat" fix
> > >>>     *void init_cache_modes(void) -> void __init init_cache_modes(void)
> > >>>     *Add Jan Beulich as Co-developer (Jan has not signed off yet)
> > >>>     *Expand the commit message to include relevant parts of the commit
> > >>>      message of Jan Beulich's proposed patch for this problem
> > >>>     *Fix 'else if ... {' placement and indentation
> > >>>     *Remove indication the backport to stable branches is only back to 5.17.y
> > >>>
> > >>> I think these changes address all the comments on the original patch
> > >>>
> > >>> I added Jan Beulich as a Co-developer because Juergen Gross asked me to
> > >>> include Jan's idea for fixing "nopat" that was missing from the first
> > >>> version of the patch.
> > >>
> > >> You've sufficiently altered this change to clearly no longer want my
> > >> S-o-b; unfortunately in fact I think you broke things:
> > > 
> > > Well, I hope we can come to an agreement so I have
> > > your S-o-b. But that would probably require me to remove
> > > Juergen's R-b.
> > > 
> > >>> @@ -292,7 +294,7 @@ void init_cache_modes(void)
> > >>>  		rdmsrl(MSR_IA32_CR_PAT, pat);
> > >>>  	}
> > >>>  
> > >>> -	if (!pat) {
> > >>> +	if (!pat || pat_force_disabled) {
> > >>
> > >> By checking the new variable here ...
> > >>
> > >>>  		/*
> > >>>  		 * No PAT. Emulate the PAT table that corresponds to the two
> > >>>  		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
> > >>> @@ -313,6 +315,16 @@ void init_cache_modes(void)
> > >>>  		 */
> > >>>  		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
> > >>>  		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
> > >>
> > >> ... you put in place a software view which doesn't match hardware. I
> > >> continue to think that ...
> > >>
> > >>> +	} else if (!pat_bp_enabled) {
> > >>
> > >> ... the variable wants checking here instead (at which point, yes,
> > >> this comes quite close to simply being a v2 of my original patch).
> > >>
> > >> By using !pat_bp_enabled here you actually broaden where the change
> > >> would take effect. Iirc Boris had asked to narrow things (besides
> > >> voicing opposition to this approach altogether). Even without that
> > >> request I wonder whether you aren't going to far with this.
> > >>
> > >> Jan
> > > 
> > > I thought about checking for the administrator's "nopat"
> > > setting where you suggest which would limit the effect
> > > of "nopat" to not reporting PAT as enabled to device
> > > drivers who query for PAT availability using pat_enabled().
> > > The main reason I did not do that is that due to the fact
> > > that we cannot write to the PAT MSR, we cannot really
> > > disable PAT. But we come closer to respecting the wishes
> > > of the administrator by configuring the caching modes as
> > > if PAT is actually disabled by the hardware or firmware
> > > when in fact it is not.
> > > 
> > > What would you propose logging as a message when
> > > we report PAT as disabled via pat_enabled()? The main
> > > reason I did not choose to check the new variable in the
> > > new 'else if' block is that I could not figure out what to
> > > tell the administrator in that case. I think we would have
> > > to log something like, "nopat is set, but we cannot disable
> > > PAT, doing our best to disable PAT by not reporting PAT
> > > as enabled via pat_enabled(), but that does not guarantee
> > > that kernel drivers and components cannot use PAT if they
> > > query for PAT support using boot_cpu_has(X86_FEATURE_PAT)
> > > instead of pat_enabled()." However, I acknowledge WC mappings
> > > would still be disabled because arch_can_pci_mmap_wc() will
> > > be false if pat_enabled() is false.
> > > 
> > > Perhaps we also need to log something if we keep the
> > > check for "nopat" where I placed it. We could say something
> > > like: "nopat is set, but we cannot disable hardware/firmware
> > > PAT support, so we are emulating as if there is no PAT support
> > > which puts in place a software view that does not match
> > > hardware."
> > > 
> > > No matter what, because we cannot write to PAT MSR in
> > > the Xen PV case, we probably need to log something to
> > > explain the problems associated with trying to honor the
> > > administrator's request. Also, what log level should it be.
> > > Should it be a pr_warn instead of a pr_info?
> >
> > I'm afraid I'm the wrong one to answer logging questions. As you
> > can see from my original patch, I didn't add any new logging (and
> > no addition was requested in the comments that I have got). I also
> > don't think "nopat" has ever meant "disable PAT", as the feature
> > is either there or not. Instead I think it was always seen as
> > "disable fiddling with PAT", which by implication means using
> > whatever is there (if the feature / MSR itself is available).
>
> IIRC, I do think I mentioned in the comments on your patch that
> it would be preferable to mention in the commit message that
> your patch would change the current behavior of "nopat" on
> Xen. The question is, how much do we want to change the
> current behavior of "nopat" on Xen. I think if we have to change
> the current behavior of "nopat" on Xen and if we are going
> to propagate that change to all current stable branches all
> the way back to 4.9.y,, we better make a lot of noise about
> what we are doing here.
>
> Chuck

And in addition, if we are going to backport this patch to
all current stable branches, we better have a really, really,
good reason for changing the behavior of "nopat" on Xen.

Does such a reason exist? Or perhaps, Juergen, could you
accept a v3 of my patch that does not need to decide
how to backport the change to "nopat" to the stable branches
that are affected by the current behavior of "nopat" on Xen?

To do such a v3, I would just have to fix the style problems
with my original patch and not come to an agreement with
Jan about how to deal with the "nopat" problem.

Chuck

Chuck
