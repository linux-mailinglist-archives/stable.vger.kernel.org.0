Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE33575977
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 04:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241255AbiGOCHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 22:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241254AbiGOCHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 22:07:47 -0400
Received: from sonic303-23.consmr.mail.gq1.yahoo.com (sonic303-23.consmr.mail.gq1.yahoo.com [98.137.64.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A36474DF8
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 19:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657850865; bh=nzz5QL7S9DLFkCMBr3Jim+Elhx8CrLEWNxNyWEg5v+E=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=S1vxLiilifOP+Y+3gVSDu3ocGcLdk3Yl3flRXk6iiZcJTd8jE2f8uPN6E6vSH+yE3Tce0f8vZBUMDDcy86+CjNE6ffihuNFWMFlO+Kza8AJhFBnKIAWdWugB5cMlLhadY4kHFzBaH50rUAojasyh5G4PZhRrglsmypYLwzWGIPK+1BEN1W9DpEXCMG6k4MqEtErZwcpWrEEet7+cym49+mlBI5v8ap03AebS6BWfqpn6/B/zj44Iwi2xzUCuqSFDyOW2fh4dbmEX/rYp1ibPS6PjshJ+yh3glGsAUdayoZV68d15JVMAPN6ameysRjmI0CFvQzumuCm1aOWd7qj1EQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657850865; bh=mBjM5fr05W7yyMdpoeeh4co6EO/zHVVw+ogE46gMJKr=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=QfFDbf0P7TH17MXGL93AmFSC1u+aXl7GlpyPXJDXyjEZSfvMYCZCwjhBptEKK8VSdPZYMlwhNXjJmPGXM5ZvCSrq1VybyE1A5OZMSXt1iQQmyjQyu7jjCthhOGl/vdgxpFf6J1mZVHtp0rn6AHfQxw2i28p4oPSTqXZ0AQ4HBakiEccEZXgPg8yKEyOlgIjjDh+N4+d302CIM0XtMti0zr4ofBkbH4eQQr65gfPfl3LshfNEr7YRyoP6TDaO/OmSkqA4shrtIkaFR4L5Zq6OiuxMBbhY4Igm3xJAlqIr6wn6T3fFGxoJmOF6SDQmSOP/3SlJ6RJStphQD/u+k/5THA==
X-YMail-OSG: HvN33AoVM1kCCkC0XcVyGo6GBCiv59acgj3M6hzk2m_M8XCdr5VdEkA__n9uf0e
 ZxFOV5wtFW51DkgGDy7HIJNs3hcffNgdYFypFExDHWbnZg1EbT0DBtg0.ySt.lGnQFAktP2sSoVr
 EsQJkXa4A5fXMOz6Lrz3bS71HJ6d0NkXBECp.YyfZnPWAfeMV4a0uUY7LsKNIJcROjiq33QcdJoG
 2f.18Ju177hjNmUY4yz1HoYocGH.OZgjYBkSfwUp8xz6nzqU81_TB6GUy0atquF5_bkkXxiMXwC9
 a72DorlfDypCGmdTeR6e4bZp55mFtCpxCKY9CwMkqn7U94LCZ0Vp2yxf5mYtTFImF97JgX9xsfs.
 w_.lhDhU6XlUp7AUPRkxqJcVbifLx1L8bTj.6uDIJvJZZD3UMqR254Y.zRbX.Y2qjSpBLHpW5tAY
 C6fJK_jzx_gUw8yBK3mYgIqs6WTsvN46qNf3ivGo5Nqus9EFdybskGO7fkC_LckTuhu6wA2sjEYy
 MkCngTwn2M02OWwNJF1nw0Patw5h1EG.8q4LrYhUrSoRxXK1CWbBwB.uwBg5vOhD8t2swFAcfVk_
 n4ZLIW_dmfQDsTGtD1Dpq3b70BkQLZ8iaorJwDib6LiUgiNG8X83JDfOeTVy33pfWUtOax1U3wsP
 .geDph1Xs.bxTp46yC7JZuk3xCLK25jGHvTEKvM9n1GpiZuzjw5_00Oh6jTdIQvbRQl4oOV96oxW
 ZBY2CSjbYOyzZvBF2RarId_Qa3P9wYgkx_XFwuunZ0C.HPCNFxhR7uZMVSByAaZWuxHjdOAbbpwN
 b29JeINk3hi73M8Bz.e14.jMtusHcJPZxz_0fexQisxDQhXYQUrK3ZRjFQiZseR2mY5sJNdus_Y6
 0dixxbM_2INjZNNPjMiW6gJp7K.DqCp3IUt5NvZPdhiVDWfzY4IfD1CEjOe33n4uH1cAI1ycoDr5
 prlMAZIfyFTPv0Wq6twh0VkDyIaS7mex3In3S6Z7dhSnCus5T9pAm3IV69_OpCwzVMc7aj3vSt34
 55FsYEJcx7NddlYpySIJJo_F3DYNc3Ce.sW87wcPSfpm.B1MNghUgp5eo9eZBfLgTjzUub3SvhS2
 Sz8wiqGrvQMDrKfbhQHNqtNmHVwahRVMRUymK61QnY8LucyPD19_jx2gpK39BG0vSwXo8kqXG7eL
 EGNztORaW2RTXdXWsK8VylfM3DCmL3vfnLuSQoTbiQ_UkeEFiU5oTFyMynJbymps5oKH4usPlJzR
 7lu.kzYkUpeTlq4Ff8iq4aUUpmfjJ5bc01Z9DqGOehxQDhR0gk4IJ2Dj9GDoKDTIfYwcY7QZ9ucr
 BfAC2Pa4f6cwm2eeKUycfJc94Nf55ycZ.7NIpt3rDKeHsMljqWSk1B0DioEmxlODjPSB5aBzbGEH
 A518VwJTPH3.DGbUMTNNQaQkc4ViDkfhfZuh76LuWUiNrRI4ToSWTrUKKIBgxXZ6I2FCH8utGH95
 yjnCs8EItKvCGkU8TpRmfl55TdbM3b5PQWEHVx8fUYRU9n6CXhClIcwgTFzTpaIstZVF7nE1d5Y7
 Rl4aTza7dwrGPq_rtfX4ze20hTGNgv0avdx0LaNm9B36pVckN72oYXi8uSNgh8qAxp03NWex2I4O
 bpMVpx8Od3HJRMRNuPBgwLmCccWS8fAFHdtP4cNT66YII5ZLlshCTBYx13qhK_TQGrgUrWqtVsYI
 GdR0QlqBsqj5EP2LibZa_r2MXTvCf7ETXvWWHSgfZ63J4h1DhxTP3PaZTCwBumPy.LSBAhmKFKls
 udSxpuzIA_A_cSIwb5vVzN3nIvRqaSb_krMMQ6n9_C2kyeNPd.p2E1K_5g1At_.e1yXtaBtm51Uw
 by9P0qj1mJ2PG.Zr_IFl3DH9_KLxa_wBtSVzVvkEzEAWUorwQqqpN210nf4lWicWiv.SJ2Ed8MRX
 jGH4qYu86UzK56g4K3LDMyQPiD7LV8lduflZG_I4bvfO0dKtdLaGp.FLdI1NVNztsJXIZCveO7kj
 BWxXNBiSfzBw9XeN0lkaUxWnS_BJgToi4DCQMnDfh5YwAC14npUM_DGkH_TstqL3dfqaRyRtf9vF
 Thg0O6tW5U258edg4TdD3kPUqm4BE0Fos0vI3ZiqC4koGAtKPN5YfyVU_uu3zcctZBE4BimkPa.P
 _Xp0Uob9BC_hoso6EQFQhM0KpkzXOLtc4kk4XeoH.81PxbZ8.DYNIKwWNfRtUkqFUOLDcXqjsZml
 6.y6l
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.gq1.yahoo.com with HTTP; Fri, 15 Jul 2022 02:07:45 +0000
Received: by hermes--production-ne1-7864dcfd54-8q7fk (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 71743821a1d43004a7054548f9d96445;
          Fri, 15 Jul 2022 02:07:39 +0000 (UTC)
Message-ID: <56a6ab5f-06fb-fa11-5966-cb23cb276fa6@netscape.net>
Date:   Thu, 14 Jul 2022 22:07:36 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
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
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <5ea45b0d-32b5-1a13-de86-9988144c0dbe@leemhuis.info>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <5ea45b0d-32b5-1a13-de86-9988144c0dbe@leemhuis.info>
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

On 7/14/2022 1:30 AM, Thorsten Leemhuis wrote:
> On 13.07.22 03:36, Chuck Zmudzinski wrote:
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
> > This approach arranges for pat_enabled() to return true in the Xen PV
> > environment without undermining the rest of PAT MSR management logic
> > that considers PAT to be disabled: Specifically, no writes to the PAT
> > MSR should occur.
> > 
> > This patch fixes a regression that some users are experiencing with
> > Linux as a Xen Dom0 driving particular Intel graphics devices by
> > correctly reporting to the Intel i915 driver that PAT is enabled where
> > previously it was falsely reporting that PAT is disabled. Some users
> > are experiencing system hangs in Xen PV Dom0 and all users on Xen PV
> > Dom0 are experiencing reduced graphics performance because the keying of
> > the use of WC mappings to pat_enabled() (see arch_can_pci_mmap_wc())
> > means that in particular graphics frame buffer accesses are quite a bit
> > less performant than possible without this patch.
> > 
> > Also, with the current code, in the Xen PV environment, PAT will not be
> > disabled if the administrator sets the "nopat" boot option. Introduce
> > a new boolean variable, pat_force_disable, to forcibly disable PAT
> > when the administrator sets the "nopat" option to override the default
> > behavior of using the PAT configuration that Xen has provided.
> > 
> > For the new boolean to live in .init.data, init_cache_modes() also needs
> > moving to .init.text (where it could/should have lived already before).
> > 
> > Fixes: 99c13b8c8896d7bcb92753bf ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
>
> BTW, "submitting-patches.rst" says it should just be "the first 12
> characters of the SHA-1 ID"

Actually it says "at least", so more that 12 is It is probably safest
to put the entire SHA-1 ID in because of the possibility of
a collision. At least that's how I understand what
submitting-patches.rst.

>
> > Co-developed-by: Jan Beulich <jbeulich@suse.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Chuck Zmudzinski <brchuckz@aol.com>
>
> Sorry, have to ask: is this supposed to finally fix this regression?
> https://lore.kernel.org/regressions/YnHK1Z3o99eMXsVK@mail-itl/

Yes that's the first report I saw to lkml about this isssue. So if I submit
a v3 I will include that. But my patch does not have a sign-off from the
Co-developer as I mentioned in a message earlier today, and the
discussion that has ensued leads me to think a better solution is to just
revert the commit in the i915 driver instead, and leave the bigger questions
for Juergen Gross and his plans to re-work the x86/PAT code in September,
as he said on this thread in the last couple of days. This patch is dead
now,
as far as I can tell, because the Co-developer is not cooperating.

Chuck
>
> If yes, please include Link: and Reported-by: tags, as explained in
> submitting-patches.rst (I only care about the link tag, as I'm tacking
> that regression).
>
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>
> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> reports and sometimes miss something important when writing mails like
> this. If that's the case here, don't hesitate to tell me in a public
> reply, it's in everyone's interest to set the public record straight.

