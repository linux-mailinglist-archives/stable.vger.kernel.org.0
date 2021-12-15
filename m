Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A971475D79
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 17:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244842AbhLOQdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 11:33:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24437 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232770AbhLOQds (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 11:33:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639586027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rTWRI7IQ5pBShV73sl2YszfEDD/jUEjZHLTeNinnSZ4=;
        b=BIn6rTH+ZejUeNswsnbOc/bNoWXpKoJsuwsIuoifYDYktcjjFNkGLEbT8xKSDstC3H8C7n
        0rfQkdI0BdnAtwgVyD6Gd6cC+yeRTGqWNPsN9PlVkpS2hgT/RkyqGdxAKTz7wOojrvsbrG
        OfG8RE4yh4hlohyc3IpPTzd5MDtzFyk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-FM9eUFgCN1aJgcDmw7eF0A-1; Wed, 15 Dec 2021 11:33:46 -0500
X-MC-Unique: FM9eUFgCN1aJgcDmw7eF0A-1
Received: by mail-ed1-f72.google.com with SMTP id w17-20020a056402269100b003f7ed57f96bso1675089edd.16
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 08:33:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rTWRI7IQ5pBShV73sl2YszfEDD/jUEjZHLTeNinnSZ4=;
        b=jUSw4sZLwhvT0SueH+MjyPy0DiBxX1AkmQJeiDP98mEI1Mr2LltSZGnt7cK4z8ZkFV
         /UbXYGStdKsFiIc70/0oMPFeWAsemMMs1TayM1xEoi3A6CbNTyNazL51EOQYzI0sD79t
         mYvhNnfEW6PdCYKMFORMYP6EInVLweipTSUADqZYyT0DbvHaMZ8pKLrm0EalGz81cBMq
         krJq62I3CZjU1//MyB9OQvPDy2v0O5ItDRyR78KuCakACV4eiCO6uFRcfvLQ/D3QXNrD
         Bvh4lVmGxmDR5Y/OBIUV0eO/2aMTTTkxNjOs3w5ni5//Nwe0sWC3sM1ApXVLRbjzDOF9
         PqHQ==
X-Gm-Message-State: AOAM5327Wjzv5WVkg/Pu6zYjtItLnnG9B46qTzgM8KUHxIMN4cxXk5HT
        sSGBLprClS4t+7w4aOVpwUoEQoqKnXty/T3eVH/DH7zgOdSt2q7YSAfVZmLOfKdmOawOUbVanRd
        Q6n6hTJGiH9j60+HL
X-Received: by 2002:a17:906:3a59:: with SMTP id a25mr11616030ejf.762.1639586024963;
        Wed, 15 Dec 2021 08:33:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxBRcoWA/8+jmGqvNy+vOjrnVcNvuUG8Ih8zM6qxxp40c/111cdvP54IEIraKW+KE04Y1TNpw==
X-Received: by 2002:a17:906:3a59:: with SMTP id a25mr11615977ejf.762.1639586024577;
        Wed, 15 Dec 2021 08:33:44 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id i5sm871712ejw.121.2021.12.15.08.33.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 08:33:44 -0800 (PST)
Message-ID: <cf988af8-64b3-c639-0ef2-678f8c08c52a@redhat.com>
Date:   Wed, 15 Dec 2021 17:33:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 1/2] x86/PCI: Ignore E820 reservations for bridge
 windows on newer systems
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Benoit_Gr=c3=a9goire?= <benoitg@coeus.ca>,
        Hui Wang <hui.wang@canonical.com>, stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
References: <20211215160145.GA695366@bhelgaas>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20211215160145.GA695366@bhelgaas>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bjorn,

On 12/15/21 17:01, Bjorn Helgaas wrote:
> On Tue, Dec 07, 2021 at 05:52:40PM +0100, Hans de Goede wrote:
>> On 11/10/21 14:05, Hans de Goede wrote:
>>> On 11/10/21 09:45, Hans de Goede wrote:
>>>> On 11/9/21 23:07, Bjorn Helgaas wrote:
>>>>> On Sat, Nov 06, 2021 at 11:15:07AM +0100, Hans de Goede wrote:
>>>>>> On 10/20/21 23:14, Bjorn Helgaas wrote:
>>>>>>> On Wed, Oct 20, 2021 at 12:23:26PM +0200, Hans de Goede wrote:
>>>>>>>> On 10/19/21 23:52, Bjorn Helgaas wrote:
>>>>>>>>> On Thu, Oct 14, 2021 at 08:39:42PM +0200, Hans de Goede wrote:
>>>>>>>>>> Some BIOS-es contain a bug where they add addresses which map to system
>>>>>>>>>> RAM in the PCI host bridge window returned by the ACPI _CRS method, see
>>>>>>>>>> commit 4dc2287c1805 ("x86: avoid E820 regions when allocating address
>>>>>>>>>> space").
>>>>>>>>>>
>>>>>>>>>> To work around this bug Linux excludes E820 reserved addresses when
>>>>>>>>>> allocating addresses from the PCI host bridge window since 2010.
>>>>>>>>>> ...
>>>>>>>
>>>>>>>>> I haven't seen anybody else eager to merge this, so I guess I'll stick
>>>>>>>>> my neck out here.
>>>>>>>>>
>>>>>>>>> I applied this to my for-linus branch for v5.15.
>>>>>>>>
>>>>>>>> Thank you, and sorry about the build-errors which the lkp
>>>>>>>> kernel-test-robot found.
>>>>>>>>
>>>>>>>> I've just send out a patch which fixes these build-errors
>>>>>>>> (verified with both .config-s from the lkp reports).
>>>>>>>> Feel free to squash this into the original patch (or keep
>>>>>>>> them separate, whatever works for you).
>>>>>>>
>>>>>>> Thanks, I squashed the fix in.
>>>>>>>
>>>>>>> HOWEVER, I think it would be fairly risky to push this into v5.15.
>>>>>>> We would be relying on the assumption that current machines have all
>>>>>>> fixed the BIOS defect that 4dc2287c1805 addressed, and we have little
>>>>>>> evidence for that.
>>>>>>>
>>>>>>> I'm not sure there's significant benefit to having this in v5.15.
>>>>>>> Yes, the mainline v5.15 kernel would work on the affected machines,
>>>>>>> but I suspect most people with those machines are running distro
>>>>>>> kernels, not mainline kernels.
>>>>>>
>>>>>> I understand that you were reluctant to add this to 5.15 so close
>>>>>> near the end of the 5.15 cycle, but can we please get this into
>>>>>> 5.16 now ?
>>>>>>
>>>>>> I know you ultimately want to see if there is a better fix,
>>>>>> but this is hitting a *lot* of users right now and if we come up
>>>>>> with a better fix we can always use that to replace this one
>>>>>> later.
>>>>>
>>>>> I don't know whether there's a "better" fix, but I do know that if we
>>>>> merge what we have right now, nobody will be looking for a better
>>>>> one.
>>>>>
>>>>> We're in the middle of the merge window, so the v5.16 development
>>>>> cycle is over.  The v5.17 cycle is just starting, so we have time to
>>>>> hit that.  Obviously a fix can be backported to older kernels as
>>>>> needed.
>>>>>
>>>>>> So can we please just go with this fix now, so that we can
>>>>>> fix the issues a lot of users are seeing caused by the current
>>>>>> *wrong* behavior of taking the e820 reservations into account ?
>>>>>
>>>>> I think the fix on the table is "ignore E820 for BIOS date >= 2018"
>>>>> plus the obvious parameters to force it both ways.
>>>>
>>>> Correct.
>>>>
>>>>> The thing I don't like is that this isn't connected at all to the
>>>>> actual BIOS defect.  We have no indication that current BIOSes have
>>>>> fixed the defect,
>>>>
>>>> We also have no indication that that defect from 10 years ago, from
>>>> pre UEFI firmware is still present in modern day UEFI firmware which
>>>> is basically an entire different code-base.
>>>>
>>>> And even 10 years ago the problem was only happening to a single
>>>> family of laptop models (Dell Precision laptops) so this clearly
>>>> was a bug in that specific implementation and not some generic
>>>> issue which is likely to be carried forward.
>>>>
>>>>> and we have no assurance that future ones will not
>>>>> have the defect.  It would be better if we had some algorithmic way of
>>>>> figuring out what to do.
>>>>
>>>> You yourself have said that in hindsight taking E820 reservations
>>>> into account for PCI bridge host windows was a mistake. So what
>>>> the "ignore E820 for BIOS date >= 2018" is doing is letting the
>>>> past be the past (without regressing on older models) while fixing
>>>> that mistake on any hardware going forward.
>>>>
>>>> In the unlikely case that we hit that BIOS bug again on 1 or 2 models,
>>>> we can simply DMI quirk those models, as we do for countless other
>>>> BIOS issues.
>>>>
>>>>> Thank you very much for chasing down the dmesg log archive
>>>>> (https://github.com/linuxhw/Dmesg; see
>>>>> https://lore.kernel.org/r/82035130-d810-9f0b-259e-61280de1d81f@redhat.com).
>>>>> Unfortunately I haven't had time to look through it myself, and I
>>>>> haven't heard of anybody else doing it either.
>>>>
>>>> Right, I'm afraid that I already have spend way too much time on this
>>>> myself. Note that I've been working with users on this bug on and off
>>>> for over a year now.
>>>>
>>>> This is hitting many users and now that we have a viable fix, this
>>>> really needs to be fixed now.
>>>>
>>>> I believe that the "ignore E820 for BIOS date >= 2018" fix is good
>>>> enough and that you are letting perfect be the enemy of good here.
>>>>
>>>> As an upstream kernel maintainer myself, I'm sorry to say this,
>>>> but if we don't get some fix for this merged soon you are leaving
>>>> my no choice but to add my fix to the Fedora kernels as a downstream
>>>> patch (and to advise other distros to do the same).
>>>>
>>>> Note that if you are still afraid of regressions going the downstream
>>>> route is also an opportunity, Fedora will start testing moving users
>>>> to 5.15.y soon, so I could add the patch to Fedora's 5.15.y builds and
>>>> see how that goes ?
>>>
>>> So I've discussed this with the Fedora kernel maintainers and they have
>>> agreed to add the patch to the Fedora 5.15 kernels, which we will ask
>>> our users to start testing soon (we first run some voluntary testing
>>> before eventually moving all users over).
>>>
>>> This will provide us with valuable feedback wrt this patch causing
>>> regressions as you are worried about, or not.
>>>
>>> Assuming no regressions show up I hope that this will give you
>>> some assurance that there the patch causes no regressions and that
>>> you will then be willing to pick this up later during the 5.16
>>> cycle so that Fedora only deviates from upstream for 1 cycle.
>>
>> 5.15.y kernels with this patch added have been in Fedora's
>> stable updates repo for a while now without any reports of the
>> regressions you feared this may cause.
>>
>> Bjorn, I hope that you are willing to merge this patch now that it has
>> seen some more wide spread testing ?
> 
> I'm still not happy about the idea of basing this on BIOS dates.  I
> did this with 7bc5e3f2be32 ("x86/PCI: use host bridge _CRS info by
> default on 2008 and newer machines"), and it was a mistake.
> 
> Because of that mistake, we now have the use_crs/nocrs kernel
> parameters, which confuse users and lead to them being passed around
> as "fixes" on random bulletin boards.
> 
> Adding another BIOS date check and use_e820/no_e820 kernel parameters
> feels like it's layering on more complexity to cover up another major
> mistake I made, 4dc2287c1805 ("x86: avoid E820 regions when allocating
> address space").
> 
> I think it would be better for the code to recognize the situation
> addressed by 4dc2287c1805 and deal with it directly.  Is that
> possible?  I dunno; I don't think we've really tried.

So we are just going to leave a ton of users systems broken *for years*
until someone has the time to try ? I've not seen anyone step up to
try and address the issue worked around by 4dc2287c1805 (and no I'm not
volunteering).

Also how are we going to come up with another fix for that without any
of the hardware which was affected by the issue back then to test on?

AFAIK we agree that:

1. In hindsight commit 4dc2287c1805 was not a good idea.
2. We cannot just revert it without causing regressions

So given these 2 things, disabling the problematic behavior introduced
by commit 4dc2287c1805 on newer machines, to avoid the older machines
which need it from regressions really seems like the obvious fix to me ?

Especially since replacing commit 4dc2287c1805 seems impossible to me
without access to the originally affected hardware to verify any fix.

AFAIK there are a number of other places in the kernel where
BIOS date checks are used, to e.g. not use ACPI on really early
buggy ACPI implementations, so this is not unheard of.

You seem to mainly be concerned about users cargo-culting
the use_e820/no_e820 kernel parameters as workaround for issues
which have a completely different root cause.

Would my solution to disable the troublesome workaround from
4dc2287c1805 be acceptable if I drop the new commandline options?

I added those just in case, but so far no Fedora users have
needed them, so I would be happy to drop them ?

Regards,

Hans

