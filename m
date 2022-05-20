Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3FF52F15B
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 19:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238817AbiETRNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 13:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352077AbiETRNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 13:13:31 -0400
Received: from sonic307-55.consmr.mail.gq1.yahoo.com (sonic307-55.consmr.mail.gq1.yahoo.com [98.137.64.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38B314640B
        for <stable@vger.kernel.org>; Fri, 20 May 2022 10:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1653066810; bh=ZnNjsgwavctM88RO14AtFlicUyxZdGakReSouC7+2Sc=; h=Date:Subject:From:To:Cc:References:In-Reply-To:From:Subject:Reply-To; b=n+nql3SVs5x/p1JjpWauHUSqJi2Pid3hPFdX1IOjez3ueDnN2ynpZ1uff4AEOEVlBp1oX73SN9qaKzy5bthXTVsE5Q9d4a9IEnHuOcezmUTVK5azJrOK6SVklkHBEfUnLvjsTE2EggRm0uhvcqOtZq/izUSoP947Hx3dNNUFBsnl0TTtI58LvFumD53SZpw7hLqCOiHkmXPcybEROQ3BNfVXkGLwEvyqntvYMwH4a6yh2e+VgORaZRSoJSEcxNDXkYdTpKoFTOhk/jWFvcEzwhdt8JkTULXAtvu8Ol6FB7bYWbk11KHQsdnLXb4SCFLry5yVX1U6ZZdFrcFuWFzukA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1653066810; bh=wNWZIHUcsrK1WLhY8BinSDrv8NSUTAF6pz2t2BSqdkk=; h=X-Sonic-MF:Date:Subject:From:To:From:Subject; b=WQXzUPFY0kZ/sFlFlir+Cg8C/PFS4akMMtn43YHi7FDlI2hu8HSfX+kWTvlA9BqF9ASifhMyIaz5J5/qBqRmTeDLFTC99sB4tEx0mx+McpvzAsfDRH4RZukSstgwt0ILBuRzinYU46iY0eNeOw6LjGkeltZfQLabK7WkBlD79n4EGrTvXh7ztoQ9TOM/SgW0MyEDEV+7gvcvPdMyAjr8oL7rRthFMOMsfkymxTIssde9gCmOGgnpSkGtTtAXRWm+uk6dx2HCCYobVBFJoPV3Aq65Z7p5qaHNfCRDAhdpFy4YfoX1MBiTt/Kqb2IcFx1nQ6d+7WfgyfANEbQvHCTlZQ==
X-YMail-OSG: KAivCtcVM1mCPV0sW8DrhJ9VfMC0kqr9SKouDANqbDMh4JOy8BM94.sPxvNph9K
 QOVeWnvlX8AKgKMYjmePNFOu.nIpP0oj6zfeVN4vL6wdKGF3g.O2FqxVEhFza8htb1jgPeN8GRFp
 z1AcC_7jLQDxIk78vIxK9F6LSIBEySwwDlFWgGuasNsSD311EMZKgrrv6anJ0pz.CpIE3baA5Ec9
 H.FGT7RSn5RFLvLB6oysmqb1Rf0b8x1p91kTv2Tg72gEj.sfNtDpaSSdsiwW.B9hWs.ZtwJwMJZD
 B60PqXWd11XS8i46iQwJIqKxW6T5.Q.bVizpjKVjNAQxNHhK7f5mGk46eXmvEQ2CsVarNNE2NlpN
 QRb4VY6551_9rI.UmRe93hpeKDR_N.jsa5KR4e357JDGOSyYHB_cbH5S5yqk7Kn8t..4vdVtkfSP
 7aa7vTbA649lp9Aufed21Wdrmuy8agy93So4MSPcD0NIZjLousYCBg.DoGKFyLm2_Ads9jj8RgWj
 17AsXzc2h..t8syNOhLfyJ0WuiYfALpco8V7e_I7_DaI2pYNcy_0rW3SNMkfEkLFeKlzAvUjlyeU
 V1XGa2fVX8gNvzadocGKwCHyWzsXxhvcdL3GIDULCpRM2CSF.zQAtvJwm7L.emeweBgdRvW8w.qi
 GvB4.zZNCTWToCpfC.Kb9qUi0YNlt6ZNo.vCkIIZ9bMHaEhCYJ.rDI7NoDAkqFdCK41W9OeHWAgK
 YxTXAEynDjY11i1Rx_I_tBpAyATAZcU_TZs7m0XCqsnNxB0WanRB.7EZpSsrIzRaMhNics2aWzcQ
 XShu4AnAF8kbLE_E1WaD1JDFUnhMRJQZJfifBDDavfs4JEqqCSgdtjwoxLDFj0q5oPMQVxIGZxW.
 bNTFLwYny54uAloS6aMwZ3468rJtJ43dIFw5Hu10hUkz9JkhPElnLvgoXdCpgzhru_sS6nOG.q60
 SL3SSc6.1jkLEWRKMx1MFDCXuZgWUPHdxt2yQqfBz8HeuzGzF1_EdJjmTAR51NTUcoIPXZ08IIcX
 Rs1ZAQRBENtxeoR_MuELDhPwOExIvT6chIdyPFwLyACv3emk4ia3NN9p.JkmdRjWViWEdIC5RWKk
 XiROu1vujJBcrL06mVSjtuDcSnnYQDkipg5TQyx4p_nkpNzs6YHDmuvTGxrCaZIsC8Z8rPAXFxC8
 mr32xjlD0f2ycT.257FxNdqifkl9Nglcnn4kEwDGF6fVKBJpvRsFXVffOwWbBk8WFjYZkKwxFVC6
 jtftteVcZhBBZxRReIwN4TTVcxGmdErABPaLOCvx3lR9fPUtQQGZECjd537lAY993_32ILIZcP6M
 pIdNBwGZTflmkl80sZl_xSiuN17GRs9xQouAct2oCZ2_UmVxTBm51b92rPbKIC0nIlALSIVhh7SV
 k.cBYGvg8YiOJnDoy54TL4amAy9mIAkm1tAg5fUIqHmTbBYEIPgyRLIG04Q9GUmK1PdgwyXXdPwJ
 8D4jbSmROS2dEkl5G_koSZGrEo5KIb_0zd64JlfRfFw4viJG4p80.ML29G7EPPjvEcXRyIL_C.X9
 M0jmrz1BPbTyMk7WBuI.g7l4Jro1NnfQOUhZkaDJHrqI95mBVuAjwxK._iGO9grdcDgarAA7saQp
 aB.oIRm.5l1KuYPt4wdA4AUeL6dyhKgsGnZkzkUeW0EkPMXEYmn.V4ZzYMiZK0eX7YKXn2BtZn4h
 ybM1UP3FTn4gBhA5qaoxEqtB9mLZJI1oCuFZOMVOJ1Bli_DT2k35zrft0GYPDp9_81hrCd7uikC2
 aRPMFtk9jKm1kxWb5JAVWYlH4ZdIJbvBqwdbU.teWpLEDQCzh6HIUkV0Mz0r6BAYPgife.5CoSNC
 xzr.NykytrT5B4eAksJFS87RIc_WL.220BSArWY8xFREq.hDOr3DQPYdnDJnPfJQ0xnEoWhsHvLw
 SKM42_M.5G82UvbhKeT06C1FoKYd3c.u0oswpPmDMhxdaSYg1LMEmdMCiyVFlKPTUddDryOcCS7p
 rlAledo3h0VluSYgEa9A17iitnUWLkI3.e3qY0M54FoiBYLKJEyXq.O2_omUN6vb5xhWoe342WSh
 EEyL0fFZYmh6iFujwJBYGDoIz_jGHI29m5epp4KsYEFSzRGOxlfhNYmf0E__EWJfRNNx9rr02y.p
 OP.Aosei6Nspa4dpNYZHEPp1ODfTIjdU_tHQWqFxRRB52wSjQKe7gJR6x4IKYADpcRGkhNkxqNec
 MhARqDbTWKM6MVg--
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.gq1.yahoo.com with HTTP; Fri, 20 May 2022 17:13:30 +0000
Received: by hermes--canary-production-ne1-5495f4d555-vwstm (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 931cede65a94a3eeacd5e1369d2ebbf5;
          Fri, 20 May 2022 17:13:26 +0000 (UTC)
Message-ID: <0a2e61ea-a73c-bbdc-e7c7-5110162b39bb@netscape.net>
Date:   Fri, 20 May 2022 13:13:25 -0400
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
In-Reply-To: <3efb9e54-b0d6-36db-c1c4-68d4f8f9a5ed@netscape.net>
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

I think this summary of the regression is appropriate for a top-post. 
Details follow below.

commit bdd8b6c98239: introduced what I call a real regression which 
persists in 5.17.x

Jan's proposed patch: 
https://lore.kernel.org/lkml/9385fa60-fa5d-f559-a137-6608408f88b0@suse.com/

Jan's patch would fix the real regression introduced by bdd8b6c98239 when
the nopat option is not enabled, but when the nopat option is enabled, this
patch would introduce what Jan calls a "perceived regression" that is really
caused by the failure of the i915 driver to handle the case of the nopat 
option
being provided on the command line properly.

What I request: commit Jan's proposed patch, and backport it to 5.17. That
would fix the real regression and only cause a perceived regression for the
case when nopat is enabled. In that case, patches to the i915 driver
would be helpful but necessary to fix a regression.

Regard,

Chuck Zmudzinski

On 5/20/2022 11:46 AM, Chuck Zmudzinski wrote:
> On 5/20/2022 10:06 AM, Jan Beulich wrote:
>> On 20.05.2022 15:33, Chuck Zmudzinski wrote:
>>> On 5/20/2022 5:41 AM, Jan Beulich wrote:
>>>> On 20.05.2022 10:30, Chuck Zmudzinski wrote:
>>>>> On 5/20/2022 2:59 AM, Chuck Zmudzinski wrote:
>>>>>> On 5/20/2022 2:05 AM, Jan Beulich wrote:
>>>>>>> On 20.05.2022 06:43, Chuck Zmudzinski wrote:
>>>>>>>> On 5/4/22 5:14 AM, Juergen Gross wrote:
>>>>>>>>> On 04.05.22 10:31, Jan Beulich wrote:
>>>>>>>>>> On 03.05.2022 15:22, Juergen Gross wrote:
>>>>>>>>>>
>>>>>>>>>> ... these uses there are several more. You say nothing on why
>>>>>>>>>> those want
>>>>>>>>>> leaving unaltered. When preparing my earlier patch I did 
>>>>>>>>>> inspect them
>>>>>>>>>> and came to the conclusion that these all would also better
>>>>>>>>>> observe the
>>>>>>>>>> adjusted behavior (or else I couldn't have left pat_enabled() 
>>>>>>>>>> as the
>>>>>>>>>> only predicate). In fact, as said in the description of my 
>>>>>>>>>> earlier
>>>>>>>>>> patch, in
>>>>>>>>>> my debugging I did find the use in i915_gem_object_pin_map() 
>>>>>>>>>> to be
>>>>>>>>>> the
>>>>>>>>>> problematic one, which you leave alone.
>>>>>>>>> Oh, I missed that one, sorry.
>>>>>>>> That is why your patch would not fix my Haswell unless
>>>>>>>> it also touches i915_gem_object_pin_map() in
>>>>>>>> drivers/gpu/drm/i915/gem/i915_gem_pages.c
>>>>>>>>
>>>>>>>>> I wanted to be rather defensive in my changes, but I agree at 
>>>>>>>>> least
>>>>>>>>> the
>>>>>>>>> case in arch_phys_wc_add() might want to be changed, too.
>>>>>>>> I think your approach needs to be more aggressive so it will fix
>>>>>>>> all the known false negatives introduced by bdd8b6c98239
>>>>>>>> such as the one in i915_gem_object_pin_map().
>>>>>>>>
>>>>>>>> I looked at Jan's approach and I think it would fix the issue
>>>>>>>> with my Haswell as long as I don't use the nopat option. I
>>>>>>>> really don't have a strong opinion on that question, but I
>>>>>>>> think the nopat option as a Linux kernel option, as opposed
>>>>>>>> to a hypervisor option, should only affect the kernel, and
>>>>>>>> if the hypervisor provides the pat feature, then the kernel
>>>>>>>> should not override that,
>>>>>>> Hmm, why would the kernel not be allowed to override that? Such
>>>>>>> an override would affect only the single domain where the
>>>>>>> kernel runs; other domains could take their own decisions.
>>>>>>>
>>>>>>> Also, for the sake of completeness: "nopat" used when running on
>>>>>>> bare metal has the same bad effect on system boot, so there
>>>>>>> pretty clearly is an error cleanup issue in the i915 driver. But
>>>>>>> that's orthogonal, and I expect the maintainers may not even care
>>>>>>> (but tell us "don't do that then").
>>>>> Actually I just did a test with the last official Debian kernel
>>>>> build of Linux 5.16, that is, a kernel before bdd8b6c98239 was
>>>>> applied. In fact, the nopat option does *not* break the i915 driver
>>>>> in 5.16. That is, with the nopat option, the i915 driver loads
>>>>> normally on both the bare metal and on the Xen hypervisor.
>>>>> That means your presumption (and the presumption of
>>>>> the author of bdd8b6c98239) that the "nopat" option was
>>>>> being observed by the i915 driver is incorrect. Setting "nopat"
>>>>> had no effect on my system with Linux 5.16. So after doing these
>>>>> tests, I am against the aggressive approach of breaking the i915
>>>>> driver with the "nopat" option because prior to bdd8b6c98239,
>>>>> nopat did not break the i915 driver. Why break it now?
>>>> Because that's, in my understanding, is the purpose of "nopat"
>>>> (not breaking the driver of course - that's a driver bug -, but
>>>> having an effect on the driver).
>>> I wouldn't call it a driver bug, but an incorrect configuration of the
>>> kernel by the user.  I presume X86_FEATURE_PAT is required by the
>>> i915 driver
>> The driver ought to work fine without PAT (and hence without being
>> able to make WC mappings). It would use UC instead and be slow, but
>> it ought to work.
>
> I am not an expert, but I think the reason it failed on my box was
> because of the requirements of CI. Maybe the driver would fall back
> to UC if the add_taint_for_CI function did not halt the entire system
> in response to the failed test for PAT when trying to use WC mappings.
>
>>> and therefore the driver should refuse to disable
>>> it if the user requests to disable it and instead warn the user that
>>> the driver did not disable the feature, contrary to what the user
>>> requested with the nopat option.
>>>
>>> In any case, my test did not verify that when nopat is set in Linux 
>>> 5.16,
>>> the thread takes the same code path as when nopat is not set,
>>> so I am not totally sure that the reason nopat does not break the
>>> i915 driver in 5.16 is that static_cpu_has(X86_FEATURE_PAT)
>>> returns true even when nopat is set. I could test it with a custom
>>> log message in 5.16 if that is necessary.
>>>
>>> Are you saying it was wrong for
>>> to return true in 5.16 when the user requests nopat?
>> No, I'm not saying that. It was wrong for this construct to be used
>> in the driver, which was fixed for 5.17 (and which had caused the
>> regression I did observe, leading to the patch as a hopefully least
>> bad option).
>
> Hmm, the patch I used to fix my box with 5.17.6 used
> static_cpu_has(X86_FEATURE_PAT) so the driver could
> continue to configure the hardware using WC. This is the
> relevant part of the patch I used to fix my box, which includes
> extra error logs, (against Debian's official build of 5.17.6):
>
> --- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c    2022-05-09 
> 03:16:33.000000000 -0400
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c    2022-05-19 
> 15:55:40.339778818 -0400
> ...
> @@ -430,17 +434,23 @@
>          err = i915_gem_object_wait_moving_fence(obj, true);
>          if (err) {
>              ptr = ERR_PTR(err);
> +            DRM_ERROR("i915_gem_object_wait_moving_fence error, err = 
> %d\n", err);
>              goto err_unpin;
>          }
>
> -        if (GEM_WARN_ON(type == I915_MAP_WC && !pat_enabled()))
> +        if (GEM_WARN_ON(type == I915_MAP_WC &&
> +                !pat_enabled() && !static_cpu_has(X86_FEATURE_PAT))) {
> +            DRM_ERROR("type == I915_MAP_WC && !pat_enabled(), err = 
> %d\n", -ENODEV);
>              ptr = ERR_PTR(-ENODEV);
> +        }
>          else if (i915_gem_object_has_struct_page(obj))
>              ptr = i915_gem_object_map_page(obj, type);
>          else
>              ptr = i915_gem_object_map_pfn(obj, type);
> -        if (IS_ERR(ptr))
> +        if (IS_ERR(ptr)) {
> +            DRM_ERROR("IS_ERR(PTR) is true, returning a (ptr) error\n");
>              goto err_unpin;
> +        }
>
>          obj->mm.mapping = page_pack_bits(ptr, type);
>      }
>
> As you can see, adding the static_cpu_has(X86_FEATURE_PAT)
> function to the test for PAT restored the behavior of 5.16 on the
> Xen hypervisor to 5.17, and that is how I discovered the solution
> to this problem on 5.17 on my box.
>
>>> I think that is
>>> just permitting a bad configuration to break the driver that a
>>> well-written operating system should not allow. The i915 driver
>>> was, in my opinion, correctly ignoring the nopat option in 5.16
>>> because that option is not compatible with the hardware the
>>> i915 driver is trying to initialize and setup at boot time. At least
>>> that is my understanding now, but I will need to test it on 5.16
>>> to be sure I understand it correctly.
>>>
>>> Also, AFAICT, your patch would break the driver when the nopat
>>> option is set and only fix the regression introduced by bdd8b6c98239
>>> when nopat is not set on my box, so your patch would
>>> introduce a regression relative to Linux 5.16 and earlier for the
>>> case when nopat is set on my box. I think your point would
>>> be that it is not a regression if it is an incorrect user 
>>> configuration.
>> Again no - my view is that there's a separate, pre-existing issue
>> in the driver which was uncovered by the change. This may be a
>> perceived regression, but is imo different from a real one.
>
> Maybe it is only a perceived regression if nopat is set, but
> imo bdd8b6c98239 introduced a real regression in 5.17
> relative to 5.16 for the correctly and identically configured
> case when the nopat option is not set. That is why I still think
> it should be reverted and the fix backported to 5.17 until the
> regression for the case when nopat is not set is fixed. As I
> said before, the i915 driver relies on the memory subsyste
> to provide it with an accurate test for the x86 pat feature.
> The test the driver used in bdd8b6c98239 gives the i915 driver
> a false negative, and that caused a real regression when nopat
> is not set. bdd8b6c98239 can be re-applied if we apply your
> patch which corrects the false negative that pat_enabled() is
> currently providing the i915 driver with. That false negative
> from pat_enabled() is not an i915 bug, it is a bug in x86/pat.
>
> Chuck

