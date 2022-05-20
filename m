Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3059952EE71
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 16:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350471AbiETOsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 10:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350449AbiETOsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 10:48:39 -0400
Received: from sonic311-23.consmr.mail.gq1.yahoo.com (sonic311-23.consmr.mail.gq1.yahoo.com [98.137.65.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CEC178563
        for <stable@vger.kernel.org>; Fri, 20 May 2022 07:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1653058092; bh=ecCcTHN/2j4q/asbW1Ibk0Ydf5EAE/ER3GPAGku96ZU=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=V5Km9I73HM6lcClKrScegsgse2K1Ln3SjsBPv1aMWQ9T87bh3PN50zbhFTUcYWUyJsxNtOcx4Tdy4o2qTC3k8i1nzCC/1SQAjaxm6907o/l2alW3xIrrU99hZLWsYvXLbheRM9tr24udXqbEHwRhxFB5z3b5GvxeR6TNkESmHXhC3yVxITW3jia5zhG4VOqSc0MYcBccO56yuu6gBP7/7Jny3L1AeMhK8pqM8AqtHYHXasG2WyGa9XYHiw+rXTTLHnzwoujL6wl7o1stsjmgUXu5IEZllgxPjNDzCy0DLTHkYYJBMAhJ9yHjEPoIJd0+3JcDChcFubCCah064djHGQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1653058092; bh=1416R1MSilgHvGCcGyrPm+pAtivsYRo3q2jSqmtVs4p=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=a0wy3XomK2RIu10QB1d+2AbN66Dwn3907IbWEmhPwx7R4Eq11VjmR/4uTPPmGX1M+otf3iOHAR5GFP6Lc5P/vFLSsuvjLWYQ+YcBUEOXUxJ9jIcJ2hPLdcTRDid9OILOy+xEe+dfE1IImXuvFtcu0oM5O1d5Tw7cAujsnh3LZnFkgOhXVhhC/G2zW2gfWM3zYP+AR3fVIeOjO67Wnw2epaV2YXTfH1vfu8nb2/2D+Q2548eFNOfsC4gFCKjYiFMqXZa/6Kf5XsRNi/oCT8XOCjz+ENDVOelRfY4VIkOPiVB5Y/dfy7u0/w/rsgxTN92OaGK4pew0bd9xzn/fwvDn2A==
X-YMail-OSG: CognXTYVM1mBbBhkscyikIDMCD.HbAwkk9KcwGjyFdhGad70Vp9S4rJw8emke6o
 IadPBPyjgB.UYI9T2IpafdwJtql4v.Ten95hLNwkOQ3XJ89iZBX7wc2rokVFq6alSPFuWozDPiEN
 vCaIXvSSAf8SPRn.lHV608fPmsKXxa6aD_iY07ab22dpRHpmQ0yVGRArmy4LCTB4lPu9Y.AByd6O
 CjBQEccInr.pq4o9Fq72vHWRM1KhqP0mKBI6nD8xkHtH3fnlkV4ZZypomHm4wSZEpcnlbocyAHRE
 beXkAkQ4lw3.cy_3bC1FhGok.uj_FvBxjELV4wwlA.uzhNYek5GulSuLCmOUrTmDswvebMqsYWhf
 4t0qU_1UU9kbSrsT_Q4Nbd9gtEzTq1IZOu6ZWCz2WPNlF2rLTv13HV4t2x5gEMwZl0Z1VlZV5Lur
 qKRi5kGKk_ln5GVZIijB_8B5ZWUpJcagYHl_IPLrhbobXtKpiIu.nZqyNFqL64aCWArE7aD3ZwA.
 J6KKYUSWbyaoYDNOGewS.x452v_48cz5ySnYwehpOkxr1XEGhOTxdFT2hXf3cPnQp.MSQ4mPrKqB
 y1MmhUS1ERehmAnVcVf5p.Mk9dy0Cd9lPi8PDfjMijx3tsYIfo3R.m3a90XBqIy53y20xhUKAaUk
 TIJPAA0hACeWfWCiEtNSv3M0N8iJjCsMlKvD9L9udu2yWQPdZZHoICfQJdzJUiRN8M_Kvi1fNT2i
 HJYJ9cinElHIrQ9uDV06LcBgh84JMX20zaI63qxG4HZ35SFo9ywQFly0kg0GCrdHX6UGZ40sSwLr
 5lomXwKBXH639KT8mB3TK3E7QQOWe40aQn2N.6HopoeT4oD4GSp4Z7b7JTYCeILAZhnOofcNb6qc
 szI91EsG3HtkgNiAQN0s4_LyBF4kaMtqzKrQtJK5suBIwBxfIKCG1SbvoRbW30HNvWNPXVmrVK8.
 .Au_lT0pRPnU765iJFLQrQZBk4kHz.wJNWZL_YrEXnS3Lj24b99svP1K06kOrSWHGjVy_LFAlZ8O
 plK74HCEWUyGv1soi1FOPho.b_gIr.TztkYrW_UD9nazEM3PKC97zeITCl1LfpxSSm.oXXdfmpNJ
 5xbv9nj8ya.afEQOAjtHSBM9fwCAqIidUIjmNtObQ4MatwwAkK3WBy.MmqYo93EBGZcfmGNJn33U
 AyFz3aNeMnrJI22H2l3s.Xg890wHiYoE19NFYafwShYhzBFIeXyt5Wn2HdcJU7XFzgvEtDZAmnZp
 OWBx0O1C4oOWZOt7q3_bK7U7Sfzl9_Cq79DbM.y.eQNtOn8dE53DvcImOrDmKhnfHFtDM12PCTGK
 GifZem8uVelcKbxmS0ronycKSCm2dDgRdHmk_fFiLHMVQO8xVP4cBxXon3aCO6R2TjvTNwGHOtgX
 sDyxLhMmlIdyGoH9EftcN47sVQjWaCZM2q3VB7xAAw47jx1HYAUBhSiGxIn.qO8RNyH2nqPgIuCr
 Lsz3lxwqEyyIPg4GghZJpjvhXx76jr.zBbJY9_7AtaPwy5EorSfZri1dzroZfBBUr9MvECPpyJho
 3qc0ukWBKPETtoeJKQigVHCM2JXvXXSzc8jMYopkroLsIY6XoHOfTcs0ybwhKCR33dYE50fADwam
 urxAV1HDmAVOzkp8qwVUdCmGsJncWAtxcr7irczuoDjHg5748lxbUei1H19CuEQvp8DAend46AkB
 F9SAELzuheoDtw5PNiFbLc4boQ.1pmTdNyAkpEO.JqfJBJM9_7eyo7jyGLv86XRo0LElyCSPRlMA
 pHPu.yAd0POvmZVwASiBFft_HlJ6YifEn1PrKVki.Tlcm2Yyy0JIcgf4y8HgykDSgoaJkvb6cUV0
 _lReh7YYWUmRnfupI5WKFGZIKzdsneWYaf2PYaa0tdsSpFqjbcyqULIZqMQQ2FsLaPcXae8rFMtK
 esbxwSnjHTrUU_TYwgo9LQ3SecCKX898bJI9zSqkfsbPCmulbBe51YrLOo3bVgXQlNdYnZ8ZXuAA
 7d6StWniR5am85XcuHYHVnsTBy6HATG9lof.vN9_gOYz1Uc3unzH5X2oRNMUn60.1OutX_a.3C3I
 fslrQ5_hoGLrM8q18R30AVAeasZotvwNelCtIBQp1mRFdzu...V5AWqFTumIv0JvwQ9oWRti3D3M
 9cIv7aSmzUc0XP9HW1RySUWFrz6.CEwvs1THMNMKxwe.SUAcwRUfwdmsSGUnxSIsX0Ak5QCoyOvF
 37O0c9fpbWNCP
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.gq1.yahoo.com with HTTP; Fri, 20 May 2022 14:48:12 +0000
Received: by hermes--canary-production-bf1-5d4b57496-n4p64 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID d77aeccd90ab3900c3b3abd94bd345b8;
          Fri, 20 May 2022 14:48:08 +0000 (UTC)
Message-ID: <b2585c19-d38b-9640-64ab-d0c9be24be34@netscape.net>
Date:   Fri, 20 May 2022 10:48:06 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 2/2] x86/pat: add functions to query specific cache mode
 availability
Content-Language: en-US
To:     Jan Beulich <jbeulich@suse.com>, regressions@lists.linux.dev,
        stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Juergen Gross <jgross@suse.com>
References: <20220503132207.17234-1-jgross@suse.com>
 <20220503132207.17234-3-jgross@suse.com>
 <1d86d8ff-6878-5488-e8c4-cbe8a5e8f624@suse.com>
 <0dcb05d0-108f-6252-e768-f75b393a7f5c@suse.com>
 <77255e5b-12bf-5390-6910-dafbaff18e96@netscape.net>
 <a2e95587-418b-879f-2468-8699a6df4a6a@suse.com>
 <8b1ebea5-7820-69c4-2e2b-9866d55bc180@netscape.net>
 <c5fa3c3f-e602-ed68-d670-d59b93c012a0@netscape.net>
 <3bff3562-bb1e-04e6-6eca-8d9bc355f2eb@suse.com>
 <3ca084a9-768e-a6f5-ace4-cd347978dec7@netscape.net>
 <9af0181a-e143-4474-acda-adbe72fc6227@suse.com>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <9af0181a-e143-4474-acda-adbe72fc6227@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.20225 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/20/2022 10:06 AM, Jan Beulich wrote:
> On 20.05.2022 15:33, Chuck Zmudzinski wrote:
>> On 5/20/2022 5:41 AM, Jan Beulich wrote:
>>> On 20.05.2022 10:30, Chuck Zmudzinski wrote:
>>>> On 5/20/2022 2:59 AM, Chuck Zmudzinski wrote:
>>>>> On 5/20/2022 2:05 AM, Jan Beulich wrote:
>>>>>> On 20.05.2022 06:43, Chuck Zmudzinski wrote:
>>>>>>> On 5/4/22 5:14 AM, Juergen Gross wrote:
>>>>>>>> On 04.05.22 10:31, Jan Beulich wrote:
>>>>>>>>> On 03.05.2022 15:22, Juergen Gross wrote:
>>>>>>>>>
>>>>>>>>> ... these uses there are several more. You say nothing on why
>>>>>>>>> those want
>>>>>>>>> leaving unaltered. When preparing my earlier patch I did inspect them
>>>>>>>>> and came to the conclusion that these all would also better
>>>>>>>>> observe the
>>>>>>>>> adjusted behavior (or else I couldn't have left pat_enabled() as the
>>>>>>>>> only predicate). In fact, as said in the description of my earlier
>>>>>>>>> patch, in
>>>>>>>>> my debugging I did find the use in i915_gem_object_pin_map() to be
>>>>>>>>> the
>>>>>>>>> problematic one, which you leave alone.
>>>>>>>> Oh, I missed that one, sorry.
>>>>>>> That is why your patch would not fix my Haswell unless
>>>>>>> it also touches i915_gem_object_pin_map() in
>>>>>>> drivers/gpu/drm/i915/gem/i915_gem_pages.c
>>>>>>>
>>>>>>>> I wanted to be rather defensive in my changes, but I agree at least
>>>>>>>> the
>>>>>>>> case in arch_phys_wc_add() might want to be changed, too.
>>>>>>> I think your approach needs to be more aggressive so it will fix
>>>>>>> all the known false negatives introduced by bdd8b6c98239
>>>>>>> such as the one in i915_gem_object_pin_map().
>>>>>>>
>>>>>>> I looked at Jan's approach and I think it would fix the issue
>>>>>>> with my Haswell as long as I don't use the nopat option. I
>>>>>>> really don't have a strong opinion on that question, but I
>>>>>>> think the nopat option as a Linux kernel option, as opposed
>>>>>>> to a hypervisor option, should only affect the kernel, and
>>>>>>> if the hypervisor provides the pat feature, then the kernel
>>>>>>> should not override that,
>>>>>> Hmm, why would the kernel not be allowed to override that? Such
>>>>>> an override would affect only the single domain where the
>>>>>> kernel runs; other domains could take their own decisions.
>>>>>>
>>>>>> Also, for the sake of completeness: "nopat" used when running on
>>>>>> bare metal has the same bad effect on system boot, so there
>>>>>> pretty clearly is an error cleanup issue in the i915 driver. But
>>>>>> that's orthogonal, and I expect the maintainers may not even care
>>>>>> (but tell us "don't do that then").
>>>> Actually I just did a test with the last official Debian kernel
>>>> build of Linux 5.16, that is, a kernel before bdd8b6c98239 was
>>>> applied. In fact, the nopat option does *not* break the i915 driver
>>>> in 5.16. That is, with the nopat option, the i915 driver loads
>>>> normally on both the bare metal and on the Xen hypervisor.
>>>> That means your presumption (and the presumption of
>>>> the author of bdd8b6c98239) that the "nopat" option was
>>>> being observed by the i915 driver is incorrect. Setting "nopat"
>>>> had no effect on my system with Linux 5.16. So after doing these
>>>> tests, I am against the aggressive approach of breaking the i915
>>>> driver with the "nopat" option because prior to bdd8b6c98239,
>>>> nopat did not break the i915 driver. Why break it now?
>>> Because that's, in my understanding, is the purpose of "nopat"
>>> (not breaking the driver of course - that's a driver bug -, but
>>> having an effect on the driver).
>> I wouldn't call it a driver bug, but an incorrect configuration of the
>> kernel by the user.  I presume X86_FEATURE_PAT is required by the
>> i915 driver
> The driver ought to work fine without PAT (and hence without being
> able to make WC mappings). It would use UC instead and be slow, but
> it ought to work.
>
>> and therefore the driver should refuse to disable
>> it if the user requests to disable it and instead warn the user that
>> the driver did not disable the feature, contrary to what the user
>> requested with the nopat option.
>>
>> In any case, my test did not verify that when nopat is set in Linux 5.16,
>> the thread takes the same code path as when nopat is not set,
>> so I am not totally sure that the reason nopat does not break the
>> i915 driver in 5.16 is that static_cpu_has(X86_FEATURE_PAT)
>> returns true even when nopat is set. I could test it with a custom
>> log message in 5.16 if that is necessary.
>>
>> Are you saying it was wrong for static_cpu_has(X86_FEATURE_PAT)
>> to return true in 5.16 when the user requests nopat?
> No, I'm not saying that. It was wrong for this construct to be used
> in the driver, which was fixed for 5.17 (and which had caused the
> regression I did observe, leading to the patch as a hopefully least
> bad option).
>
>> I think that is
>> just permitting a bad configuration to break the driver that a
>> well-written operating system should not allow. The i915 driver
>> was, in my opinion, correctly ignoring the nopat option in 5.16
>> because that option is not compatible with the hardware the
>> i915 driver is trying to initialize and setup at boot time. At least
>> that is my understanding now, but I will need to test it on 5.16
>> to be sure I understand it correctly.
>>
>> Also, AFAICT, your patch would break the driver when the nopat
>> option is set and only fix the regression introduced by bdd8b6c98239
>> when nopat is not set on my box, so your patch would
>> introduce a regression relative to Linux 5.16 and earlier for the
>> case when nopat is set on my box. I think your point would
>> be that it is not a regression if it is an incorrect user configuration.
> Again no - my view is that there's a separate, pre-existing issue
> in the driver which was uncovered by the change. This may be a
> perceived regression, but is imo different from a real one.
>
> Jan

Since it is a regression, I think for now bdd8b6c98239 should
be reverted and the fix backported to Linux 5.17 stable until
the underlying memory subsystem can provide the i915 driver
with an updated test for the PAT feature that also meets the
requirements of the author of bdd8b6c98239 without breaking
the i915 driver. The i915 driver relies on the memory subsytem
to provide it with an accurate test for the existence of
X86_FEATURE_PAT. I think your patch provides that more accurate
test so that bdd8b6c98239 could be re-applied when your patch is
committed. Juergen's patch would have to touch bdd8b6c98239
with new functions that probably have unknown and unintended
consequences, so I think your approach is also better in that regard.
As regards your patch, there is just a disagreement about how the
i915 driver should behave if nopat is set. I agree the i915 driver
could do a better job handling that case, at least with better error
logs.

Chuck

>
>> I respond by saying a well-written driver should refuse to honor
>> the incorrect configuration requested by the user and instead
>> warn the user that it did not honor the incorrect kernel option.
>>
>> I am only presuming what your patch would do on my box based
>> on what I learned about this problem from my debugging. I can
>> also test your patch on my box to verify that my understanding of
>> it is correct.
>>
>> I also have not yet verified Juergen's patch will not fix it, but
>> I am almost certain it will not unless it is expanded so it also
>> touches i915_gem_object_pin_map() with the fix. I plan to test
>> his patch, but expanded so it touches that function also.
>>
>> I also plan to test your patch with and without nopat and report the
>> results in the thread where you posted your patch. Hopefully
>> by tomorrow I will have the results.
>>
>> Chuck
>>

