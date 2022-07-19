Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D29557A057
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 16:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbiGSOEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 10:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbiGSOEX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 10:04:23 -0400
Received: from sonic307-54.consmr.mail.gq1.yahoo.com (sonic307-54.consmr.mail.gq1.yahoo.com [98.137.64.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787A396B0C
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 06:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1658236600; bh=i+MHmC3f3nRIa71TZ5V0lJfoBtcQ3Szmjn8VPRGZXig=; h=Date:Subject:From:To:Cc:References:In-Reply-To:From:Subject:Reply-To; b=PhWZ53ZTCllywnY+bGq0JlI3RLYHN0ZT1uacDe2L7F0rbnShp3mHCGZP9YkrXkDpmzCSlcvcCMXiPUJZOgeJuGNZ2hjQXMSaKht5YfahbgXhncWgDPxjEPdeBgETpSg2fzoKFTPEN4YIyu6Klt+nU4WIO1dpwtUSSrZ9qGQ+dAibun//+9W7rG1UM1yDc8HbJ+qen+Lw+4XJxxoV1gHD2eV1sZ+R4Y/N/6MwZ0DvtLbb6w5f4DZfcZzrFxIYIex0VYJJARh1HBTHIuxYC6IWzdZ1r1A78w/de+3p0tSSx4x6eyCbwy2md4yjxwpWUUeNTLISqCiqA/NJveZ8mJqQZA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1658236600; bh=ZwKFe3NDbpGlvjCIECpC3Bpp0uLTj2n6XiB4+GzCk2F=; h=X-Sonic-MF:Date:Subject:From:To:From:Subject; b=AwG8XX1e6kdTM2RygujQzsKa2StldLZff6uUm4NC0VyNfPIw0XtzKBlZVpBg4vGAxXQsUCGLNuyTV+S69B0ZkWndf6+hghQIcdYP/jGqSs7WMUs8Se6NPnxMwR76UMaTQVWTJTpS0kIxfO8lnAbn/+pCTwIgnUVN+GkzG2r12CpqR3FmtRyrqBCzKA8g29mAvXPOJPEjHYsAYVXyo2JW+SikAFpBXIS0iXmTBQBICDvENxkCmBtcxCyfKDRvMsIYKJLqOGDuz8I82EJTw3K7whZ3xaML0u88FFYT7uWndfJwyS7LEolKe1TsMIEY+S8E+u4EqdDmJsDR1eVRZkPoow==
X-YMail-OSG: idGw8U4VM1niBTlOcwHK07XhbPiQyi2sNeAnUxpcgKMxFFgZwZJYqEr3JochjSn
 hRikbd48hubP3r5AzQy7TYEX2ZrK79Jj83hzVIEkykqFFOokkAHuAhg_LTPE3FDoEz430_ePwVM0
 OsgrNhZ1vFeyus4S3VPxrVsyvMWv2UhDQJQYSBG8uUJRiFQCaHbknpX0bLXhxjYEo1iVQFj3UgTF
 jyMQtETf45nryFUUkhMuKETJ6pPLqXo9TmRu6rSKghOL4Flg7MErYW6WevwtN_3izKNhv6FGEHPG
 U0iqC_fwVSUk8aaGghfVZR2lBTeoeHL_PKefNGLMivM99jweL1GiiRtAkTPae9tqlACNv4am8i82
 iCvchdvB0quGk6ks9xS7C6Le7bRSD9MK.tHv69w6qsBNJCQuHzNKAVh.qodQYAZDH_Je.xG5sVmG
 DUoL.VOlBlQF2275FhitN9QnKIIQpvFLgK1Q.ZlgIGoj45Z1T_qI.vC94F6hFrWuPL6elz7JbBqK
 .BwbaMl8CeZkgtnX67T85_cB9aKoO9GdERn2WrrdAmf1e2dB178ZsTc3U0jQ3VMzADW.WQH0QWqd
 lLTkGDYpI5eJlZIQCg9W4mFJ5AZoZTrJOyPgJ3mLakhqsAKR64RSkJrqkhjFhfJttcuTDOucBoTz
 cV42iSMP4bSY.n5WaOCeO0layGsJmgA4_YKMeZUYCTfoV92pYARCcwm.32o0V_MxuFOBKzop6rRZ
 sOyy.578hrtxADgo_MGc5rhqt3vcQJOTzotB9V3e.ldXrx6dkI.ocRj8eNYZJEmxieE5p.0ijDlc
 bNCNSqqapVvWZjHpOmNUVQSiWA8JG7tEvKdMZ3yU4.DepJoxgoIoZJDlMvNvyo6Twzr.o.ZEkkzH
 zRZMiCNIFZXTptBzEOtQq4.Br_dRIWyijvLhhGf1_2D_tXWYDQbRYitaKO7C42VIy27Ga.v6hUht
 tWnZaJVxNyNONSAmNAt8t33z7Z.lkjj.eQsXAoWGiGzCg7O2lpRT1DqdskzfSeKH7oUEEr_NVOOA
 TMNIzoGETM3O0H0thXCU7aRFo5ssZ6jQpXhkf_Uo7j1bdx_CILNPneqkIFKcwUihbGrxvNDW2Otq
 zrVARYNrtGpMNjHlathA7RJOJSeZWAcO9c9i3n7vQd0mv1DOzpeHBhQ786sEtpc.tByw1U9Px1Gr
 7DcbAPfXnVA5fOddpdV9JmctZnRIM_2_LBWUbLaz_j2ftEY44y3PjwQvsELIGa11i1U1O1k_loIc
 whn.1xPQSDNGNmgA.adcNGVt5CakQGFYcNr4ZVrgRBeP.Yv0deXBXDseUduByPu65JP9ES3TkpbD
 O2nEBDIEvKNNWkHs.d40g6hRIlPh3_FfiizQlpMl12W.BKAil2v3qJP65wDNZKPKZ2ZQ6omCALyt
 NtyFuC.SyuhCJY6cF_t_I79GtpUmSlM2GNLuoY0xo4R6caC4CYO5LimcwNESFGmmcvvzUyIqUmm5
 CMIoxjWs7gs5rtX8J5Mz2MRlMWyIGDflFYBXGHJZv.ibn.8VGXIF1H_h1HnQNoQpK1PtI1SKJekI
 Trcwky8SIft7Lsj.GSexwiG.qJrChCnb.ItU1MdFio3VHRIv2UFDIurjctQz1r.EJ8tk3d_9Xy53
 ERon6OqshmOiQjLBSy_BUherSuotY49.ep4ZoVSB_zB2kYpPkv936g3hs_8dMyxOYoLKD.UaotwU
 SwbIIGnGfnXaGnPI9gfKqzRNIo7KlZg.oaZpjwYTyuZAFIAWKJm6dhCBrYzWJ0SbNPNeQO28IbWU
 f.60f7uxIx23V6kkX7VDQVj9MtBeMkhHBD4Tnd_oPmX0WuuMCtq9D179prWGZfkHcQOkrBPd1ULF
 9XvZxJjwZFTt7Pq_kWmroFMnV50vQ15Jx6yk1.Mukkg8kcEJdRq8JikSUTE2vXJ8wc.lhijLkb_L
 JA.RjuVr4pyrzm.B6.DKQgVJmUBrH9AT6tZX20nALWqXkAw2MVhfqzLaAWyhfjSYPwoWwlNpQIFH
 VUb42Ke5l5DrN91uYVrlLfD5a12FMbh1UP2h8DYlISzx0q8U7X5mRf4z8CQ2jf5acDHdTewQiw3l
 TFdyWCXIEWIGIXD7uPaNsxDxKCp74_Y.x09zd0dF7J0da_7Ky8CIuAdCMMas4BS0_dhe9FES0.Yu
 2Pl28pA.HFv65DJ8xmTolmQkRLFvRNuCNXWxB8NXWzCQpA9Y0zHbF_1iRBtIMAxfkarKCWExrbDc
 LJg9ZJfbwojhVOeZC2xpJ7nFG7O4_P9.DpAUMmL5FGhy.HYx4zT05zrCEmm.Kzmamf0rvgRGm7ip
 V9m6ymQ--
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.gq1.yahoo.com with HTTP; Tue, 19 Jul 2022 13:16:40 +0000
Received: by hermes--production-ne1-7864dcfd54-zcbtw (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID f8a194b32ac8dff4c07ef190f4a5c24b;
          Tue, 19 Jul 2022 13:16:36 +0000 (UTC)
Message-ID: <c93c7153-f062-df46-5ff4-416b14ff1e92@netscape.net>
Date:   Tue, 19 Jul 2022 09:16:32 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/3] x86: make pat and mtrr independent from each other
Content-Language: en-US
From:   Chuck Zmudzinski <brchuckz@netscape.net>
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Cc:     jbeulich@suse.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "# 5 . 17" <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20220715142549.25223-1-jgross@suse.com>
 <efbde93b-e280-0e40-798d-dc7bf8ca83cf@leemhuis.info>
 <4ef8c3ae-b365-03ba-0e8e-9f4a2bf53748@netscape.net>
In-Reply-To: <4ef8c3ae-b365-03ba-0e8e-9f4a2bf53748@netscape.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20407 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/18/2022 7:32 AM, Chuck Zmudzinski wrote:
> On 7/17/2022 3:55 AM, Thorsten Leemhuis wrote:
> > Hi Juergen!
> >
> > On 15.07.22 16:25, Juergen Gross wrote:
> > > Today PAT can't be used without MTRR being available, unless MTRR is at
> > > least configured via CONFIG_MTRR and the system is running as Xen PV
> > > guest. In this case PAT is automatically available via the hypervisor,
> > > but the PAT MSR can't be modified by the kernel and MTRR is disabled.
> > > 
> > > As an additional complexity the availability of PAT can't be queried
> > > via pat_enabled() in the Xen PV case, as the lack of MTRR will set PAT
> > > to be disabled. This leads to some drivers believing that not all cache
> > > modes are available, resulting in failures or degraded functionality.
> > > 
> > > The same applies to a kernel built with no MTRR support: it won't
> > > allow to use the PAT MSR, even if there is no technical reason for
> > > that, other than setting up PAT on all cpus the same way (which is a
> > > requirement of the processor's cache management) is relying on some
> > > MTRR specific code.
> > > 
> > > Fix all of that by:
> > > 
> > > - moving the function needed by PAT from MTRR specific code one level
> > >   up
> > > - adding a PAT indirection layer supporting the 3 cases "no or disabled
> > >   PAT", "PAT under kernel control", and "PAT under Xen control"
> > > - removing the dependency of PAT on MTRR
> >
> > Thx for working on this. If you need to respin these patches for one
> > reason or another, could you do me a favor and add proper 'Link:' tags
> > pointing to all reports about this issue? e.g. like this:
> >
> >  Link: https://lore.kernel.org/regressions/YnHK1Z3o99eMXsVK@mail-itl/
> >
> > These tags are considered important by Linus[1] and others, as they
> > allow anyone to look into the backstory weeks or years from now. That is
> > why they should be placed in cases like this, as
> > Documentation/process/submitting-patches.rst and
> > Documentation/process/5.Posting.rst explain in more detail. I care
> > personally, because these tags make my regression tracking efforts a
> > whole lot easier, as they allow my tracking bot 'regzbot' to
> > automatically connect reports with patches posted or committed to fix
> > tracked regressions.
> >
> > [1] see for example:
> > https://lore.kernel.org/all/CAHk-=wjMmSZzMJ3Xnskdg4+GGz=5p5p+GSYyFBTh0f-DgvdBWg@mail.gmail.com/
> > https://lore.kernel.org/all/CAHk-=wgs38ZrfPvy=nOwVkVzjpM3VFU1zobP37Fwd_h9iAD5JQ@mail.gmail.com/
> > https://lore.kernel.org/all/CAHk-=wjxzafG-=J8oT30s7upn4RhBs6TX-uVFZ5rME+L5_DoJA@mail.gmail.com/
> >
> > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> >
>
> I echo Thorsten's thx for starting on this now instead of waiting until
> September which I think is when Juergen said he could start working
> on this last week. I agree with Thorsten that Link tags are needed.
> Since multiple patches have been proposed to fix this regression,
> perhaps a Link to each proposed patch, and a note that
> the original report identified a specific commit which when reverted
> also fixes it. IMO, this is all part of the backstory Thorsten refers to.
>
> It looks like with this approach, a fix will not be coming real soon,
> and Borislav Petkov also discouraged me from testing this
> patch set until I receive a ping telling me it is ready for testing,
> which seems to confirm that this regression will not be fixed
> very soon. Please correct me if I am wrong about how long
> it will take to fix it with this approach.
>
> Also, is there any guarantee this approach is endorsed by
> all the maintainers who will need to sign-off, especially
> Linus? I say this because some of the discussion on the
> earlier proposed patches makes me doubt this. I am especially
> referring to this discussion:
>
> https://lore.kernel.org/lkml/4c8c9d4c-1c6b-8e9f-fa47-918a64898a28@leemhuis.info/
>
> and also, here:
>
> https://lore.kernel.org/lkml/YsRjX%2FU1XN8rq+8u@zn.tnic/
>
> where Borislav Petkov argues that Linux should not be
> patched at all to fix this regression but instead the fix
> should come by patching the Xen hypervisor.
>
> So I have several questions, presuming at least the fix is going
> to be delayed for some time, and also presuming this approach
> is not yet an approach that has the blessing of the maintainers
> who will need to sign-off:
>
> 1. Can you estimate when the patch series will be ready for
> testing and suitable for a prepatch or RC release?
>
> 2. Can you estimate when the patch series will be ready to be
> merged into the mainline release? Is there any hope it will be
> fixed before the next longterm release hosted on kernel.org?
>
> 3. Since a fix is likely not coming soon, can you explain
> why the commit that was mentioned in the original
> report cannot be reverted as a temporary solution while
> we wait for the full fix to come later? I can say that
> reverting that commit (It was a commit affecting
> drm/i915) does fix the issue on my system with no
> negative side effects at all. In such a case, it seems
> contrary to Linus' regression rule to not revert the
> offending commit, even if reverting the offending
> commit is not going to be the final solution. IOW,
> I am trying to argue that an important corollary to
> the Linus regression rule is that we revert commits
> that introduce regressions, especially when there
> are no negative effects when reverting the offending
> commit. Why are we not doing that in this case?
>
> 4. Can you explain why this patch series is superior
> to the other proposed patches that are much more
> simple and have been reported to fix the regression?
>
> 5. This approach seems way too aggressive for backporting
> to the stable releases. Is that correct? Or, will the patches
> be backported to the stable releases? I was told that
> backports to the stable releases are needed to keep things
> consistent across all the supported versions when I submitted
> a patch to fix this regression that identified a specific five year
> old commit that my proposed patch would fix.
>
> Remember, this is a regression that is really bothering
> people now. For example, I am now in a position where
> I cannot install the updates of the Linux kernel that Debian
> pushes out to me without patching the kernel with my
> own private build that has one of the known fixes that
> have already been identified as ways to workaround this
> regression while we wait for the full solution that will
> hopefully come later.
>
> Chuck
>
> > P.S.: As the Linux kernel's regression tracker I deal with a lot of
> > reports and sometimes miss something important when writing mails like
> > this. If that's the case here, don't hesitate to tell me in a public
> > reply, it's in everyone's interest to set the public record straight.
> >
> > BTW, let me tell regzbot to monitor this thread:
> >
> > #regzbot ^backmonitor:
> > https://lore.kernel.org/regressions/YnHK1Z3o99eMXsVK@mail-itl/
>

OK, the comments Boris made on the individual patches of
this patch set answers most of my questions. Thx, Boris.

Chuck
