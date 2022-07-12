Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732A05726D0
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbiGLT5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbiGLT5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:57:52 -0400
Received: from sonic306-20.consmr.mail.gq1.yahoo.com (sonic306-20.consmr.mail.gq1.yahoo.com [98.137.68.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB823E59
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 12:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657655870; bh=gVNIDnB0rwg0U52jp8XQ0N1+sFJsTQLMngaDbXUXbMc=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=kVhI3kveFTbqCZCXcm5KMuGkeSj49gYXQgkACEx7MdQKIiDicrsy7FQOyHbz/ZC+cfjNmlgekM6pGmU6CHx+uTcIBJXhvLHi9J09UcMBiRhX8nyYD7ZuPOflZU/qwvvk16G3gKd0OkCS/s8oDEjtUJe/SobaVSKkLRVb8dcvfLSj5y1+TOFP8kfoyMy+2clfDJmYs3lQcqg92a77xLzuIlnnlZ4WeIQlIrxzV5F4EfWb/Bu2+vFkSk2NLezjg7lRgFrIHVmqLvUNnBxKK03wGK5StOtNS9dtXM6y+u4j5Tm2w2dFWSC/4KWllYRrM1pBk9oeKvo0E0N/xBE3AdmGoA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657655870; bh=IiioFCTJVjJjhIygn2ZBqdTmcjLz4leAoJuVtgdQfQy=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=XvwyZwISFXfE170G+U12KE+WRqio3bvNPKbWeYzzrKooZmFYTTO4haY/dlZIrGGdH0+z+RQDd14uRU5wTzQQvI0Yt9/9LBnyLl4vPbZpUBMByfCsg+HUb6qDWpxt3ZjQa/3eqlLaTtX7MAYnO/egHngK44GzjFwIUS3jcpZ/Zwvl4Dpm4gjyTvBgcD36oatrbYgYk3dQtGYBOrIyMWwOBz6rrdZ2Qulm5+qisikGuBksp1Glx1plHzrVwYxAfzzlcckV3WcOQ3gmNJO0oTalVp1df4TrIPuG6X2C3aYeO7vIF6IibbA3W0+ZNXoLLHMcTVfvjGM0xIojVeF/F1YIGg==
X-YMail-OSG: Gp6QV24VM1keOGlwbdklQrOy4xcanvYpcd4oO0yfIlFrKzTDqN6x4kI4wGVkqG0
 DyRz9VE2ZpDXWWvD0_mET1e570_5.NsxDx6jBC2YSrm8LYSPC3NqkymDg3qmxkPYnkx4MWYeRhT7
 oEgNfe7ti3IbW.ZwzZdAxWN9rWdmBgvkZhi6xTnqV5Fhtvr_nYoc6.vAYml4jZ0KfLkbeRQVdr5g
 mYZHWPgXRkKuTeBXNMd8nWIGy0eKPRhBJ3EdqnyN4WWe5NoqoakfsUftnsmB6HYd65Y9h2QTiT_b
 fSD.wj5mUXU_NKfOAOi_FjWXTF6bGNstZYj8TM79BsG19gywlusTiclyxZTjSun8gnVNE4dXZryw
 LC5HEucVM2fZaKmj9uVEcmyTfjIdRFq3O5V2xdkyOvaorhSbgmgROyTJnQtyI3Nfz4yKqRaH_GlW
 D96eIAWIFWrDfQ4NUfQhrA2r5rvHWkzuF2pbepkF._c5cMBQDe_iIN2LtLknKuroRKxfqESK8W4q
 N3uVBAeJMtsfPeKUGMwVXqhCY09r8bAp_xrHtVUDNFT_Ai35Urk2KXoXrvlozqxgBpnH.DYLCXK0
 .2kvBpFwCoibAF3zsgFS8FvvJLiWIhCXrg35dNc9h.56HIxa8iGtMa80h8jtDW0_XG8c8wrDmvOX
 SAPCza08JYQWPCnPDx33yGhxEoiyN9lkJQvwsfQlCIWkZCUiBJaAPHfRV6Y58wwmIi4OY9ImioFH
 WUA04Z0wHAKazk.LL5CT37ZeSsIT2b5.88wryZC0XDjO8Al6RjAusST4cXlhz5GDClOq9LRM2DuO
 8H2zCMYoyR5R1OUt4As5k.kk_qWCYbW2JuqHhk5WGLLtUF6DejjjClM9E1mvkdmpfzSeeheeQoaN
 9uj4eqfUsHobpNOD.c36jVglUPM8Wdbyztj0knaWh3bf7zdL5JD1MDz_Bemzt5HZeUItScolniu9
 eLx7BizyTIPm6IilClF1FK.nv2wE_iX3UYYFXgeVlYKz_MV3jDWMaFE_apcqTjYqAbPu5BX4xVn2
 XAg3ZC4LeXQUAD5ikg36aDnLz5b3dsI4as7Y98hzU7rKkp7CWs4IrJN2qhdZzLxnQIYczJYen7Jx
 Qm2Krsbsz7JMsptS4EtjhqCOAGc6f8o416SVgVFaN1rhsQGYP_EM1stBgL3R9NrZ2h_ImpjUvF2c
 dDQZdVubjdc6C3Ae0s90ZCxgyJDXz6.7OO4g6smW4IS2_En8Zwo6zMopMAjMhO3cjwqs4tc7gQhJ
 WWHyKJ9tGQ0ifXKkSqNXbAj6naP6LMF.2kzBcW_NuhFpy01S7.nB1UuyA4uPzO4YFGrN8vI9VaMe
 gQoAD_G_KCiC2qu457uYKTXcL6ztzxmFkiU.A5pysFpxdByAr7jUZpsOliC3n8_b3dfAth8Z4htx
 w9fuqyfONy7Yvftqt.rE_87KFHLI1ricTVo1YjrMMvEXBOh5CiW11OW8K9StLnoFFXzX2E6U56VN
 7ID_2vBccfhOi2YafF1kXPJ9mv4EhBaHgihwA62GUy.gRsFkRhnLqRd.Jj0Ad4V.n1TQzsk3UHxm
 72Tuv0.DUPJoAcdTOrFv15srf5aOML.sG59a1uY.ZBMa_2QMb3znZ2zshTUdCkTYVR9bEBomTtpJ
 DkpJSkZB7SeNrlrx7Kmc5fEuubKmVX5UglDGzxKsmJosybGFXlCC7P0O4dNgAIcWM9ZcnNYBUSxC
 Cd3tULROZQorHjxaC_C2WhvwnPjCgPp.lqb7Qb_x99yVz5ufuKsEuW26GUa4Q4O7NNGW.75z7tTB
 arLvwCeBaGutJuf3fLXUNxgLzCKzmpmZyZ5NdWr4iIieKHVCwu3IKjj8mItOO69gTqCvn39137kZ
 D0CeE4r3x7of6a.A0htBZPDVEGH9xLxP1yUjy4EGti1R7MCu_APBJBkVQjvqsUVC5KHdayk0Sf8g
 ..Ych4o6h1LhF17OgYCOQeWa8_7C9Sqem.F6mPg0_zRlHgxx9ZbvBEU2LQV4kmzHGqQbHDMExW9P
 pdbpaOY6.lvKJLrDGj6hW4t3IYfr0XIPlagDM2UjcEm9do44QvD31xjq9cRDQCQf_DrLJhv_QzVZ
 VvskVNIUzJBvo8WYKztL4e3utwl.4UXT8o6KC.Ncc8asv0iQTuJdkSw1XBoigwRS1NRWVaG.Zyxt
 nU4PttDIqE5wgfuYr2YEz2zz1veAwKM7Vq_0CVWZtNqhQw54S4ICop6__BAv9yrzFAFscU2qExaR
 VViEnHESDsg--
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.gq1.yahoo.com with HTTP; Tue, 12 Jul 2022 19:57:50 +0000
Received: by hermes--production-bf1-58957fb66f-c5dsp (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID d650e0fd81500940b6eca43bb599a29c;
          Tue, 12 Jul 2022 19:57:47 +0000 (UTC)
Message-ID: <008ff24c-d059-8d39-5e57-6f5e9de0dcbf@netscape.net>
Date:   Tue, 12 Jul 2022 15:57:45 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] x86/PAT: Report PAT on CPUs that support PAT without MTRR
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
References: <2885cdcaccffd287ef69c7509056ddf183a38a0e.1657647656.git.brchuckz.ref@aol.com>
 <2885cdcaccffd287ef69c7509056ddf183a38a0e.1657647656.git.brchuckz@aol.com>
 <Ys2/Lho9vQO33RZc@kroah.com>
 <a9efcbf3-3b34-53b7-0fa8-55a5ed3a17b4@netscape.net>
 <Ys3K0oS9QLx778Lb@kroah.com>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <Ys3K0oS9QLx778Lb@kroah.com>
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

On 7/12/22 3:26 PM, Greg KH wrote:
> On Tue, Jul 12, 2022 at 03:16:01PM -0400, Chuck Zmudzinski wrote:
> > On 7/12/22 2:36 PM, Greg KH wrote:
> > > On Tue, Jul 12, 2022 at 02:20:37PM -0400, Chuck Zmudzinski wrote:
> > > > The commit 99c13b8c8896d7bcb92753bf
> > > > ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > > > incorrectly failed to account for the case in init_cache_modes() when
> > > > CPUs do support PAT and falsely reported PAT to be disabled when in
> > > > fact PAT is enabled. In some environments, notably in Xen PV domains,
> > > > MTRR is disabled but PAT is still enabled, and that is the case
> > > > that the aforementioned commit failed to account for.
> > > > 
> > > > As an unfortunate consequnce, the pat_enabled() function currently does
> > > > not correctly report that PAT is enabled in such environments. The fix
> > > > is implemented in init_cache_modes() by setting pat_bp_enabled to true
> > > > in init_cache_modes() for the case that commit 99c13b8c8896d7bcb92753bf
> > > > ("x86/mm/pat: Don't report PAT on CPUs that don't support it") failed
> > > > to account for.
> > > > 
> > > > This patch fixes a regression that some users are experiencing with
> > > > Linux as a Xen Dom0 driving particular Intel graphics devices by
> > > > correctly reporting to the Intel i915 driver that PAT is enabled where
> > > > previously it was falsely reporting that PAT is disabled.
> > > > 
> > > > Fixes: 99c13b8c8896d7bcb92753bf ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Chuck Zmudzinski <brchuckz@aol.com>
> > > > ---
> > > > Reminder: This patch is a regression fix that is needed on stable
> > > > versions 5.17 and later.
> > >
> > > Then why are you saying it fixes a commit that is in 4.4.y and newer?
> > >
> > > confused,
> > >
> > > greg k-h
> > 
> > It is true the erroneous reporting of PAT goes back to 4.4.y. But it
> > was not until 5.17.y when the i915 driver was patched with a commit
> > that started using pat_enabled() instead of boot_cpu_has(X86_FEATURE_PAT)
> > and that is when a regression that started annoying users appeared
> > in the kernel. I presume that we only backport patches to stable that
> > fix regressions that are really bothering users, so even though the
> > problem dates to 4.4.y, there is no need to backport before 5.17.y
> > which is when the problem manifested in a way that started
> > bothering users.
>
> If it needs to go back to 4.9.y or so, let's take it all the way back to
> be consistent everywhere.
>
> thanks,
>
> greg k-h

I presume you want me to prepare the backport patches, or at
least the ones that need the patch to be significantly modified to
apply to those branches. I expect older versions will need the
patch to be significantly modified to apply. If not, please let me know.

Is 4.9.y the oldest version we are still supporting?

Chuck
