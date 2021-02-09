Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7C8315447
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 17:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhBIQrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 11:47:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43567 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233028AbhBIQpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 11:45:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612889043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jXgigGlEWwXeuHFBknU4UpbbHCCiPYOX7SCmGJAz80k=;
        b=DyV054QVZwn2SMV8b/A/s0AUqLhZHcvbLALJuiaZySo71UMq5yNzAOol9nNVKXOF5AeM7Y
        Yr3EHGbANrIg68rUGudbl69DWwOBmhegZZleomO94ViX+69o4f93dFXC9jpzUZWM2SwdQo
        avXu0UIj7xXD9cIcC/4+s1DwAm80iiM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-wD15JNl7Muysh-S9s5IpSA-1; Tue, 09 Feb 2021 11:44:00 -0500
X-MC-Unique: wD15JNl7Muysh-S9s5IpSA-1
Received: by mail-ed1-f70.google.com with SMTP id t9so18540062edd.3
        for <stable@vger.kernel.org>; Tue, 09 Feb 2021 08:44:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jXgigGlEWwXeuHFBknU4UpbbHCCiPYOX7SCmGJAz80k=;
        b=PoRJFBNVkis1w8B4WaNBw90aYRDU/3PRf/loDU0RgZdltBV+eyeVZtZ1mxeI07zBdZ
         B232DkSBQZ2EXemRgvG+e6qyXU2LLEjjBcVFq8wXfLX90tmmvdidJ7O/EHxKo0XfO8VZ
         EMMSoorZ1PSXNupV6IaXs5qa5j940mANSt9j6TGIx9LGk2TUPtRWWXIzRlllhXJSfRH/
         rTUxfvCbPLZvUP/gkjpsujJbCiTyKvEHmZ01GekhRXFL9KLJgSirMtqu/vfYcNDDLHtp
         Gq4YoXhqFU40BfBv0vpqZAenOWEKJSr3qxpukfZKjNPU0hcC0Cm+dcKyRTPNqeYmQ1Ky
         zIuQ==
X-Gm-Message-State: AOAM530S32ITH6VzAWWwUIjy5Gqv416Nh6GsfSDdaDu03JB44BjclvWs
        SoK4Cl/sXpXwp0TLaRsgH68RaFMbn4O5FGExnVP4NgpaJko3ln5Ja75De6sXHxPhBxCQn33sATf
        TMf5PBQjus70rDrgQJnbuinfnzwjp3ziX+eJldBwHpuGYL/T4OQA2Re+LW7M81uvZAc+a
X-Received: by 2002:a17:906:1be9:: with SMTP id t9mr22841988ejg.527.1612889039656;
        Tue, 09 Feb 2021 08:43:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz80em6MoRBiFwcDp4DrFzeg9eZXV4029nWQZ0qYr/6kTtG6eLyGrOybSwxBTQaYCk0Vcn1EQ==
X-Received: by 2002:a17:906:1be9:: with SMTP id t9mr22841954ejg.527.1612889039340;
        Tue, 09 Feb 2021 08:43:59 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id z19sm5135435edr.69.2021.02.09.08.43.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 08:43:58 -0800 (PST)
Subject: Re: [Intel-gfx] [5.10.y regression] i915 clear-residuals mitigation
 is causing gfx issues
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org
References: <fe6040b5-72a0-9882-439e-ea7fc0b3935d@redhat.com>
 <161282685855.9448.10484374241892252440@build.alporthouse.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <20c3d11d-75f6-ad82-1100-3015ff463406@redhat.com>
Date:   Tue, 9 Feb 2021 17:43:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <161282685855.9448.10484374241892252440@build.alporthouse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2/9/21 12:27 AM, Chris Wilson wrote:
> Quoting Hans de Goede (2021-02-08 20:38:58)
>> Hi All,
>>
>> We (Fedora) have been receiving reports from multiple users about gfx issues / glitches
>> stating with 5.10.9. All reporters are users of Ivy Bridge / Haswell iGPUs and all
>> reporters report that adding i915.mitigations=off to the cmdline fixes things, see:
> 
> I tried to reproduce this on the w/e on hsw-gt1, to no avail; and piglit
> did not report any differences with and without mitigations. I have yet
> to test other platforms. So I don't yet have an alternative. Though note
> that v5.11 and v5.12 will behave similarly, so we need to urgently find
> a fix for Linus's tree anyway.

Note I've gone ahead and prepared a test kernel for the Fedora bug reports
with the following 3 commits reverted from 5.10.y :

520d05a77b2866eb ("drm/i915/gt: Clear CACHE_MODE prior to clearing residuals")
ecca0c675bdecebd ("drm/i915/gt: Restore clear-residual mitigations for Ivybridge, Baytrail")
48b8c6689efa7cd6 ("drm/i915/gt: Limit VFE threads based on GT")
(Note this are the 5.10.y hashes)

I know going this route is not ideal but it might be best for 5.10.y for now.

I will let you know if reverting these 3 actually helps once I hear back
from the reporters of the issue.

Regards,

Hans

