Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E530573469
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 12:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236080AbiGMKhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 06:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiGMKhG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 06:37:06 -0400
Received: from sonic308-54.consmr.mail.gq1.yahoo.com (sonic308-54.consmr.mail.gq1.yahoo.com [98.137.68.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C1FFD51C
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 03:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657708623; bh=TC1YZJRZ1HK+fEyY7YDkLkdLYwW/HtLekVLODCURuoc=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=CRq6hwaUkxj1cqg4bN+xsmARZxQn57v3O4MbQk4T/NrjoW1rWoUKNv3VPLhbZS02xI5YT0ImAsXG+IRSlSixQyqMPDe51+zj5bi+A/bDqjryfpLwatNJcJzQDWa77ZRQf0lWYOY0SLwg7R6IS/68q/5MDdY1QzJC7ytl/AaU84n+fgN63mkDcCaF1kqYYyL5gP2qyDJ+CRwN8rWGGkHnzGlK2VdZtK0UVKMi5ZmsE7UazwyTAGLmURX/TZtXyNWd0fTIuMwvjN64Zb+gid7cFby40fw+qQ7FEBeNjYW/c0CfI7OlYUE0KA3ZYT16iJu+CZGRNSqIFk+XCr04KMMDng==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657708623; bh=1aKOJ3rqFl3/Xk516KhFG2RmtNCAOe5ux/yPgO41wBf=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=FceTnK+kUr5uVObmwGpy68/wPTIOPw+h0JrlrMPrvUKTjYqVUCwNvgIJrdwkI/fcGNqfxjhFilSQLmaPO02Rg5qtoV9ftQAFC1TdnUW0z7nkzL3aJVofMg/LDX6ROrhnsY2WRwN57W15KlU4HIJn0+Ez87QfBL+6J+RyJJUkyuAd+1VOeOnxzTx2ORSebheMhjoGw/Yuk3VgPxbXyYJ0cPaiVbKg9lGY9JSLPI8EDb307QMbIPYezl9nWXsZqiD2Lg0Hiq4V5MYwb/gxVoVyu9/sQMu3hPR1jqlOwiCkVsr0Ud+bl+chNz+UEtEahbsGpofSo6kYTeDpqi2UDoY6jA==
X-YMail-OSG: Ejjps90VM1lhpOImESIgbi_Y8Kj5j50KHq3kji2wF8n.kpmmQ5ufuj2EAGBzXDA
 txgPZZUj4zT2vj6aL5SQplr6m6E3urlCLzOXDkgSFZcjBAJyX0OIJkEY8k4_NtvQ0nhwXJvIf8Qa
 APoAAzKxQZQBjrYZyg7qCXEm4vYflZXO2gedoLWWC7cIUEdbUgAGMxYn3BWI8U5oOsCdmKx8Hi_L
 YyQnX2_4As0_NJwSmMWbDmSxqIVsZeM9G4y6v1q5yemvb0H3yj1PemCo0F4mcSMwiEfopqcEEA9X
 ByYDndQG0ZU0xZr9nLd2XgCl3HMquLoa.hP8XRrq2kRkYYZjD3qlZB4qbEZlCy4rCQInEzf1f7r8
 hAIGIAAMgz6OUKEcTyGQbIHQ457KBDWN8zUobc_NbWMGo21oA1zv9SC4VMQOdQUf.QaJd_2T8zLo
 b9DJOnKVWrLPtqSjMatoVW2MdF3kR3qxr8OcLAHKkehbG_ufjPjBoAPrEq.tWi5uShWbXTG.xQwl
 9duA9cpvrZJZi_uXVAM5tE04yYpwPTTfsHHPsElcXnf5Yh.b0buikXHQZRJh0vN8ZsArFUfyS_xe
 GKfPabpbtgEFOOOOzmdhY5uNFU57117STzzeYiOyy0RU8s6lD6f.WLlBUoAiT5JqQMjrt7oIT2XO
 W5Miej55.W_JcXtWvTV.5l6s3g01DZGNpSLCWnWX1AfEuuqd2sn6SfIigZwscdxxTH4AVCHC27X6
 58jLsk_869806ARiOoD9oO3CjVoUU35YK6erD4._CwBpQ_h4ZhRZN77gYTpJ3Bqw1zoUd5Fvkw8M
 PcbjaYWHIiL5B9rQUsa4_jSsrolNbLSRoAIZD3UfIdvz2uwKNHW.CQ_8ELqxccgr8BF02FEH4UDI
 uZs_RCKYPOTPfLO7DC7xHVHFcSeslBvYwMIfM5hPro.rG9phfInxLb1uoPoVoAbf0bWMzOUZlZEz
 nrMCmf4o4o4FvsrY8DDGDWF37PQS3sA9eGrEGh45xrCvVnG27PHECxz8SAjHNmhNaLd__sEPkkct
 yupoS1I7Zi6IxGgX.WeeEQN5Jg_2lCoqAL8GFBiovIcxc0B3ZhusU3hndfLo1mh7DM3MTApsoail
 4WK_dZlqSrUM5aUnptvVDhzqwiQ6duLD9UEqNC8whmEXaxaxBRGYyg7U0LA94yhOtacbI9sunwIh
 g8sbLZpoY.Qt6zz2aqdnKoIPAIeRq.14Kfm3KFEcuAgKp48yeJtwOm2Ms9aCuvlQgAO60zIUSR0L
 Tom79xYEhYkNWk_ZGSTQ_tc64A.VWnRcFNG78Mkrym7VeStPiUG8LmhcxPe0GmAkbXu66qy.Zkj9
 AYa9L0Vr74uCFv6RpSQSLVC2xtPmq9v5RnE0hxOvzlKiVPRHtra6vxLNDxtbBNdrpjAxdcQUSAm0
 qUTUfuJmp0qRkRgRrQoW6mvQE9cmFZW_BNJowz8.FDIzw7YsjIi4M96cRPs_jU5MpIu8jNkYnkKn
 OtlYbeKpjfRBYZAI1yMmgnGhNx_XVH1hcQT2eZtIMK82BFZz3yXNYS2cZ8NQEDSMBITRk3n31buo
 qEQQz7fgLnvCPhXf7pj5Txln9KPGWyyIX9Qu7HtVpzFqJVQ6GUY334kDyxES3yHbrNt8YQYkumMP
 5cqshiiDp8OJzTq.ubHVu1hrizH.wBWXDU1EBfpvLQchi4m9TN89nSsPJmZquIWYhADwMWEqJriB
 _wF9P4mTizm5n4IeJV2QwqgXLheb9jqWrSSpk_q0urw6_Nq5jX67k2upvtJcXq_I_dx67SyUdSxy
 2EheJtuFYg5Uy6XjPPcupE3G05f4bpKEUv7TEU05F15SFyD0F5KBPO5DplhbGrSnRIAyxccyhWBC
 xxpt6ebvLQRy6Yp0HPLT7ARL0wz99_XBjYXRXe3bQvmueYXpmeps9Ilp1bdRhJHOlp6VnFwO8P7H
 SbZ4XmqI.K13yZ9oy4j1Ld2cQXgUCiiwKHIrT5BVYOQ2vmYRKFgrOij_wC27r9no.gq8mYE1XKcQ
 w06axBiPNx739WWXffTQNR5cnI.6py_lf6FkjciSwre9K_LjjoZ8.3ggKMfupxzy8XwBmLObx53T
 EkcL5ex_66shSrx0taOjyYeuEcnnq_FncxsjItWfVKnsmP3wVFvsORdZNeXV1gUWEU31jxAlHpOl
 1K1tJAv8zq01jetlJUMRk3iEb1tyMSJf9n2ZVH6WebYsyytbzTActYzruGY8ID3Geq_EJ48cRL5g
 -
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.gq1.yahoo.com with HTTP; Wed, 13 Jul 2022 10:37:03 +0000
Received: by hermes--production-ne1-7864dcfd54-xmlhn (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 54bb56f5686ec92203ef9b89a04e8860;
          Wed, 13 Jul 2022 10:37:00 +0000 (UTC)
Message-ID: <775493aa-618c-676f-8aa4-d1667cf2ca78@netscape.net>
Date:   Wed, 13 Jul 2022 06:36:58 -0400
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
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <e0faeb99-6c32-a836-3f6b-269318a6b5a6@suse.com>
 <3d3f0766-2e06-428b-65bb-5d9f778a2baf@netscape.net>
 <e15c0030-3270-f524-17e4-c482e971eb88@suse.com>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <e15c0030-3270-f524-17e4-c482e971eb88@suse.com>
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

On 7/13/2022 5:09 AM, Jan Beulich wrote:
> On 13.07.2022 10:51, Chuck Zmudzinski wrote:
> > On 7/13/22 2:18 AM, Jan Beulich wrote:
> >> On 13.07.2022 03:36, Chuck Zmudzinski wrote:
> >>> v2: *Add force_pat_disabled variable to fix "nopat" on Xen PV (Jan Beulich)
> >>>     *Add the necessary code to incorporate the "nopat" fix
> >>>     *void init_cache_modes(void) -> void __init init_cache_modes(void)
> >>>     *Add Jan Beulich as Co-developer (Jan has not signed off yet)
> >>>     *Expand the commit message to include relevant parts of the commit
> >>>      message of Jan Beulich's proposed patch for this problem
> >>>     *Fix 'else if ... {' placement and indentation
> >>>     *Remove indication the backport to stable branches is only back to 5.17.y
> >>>
> >>> I think these changes address all the comments on the original patch
> >>>
> >>> I added Jan Beulich as a Co-developer because Juergen Gross asked me to
> >>> include Jan's idea for fixing "nopat" that was missing from the first
> >>> version of the patch.
> >>
> >> You've sufficiently altered this change to clearly no longer want my
> >> S-o-b; unfortunately in fact I think you broke things:
> > 
> > Well, I hope we can come to an agreement so I have
> > your S-o-b. But that would probably require me to remove
> > Juergen's R-b.
> > 
> >>> @@ -292,7 +294,7 @@ void init_cache_modes(void)
> >>>  		rdmsrl(MSR_IA32_CR_PAT, pat);
> >>>  	}
> >>>  
> >>> -	if (!pat) {
> >>> +	if (!pat || pat_force_disabled) {
> >>
> >> By checking the new variable here ...
> >>
> >>>  		/*
> >>>  		 * No PAT. Emulate the PAT table that corresponds to the two
> >>>  		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
> >>> @@ -313,6 +315,16 @@ void init_cache_modes(void)
> >>>  		 */
> >>>  		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
> >>>  		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
> >>
> >> ... you put in place a software view which doesn't match hardware. I
> >> continue to think that ...
> >>
> >>> +	} else if (!pat_bp_enabled) {
> >>
> >> ... the variable wants checking here instead (at which point, yes,
> >> this comes quite close to simply being a v2 of my original patch).
> >>
> >> By using !pat_bp_enabled here you actually broaden where the change
> >> would take effect. Iirc Boris had asked to narrow things (besides
> >> voicing opposition to this approach altogether). Even without that
> >> request I wonder whether you aren't going to far with this.
> >>
> >> Jan
> > 
> > I thought about checking for the administrator's "nopat"
> > setting where you suggest which would limit the effect
> > of "nopat" to not reporting PAT as enabled to device
> > drivers who query for PAT availability using pat_enabled().
> > The main reason I did not do that is that due to the fact
> > that we cannot write to the PAT MSR, we cannot really
> > disable PAT. But we come closer to respecting the wishes
> > of the administrator by configuring the caching modes as
> > if PAT is actually disabled by the hardware or firmware
> > when in fact it is not.
> > 
> > What would you propose logging as a message when
> > we report PAT as disabled via pat_enabled()? The main
> > reason I did not choose to check the new variable in the
> > new 'else if' block is that I could not figure out what to
> > tell the administrator in that case. I think we would have
> > to log something like, "nopat is set, but we cannot disable
> > PAT, doing our best to disable PAT by not reporting PAT
> > as enabled via pat_enabled(), but that does not guarantee
> > that kernel drivers and components cannot use PAT if they
> > query for PAT support using boot_cpu_has(X86_FEATURE_PAT)
> > instead of pat_enabled()." However, I acknowledge WC mappings
> > would still be disabled because arch_can_pci_mmap_wc() will
> > be false if pat_enabled() is false.
> > 
> > Perhaps we also need to log something if we keep the
> > check for "nopat" where I placed it. We could say something
> > like: "nopat is set, but we cannot disable hardware/firmware
> > PAT support, so we are emulating as if there is no PAT support
> > which puts in place a software view that does not match
> > hardware."
> > 
> > No matter what, because we cannot write to PAT MSR in
> > the Xen PV case, we probably need to log something to
> > explain the problems associated with trying to honor the
> > administrator's request. Also, what log level should it be.
> > Should it be a pr_warn instead of a pr_info?
>
> I'm afraid I'm the wrong one to answer logging questions. As you
> can see from my original patch, I didn't add any new logging (and
> no addition was requested in the comments that I have got). I also
> don't think "nopat" has ever meant "disable PAT", as the feature
> is either there or not. Instead I think it was always seen as
> "disable fiddling with PAT", which by implication means using
> whatever is there (if the feature / MSR itself is available).

IIRC, I do think I mentioned in the comments on your patch that
it would be preferable to mention in the commit message that
your patch would change the current behavior of "nopat" on
Xen. The question is, how much do we want to change the
current behavior of "nopat" on Xen. I think if we have to change
the current behavior of "nopat" on Xen and if we are going
to propagate that change to all current stable branches all
the way back to 4.9.y,, we better make a lot of noise about
what we are doing here.

Chuck
