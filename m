Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB33327358
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 17:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhB1Q3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 11:29:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50590 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229982AbhB1Q3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 11:29:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614529690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KW+A4fMCUXlM1ZCXJuqgg2ArSuejTl4g/godkV8lJuM=;
        b=ZRkILcsAGqPHMau5zgjjVvJibTzhMLzQS1Wx2jAt5unMei22pIi+5sGukxMwTYR+24ARaJ
        MxahRvZ4pUDCLRXBqNebUj2mqGLsy/RDWTG9qczVG59LC7IGZxEeX7eOQzM6xPCF+yVESH
        I5bolM8rMtCeXhVcOjmlLAN9t213rjE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-vWaHxPrKPLKf8_WwN7AT7g-1; Sun, 28 Feb 2021 11:28:09 -0500
X-MC-Unique: vWaHxPrKPLKf8_WwN7AT7g-1
Received: by mail-ed1-f71.google.com with SMTP id t18so7542910edr.19
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 08:28:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KW+A4fMCUXlM1ZCXJuqgg2ArSuejTl4g/godkV8lJuM=;
        b=q0eIJGcJkPBxyXkk4Shq3WBvUrrN3baUN+aVJzCRt4brbdqO3aMQOfGvh8OxxI6jtG
         5+KfbLgCMyQZa7QR3vVmYZEb94j1C8JtI0wO8Uki2oUndAGchxVAt4gRb3gRmRat5yng
         QTm2JxewYMJDVLtJad0FDmQEQcWynSl35ekjXlTzA4ZmiXm4MD9U8ikA8vHSRfMGqIM8
         WAZsy6cVqhMCZ31wulHSkbdBrz8ricSBFNTRDZjE8HELXqjuquaJfVGkOyGwgb74D0Aw
         TVk7d7eVP2R2X6yiJScB/fl7ykCDdt/cUqtX2+VP4axWY+9+xbnSKv9AC7HLYlvCDsze
         c7bg==
X-Gm-Message-State: AOAM530TtEqcQK5CPCn7HzSYSFD952V4alCG82UKlQ9TD+YuVQFfVcf/
        CKf65Z1muSFvFFBTijgQwZID1Rj3B6tUTBDaA7I+bNveUI6Pf/Vwrsk862Zeegyysd0xIZuuc9c
        khFTKRp0JXZdFPrrjGH0a8hamO7oYnuotcouCBZub/OI8qWySmqERXznp9ABas5YwAj9a
X-Received: by 2002:a05:6402:3585:: with SMTP id y5mr12354979edc.97.1614529687763;
        Sun, 28 Feb 2021 08:28:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyD73hG/59Kk13XOJ6O+yfcazWfJ5/gBxFHjWSszQjbVa0uDW4D1PcpQ1P6aTsB8B0LIGNeKg==
X-Received: by 2002:a05:6402:3585:: with SMTP id y5mr12354957edc.97.1614529687527;
        Sun, 28 Feb 2021 08:28:07 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id l6sm11851022edn.82.2021.02.28.08.28.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Feb 2021 08:28:07 -0800 (PST)
Subject: Re: [Intel-gfx] -stable regression in Intel graphics, introduced in
 Linux 5.10.9
To:     Greg KH <gregkh@linuxfoundation.org>,
        Diego Calleja <diegocg@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
References: <3423617.kz1aARBMGD@archlinux> <YDuzbvIjMO5mFcYm@kroah.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <e662d6bf-53e3-9774-37db-9e7ea88a4ec9@redhat.com>
Date:   Sun, 28 Feb 2021 17:28:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YDuzbvIjMO5mFcYm@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2/28/21 4:14 PM, Greg KH wrote:
> On Sun, Feb 28, 2021 at 03:29:07PM +0100, Diego Calleja wrote:
>> Hi,
>>
>> There is a regression in Linux 5.10.9 that does not happen in 5.10.8. It is still there as
>> of 5.11.1
> 
> Is this the same issue reported here:
> 	https://lore.kernel.org/r/f1070486-891a-8ec0-0390-b9aeb03178ce@redhat.com
> ?
> 
> If so, is this a problem in 5.11 as well?

I see in the original email:
https://lore.kernel.org/stable/3423617.kz1aARBMGD@archlinux/

That Diego is using the iGPU part of a Haswell CPU, so yes this is almost
certainly the same issue.

Diego as I already mentioned to another arch user, it would be good if the
arch kernel-maintainers can pick-up these 3 commits from the drm-intel tree
as downstream patches for now:

e627d5923cae ("drm/i915/gt: One more flush for Baytrail clear residuals")
d30bbd62b1bf ("drm/i915/gt: Flush before changing register state")
1914911f4aa0 ("drm/i915/gt: Correct surface base address for renderclear")

We (Fedora) have added these as downstream patches for now and we have
multiple reports that these resolve the problem.

Chris, can you please send the 2nd and 3th commit of the above list on
their way to Linus ASAP, so that Greg can add them to the stable series?

ATM only the 1st commit is in Linus tree (unless the others have landed
with different hashes?)

Regards,

Hans

