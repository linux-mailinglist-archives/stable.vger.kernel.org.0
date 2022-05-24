Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E54533073
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 20:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240343AbiEXScl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 14:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240344AbiEXSck (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 14:32:40 -0400
Received: from sonic317-20.consmr.mail.gq1.yahoo.com (sonic317-20.consmr.mail.gq1.yahoo.com [98.137.66.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1A65401F
        for <stable@vger.kernel.org>; Tue, 24 May 2022 11:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1653417157; bh=bWdvczIx7ry7wZOALAI1wr+HsImsxjNz7PtVMvZvtj8=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=lBrYG59B4NAY+zeSFmHe92QcF1AtKxVljoQibxCKbJeGAH6xT4wrcxRqmVgG+ZOnF/NwJnyx2D2jrxTQFFqcrnsNlQGzqyBr5FBJqtk4pi20bJU2LWH5nt4WpEOYVPfuX/21cWrYreqcQWzIW3bKDCN1zS/9lbxTnCbXPvnX3ZjxQ+R/5bhf6v7zWSSZK5o9Lmxj2GTwf3/bdDZH9StPsPqz35Mce5ne2lTmyWvajx/dMfqjTw4Pj0lYyatwW5y/sJEvGh1y0rOGiz3cyRN3KY927n2ZsoCD++cxgFVxAB7Aa0L9w+gA+GQUMTzOEf1asJoeqnEjrBV3QOonXUDNAw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1653417157; bh=s3RpZhgR4s9uWwhVoE5EIzWfLL3MAfA6mE5D7/0OW9A=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=XrB1Ps2zvpEsObxvQNaMgTqSxGlBkUGvkxRXCc3LJIL9Ix9+giBk514R43WYLmzpvcT5yUIeaeMertglYe0cAsiPxgqXTudWefTGZVv0eZ30RFj1BMIubkW5z362+2jITR0lCNEhFCMWOVm1b7Diio8crHcxT3hUT1uXvdGPOuMzi12PmZ/KNzkksfLObxZNgb8mNiuLxXB2xOV2ysRLkuI6OKzAq6zaS7NP064Ao4o8x+Y7nVk5NQIdd1IYsv8hbUYkpv7YvVUw8bju8kc5/IknnI7C5gDhpfuZwR892FeSehs4tQqExb0gJ94bzSVw6FFnyVrupqGThIPulLOE2g==
X-YMail-OSG: J42Z.mEVM1mppfHkyqWoRpCGB0mXn4dGsrlfQrFalIJjwaJPzLD9X6PbJIQodNc
 I1oX7Jwl3xDkSLGmOgC5IpFTFwncYKvZWjVHTKDLXTLUvGnVEZkhM.cT1_Qe32_VHoIQ3K7QhF_T
 fs2bSdHo8POl2vloU_or9Ynxo84f3n.pglT46gC4Q4zpaZHmvPUxNn0LpHNAkoLizYif2vDzLkDN
 L2J.leqIbGq61xTEGg37LZLVNmrLtecDoe_l80EkYfKzUGob7bKDek3tx3HXFvq4XeZGmXPVBRgI
 x04Y0LzovydetX11xkm9BEmp9VplSympKgWB_sopf7ndo2VPviGMVxPCkUTzdGzmQTHZeuHK0baM
 nwY95HLmK1tKFLfmUIyfsOf5Sh.SoTzGFP6KNI5prw3OwnfgXTEb2Xvn5VkHva.Lbb_hWgKRBi8G
 QY5avLVfQkfBm6rlcpDdAyoFgVQg91OsH0xDDQmw.JUiU_h3O39Vdw6GHo1Z6CSnKa.8mHrCZ2_K
 oC4Ic26g68biMyU7QCQJLoQO3td.jifMKrUOMzd4Yqnl2nus4HtKD5tlFy6mZVRiIQwkfhYnZuHf
 Uh_bh0hSTs6dE5rb7ionVmwIdwcxkEeLN_s_jFj8.TDWfS4oWJGG5yGmLBstw4rdPrCnx9tMoote
 F_KQxur7Sj9Ruo1OK0xckP0ZgJ3f0v.CEkt7kSE0j_ScNJ1v3Q553xBBj6PlyTXa41Q1hTBLmCnl
 wbhkOGD92YNzz.4nG5x2jfC7L2nwVlXI8RAUlPQTj1eqK1Qys5ECNU10auqEMFbXQDaNUdYJQ4tY
 udzuQWNh4CMSf93DwYXh7cOuc5rmERY7rfYkGnbmn2y4MeTBJmyFFo03_p.DSotwbJUAsDBxYdXR
 HeH30PSe8o3Ni0rcOFixzqo8jA3bZ27ISECfahxR1842QNS.3j_Bw7.kyikWGTxKZza03bcbF_re
 s8Hs9syqWwy37LhyVfe1Clm.rCIN1QHsWR2hxOMwERAHqL4DDCO4MMe8LrgGRJWdTwZdxyuNYSBB
 8CNU65ORiE5idkjg44.En3efNoi06JYJRY9h3r8eULAFVTUr.MO3XCxmsipHeIlxx4a8PYp9DU15
 F0Gm_CiSgul2mWQzUs.nE0FRzMnU6BjZ4d2WU7k6UKNpp79v1QfKy4DCjPzNnAiBS793Mdd6IBCu
 WHkQmdAT.VgfAfi7pJvHVWH_iZu5fV1rJT7l1Rx.2heRhzdabGeZPi0QbUcG4wbKybegpH_EACkF
 vOgMlKG6W5vcpNztXUerPYCueShA1SWGTgpz5bnwoqo2GbZOMjo.IR8Ynb.AYp5Flc.iKINKy4s_
 X911QoCXMBQzNfz9An9pQfeZuVFZJBripjQQ50X3v4tOn0rlSMMZZSXSpoVY2x6iFkyAof0PfENZ
 tHSP8r8ssIS.y8Fmj_9gc._SeczNxPHfThrqEluHwUQf35vlYvTfh6XHJKGzuECWx5uNgsuNWsqj
 0f_S.WJHzmAJ9URgVJQlIzI_pHXQt9nPBoXkmz_7c6PsZRN9cJniMmvaf68QUryyFy5V36_LDfHo
 SdxQy7829U58fbic2I.iEfnQ3hh8KCaMUqihkmRXOSZlHxxqRjNin4eFDoi_qSAqFB7o1h6YSwSS
 .sm9dDBiw1C_sJSRJLUYxCKJPxkkFb3NsgDodKxcUVAN3nBzY6QW9JkRLTfXIhZ7SMrrmknSQhw1
 Dzhd6yHj4lcrd_4VFOFi5lMKOMsLdD6ydUpoWhwkCt.vDH8OJbd4Nk0ruPBOscAbBl0MJgzAMjEs
 zvO3sePr.8oHBgzNEw2wYX5u9Y7ykffC_YtgPSLRg.HAZxlWLMGVDWT4a5UKhsPuoHpX_Xf19WGf
 UdAqS6bb7MlA_K_coB3EGR3.CvJst2VQD5ewL5XK0s7NWI28ks1WbdmImZr9yQE3dkHLe7YYmq2t
 SS90c4vme4OWiiEokiOsIIb94tvgpAUhGXsVSu9Cp9Cjv_hr9ImPppkeec9Fjv944GfzlIQ2a18w
 P1eeVMx2c2mRgA3n0r8aq.LnmhxnQ3Ee2CFIPGpkb1ptoJ3mdELhzQiQ3wdzcwJhSAzoTPoQY4V.
 YBEK7no8jP6Ftxfj9Gh1k9rgPy9qGCbS9iJpa3bdVmnahP7gkZ244Pn0W6lEHIt7.RGpVG1lkkL9
 mZhwuqB4VikkxukFkcgJR6rdy99.nUF.0YiAAf8kMksIXv0sT.YrlDYaraSWuXayrHTSNnURDwu4
 0
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.gq1.yahoo.com with HTTP; Tue, 24 May 2022 18:32:37 +0000
Received: by hermes--canary-production-ne1-5495f4d555-xgn59 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID f18826b5cd811627c8ace28c66b17372;
          Tue, 24 May 2022 18:32:32 +0000 (UTC)
Message-ID: <3fc70595-3dcc-4901-0f3f-193f043b753f@netscape.net>
Date:   Tue, 24 May 2022 14:32:30 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 2/2] x86/pat: add functions to query specific cache mode
 availability
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Jan Beulich <jbeulich@suse.com>, regressions@lists.linux.dev,
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
 <b2585c19-d38b-9640-64ab-d0c9be24be34@netscape.net>
 <dae4cc45-a1cd-e33f-25ef-c536df9b49e6@leemhuis.info>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <dae4cc45-a1cd-e33f-25ef-c536df9b49e6@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.20225 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/21/22 6:47 AM, Thorsten Leemhuis wrote:
> On 20.05.22 16:48, Chuck Zmudzinski wrote:
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
>>>>>>>>>>> adjusted behavior (or else I couldn't have left pat_enabled()
>>>>>>>>>>> as the
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
>>>
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
>>>> Are you saying it was wrong for static_cpu_has(X86_FEATURE_PAT)
>>>> to return true in 5.16 when the user requests nopat?
>>> No, I'm not saying that. It was wrong for this construct to be used
>>> in the driver, which was fixed for 5.17 (and which had caused the
>>> regression I did observe, leading to the patch as a hopefully least
>>> bad option).
>>>
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
>>>> be that it is not a regression if it is an incorrect user configuration.
>>> Again no - my view is that there's a separate, pre-existing issue
>>> in the driver which was uncovered by the change. This may be a
>>> perceived regression, but is imo different from a real one.
> Sorry, for you maybe, but I'm pretty sure for Linus it's not when it
> comes to the "no regressions rule". Just took a quick look at quotes
> from Linus
> https://www.kernel.org/doc/html/latest/process/handling-regressions.html
> and found this statement from Linus to back this up:
>
> ```
> One _particularly_ last-minute revert is the top-most commit (ignoring
> the version change itself) done just before the release, and while
> it's very annoying, it's perhaps also instructive.
>
> What's instructive about it is that I reverted a commit that wasn't
> actually buggy. In fact, it was doing exactly what it set out to do,
> and did it very well. In fact it did it _so_ well that the much
> improved IO patterns it caused then ended up revealing a user-visible
> regression due to a real bug in a completely unrelated area.
> ```
>
> He said that here:
> https://www.kernel.org/doc/html/latest/process/handling-regressions.html
>
> The situation is of course different here, but similar enough.
>
>> Since it is a regression, I think for now bdd8b6c98239 should
>> be reverted and the fix backported to Linux 5.17 stable until
>> the underlying memory subsystem can provide the i915 driver
>> with an updated test for the PAT feature that also meets the
>> requirements of the author of bdd8b6c98239 without breaking
>> the i915 driver.
> I'm not a developer and I'm don't known the details of this thread and
> the backstory of the regression, but it sounds like that's the approach
> that is needed here until someone comes up with a fix for the regression
> exposed by bdd8b6c98239.
>
> But if I'm wrong, please tell me.

You are mostly right, I think. Reverting bdd8b6c98239 fixes
it. There is another way to fix it, though. The patch proposed
by Jan Beulich also fixes the regression on my system, so as
the person reporting this is a regression, I would also be satisfied
with Jan's patch instead of reverting bdd8b6c98239 as a fix. Jan
posted his proposed patch here:

https://lore.kernel.org/lkml/9385fa60-fa5d-f559-a137-6608408f88b0@suse.com/

The only reservation I have about Jan's patch is that the commit
message does not clearly explain how the patch changes what
the nopat kernel boot option does. It doesn't affect me because
I don't use nopat, but it should probably be mentioned in the
commit message, as pointed out here:

https://lore.kernel.org/lkml/bd9ed2c2-1337-27bb-c9da-dfc7b31d492c@netscape.net/

Whatever fix for the regression exposed by bdd8b6c98239 also
needs to be backported to the stable versions 5.17 and 5.18.

Regards,

Chuck Zmudzinski
>
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>
> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> reports and sometimes miss something important when writing mails like
> this. If that's the case here, don't hesitate to tell me in a public
> reply, it's in everyone's interest to set the public record straight.
>
>> The i915 driver relies on the memory subsytem
>> to provide it with an accurate test for the existence of
>> X86_FEATURE_PAT. I think your patch provides that more accurate
>> test so that bdd8b6c98239 could be re-applied when your patch is
>> committed. Juergen's patch would have to touch bdd8b6c98239
>> with new functions that probably have unknown and unintended
>> consequences, so I think your approach is also better in that regard.
>> As regards your patch, there is just a disagreement about how the
>> i915 driver should behave if nopat is set. I agree the i915 driver
>> could do a better job handling that case, at least with better error
>> logs.
>>
>> Chuck
>>
>>>> I respond by saying a well-written driver should refuse to honor
>>>> the incorrect configuration requested by the user and instead
>>>> warn the user that it did not honor the incorrect kernel option.
>>>>
>>>> I am only presuming what your patch would do on my box based
>>>> on what I learned about this problem from my debugging. I can
>>>> also test your patch on my box to verify that my understanding of
>>>> it is correct.
>>>>
>>>> I also have not yet verified Juergen's patch will not fix it, but
>>>> I am almost certain it will not unless it is expanded so it also
>>>> touches i915_gem_object_pin_map() with the fix. I plan to test
>>>> his patch, but expanded so it touches that function also.
>>>>
>>>> I also plan to test your patch with and without nopat and report the
>>>> results in the thread where you posted your patch. Hopefully
>>>> by tomorrow I will have the results.
>>>>
>>>> Chuck

