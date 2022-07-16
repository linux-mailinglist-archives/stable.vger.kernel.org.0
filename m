Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2B9576D69
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 13:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiGPLEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jul 2022 07:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiGPLE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jul 2022 07:04:29 -0400
Received: from sonic311-50.consmr.mail.gq1.yahoo.com (sonic311-50.consmr.mail.gq1.yahoo.com [98.137.65.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81000DFB8
        for <stable@vger.kernel.org>; Sat, 16 Jul 2022 04:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657969467; bh=9kCVGUMpl2oWSCZYJC+fW/uAOWc3h3qV4xzemUT96SE=; h=Date:Subject:From:To:Cc:References:In-Reply-To:From:Subject:Reply-To; b=GujfvsK3tbeKL650aaxCePnYUZ+BCHW6RyYhVhTtwzmjtMCy4UE76Bg1eTFVFWVbmQl3dNyC+bicRyQ4mktA3cpdzi7aIf/lDpc5fjhSQT8+Yktz4pgheMWNfCBJGytJPHsktdrqVNZwsMF7Vs1RJ6vy/WsyyhmKCbH9a9D4Df0gxnaA5YzVpvTtsBLceikdGRQ0yQQcsc6F/ANtJbyq7w0j1t0HNQKv5w104XLcXvVFVleeCzZMSvn2ANRXQPUs2nlePEWaakL2TBaL4vHUc9u/d8xdoZ6MdU7E7wgVSpGUKcsjWvgqMfuglOGMS4ucLM6xS0u3yDvFh55ki+V+Pg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657969467; bh=pALuA2PaqkJcZFg6nSOqnMnN/y9LNS4HKyh+F3Huagi=; h=X-Sonic-MF:Date:Subject:From:To:From:Subject; b=DyLPwWJ//DNjw29UXmL9nnGyACsUzRP/XRiW/H4zxVpJUO3hIqSVVk0WNRjXWv4nNEa6gLrhAl9z4rmP+5PSemyymB83RsI5GJIHYl1POEY3uDqDL45kgyXOpwcuP2dmBSFawqmW3/qhXZUqssZu+jeXoLxAQm0Naohz5TZWGuaphrrvRgWt6on2iCymhTgPqKmlfWqct0K8zpC7fyGcEIm7/gVxdbflXP7QOMkjMOuM7r1MRMwXTOmihH3aQEQf61rV9eHVfvCNuIeVzDfOSgqQjt3ZDjZbuiE9/cex3396ziRDLDoYQrnHtB4jrEh69WDAWaYvUNpsXxKQ2f1YQg==
X-YMail-OSG: S306_2UVM1n7GGGk3qFOuAulwIAj3xRtTyH_jeOihl0nI2.mN5zvtlDgTr88v_.
 YAGkQDbmRJLdZ8_ONmncnqU0vwKvLqPdKw70fu9fz1a6LpHUN_3kqQNSi660ldOVvV20IF0baY2V
 bByy42KCH8A.Y6Ez1fHHb8BfIpUay_Wb5VtZLXBiKinrTBuWRgK7lYKDqdGYFI3GiOorAGrclyJI
 ehHSwO1EELMPc0AxdSNMT5qWkLf2JVitExqqZH3OuHEDB_xhAPuUsYhl0OJPPNH_rOJQFqVpaXm7
 YoNQWdjgFku_xqNNDqBJmk483ZIG_HQ106jGOmDjc_RZgNJImX75NoC5l3YLVGpb.NX43tbTaGX0
 tuVzSSK._ubE3W_8Z0KzG75Sdm40.kZCHWPjL4SEWNQtsJM8LFwsostM0Qg4zBvofGT7D87ZbDyK
 FkEjD7FU6R8BEezJfUgOd_OJo0ES_81FGi3PPwC_bfOpqctoUvr7C.Dyf7AbNRCLOJv5MXU_VPhN
 TC5IMFisbVOeqKqZPIJMLqjQcmkslnq7fMUJOf7c2HgNXjLzWUjp_oNW9lM3z4VTEe0Yu2EpaTV9
 Zyvfgb8HEH7CSdMKvCKGExAxrW4rwDxIJhlmQNNQRsJhArFcCaPGAwYKhgAvz1rxCSFvYmyYVzD2
 JKTGwgAWD_KOnv9YLRYCj0viJp9TpHZwCSXKEiRnPW4WQgF0wMperaxXGJKcc0V4oi6UGuFTks0E
 ONbPZEY3NmD6UE9J8ev_Ny5HnwIG6nhzYBYneMHe2PPL9FLQhCpsUJP3G1Qg7zay6aor2x3zurwX
 HM5gnvxw_etjyWr6owcPU.eKxYi8cSdULiRT32N2HGLTx9iwQm.NTsvSzVX1X5MQdQm_vl6DBujz
 hw1MdOYVoR7Yx91p_OD_bJnfdQKJkgqNwrVwFjyNM5v_IGaHCWOW3P9Meme_jGgztsGL7OmCYSHz
 wpGG_MMqTKDP.MCgvVxbxPzb.a9HF9Cqsdw.1Gio24yTybwv5hXWQLE7AbwuuOpMmbDdbhwIpcaF
 PCCLjzSAjbdl5uE_uf7_f69WD_IbInpzG6frG.ZtuZpmucWg7q966PPizMrpDhqDIwS1cDC1qzXS
 NwxuLgF3T2aXo1g3t15zpgF5nw3v3b8nlhRLBHY0j.c95gU_1KDDAoqUY53ttpF8uQjKDoJBii5D
 7bCIoDez13wfgBMVeWuObZtOvJVmt0licA9.RzK5V.dhbFMaw_F452BaB.na3tuI.zVq5UOHhW5b
 vrPtbLi89246B2ydKxPFtwPjfdhtH4hll8aqaGZSWxWWEnrqnJn8UYfxz6O5lbb1.NEDymXWAE.J
 pVFJz9yNRs5j73MmBp7SdpF5nbtrXh7JUvLXA_GOHYu4mhU8KVNQjXXJyawyXhfxTeOxiFvWXhhz
 HsnsA1bT_AhXSrDOCBrR52XQ7FtLJV2oCBY_AMMXBG1qHezbNGvTkhfXEdM4syPPvBm75P8oWfBe
 j5G218exk02Yex2LrmoGYpOUMAN1x1fL2OafQpYK4.pTq5V_BdSUeBmghh8CgBhx0eDEZq63JPXR
 8NZMBMjXPJyg6vdNfHmdPfcusq9r1S65iGdz8SbLETsBwttLTv5dIxUwePq.Fofa5leRFV_5OLbW
 5GfbUJafiT1JPA.qXypWbBlOVhOIzvizmviuucgM1UTV1H_RchKKRyqz1hvlb8MuHPr26RVtjZtY
 ciS5BuFWw9rYRIoA8mYkzt1J4Coa9.PHWCpbzGLckYoV1J.TimUzJLXoupimaHdcfCCDoFHLIi_6
 9hjk2y_8urGYYJCArIdCsGLUJKxf_R0Y5wSrxVvpoTQGjSY4jhoaLmPy0E36fAUKsaW_7BH5cEuh
 gsEnCfHF2PWE8LGtd6qglHyUp8SNpLfDWny8EiJ3zaV8Vx4ytJBbACyao.1_CwMFN.Hw2Qcw9GXT
 TArFvhuPu.zVnD578neQfQvQLTH4xXkF2vHL5..Qnk04W_lAAysQ8Ay2WF1baDOZl2X.scrz.CoJ
 iMhwyxlcUXkBIiAn2Q0YTyDqwbGUIRz_rJy0now_TGBg80cmxiSqIvL75KnIC8UHs0YqdJweeJ0m
 r2ULwuiLaAmeaE3iO8loghYzGrQkhpKlN7_h_GgPx.DlpK2mJ_adBjwg6EXpASzkSmVvI3uQcK.i
 Gh7atEOp1qGo7HORtKjoOfjp9G4E_BQvFYn5xBlUeVgp6aUDpiI38ykFV3AcEPsABXMKgJ8sYfLP
 _6w--
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.gq1.yahoo.com with HTTP; Sat, 16 Jul 2022 11:04:27 +0000
Received: by hermes--production-bf1-58957fb66f-fvhff (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 0c6d0fae316bf9b3c37baf18a7fd0b51;
          Sat, 16 Jul 2022 11:02:25 +0000 (UTC)
Message-ID: <03ae6425-6d99-4ec8-9f94-005a4d79ca16@netscape.net>
Date:   Sat, 16 Jul 2022 07:02:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
Content-Language: en-US
From:   Chuck Zmudzinski <brchuckz@netscape.net>
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
        Thorsten Leemhuis <regressions@leemhuis.info>,
        linux-kernel@vger.kernel.org
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <5ea45b0d-32b5-1a13-de86-9988144c0dbe@leemhuis.info>
 <56a6ab5f-06fb-fa11-5966-cb23cb276fa6@netscape.net>
 <d3555a74-d0cb-ca73-eb2e-082f882b5c81@suse.com>
 <1309c3f5-86c7-e4f8-9f35-e0d430951d49@netscape.net>
In-Reply-To: <1309c3f5-86c7-e4f8-9f35-e0d430951d49@netscape.net>
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

On 7/15/2022 3:53 PM, Chuck Zmudzinski wrote:
> On 7/15/2022 6:05 AM, Jan Beulich wrote:
> > On 15.07.2022 04:07, Chuck Zmudzinski wrote:
> > > On 7/14/2022 1:30 AM, Thorsten Leemhuis wrote:
> > >> On 13.07.22 03:36, Chuck Zmudzinski wrote:
> > >>> The commit 99c13b8c8896d7bcb92753bf
> > >>> ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > >>> incorrectly failed to account for the case in init_cache_modes() when
> > >>> CPUs do support PAT and falsely reported PAT to be disabled when in
> > >>> fact PAT is enabled. In some environments, notably in Xen PV domains,
> > >>> MTRR is disabled but PAT is still enabled, and that is the case
> > >>> that the aforementioned commit failed to account for.
> > >>>
> > >>> As an unfortunate consequnce, the pat_enabled() function currently does
> > >>> not correctly report that PAT is enabled in such environments. The fix
> > >>> is implemented in init_cache_modes() by setting pat_bp_enabled to true
> > >>> in init_cache_modes() for the case that commit 99c13b8c8896d7bcb92753bf
> > >>> ("x86/mm/pat: Don't report PAT on CPUs that don't support it") failed
> > >>> to account for.
> > >>>
> > >>> This approach arranges for pat_enabled() to return true in the Xen PV
> > >>> environment without undermining the rest of PAT MSR management logic
> > >>> that considers PAT to be disabled: Specifically, no writes to the PAT
> > >>> MSR should occur.
> > >>>
> > >>> This patch fixes a regression that some users are experiencing with
> > >>> Linux as a Xen Dom0 driving particular Intel graphics devices by
> > >>> correctly reporting to the Intel i915 driver that PAT is enabled where
> > >>> previously it was falsely reporting that PAT is disabled. Some users
> > >>> are experiencing system hangs in Xen PV Dom0 and all users on Xen PV
> > >>> Dom0 are experiencing reduced graphics performance because the keying of
> > >>> the use of WC mappings to pat_enabled() (see arch_can_pci_mmap_wc())
> > >>> means that in particular graphics frame buffer accesses are quite a bit
> > >>> less performant than possible without this patch.
> > >>>
> > >>> Also, with the current code, in the Xen PV environment, PAT will not be
> > >>> disabled if the administrator sets the "nopat" boot option. Introduce
> > >>> a new boolean variable, pat_force_disable, to forcibly disable PAT
> > >>> when the administrator sets the "nopat" option to override the default
> > >>> behavior of using the PAT configuration that Xen has provided.
> > >>>
> > >>> For the new boolean to live in .init.data, init_cache_modes() also needs
> > >>> moving to .init.text (where it could/should have lived already before).
> > >>>
> > >>> Fixes: 99c13b8c8896d7bcb92753bf ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > >>
> > >> BTW, "submitting-patches.rst" says it should just be "the first 12
> > >> characters of the SHA-1 ID"
> > > 
> > > Actually it says "at least", so more that 12 is It is probably safest
> > > to put the entire SHA-1 ID in because of the possibility of
> > > a collision. At least that's how I understand what
> > > submitting-patches.rst.
> > > 
> > >>
> > >>> Co-developed-by: Jan Beulich <jbeulich@suse.com>
> > >>> Cc: stable@vger.kernel.org
> > >>> Signed-off-by: Chuck Zmudzinski <brchuckz@aol.com>
> > >>
> > >> Sorry, have to ask: is this supposed to finally fix this regression?
> > >> https://lore.kernel.org/regressions/YnHK1Z3o99eMXsVK@mail-itl/
> > > 
> > > Yes that's the first report I saw to lkml about this isssue. So if I submit
> > > a v3 I will include that. But my patch does not have a sign-off from the
> > > Co-developer as I mentioned in a message earlier today, and the
> > > discussion that has ensued leads me to think a better solution is to just
> > > revert the commit in the i915 driver instead, and leave the bigger questions
> > > for Juergen Gross and his plans to re-work the x86/PAT code in September,
> > > as he said on this thread in the last couple of days. This patch is dead
> > > now,
> > > as far as I can tell, because the Co-developer is not cooperating.
> >
> > ???
> >
> > Jan
>
> I think I recall you said my patch proves I don't want your S-o-b. I
> also want
> to add some useful logs with your approach, probably a pr_warn, which you
> are not interested in doing. I think it is probably necessary, under the
> current
> situation, to warn all users of Xen/Linux that Linux on Xen is not
> guaranteed
> to be secure and full-featured anymore. That is also why I think the Linux
> maintainers are ignoring your patch. They are basically saying Xen is just
> some weird one-off thing, I can't remember who said it, but I did read
> it here
> in some of the comments on your patch, and you do not seem to be listening
> to and responding to what the Linux developers are asking you to do.
>
> Two things I see here in my efforts to get a patch to fix this regression:
>
> 1. Does Xen have plans to give Linux running in Dom0 write-access to the
> PAT MSR?
>
> 2. Does Xen have plans to expose MTRRs to Linux running in Dom0?
>
> These don't have to be the defaults for Dom0. But can Xen at least make
> these as supported configurations for Linux? Then, the problem of Xen
> being some weird one-off thing goes away. At least that's how I see
> the situation. Maybe Xen can provide these for Linux in Dom0, but
> from what I've read here, it seems Xen is not willing to do that for
> Linux. Do I understand that correctly?
>
> Chuck

???

Chuck
