Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC3E52EF9B
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 17:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351142AbiETPrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 11:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238484AbiETPq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 11:46:58 -0400
Received: from sonic310-21.consmr.mail.gq1.yahoo.com (sonic310-21.consmr.mail.gq1.yahoo.com [98.137.69.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44F15BE51
        for <stable@vger.kernel.org>; Fri, 20 May 2022 08:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1653061611; bh=dYvOsYj975WZtAhaXLvp5QnpcOqZNNHInEfhbuG4NHw=; h=Date:From:Subject:To:Cc:References:In-Reply-To:From:Subject:Reply-To; b=Cxjt1KXv3fLQrBLUITJrZ5qC0ekqzxNCzezQ5ytSEnMGtHDbX6Ox96Ul/yob6k7aMsu4LVyXY1lqmakYOHHkiLjcgJfWpTDbRwzkZWrZ9RDcg3zsv8IC4DiEPLeyKhttt+VtJ7iju0oOyWFAFgLdGu/M9aC/D6l7m4oShDyXho0PMK1u35ruEgKUG30iujIAXm8yxwV3ZbQ8in3CCW6E/RIY7iM2OCXOCaw1TGQq8GIEHUDUwB8r4020db4BrDrLJ/PCe6pb9KnC3nleAXLYKLBq+PpGW+G266MZmazeR8ssC8dXQKwBnRe9BQ1yQPuQJuoOgCbOel8/ml9Hw4dGxw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1653061611; bh=H54F1szVjTyLu890ZQRCRRW7CSMdm2B8Nd3tknxxcLq=; h=X-Sonic-MF:Date:From:Subject:To:From:Subject; b=WK1zAniam0y5W1FFnOzY6sfOgAiw64JYID+e+/KodRW5+qoTKbL2ms/9sVdANM1DQy0fhl7dWBpYpqJCNx5f0dhDoKDmhkbQLM8QK491AEmILSNuCNuP8sM5nJFC0nackOix7GpmGQD13uuLqPNB0WBo7KI5sKt3ZhNua7H+pKqeNye8ciWKmmi+Spx1K/sBq8AF3JV1a69qg8LDRv+3bq2QxqrEdo0QO5/ZNskXaLOZiH8+vFV2wp4OvUxHu0X6/+59fC87ZnvJoCO+m4mf/sXI36RF8wcM9YjAhX7n0uutTJxuJylxQd2RBWEd+Cofl4ARY1Heute72T/TIrWdUA==
X-YMail-OSG: HPcVJVgVM1mCYTQXmFkVArz9P8kXrdWw0VJjD7_O8Yt9gLvXdcGoVAgVsnjtVda
 ZcmBU1C4FgvUPaJHDwKfzvVVBkKQgTzbBM.DuWf01x0YT6khsIsczeih1dxtjw54XIPKkiTMj7MS
 uLS5OCgPmIe1XH6N3of6EBVtJObEB2X0Vywtjvybf2GQTYezKturPfx0ShGOOcIRJAr0Xl1r_OUN
 6uLOAljW37OxjurFoRnfgNHjVaGPS9zd8MscSVBhMJA5MDj8YZa7QlPuAsroqL1Zj2cXhwA4SjPz
 14CzkX_y0eCzoJoFlBaOvuIIMuqgibGcIkn.ra3g6p0ycS_HcHDdtHcE_FA8AaJjRPlThlSQCigm
 hU7vW.4rUtP7UgCXcNXAyjCxgJDyVWXXTAuneh0Cv7OGOanofBJRDvU5V2W7OdIkEZu_Ir5vGnVy
 Gi6IJG5mZcwJ8k4xbc6htu3v89neRWHGm3kRJcouYcJT_Hpn8cNKeLkoJd73qshLbNU85Tc5_I6C
 snQXcD.NxE5gzgdSuHtmRsdtML38hiZqUCZt4UCvT8zJE3HP.9SMi4uu.jhaEJRmZJHkilOKzens
 rkd90KNCkt6PGE9.22YoL0BD323ydMHiciQMcDcvg2.OtHYi9jsSzRc2tmNiY26RNJCZehBjMDhw
 RAT9sRAszt0DYBIe00LAsXXiwGtlgoLlLt20TJ9pQRxrGctc90y0iMr2XTErpJPMOfbHYTtLx5w8
 651vi.NqbJ47fzVIS4ZNXnGJxxE7NcstLHQqtaKNrLcp2p8svw70peNxeDnFZEdqwHsDk5ELyJHl
 eJAY58HhEPxZIo0NSyvsTfEbQ8dCOWVQMjeFxYZXecN2nJUgRKh4enit_wzd.zL0eViRdYvfhCyi
 T.10g.zRJCVCU7.bkIfNJttIZSynG4GrxYWm.rHiy.kcxAV0pMZBSubgcSgaLID.l0NDWV4pfBab
 HCcNe1kX_enUO5fr9P.mgi7EwxbVbpeow.ediO1CTrZjSCQ00aflFcvedjhNnGNDZ6e7WYaBhfKg
 rhTHIauqxNDTMC3UEHQUJG08M_Jc.opTYAtDPH56Hqq5775xTqnt7e67UYPlHZl8_ktw1TiwzgSk
 ByF3NVo_A89AgpzJdkREadxZnKXES9heCBBMmDzI4nWG8Bg8JvDU9cs6OFv3yakh_romkCSG.XuB
 EnwcmpVWj2.lESiyvakzJo6k2hua4ETwv19Jpe9Zp0jh5M7Xrq760Bjx5S5gFGJWZI_B0uLCSm1B
 DheQXVfnfKfq_rEtiTIQmeses_ByNA_zdOumFhUlxevE9gMhHB5ZHMZGqPlyTGkwgr9.OjjLygWo
 l0wTmYLOchaI2MDuJdESTpIKMNsxRLLm2uQR7v7S.gA4kooZIZvnB4NP498elRPM3Hr_tMRKlh0e
 onxRhqiJr3zt4egFCEbmA6Fp7UpnMyIv5YUg9L2TKTwT_1cAOq0QbklAhwfcRkvZeOfSw759WG.J
 3HIGUvWvAh7WiR9o5RhqubC455n3SFeVffOCDfBnVsJUajp39jwuHMZYXAFr9pVDwFtyDcvjVpG1
 xbu8Oo3Cxp_PrSHPeuPsqGCzmIgKyTTDmK.F.Oo2q3p.WmFZcNm25pDqRXjx9V2VEUPGeVEqYea_
 LAfZBFlioghP60yOJa3fUE_1b_R6gxymFWVZGS7lcRUeRiL0WUv6iFt8dfgPA56ko5GTkfhL_xxa
 sn1esF85gG41bs6BqSvBGSoduDurGj_vXgGWwJit.iUKiaFi6KlF2xKJXV6ceaNA9Phs6K5L9HdF
 7qR9Krm5wCTL2a0OMsDZfupV9MFz5mnAqoId1Dd3ne5O1JbTAQQ7NBaVUAcV4lGy5sH_2_JMXu6x
 wddkEfnikU8w.offg7WTT0vKU.SRYgR.qwKhfyCAJwYAb5QC2XbLcfI9rKfeCbdQvV9nw6NBKJT3
 BPmOdEsW20ttaQ7ow2lcwXDw6xWCL0AlOA9dqg7JPrF5WNc4PfQuydqPspQwhZtXyr5B8CqrAif5
 SSl3LyW92_ASxvg0GOo1zYWxEq75eID9AY.IH05kiumPkszBAv4LcPhKVrNHt9N2QuTVgHSvoypd
 nhEzsQDVfkmgz7a_bgCcq.cOk1CHQ_K_zaHf2JZeUVtLmVi.0dMxLMxA2b3iwKNpJ_MquaVMtgDM
 wuJHLeKUg89Xspa4iCbfdvlcZTMn.wzNkaPIj.vqmAPJPOwahkX99dPNZrXQzskD0TUf_kdUiBAE
 6NWuemK79OKSy
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.gq1.yahoo.com with HTTP; Fri, 20 May 2022 15:46:51 +0000
Received: by hermes--canary-production-ne1-5495f4d555-xgn59 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 5d25dbe75183c009d9335f93b2057068;
          Fri, 20 May 2022 15:46:48 +0000 (UTC)
Message-ID: <3efb9e54-b0d6-36db-c1c4-68d4f8f9a5ed@netscape.net>
Date:   Fri, 20 May 2022 11:46:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
From:   Chuck Zmudzinski <brchuckz@netscape.net>
Subject: [REGRESSION} Re: [PATCH 2/2] x86/pat: add functions to query specific
 cache mode availability
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
Content-Language: en-US
In-Reply-To: <9af0181a-e143-4474-acda-adbe72fc6227@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.20225 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
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

I am not an expert, but I think the reason it failed on my box was
because of the requirements of CI. Maybe the driver would fall back
to UC if the add_taint_for_CI function did not halt the entire system
in response to the failed test for PAT when trying to use WC mappings.

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
>> Are you saying it was wrong for
>> to return true in 5.16 when the user requests nopat?
> No, I'm not saying that. It was wrong for this construct to be used
> in the driver, which was fixed for 5.17 (and which had caused the
> regression I did observe, leading to the patch as a hopefully least
> bad option).

Hmm, the patch I used to fix my box with 5.17.6 used
static_cpu_has(X86_FEATURE_PAT) so the driver could
continue to configure the hardware using WC. This is the
relevant part of the patch I used to fix my box, which includes
extra error logs, (against Debian's official build of 5.17.6):

--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c    2022-05-09 
03:16:33.000000000 -0400
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c    2022-05-19 
15:55:40.339778818 -0400
...
@@ -430,17 +434,23 @@
          err = i915_gem_object_wait_moving_fence(obj, true);
          if (err) {
              ptr = ERR_PTR(err);
+            DRM_ERROR("i915_gem_object_wait_moving_fence error, err = 
%d\n", err);
              goto err_unpin;
          }

-        if (GEM_WARN_ON(type == I915_MAP_WC && !pat_enabled()))
+        if (GEM_WARN_ON(type == I915_MAP_WC &&
+                !pat_enabled() && !static_cpu_has(X86_FEATURE_PAT))) {
+            DRM_ERROR("type == I915_MAP_WC && !pat_enabled(), err = 
%d\n", -ENODEV);
              ptr = ERR_PTR(-ENODEV);
+        }
          else if (i915_gem_object_has_struct_page(obj))
              ptr = i915_gem_object_map_page(obj, type);
          else
              ptr = i915_gem_object_map_pfn(obj, type);
-        if (IS_ERR(ptr))
+        if (IS_ERR(ptr)) {
+            DRM_ERROR("IS_ERR(PTR) is true, returning a (ptr) error\n");
              goto err_unpin;
+        }

          obj->mm.mapping = page_pack_bits(ptr, type);
      }

As you can see, adding the static_cpu_has(X86_FEATURE_PAT)
function to the test for PAT restored the behavior of 5.16 on the
Xen hypervisor to 5.17, and that is how I discovered the solution
to this problem on 5.17 on my box.

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

Maybe it is only a perceived regression if nopat is set, but
imo bdd8b6c98239 introduced a real regression in 5.17
relative to 5.16 for the correctly and identically configured
case when the nopat option is not set. That is why I still think
it should be reverted and the fix backported to 5.17 until the
regression for the case when nopat is not set is fixed. As I
said before, the i915 driver relies on the memory subsyste
to provide it with an accurate test for the x86 pat feature.
The test the driver used in bdd8b6c98239 gives the i915 driver
a false negative, and that caused a real regression when nopat
is not set. bdd8b6c98239 can be re-applied if we apply your
patch which corrects the false negative that pat_enabled() is
currently providing the i915 driver with. That false negative
from pat_enabled() is not an i915 bug, it is a bug in x86/pat.

Chuck
