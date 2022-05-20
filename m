Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC83E52F168
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 19:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbiETRRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 13:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347851AbiETRRe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 13:17:34 -0400
Received: from sonic304-24.consmr.mail.gq1.yahoo.com (sonic304-24.consmr.mail.gq1.yahoo.com [98.137.68.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31A8186299
        for <stable@vger.kernel.org>; Fri, 20 May 2022 10:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1653067052; bh=ca7iPlJkCoStYqyWys5LDO2Gdak2vbwjABNP3QbxdJg=; h=Date:Subject:From:To:Cc:References:In-Reply-To:From:Subject:Reply-To; b=RLP+eUn0luQR8MFMsK/Bu5ozIMe3R3FhPOqzUlCheTcgF25eEhykrJNUvPSs+a0W8xnMrI9rbHzkLZgVpJtbL5TP+M7Ze1WB3ndhlmODjBS/83tU91WiIEv7q+6a/gq3uI8u2FBODzcy8OZmJc3xLlVbRCVGvFowyXb4vUOxf/CFG2TdClzQETllOExsOb34u/KtnpLCvyhJXcnjAnOJ/KtcKn7YR3wMxjOmD7OXZgxcObjquGGwXrWP05Aie06o3y61XbVbs+uOsDt0kGobUDuta2ORf7o4ZE3vmQJnh0MlR32dGuxnxY6MTfFPorKsNJzKPGFrNzwU2c6wHxJwNw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1653067052; bh=7j3FEybidpG6WjHNRSwkmMNeWZDsakO25VD+3F7N2fN=; h=X-Sonic-MF:Date:Subject:From:To:From:Subject; b=kmbnkkNnYg5sOtHb/xjdjF356Lx7YhHBck56jvGr0JFPI3CLpzpkJ1ZWBDvM1n92FHCRZsVb8tB0grNGXH/Es1KqY+cTfsm9CjEAWoadb3HaEiFmiLwKuGG5qhdR8+gCrhWu+8aFTXY5tPdUI31gXXTAD4ZLQVPGnL171CdHkN9ZE9sb94cRfUOIuoG2a5X+4tESTWVwMxK+dcKB/Z2o0GENJYUI6HBnrfR8EBq/JzDVzWCqup4++tV/QzqAHJaZubtqc8QtQ2FOtwG7GFZE0WrlNCLHo9kArDw3iTRi5gmKw9PxptiYnMacMunLO8V5v6zu8XTfEjJYjGIDVv4QBQ==
X-YMail-OSG: H7OfiakVM1mSUOX8IbzsVvdwYO9oiQlgoDHPzQIgieY13RNtcqlf3ffrgLXFLu8
 ZMIugdCyo6V0GHELne5XGXeClyex4va1MyN77hEwq2jv0KS3SO7bb_M1Vd83duLCAfrPVzKFozOb
 YcIYKgw_soHeb4CerZhH5QsT5fpB5zt5dfFpDBfg.spni553wE8rJhgRezws_aP_U26M8LkhDdJF
 gJiUUwWm9fj7FeTtpfcULoF4EG7oANqLNMgMZ9U0J2qlgPcN9SmWeMG43haVPHavlwpS4b7Su2_i
 fbV5NNEa2pt70yItIwncyqm1k4Pzy6BJoKfdBkVJBCG2uspzHLysvCFOeW6jb.IS5D9EeDGDOcPV
 lPp.nZKJQRiUNuIOIZgrOWtXwiZ3JjbUuytT5Yf9O9Yqfi1HY2328fALl9MutLaCZe15UpVnWHbc
 xfspJigMbnWbgmlIW3E69FHPnlqWnunkkVfucABP90PZZ7VJHaHX4CmX_bxdCu0qeLwCdrJl5DNU
 R6EKUiqvC6R8Sbf5b5xxXowWnb9FPUQFvxNcQOf.OowStsZIK51oIFxJpPwu2UOjziXkxNCEn.jn
 LXeQ87r9NRPwn2c_aYfpFO2GH_7mHKB9oPNECRevc4kzflfbBj57nZrsRLTIhxgFgTxhfQMgTL0O
 ueCdodwiGPgxtj2U58Y9diorXJ6AlbjFZgA1lbVf1AqNdT2AvFHSfvw.6FHsO02ewjbXM6QZh0YC
 Phr_zV4wXnF9fombQJPfbb3JFTeTUWSJ83G_0XYyKDdVIf.LGd.eQTpr6abmVwyTwPWgnMyWnt.D
 4dZ2AEnzX6B1biKSHNRVrQaWrQ0mp0NDBgeYCGG6F_TetndAl7a_qZ7gFCErvbFMqaQKeWCBeXGO
 Ev0UmswUVcg.SORIjsr5XRRo1J5Y8sn2Hny35byVnolGAL1omtzpv2BC2dXYOJMxksX9lxzoUhiw
 rrPJYlqY4qAswEz6dM_7S7l_M5KH5vm8FXSJOHi9slxWUvphi.v0af_UwptMiM9A36z7nmZi6X.d
 4Gb9jQ.NSCZaxWu1Bv5u92SFOzTSD2GWza4ZlGwtVBAEwiBIBqK4ZwmD07JPnrWWPFfn.mY7Bwr6
 .cqwBuCJUJOiAOCSV3.mAX3.gM3RUuQ1xU_QPGCTBCBtKD8gW52Yp8l.0N8Wry9XHz6emY.Hqlln
 J8wSBkFwSq6azUKiZNtp1CA9kes7Stwwq1cNoIYUwthnzbD84Mp6wAT2a_.U10MdgXO..qOKaXzq
 IdGRsHQKX.s63.4U_sGMVLPjL2LrMP9nHyV.4vYxJJ8tsEpIfb8O00WVNOMaEXLgSZRPdhR6bZjU
 jQ.lQHx7IAUIvODcXDA.v1gsqok5cMZISxD.va0xMVrNKmzsCz.xA.eUgrJ2PvMYl80KXDGqGX8P
 orH5y_uyMjBPZiTBTOG5pjWx_6EHyglq3SHCJP.Ezpr9NH6tfG6U7GARFx.lqL_8ZFlehPTWHmrQ
 XaN60UihPwGuYhF9np8PS8nVPgt6f6BHjzezx6Z1a..YBsGFFenRdHwejTIVdCrt4v1HxRzWHQ5r
 xYqAwwKlhsbne7PSH5NIELGpSbwBHjww7vl9ZhEtdcji3Rhj8D5DYZlSj.qBxPUIKq5I5nbwydOb
 luZfq7cB5m22fajZUhwe8_1ZQTjqmTZ5V0KF.aeyBo6Pw02R0G.LBzrve7Jk6r3xmndggHaCDhse
 aU1g2pC.ycMbFjoxWsswE_W25RBpDQkHSkREvrMTcXWaNoZ7YuFxXuUm7xATDhGFuLTNm5gVz.u1
 Uc9V2edW286TNHq93GuvbYLUKxYsWu2qjo9E8flfg24wGTioyXtzR4qYs4Z0MUmKel_ztXvuX5Gz
 i2JULnrN3Q04PPsmRd0a2i_O43nWcycPW6IQd5u6mjcgPsvD0RRsGKjZUzbZVobxVet.cExc3taN
 7rndFk6AhHHvRWZWKkWj1ZudFIAnQ5tIjRjEQGCOBge.qFeqp7Orl5eODciqINjUnOepKsK6ndeU
 vG_3hOUVzOTLEiyOo93sEaxe_g7FCfM6cLG6gorqRnZUC27HFuQBIpzjVByfhe.6OPt6oe04wZYt
 SVmFJpwuUVe.VUN5geIHcrLJgvfABoIoW5qZKO3YTnGTR5VDgjojz3_1iVoGCbqoJJ3HpWcQTs0U
 .JiWE0WZa0x3jUi1dZoJRmz97nvCGnpcujPjIL1ZziNDsu0Ep7H7FEVYkKWpnf6iaaYSKU7f_YgR
 MVWkN9jRib.rqmGQ9Iw--
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.gq1.yahoo.com with HTTP; Fri, 20 May 2022 17:17:32 +0000
Received: by hermes--canary-production-ne1-5495f4d555-xbnpg (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 4cde7a491d1a07ad2c7d8298ef77e73b;
          Fri, 20 May 2022 17:17:30 +0000 (UTC)
Message-ID: <3a69fa16-6b3e-e567-818c-30959e50e985@netscape.net>
Date:   Fri, 20 May 2022 13:17:29 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [REGRESSION} Re: [PATCH 2/2] x86/pat: add functions to query
 specific cache mode availability
Content-Language: en-US
From:   Chuck Zmudzinski <brchuckz@netscape.net>
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
 <3efb9e54-b0d6-36db-c1c4-68d4f8f9a5ed@netscape.net>
 <0a2e61ea-a73c-bbdc-e7c7-5110162b39bb@netscape.net>
In-Reply-To: <0a2e61ea-a73c-bbdc-e7c7-5110162b39bb@netscape.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.20225 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/20/2022 1:13 PM, Chuck Zmudzinski wrote:
> I think this summary of the regression is appropriate for a top-post. 
> Details follow below.
>
> commit bdd8b6c98239: introduced what I call a real regression which 
> persists in 5.17.x
>
> Jan's proposed patch: 
> https://lore.kernel.org/lkml/9385fa60-fa5d-f559-a137-6608408f88b0@suse.com/
>
> Jan's patch would fix the real regression introduced by bdd8b6c98239 when
> the nopat option is not enabled, but when the nopat option is enabled, 
> this
> patch would introduce what Jan calls a "perceived regression" that is 
> really
> caused by the failure of the i915 driver to handle the case of the 
> nopat option
> being provided on the command line properly.
>
> What I request: commit Jan's proposed patch, and backport it to 5.17. 
> That
> would fix the real regression and only cause a perceived regression 
> for the
> case when nopat is enabled. In that case, patches to the i915 driver
> would be helpful but necessary to fix a regression.

Sorry again, I mean patches to i915 would be helpful but *not* necessary
to fix a regression.

Regards,

Chuck Zmudzinski

>
> On 5/20/2022 11:46 AM, Chuck Zmudzinski wrote:
>> On 5/20/2022 10:06 AM, Jan Beulich wrote:
>>> On 20.05.2022 15:33, Chuck Zmudzinski wrote:
>>>> On 5/20/2022 5:41 AM, Jan Beulich wrote:
>>>>> On 20.05.2022 10:30, Chuck Zmudzinski wrote:
>>>>>> On 5/20/2022 2:59 AM, Chuck Zmudzinski wrote:
>>>>>>> On 5/20/2022 2:05 AM, Jan Beulich wrote:
>>>>>>>> On 20.05.2022 06:43, Chuck Zmudzinski wrote:
>>>>>>>>> On 5/4/22 5:14 AM, Juergen Gross wrote:
>>>>>>>>>> On 04.05.22 10:31, Jan Beulich wrote:
>>>>>>>>>>> On 03.05.2022 15:22, Juergen Gross wrote:
>>>>>>>>>>>
>>>>>>>>>>> ... these uses there are several more. You say nothing on why
>>>>>>>>>>> those want
>>>>>>>>>>> leaving unaltered. When preparing my earlier patch I did 
>>>>>>>>>>> inspect them
>>>>>>>>>>> and came to the conclusion that these all would also better
>>>>>>>>>>> observe the
>>>>>>>>>>> adjusted behavior (or else I couldn't have left 
>>>>>>>>>>> pat_enabled() as the
>>>>>>>>>>> only predicate). In fact, as said in the description of my 
>>>>>>>>>>> earlier
>>>>>>>>>>> patch, in
>>>>>>>>>>> my debugging I did find the use in i915_gem_object_pin_map() 
>>>>>>>>>>> to be
>>>>>>>>>>> the
>>>>>>>>>>> problematic one, which you leave alone.
>>>>>>>>>> Oh, I missed that one, sorry.
>>>>>>>>> That is why your patch would not fix my Haswell unless
>>>>>>>>> it also touches i915_gem_object_pin_map() in
>>>>>>>>> drivers/gpu/drm/i915/gem/i915_gem_pages.c
>>>>>>>>>
>>>>>>>>>> I wanted to be rather defensive in my changes, but I agree at 
>>>>>>>>>> least
>>>>>>>>>> the
>>>>>>>>>> case in arch_phys_wc_add() might want to be changed, too.
>>>>>>>>> I think your approach needs to be more aggressive so it will fix
>>>>>>>>> all the known false negatives introduced by bdd8b6c98239
>>>>>>>>> such as the one in i915_gem_object_pin_map().
>>>>>>>>>
>>>>>>>>> I looked at Jan's approach and I think it would fix the issue
>>>>>>>>> with my Haswell as long as I don't use the nopat option. I
>>>>>>>>> really don't have a strong opinion on that question, but I
>>>>>>>>> think the nopat option as a Linux kernel option, as opposed
>>>>>>>>> to a hypervisor option, should only affect the kernel, and
>>>>>>>>> if the hypervisor provides the pat feature, then the kernel
>>>>>>>>> should not override that,
>>>>>>>> Hmm, why would the kernel not be allowed to override that? Such
>>>>>>>> an override would affect only the single domain where the
>>>>>>>> kernel runs; other domains could take their own decisions.
>>>>>>>>
>>>>>>>> Also, for the sake of completeness: "nopat" used when running on
>>>>>>>> bare metal has the same bad effect on system boot, so there
>>>>>>>> pretty clearly is an error cleanup issue in the i915 driver. But
>>>>>>>> that's orthogonal, and I expect the maintainers may not even care
>>>>>>>> (but tell us "don't do that then").
>>>>>> Actually I just did a test with the last official Debian kernel
>>>>>> build of Linux 5.16, that is, a kernel before bdd8b6c98239 was
>>>>>> applied. In fact, the nopat option does *not* break the i915 driver
>>>>>> in 5.16. That is, with the nopat option, the i915 driver loads
>>>>>> normally on both the bare metal and on the Xen hypervisor.
>>>>>> That means your presumption (and the presumption of
>>>>>> the author of bdd8b6c98239) that the "nopat" option was
>>>>>> being observed by the i915 driver is incorrect. Setting "nopat"
>>>>>> had no effect on my system with Linux 5.16. So after doing these
>>>>>> tests, I am against the aggressive approach of breaking the i915
>>>>>> driver with the "nopat" option because prior to bdd8b6c98239,
>>>>>> nopat did not break the i915 driver. Why break it now?
>>>>> Because that's, in my understanding, is the purpose of "nopat"
>>>>> (not breaking the driver of course - that's a driver bug -, but
>>>>> having an effect on the driver).
>>>> I wouldn't call it a driver bug, but an incorrect configuration of the
>>>> kernel by the user.  I presume X86_FEATURE_PAT is required by the
>>>> i915 driver
>>> The driver ought to work fine without PAT (and hence without being
>>> able to make WC mappings). It would use UC instead and be slow, but
>>> it ought to work.
>>
>> I am not an expert, but I think the reason it failed on my box was
>> because of the requirements of CI. Maybe the driver would fall back
>> to UC if the add_taint_for_CI function did not halt the entire system
>> in response to the failed test for PAT when trying to use WC mappings.
>>
>>>> and therefore the driver should refuse to disable
>>>> it if the user requests to disable it and instead warn the user that
>>>> the driver did not disable the feature, contrary to what the user
>>>> requested with the nopat option.
>>>>
>>>> In any case, my test did not verify that when nopat is set in Linux 
>>>> 5.16,
>>>> the thread takes the same code path as when nopat is not set,
>>>> so I am not totally sure that the reason nopat does not break the
>>>> i915 driver in 5.16 is that static_cpu_has(X86_FEATURE_PAT)
>>>> returns true even when nopat is set. I could test it with a custom
>>>> log message in 5.16 if that is necessary.
>>>>
>>>> Are you saying it was wrong for
>>>> to return true in 5.16 when the user requests nopat?
>>> No, I'm not saying that. It was wrong for this construct to be used
>>> in the driver, which was fixed for 5.17 (and which had caused the
>>> regression I did observe, leading to the patch as a hopefully least
>>> bad option).
>>
>> Hmm, the patch I used to fix my box with 5.17.6 used
>> static_cpu_has(X86_FEATURE_PAT) so the driver could
>> continue to configure the hardware using WC. This is the
>> relevant part of the patch I used to fix my box, which includes
>> extra error logs, (against Debian's official build of 5.17.6):
>>
>> --- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c    2022-05-09 
>> 03:16:33.000000000 -0400
>> +++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c    2022-05-19 
>> 15:55:40.339778818 -0400
>> ...
>> @@ -430,17 +434,23 @@
>>          err = i915_gem_object_wait_moving_fence(obj, true);
>>          if (err) {
>>              ptr = ERR_PTR(err);
>> +            DRM_ERROR("i915_gem_object_wait_moving_fence error, err 
>> = %d\n", err);
>>              goto err_unpin;
>>          }
>>
>> -        if (GEM_WARN_ON(type == I915_MAP_WC && !pat_enabled()))
>> +        if (GEM_WARN_ON(type == I915_MAP_WC &&
>> +                !pat_enabled() && !static_cpu_has(X86_FEATURE_PAT))) {
>> +            DRM_ERROR("type == I915_MAP_WC && !pat_enabled(), err = 
>> %d\n", -ENODEV);
>>              ptr = ERR_PTR(-ENODEV);
>> +        }
>>          else if (i915_gem_object_has_struct_page(obj))
>>              ptr = i915_gem_object_map_page(obj, type);
>>          else
>>              ptr = i915_gem_object_map_pfn(obj, type);
>> -        if (IS_ERR(ptr))
>> +        if (IS_ERR(ptr)) {
>> +            DRM_ERROR("IS_ERR(PTR) is true, returning a (ptr) 
>> error\n");
>>              goto err_unpin;
>> +        }
>>
>>          obj->mm.mapping = page_pack_bits(ptr, type);
>>      }
>>
>> As you can see, adding the static_cpu_has(X86_FEATURE_PAT)
>> function to the test for PAT restored the behavior of 5.16 on the
>> Xen hypervisor to 5.17, and that is how I discovered the solution
>> to this problem on 5.17 on my box.
>>
>>>> I think that is
>>>> just permitting a bad configuration to break the driver that a
>>>> well-written operating system should not allow. The i915 driver
>>>> was, in my opinion, correctly ignoring the nopat option in 5.16
>>>> because that option is not compatible with the hardware the
>>>> i915 driver is trying to initialize and setup at boot time. At least
>>>> that is my understanding now, but I will need to test it on 5.16
>>>> to be sure I understand it correctly.
>>>>
>>>> Also, AFAICT, your patch would break the driver when the nopat
>>>> option is set and only fix the regression introduced by bdd8b6c98239
>>>> when nopat is not set on my box, so your patch would
>>>> introduce a regression relative to Linux 5.16 and earlier for the
>>>> case when nopat is set on my box. I think your point would
>>>> be that it is not a regression if it is an incorrect user 
>>>> configuration.
>>> Again no - my view is that there's a separate, pre-existing issue
>>> in the driver which was uncovered by the change. This may be a
>>> perceived regression, but is imo different from a real one.
>>
>> Maybe it is only a perceived regression if nopat is set, but
>> imo bdd8b6c98239 introduced a real regression in 5.17
>> relative to 5.16 for the correctly and identically configured
>> case when the nopat option is not set. That is why I still think
>> it should be reverted and the fix backported to 5.17 until the
>> regression for the case when nopat is not set is fixed. As I
>> said before, the i915 driver relies on the memory subsyste
>> to provide it with an accurate test for the x86 pat feature.
>> The test the driver used in bdd8b6c98239 gives the i915 driver
>> a false negative, and that caused a real regression when nopat
>> is not set. bdd8b6c98239 can be re-applied if we apply your
>> patch which corrects the false negative that pat_enabled() is
>> currently providing the i915 driver with. That false negative
>> from pat_enabled() is not an i915 bug, it is a bug in x86/pat.
>>
>> Chuck
>

