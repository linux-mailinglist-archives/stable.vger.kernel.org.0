Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65094368DA
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 19:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhJURST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 13:18:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232071AbhJURSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 13:18:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634836562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PVbmNx2Q8EjJXm8nyHGx5Ousb89stVDtJGzhnXN95ec=;
        b=RKmnSQsvCTEjTMAhdvAaihfVfvEB+HRm7l7oPg5ZCkFfp03qLakZp7t2Ywpv0fzyQEmS5f
        CYCUEQQRcTgVyHsgOkTYoFbrcUrGKl5p9jrU+FyRLJRw9oC0//PSpw8tDwmo/5yHaDtQ5d
        AlsAM/H7i6etIZIakZYhX55HVQCKDhk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-gQAVrWVUP7aRiOpbNAKKLg-1; Thu, 21 Oct 2021 13:16:00 -0400
X-MC-Unique: gQAVrWVUP7aRiOpbNAKKLg-1
Received: by mail-ed1-f72.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso1009874edj.20
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 10:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PVbmNx2Q8EjJXm8nyHGx5Ousb89stVDtJGzhnXN95ec=;
        b=istyyt8gv2n7MhC8+bkpKscg8+paryRQTi5Dv7+1ReExLciRSLEgM2maIrQkFwMKct
         lEpnhjXn/Qz93D2Vd3fxQfFsoNE7WoqcH7mXJY+jx/33rbG/QdEeyBEE7wivGPoUybdc
         93t6Fy450Q+5Bh15XDdGOhLDeDQtLWEPv44bnGlz+tR55EchygRuj2zJk+4dRd2rboU2
         rs9A7LLhDMMN01Fhq8X0Hos2Fq8sqWl5XsYYcEupsK+X3e7QwEn2LgtCmUFfsuzrCdSr
         z3i/UHT/vqw1vPHEsyseQwTwzlCgXT2ziMXm+ZjHsZtX/09sbLc1hAcGTf2BfRUuUukN
         no5w==
X-Gm-Message-State: AOAM532dNDZiHoxbJ+HYgka8eotQCBGto6tPZOGVOijNtG1c+mnPYY7m
        mdnDf1xZYcwtJee8RTU/r8tEF6nlVQx//kly8uILEt1TEYHQ1Uh5bqv6rWnqy2zEt4ArTVS4WJ/
        VBdjuh8MVssmwn0xe
X-Received: by 2002:a17:907:1c0e:: with SMTP id nc14mr8722275ejc.103.1634836559575;
        Thu, 21 Oct 2021 10:15:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9Ddy1dmXjTr32jRFjXqDaqxR5La1DixwmbDJ79+PUHh5JU3yjOgvx/JD5tj/TOPgEtON1kg==
X-Received: by 2002:a17:907:1c0e:: with SMTP id nc14mr8722245ejc.103.1634836559359;
        Thu, 21 Oct 2021 10:15:59 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:1054:9d19:e0f0:8214? (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id z4sm3646641edd.46.2021.10.21.10.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 10:15:58 -0700 (PDT)
Message-ID: <73aeec22-2ec7-ff21-5c89-c13f2e90a213@redhat.com>
Date:   Thu, 21 Oct 2021 19:15:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
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
References: <20211020211455.GA2641031@bhelgaas>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20211020211455.GA2641031@bhelgaas>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bjorn,

On 10/20/21 23:14, Bjorn Helgaas wrote:
> On Wed, Oct 20, 2021 at 12:23:26PM +0200, Hans de Goede wrote:
>> On 10/19/21 23:52, Bjorn Helgaas wrote:
>>> On Thu, Oct 14, 2021 at 08:39:42PM +0200, Hans de Goede wrote:
>>>> Some BIOS-es contain a bug where they add addresses which map to system
>>>> RAM in the PCI host bridge window returned by the ACPI _CRS method, see
>>>> commit 4dc2287c1805 ("x86: avoid E820 regions when allocating address
>>>> space").
>>>>
>>>> To work around this bug Linux excludes E820 reserved addresses when
>>>> allocating addresses from the PCI host bridge window since 2010.
>>>> ...
> 
>>> I haven't seen anybody else eager to merge this, so I guess I'll stick
>>> my neck out here.
>>>
>>> I applied this to my for-linus branch for v5.15.
>>
>> Thank you, and sorry about the build-errors which the lkp
>> kernel-test-robot found.
>>
>> I've just send out a patch which fixes these build-errors
>> (verified with both .config-s from the lkp reports).
>> Feel free to squash this into the original patch (or keep
>> them separate, whatever works for you).
> 
> Thanks, I squashed the fix in.
> 
> HOWEVER, I think it would be fairly risky to push this into v5.15.
> We would be relying on the assumption that current machines have all
> fixed the BIOS defect that 4dc2287c1805 addressed, and we have little
> evidence for that.

It is a 10 year old BIOS defect, so hopefully anything from 2018
or later will not have it.

> I'm not sure there's significant benefit to having this in v5.15.
> Yes, the mainline v5.15 kernel would work on the affected machines,
> but I suspect most people with those machines are running distro
> kernels, not mainline kernels.

Fedora and Arch do follow mainline pretty closely and a lot of
users are affected by this (see the large number of BugLinks in
the commit).

I completely understand why you are reluctant to push this out, but
your argument about most distros not running mainline kernels also
applies to chances of people where this may cause a regression
running mainline kernels also being quite small.

> This issue has been around a long time, so it's not like a regression
> that we just introduced.  If we fixed these machines and regressed
> *other* machines, we'd be worse off than we are now.

If we break one machine model and fix a whole bunch of other machines
then in my book that is a win. Ideally we would not break anything,
but we can only find out if we actually break anything if we ship
the change.

> Convince me otherwise if you see this differently :)

See above :)

> In the meantime, here's another possibility for working around this.
> What if we discarded remove_e820_regions() completely, but aligned the
> problem _CRS windows a little more?  The 4dc2287c1805 case was this:
> 
>   BIOS-e820: 00000000bfe4dc00 - 00000000c0000000 (reserved)
>   pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]
> 
> where the _CRS window was of size 0x20100000, i.e., 512M + 1M.  At
> least in this particular case, we could avoid the problem by throwing
> away that first 1M and aligning the window to a nice 3G boundary.
> Maybe it would be worth giving up a small fraction (less than 0.2% in
> this case) of questionable windows like this?

The PCI BAR allocation code tries to fall back to the BIOS assigned
resource if the allocation fails. That BIOS assigned resource might
fall outside of the host bridge window after we round the address.

My initial gut instinct here is that this has a bigger chance
of breaking things then my change.

In the beginning of the thread you said that ideally we would
completely stop using the E820 reservations for PCI host bridge
windows. Because in hindsight messing with the windows on all
machines just to work around a clear BIOS bug in some was not a
good idea.

This address-rounding/-aligning you now suggest, is again
messing with the windows on all machines just to work around
a clear BIOS bug in some. At least that is how I see this.

I can understand that you're not entirely happy with my patch,
but it does get rid of the use of E820 reservations for
any current and future machines, removing any messing with
the _CRS returned windows which we are doing.

I also understand that you're not entirely comfortable with
my "fix" not causing regressions else where. If you want to
delay my fix till 5.16-rc1 that is fine (1).

Regards,

Hans



1) The stable series will likely pick it up soon after
5.16-rc1 though, so not sure how much that actually helps
with getting more testing time.

