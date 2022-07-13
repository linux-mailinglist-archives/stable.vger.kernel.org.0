Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16058573D14
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 21:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbiGMTXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 15:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiGMTXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 15:23:05 -0400
Received: from sonic313-20.consmr.mail.gq1.yahoo.com (sonic313-20.consmr.mail.gq1.yahoo.com [98.137.65.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286EE237EF
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 12:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657740182; bh=/pqEtPTwoqlqf1VfNjWI+ICxoox940uBU+wleS/dIQA=; h=Date:Subject:From:To:Cc:References:In-Reply-To:From:Subject:Reply-To; b=jOfzgrIZnCGAOPIyNe5JIWs0IE3kzATlnIeOengJsRshFZHKdzoOKXtvRZjg2k9NnJ1Wb+7mhzw0v4BbxCPWA5j2OylngBa8yTJpjeI4X+dXVtbJVf37Eppl+XLV946ub17PuQJbPNEDyNJDx+s6XrWrNgc9TTMNjYIxK0gSO7aIKzLqQ/nl/Rme8gw6IDNZh/ML83/boCnGnehv10j9wjRQ/7TCS0PmqltNSLTSxZ9ec310Min8XajREI+1SN8FnmQbJrkpluiQNcKWn5gb4q08j1zvgXeEPJFoaOYFImtBGBgAucJxirOinPKMVLmNEUpMchHbUS85w0HcpX5c8Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657740182; bh=iDdQzQUxoYiwLEBUT6Opp93BUFmnJiJhA/x+KMtY0pk=; h=X-Sonic-MF:Date:Subject:From:To:From:Subject; b=Tr3kDXM64Qz8a/Nk+fSD4+jPhhx8mSk0WOUnB2addJ+WEF6Br33g5JUnyT88sOVE1nvpAEcfGLsr3IfvQ1QRk1KpAgEOHxw4hmaWyHBWvtPElmJRFK9GSY6y8h14vx2QHTTycWrYK1Hhux498KLODzsO7udPsfYXlbAMr1MhvxHoIfY7OLYaqkTHBgmtKrMAKDwxMgc6RCMjF0YHf73hmlel6zkvrnh0IheGEOSMDucecax4i9cORU47hsPBUJfHYi3Y20QuRQAqfJi6BA6x960DldC8+WD9ACduVKAmd8SAK+eidAZ/Hqiqjih+n9ut05UgsEJhHvbxSjG0pcGLdg==
X-YMail-OSG: jVFH_4sVM1nv9uVHcq_abWJ3PwOSDpTt4cR4mfH4t5l46G7PndKKnZVIyhOQ95Z
 kMrzamX_2cnR7VtZSrjVKFN8KdcMsPbNqdYzQHAsfH3K.FLpYl1ESyVCCK3A.rzUPGfgWBhoY_m2
 7wRhYUhOUGJvHmHc9XaQDKFd56QUQHTtgN7cAizWZAlfslIFyh6DfCKi49JanjAh_SGs1uOzEJeF
 04gR07VvsAH2tKBPc2GNXzdaRwhxQp.hvixGwoXtBgttwA17B3gD1lEqf7NtYN94zg9rcePfL2Iz
 n9vlowjcfq799NKN3HzEwcHMQ0s2VcoaQwNCgPTgR7Rz0zrFKUjlIkmI_dJnfIDRY7pZGpQthk7x
 8pGlT73ukUpUNXmZ.jzAvtZt1_86vE6HxcsgclA6id0V506D.qlPYYcPQXNl5TLCLIwSPEi1PjCK
 xOwH6kGhfqeO7_4kfzyAShju7pQZvJ3LoQevpK46XoGP.fuUJXBf9PVAqsp6iQdUSBS54UTxfAN0
 iB__bo6cbMur4MxBQ_NzsuaVskH3SRRAVmaGtYZm4OIdEdjVToEKSaHwmJ62nWmjs3zee6rtU8ZA
 vSzdXYL6cPgGrRPN29JdZHPUgEl4uGi_cAykKmk_8bHZw5gFUAIT_kqxUrnM55KJpTqVFdg87ikb
 I_j4aOxjR_FHkx946MQTVtZFDYXO46z1uY7DnbpAUM6uFS5CVX6g4ejuURaUMlSbvvCSXOugJymm
 w3uyROGdlJrtCjLKX04xgCQZKwheC6J02nBoOrdb9q0MRR9RwCtITLq6I0s06239AYyi1RPCCmIb
 vuhKkDQ0sq0TddbHHgCv9QYvxgN60dvE54iFp_CiEIf35gUBPFBPodgpCKG9Wh8qlNH5tum5rgab
 I9EWOVzDVxD3KmgUXypIjjH.y7y7H4NbxTzJQX5VScLi.CYL_FfRERIoeT2AcJ8D5HDXmDZ08osm
 qCF6I5061yYDWTy_X6_tD4h2z05haNgm1ZFuMB_qmm1G.Erj2Gqk2.t2Ahamh0oenjH7Ln2NptA5
 dhPAThR5RrT.kOJ0DyBFoUToFzj4Db5nYb9_oWX3aDOQc.NBHwH50WQ6Nm04V2qC__rK0HXj4HJU
 ZojPKFeoUPd9XYVFOUVxga4Ymv3UMeKr7WTj1Gy1tETIExmsmDpE.T1CA5YUiWAsowxrazRkXvnP
 yXll8heAHBvzLCsPIuslVQcOSZzpEdVKUCXLlm5WQrxGPUBBev5wO0f7.2zap2aSL8uuHNxT0bnI
 Hv5ctTEi5B21XgM.Psx4Kq.HNVwg22Ij9B7aRalBDgLdlVbBqm.cwOHDoOonL2JzrvCUTSqKOX2f
 GduBe7IiSsHqhjXPm1KoUEp67Nq1YAVD4NM8XOc2qLBFEK3_HY.dLAZ4c3vFIL9x7JN9Bd32Z1BL
 1CCt1ceK2CFj__20ITwrP56hmX7R.cJcQT.YVKp3VHCPw0GZWdeBOySC5ms15GgEcSVK5JVB1IAb
 __hIpu2F_0xz3kiIpGdZnre77bGdb.N2sGbOMb.See3A5tudGSGQL7hEfhU1MrkFQJS1qE63.rr1
 PkONvRZXfxBpvxHEomtCY6uwz4jdusqAQTh52hYzNFFlKuYj5tDt2cMqP02UWQVjT4tVKoMDadP0
 FicsqjMwUBpCO8raScPwwHBYZaLd1g5JjCQ5hHlrdv0hsfyjwxSUTsovYohEHzN2lJzAUVLfw1Qb
 ISijlH4Y6ETlqSkqXMxEhJQu04DLEIhBhgQ.jTIfS6PcOsDNQyibLiOyHDdtLjHRLOCCNtkelVTS
 ot62jYJu_UeMmVYOcm.RLIFPoINLNGqbFLKWF5Qu_pTTbJcDH.9MS46_oOJagtK_rsh2HYuVyIkm
 P.EMxBfgPXNh2RDfR_CnDjRnnYXsa7OVH98Pvlt4Un3jdKWv3CWe7F9utXCFlvEGajNtnocuo1Oa
 VnRR3vEETeNbwhiF7IU2dZgeKXA4wTAPGgPestIFw71DZFie1tcAqF6hr9HJhPrSeYDKXTJ9f5Jv
 jZ6iaFQUyTGOHQ.4lbH2qDNabRkLsjpVbMr1Ac34ybtuNp94ddE4JN9LDgz0iE_ydBDzxqvpcSwB
 AJwMKus1Rnc2IPsxry8am4yV8HpSATZhJyrC84xRinldEAZzbEFKQxWs7kI5nTfFTS1VkRf.XJam
 YKn4KK3kXV_6Q3BQu9MBn5XtRchX_BtgKnWw1uV4vmrxwWJJD2s2zEf8WjkWypPjS9BY_IBhT3vC
 m6Q--
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.gq1.yahoo.com with HTTP; Wed, 13 Jul 2022 19:23:02 +0000
Received: by hermes--production-bf1-58957fb66f-c5dsp (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID be5fa1fef9434c2588515f43cf87c2ec;
          Wed, 13 Jul 2022 19:22:58 +0000 (UTC)
Message-ID: <4e74aae6-7d8c-15ed-c571-b797239374cb@netscape.net>
Date:   Wed, 13 Jul 2022 15:22:57 -0400
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
In-Reply-To: <56a304ad-606f-6d33-bd2b-8c614fcdb666@netscape.net>
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

On 7/13/2022 3:07 PM, Chuck Zmudzinski wrote:
> On 7/13/2022 9:45 AM, Juergen Gross wrote:
> > >> On 7/13/2022 6:36 AM, Chuck Zmudzinski wrote:
> > >> And in addition, if we are going to backport this patch to
> > >> all current stable branches, we better have a really, really,
> > >> good reason for changing the behavior of "nopat" on Xen.
> > >>
> > >> Does such a reason exist?
> > > 
> > > Well, the simple reason is: It doesn't work the same way under Xen
> > > and non-Xen (in turn because, before my patch or whatever equivalent
> > > work, things don't work properly anyway, PAT-wise). Yet it definitely
> > > ought to behave the same everywhere, imo.
> >
> > There is Documentation/x86/pat.rst which rather clearly states, how
> > "nopat" is meant to work. It should not change the contents of the
> > PAT MSR and keep it just as it was set at boot time (the doc talks
> > about the "BIOS" setting of the MSR, and I guess in the Xen case
> > the hypervisor is kind of acting as the BIOS).
> >
> > The question is, whether "nopat" needs to be translated to
> > pat_enabled() returning "false".
>
> When I started working on a re-factoring effort of the logic
> surrounding pat_enabled(), I noticed there are five different
> reasons in the current code for setting pat_disabled to true,
> which IMO is what should be a redundant variable that should
> always be equal !pat_enabled() and !pat_bp_enabled, but that
> unfortunately is not the case. The five reasons for setting
> pat_disabled to true are given as message strings:
>
> 1. "MTRRs disabled, skipping PAT initialization too."
> 2. "PAT support disabled because CONFIG_MTRR is disabled in the kernel."
> 3. "PAT support disabled via boot option."
> 4. "PAT not supported by the CPU."
> 5. "PAT support disabled by the firmware."
>
> The only effect of setting pat_disabled to true is to inhibit
> the execution of pat_init(), but it does not inhibit the execution
> of init_cache_modes(), which is for handling all these cases
> when pat_init() was skipped. The Xen case is one of those
> cases, so in the Xen case, pat_disabled will be true yet the
> only way to fix the current regression and the five-year-old
> commit is by setting pat_bp_enabled to true so pat_enabled()
> will return true. So to fix the five-year-old commit, we must have
>
> pat_enabled() != pat_disabled
>
> Something is wrong with this logic, that is why I wanted to precede
> my fix with some re-factoring that will change some variable
> and function names and modify some comments before trying
> to fix the five-year-old commit, so that we will never have a situation
> when pat_enabled() != pat_disabled.
>
> Chuck
Sorry, I meant to say,

To fix the five-year-old commit, we must have

pat_enabled() != !pat_disabled or pat_enabled() == pat_disabled,

and there is something wrong with that logic.

Chuck
