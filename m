Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F7B314E70
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 12:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhBILtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 06:49:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25452 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230264AbhBILsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 06:48:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612871211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=klaDtI4Zs8wXjbSMUwZ9+VaH5ZIusP/V06SeLCTa8ZQ=;
        b=Ibai+BZLWNkZCsntu8uuqxB3RO1m0tAoo8RR+tasrqM7vINohCbrrKC5Vc8UFoAvgslmiQ
        Yb/TegwkU3Iim/UmvSTGmtHz70HVuq3Z/pm43D6aA9ojk4inqyn/xzmSbpVAqDLHvF06Yn
        2iGur5zkHSAy29dhfcn9SRr4hGjX+iw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-3BD2DNCGNV-ioHSlz_QfAA-1; Tue, 09 Feb 2021 06:46:49 -0500
X-MC-Unique: 3BD2DNCGNV-ioHSlz_QfAA-1
Received: by mail-ed1-f71.google.com with SMTP id i4so17321253edt.11
        for <stable@vger.kernel.org>; Tue, 09 Feb 2021 03:46:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=klaDtI4Zs8wXjbSMUwZ9+VaH5ZIusP/V06SeLCTa8ZQ=;
        b=pjPFTGB8Sctmb+35YV/EYEJNDUyIbJBQoFCWAAactkAKlVQhVVwy775tgG9eD0AjzW
         OPRY7eHeE0UtX1aUfKcr7sefJbSto796bm+6+lvPWDCdEdvWLAC8erfDJ/Y79CMh8Nm+
         6iCwvllFHhB2WBzDQI6jBeMJKc4fAQ0wsl2JEMxwSPNHjzeKE5Gj3VIaGwHV3UscQrW7
         LVYZXOUGlGI7y8M2dYIhn6YlZvYn8Ci7Ma2JNx4LFPZhz90DiCHLAifPSOUSTwjH8XN2
         VBWLp2njHiG4qqJj4You1uGZVXFVAfjISeMuBH0tD43+6YxyjWU7UdVUijYmhgtker3J
         iIlw==
X-Gm-Message-State: AOAM5306HMV9luIBnNAXz6ChiRM/eg5ODEyEIo95SrfsHo1FA1H+S7SP
        XX5L3rVBviyR9qYEKQfVcp6VevBkj4LnoAjFehHTpqUuGsZgXOSZwj8H7gFF+ud+tD5Ikv/MGtL
        5yZjSdecv0kZ5kXpzTmskE9u6riogtGXgErdUSQVSjIaYG+eOPKFLJYnEyioV5Qp8n2DR
X-Received: by 2002:a50:80c6:: with SMTP id 64mr22292601edb.209.1612871207817;
        Tue, 09 Feb 2021 03:46:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwcLzMqHynAU+5dQG109GdIVfsGd4Rc/tvYYgRdnI0NuhGiBnd70fkMeFh167iksgwsddhvLA==
X-Received: by 2002:a50:80c6:: with SMTP id 64mr22292591edb.209.1612871207662;
        Tue, 09 Feb 2021 03:46:47 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id k6sm10278281ejb.84.2021.02.09.03.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 03:46:47 -0800 (PST)
Subject: Re: [Intel-gfx] [5.10.y regression] i915 clear-residuals mitigation
 is causing gfx issues
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org
References: <fe6040b5-72a0-9882-439e-ea7fc0b3935d@redhat.com>
 <161282685855.9448.10484374241892252440@build.alporthouse.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <f1070486-891a-8ec0-0390-b9aeb03178ce@redhat.com>
Date:   Tue, 9 Feb 2021 12:46:46 +0100
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
> to test other platforms. So I don't yet have an alternative.

Note the original / first reporter of:

https://bugzilla.redhat.com/show_bug.cgi?id=1925346

Is using hsw-gt2, so it seems that the problem is not just the enabling of
the mitigations on ivy-bridge / bay-trail but that there actually is
a regression on devices where the WA worked fine before...

If you have access to a hsw-gt2 device then testing there might help?

Also note that this reproduces more easily on 5.10.10, which does not have:

520d05a77b2866eb ("drm/i915/gt: Clear CACHE_MODE prior to clearing residuals")

Not sure if that helps though.

> Though note
> that v5.11 and v5.12 will behave similarly, so we need to urgently find
> a fix for Linus's tree anyway.

Ack.

Regards,

Hans

