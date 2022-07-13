Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5031E573D48
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 21:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236882AbiGMTiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 15:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiGMTiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 15:38:22 -0400
Received: from sonic306-20.consmr.mail.gq1.yahoo.com (sonic306-20.consmr.mail.gq1.yahoo.com [98.137.68.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C1C2F666
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 12:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657741101; bh=gvegsbKA0Ugq9G0OL2YHhHKrmsIiT+j/cAd/AQ6k6Xs=; h=Date:Subject:From:To:Cc:References:In-Reply-To:From:Subject:Reply-To; b=MZQFw9/JPmpuroD8LpVy2xa3dQDRMBFdA1RTqyTtfXGmJdjhwswFVzyIiTtrjeVLke4h9R6vpbhZrwclrfloBGOp2L+wHCFozHHxshm96MpC8KnvxjrbCxDHjQlpRIUpJr3OANhsOqTkaEeDDjVqPyjjcXAeyvNV5NU3tZXVKTLiEK/0j7m1/p13hezk70gaMuusWCA4JRaa2p0Jzse6r7VoUMRvivNOpBOcUWfv/kgTPfpCaZHSyerdo5KS/z7T6qpy9go7S/K1gkEUopfNCmdCWHS4IDEM6Mgm4KYZ0+hLIe52QXhqSu9Uw1QPPkIk8YBYeUMNc2FU2q5el6C0KQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657741101; bh=gZ+FnmKOj2zVRAIddN3HlDPLO1hF3KTuu1g/XWWOSUs=; h=X-Sonic-MF:Date:Subject:From:To:From:Subject; b=a2pkxJoMqAMjHRNepy+Lww/IxC/RE0FTJRCwDDn/wY4E0LE8qCmiLkebT84SXNo+TlgHg11MluHHmltYfW7+EFlikPZ0urlzkyhtpPIYnT6NBiEKkEIrkJ5o2w4NJKVADJI7/18sg/UjKFESFH+RP6AYTYe1iExKtTUIDxtME5cTWF1ITBkUd+qnpyaT8NMqsZHgdMNbLrpBrJDldNKFgg9Zzpn0s/q6EMtoxgdHUy+mvasB13AiPzduJ9m04jq7bK/mbIgapg9+LTqtVnZf/Vhl5Gjt/5aLDz9bMDVv/+DDIUctfWPI3NckNk1ChAZ+i9BgzS9+VYZuS4pRfNSbeg==
X-YMail-OSG: 6luG7AYVM1ncjX7nkCvm9bLVe10whawpCglcbiYMUxQ2vlNaWqmz.Z9bEDOn_49
 iRTUpxQz7K2qvaNS2J2y8psq2P0rEXp5vqGKyN11aM77RStL50FoqtrPJ6j0bdro7hg3IcsH09JN
 ne3T8aDhdkdYjDnOAxG0TmPRA4l7CQlxppszvaPxaSWGEXoEQydR9VpICDcRUf7Q6fDXGSbrNB_0
 Q572vxdxIFATyMSkoluEbUneSV3IRw.dOKEdOVreZTJOYaWtmd6mp8juh1i6BTSAU6HhiNGAlCOY
 UJnkfjbe5CWsZ5zDBlI8Qvhp8HKy0d9SEZZrNp4ZbtrWZEzaDi.o3Ij7rkk9ADsdFrVldnY.psmh
 knlFFmuqF6mXn_04ZRXKcTCX8829w.r.ah1gNITohjd8JqSnEEgfuqI2rnDOSogBGCGR.ojSthf1
 9cwixTxmGffEbuyyKVnf0x1MvLirnTSUrVAeWE2CL7louDYGEpd03wPfoAbs4rnb4l11Y3k21XcW
 Lbt1W2p4yGRVwKOIwthaq12o74hdGxUinST.2p4ZS2HgDgeQhMWD2SB7vFCrR.ZyWhmG0juDZr_y
 lFueayb9GF8.WkWzvPIeV7T6lfG73MnfrhAbz.PTbByim89nFkpHGRB46D_LIGQPYBk4gIsgml5F
 UaCBrtqWwDjWaRyxNqlCr7SfT5XlP7Xoyqgiqqq7LBD2f6fOD0qHtebvJGZccgMk8eOd0ECXRRPa
 7l7rNL5juqI99YtXBU4dRG.uP_Tw_T3R20JxGBs.2HXiMA3GB8f16_9rZdCk86nBXJqcGwa2VJV6
 yRjwbC7UHKGmlkqDcWYRIqYrj_aaeokYD7yAwntlrAkjo1HLlcIvyT2uQOQS6wSKfB5HjgpRGS0R
 9UhoLIsYxVvpwC6v2HWTOvlHC70DFJyk04G69oizXdeBicJGz_eH.InuYvclXJQcX44_EYXtSF80
 Xmc5ReIFPw6o4Nvw2a0nmOkwNd67hhv_6vcyGfURwyUHsuys17jHmXyKDsKkY.Bonqyx2H15AQ9b
 3tokiGn3Y4nPWzGgnviaD6LXI3DyRu00uv8oB.gzfDuHeDhSETaPelKXMmF2nImaT.tKktPDAocD
 4zNoYSG_xPqWm5cksbgvpXA5tR8OqpcZN6djOiIKVLu5Dyx4H6rI0Pu3oOFE17HmEZdZVmVk9lUG
 rgNtz52CKxTbNdgMmTLJBehtHFw6pansJH296wx0y26C8wZkjpFAU1J8BtiYqjNbTjOX6qNfASio
 chc.zRQCDGkLV78hS9Z4Jp9fByWtFyJ3DEhF.tco3rXB9la83ONyM2dklm9YQtcofpccVVtMZf6M
 rFuSmRQVxGQ7mpRiScTlS2dM_PU7XQO3crjWzhZAPSKYnHKwUvDse4tBUGqkgTyv2LxlEtF2p1rE
 nXzD4O54dQAj7GOH7LZJBB4y.N4VJD0c71jg_zfwoT8PIdvByLHQ2Q1J6CiGDBItchWsci_mkpsZ
 F.BvZUFLlmGv5SE2r0wFRAIRedSB1LcaiF2w.5T2dDq6c8ntVjv7WJdyViKxF4PoXjQM0MGv.zPt
 IVFuiiRtW3OxU15KT2btrB7iriw17eCDKzd7JaqBvZujjeCV05DkTGEyVqYDJdN9Z.oCduNyunYC
 LyW2kuwf0w.KJPt6J2_8s0aQzv11v76SuPMMhUMpPRWFVRnxEDeCTWiVuF4m.XqaRAonA7idjTMk
 54s80Vdyra0rFJylo9njYUS7qP4Y.2gdNBO6WXa7w8lh3bNZDsRHChZQPMRPgE48w7zAE9lzrVoY
 2vcFB__DJE.MEB8_a43uDr1Wd4HaM8FYe0RCu7YgdcCzjYdmZkKNkQofUpvhtMtN6E_SRxrrtOpr
 5OURJ9WfoKOATbcUcbSSOcOrExivbbAGtL0JiQEqYJ47Qlu5QF.WhGdXRUCslRUGq7c9U3Ai_oHo
 FYRfLsYLhqfxSEzuq6g3.1FFZHFypkQhNncDQ4gU.UZIKvUyFWGBTbjYrV5qS8Wk.qyU1Q1Vedfv
 umnFJk_NU1qEn.aUiv_.fihm.ivkRppWG0H_a.yp0cuWcELo1hd.W6jKtaIAToVmuxLc.PjczmGD
 _9tuqHljtG6g92DYqhD.6WkVzlar2mMaD0RmSt3MQvM1eUp6vZ7m1AkYrquTAHudbRlCVO.AIvWI
 dnc_HFSnf6_NX0xYI.hq.laqyMvQ99CXMuLBFAlCoIczXGGRgwwRynI4OedIYZj95bLfbVasiHgZ
 WNt2WUQ--
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.gq1.yahoo.com with HTTP; Wed, 13 Jul 2022 19:38:21 +0000
Received: by hermes--production-bf1-58957fb66f-p6kcj (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 564882263554cd3ca01f52971e669fd2;
          Wed, 13 Jul 2022 19:38:17 +0000 (UTC)
Message-ID: <9c97d8b4-ae1d-efd0-8414-91a50d22cf12@netscape.net>
Date:   Wed, 13 Jul 2022 15:38:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
Content-Language: en-US
From:   Chuck Zmudzinski <brchuckz@netscape.net>
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
 <56a304ad-606f-6d33-bd2b-8c614fcdb666@netscape.net>
 <4e74aae6-7d8c-15ed-c571-b797239374cb@netscape.net>
In-Reply-To: <4e74aae6-7d8c-15ed-c571-b797239374cb@netscape.net>
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

On 7/13/2022 3:22 PM, Chuck Zmudzinski wrote:
> On 7/13/2022 3:07 PM, Chuck Zmudzinski wrote:
> > On 7/13/2022 9:45 AM, Juergen Gross wrote:
> > > >> On 7/13/2022 6:36 AM, Chuck Zmudzinski wrote:
> > > >> And in addition, if we are going to backport this patch to
> > > >> all current stable branches, we better have a really, really,
> > > >> good reason for changing the behavior of "nopat" on Xen.
> > > >>
> > > >> Does such a reason exist?
> > > > 
> > > > Well, the simple reason is: It doesn't work the same way under Xen
> > > > and non-Xen (in turn because, before my patch or whatever equivalent
> > > > work, things don't work properly anyway, PAT-wise). Yet it definitely
> > > > ought to behave the same everywhere, imo.
> > >
> > > There is Documentation/x86/pat.rst which rather clearly states, how
> > > "nopat" is meant to work. It should not change the contents of the
> > > PAT MSR and keep it just as it was set at boot time (the doc talks
> > > about the "BIOS" setting of the MSR, and I guess in the Xen case
> > > the hypervisor is kind of acting as the BIOS).
> > >
> > > The question is, whether "nopat" needs to be translated to
> > > pat_enabled() returning "false".
> >
> > When I started working on a re-factoring effort of the logic
> > surrounding pat_enabled(), I noticed there are five different
> > reasons in the current code for setting pat_disabled to true,
> > which IMO is what should be a redundant variable that should
> > always be equal !pat_enabled() and !pat_bp_enabled, but that
> > unfortunately is not the case. The five reasons for setting
> > pat_disabled to true are given as message strings:
> >
> > 1. "MTRRs disabled, skipping PAT initialization too."
> > 2. "PAT support disabled because CONFIG_MTRR is disabled in the kernel."
> > 3. "PAT support disabled via boot option."
> > 4. "PAT not supported by the CPU."
> > 5. "PAT support disabled by the firmware."
> >
> > The only effect of setting pat_disabled to true is to inhibit
> > the execution of pat_init(), but it does not inhibit the execution
> > of init_cache_modes(), which is for handling all these cases
> > when pat_init() was skipped. The Xen case is one of those
> > cases, so in the Xen case, pat_disabled will be true yet the
> > only way to fix the current regression and the five-year-old
> > commit is by setting pat_bp_enabled to true so pat_enabled()
> > will return true. So to fix the five-year-old commit, we must have
> >
> > pat_enabled() != pat_disabled
> >
> > Something is wrong with this logic, that is why I wanted to precede
> > my fix with some re-factoring that will change some variable
> > and function names and modify some comments before trying
> > to fix the five-year-old commit, so that we will never have a situation
> > when pat_enabled() != pat_disabled.
> >
> > Chuck
> Sorry, I meant to say,
>
> To fix the five-year-old commit, we must have
>
> pat_enabled() != !pat_disabled or pat_enabled() == pat_disabled,
>
> and there is something wrong with that logic.
>
> Chuck

So to summarize, I think this means that to be comfortable
fixing the five-year-old commit and the current regression
by artificially setting pat_bp_enabled and pat_enabled() to
true, something which both my patch and Jan's patch does,
we need to come to a new understanding of what the
static boolean variable pat_disabled in
arch/x86/mm/pat/memtype.c in the code really means.

The fact is, we have a regression and the only fix we
can find is to try to make pat_enabled() == pat_disabled

I need to stop thinking about this for a while. It is time
for those who have authority to fix this regression to
make some comments about how they think this should
be fixed.

Chuck
