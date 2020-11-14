Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC5F2B2CCD
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 12:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgKNLDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 06:03:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726513AbgKNLDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 06:03:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605351793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U7Ey2Nmyuj+Y1CyHdib9Q8LW80ocjZuRz9cEG2vUNqU=;
        b=ex9TPt2AVdcMXFLH7bCp0+iBlHe0pKlGSUtHMrUv0vuPd+KQjcZ7tECdchwVm8i1rEum0z
        oai7TShk6pHevGHGtJMfs9Az5Xr7oV1mBpXE2YhXG+o/H+ZTvL9/Nc1pC7SVRoEDg8P+yR
        1ZzQxS+k89lxR8Pl0SGnrsYcuppv3Bs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-IN5NzQ3AM32rKYah_6dl2Q-1; Sat, 14 Nov 2020 06:03:12 -0500
X-MC-Unique: IN5NzQ3AM32rKYah_6dl2Q-1
Received: by mail-ed1-f69.google.com with SMTP id l24so6095034edt.16
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 03:03:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U7Ey2Nmyuj+Y1CyHdib9Q8LW80ocjZuRz9cEG2vUNqU=;
        b=lsrzqUae6aFE79uxmL+yjUqn1W2LRPBOTshLjBoYKPOWBTmw3b6wWnof1Xrj62zle7
         T+XPG47eufGO+Qqrp0CMQpZklfa3oAQyyRPFzlTvlgEZetj0EfOJOHxJzWTggeRrBtn9
         zDEXuGc+tqjuI+Qj9vX0kmzQSRJNXRjI+vHJExwZ18Dwh8sD6LKwp40Zagos7etnarS5
         7laavS28XEjPcXqQ/Xt4bGVnK3QYSKf/mEnWw5PzXpH4Ht2/GRpAUSrSDSZ8k+1LvZbU
         F/G52QWXqUiq9uV4mvKIOrvO4wCqAWCUP9JJtwa/if+j92vh24Ep8xYW79WGYGLDMW+V
         Ip4g==
X-Gm-Message-State: AOAM5319s6WrpSojPk5oxE8SbYbV+G3hoMOPMjvBlQwRtMhX9NpGqLcy
        pEubA8JZQ3j0+5NsoaMi8xVc8BNzrukP2hnvh9G/RhIVL7ztsxtMtsyMOKEYcrQLXqanwHegctp
        vW65Kc+7gfnchYEAv4y6Y3s8oqgjwNck7xAIgpbmtySLaRCbgPIo2CwWCFESbqjkMMeir
X-Received: by 2002:a17:906:2806:: with SMTP id r6mr822914ejc.130.1605351790446;
        Sat, 14 Nov 2020 03:03:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx7bv6CR2y9hT8woeWCFpYlVjWQlh0mQ6AwB+4uX8W5VQw97M3QcL42g+hHZuWQRZHSEu7mmw==
X-Received: by 2002:a17:906:2806:: with SMTP id r6mr822888ejc.130.1605351790142;
        Sat, 14 Nov 2020 03:03:10 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-6c10-fbf3-14c4-884c.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:6c10:fbf3:14c4:884c])
        by smtp.gmail.com with ESMTPSA id f16sm6487535edc.44.2020.11.14.03.03.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2020 03:03:09 -0800 (PST)
Subject: Re: [PATCH 1/3] HID: logitech-dj: Handle quad/bluetooth keyboards
 with a builtin trackpad
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
References: <20201102133658.4410-1-hdegoede@redhat.com>
 <e3817ab8-906e-cb98-91db-ffb4cc821788@redhat.com>
 <ab1788a1-1f23-45bd-72e8-fadcea82514f@redhat.com>
 <07280208-7a52-954e-4795-9022fe498294@redhat.com>
 <CAO-hwJ+u5=rFN8vkV7FJUrYv4geNmfTD3g=vdkBf3P9BMCdmxw@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <135188fc-fd13-7539-4ed9-50ac3557de6c@redhat.com>
Date:   Sat, 14 Nov 2020 12:03:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAO-hwJ+u5=rFN8vkV7FJUrYv4geNmfTD3g=vdkBf3P9BMCdmxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 11/12/20 4:49 PM, Benjamin Tissoires wrote:
> On Wed, Nov 11, 2020 at 12:07 PM Hans de Goede <hdegoede@redhat.com> wrote:

<snip>

>>> If so, I can try to push it later today or tomorrow.
>>
>> Sounds good, thank you.
> 
> I have now applied the 3 patches to the for-5.10/upstream-fixes branch.
> I also added the Fixes tag to the first commit only.

Great thank you.

<snip>

>>> Yeah, the Dinovo Mini will come later.

So I've been working on this today and I hope to have a patch for you
ready to test soon. So no need for you to spend time on this now,
that would just be us doing double work.

<snip>

>> Do the original HID descriptors of the receiver perhaps have both a report 2 and
>> a report 5 and we should add both ?
> 
> No, I think it only has report ID 5.

So I checked and there are actually both INPUT(2) and INPUT(5) descriptors
on the mouse USB-device's HID intf.

And looking at the USB ids again, this is not new vs old. This is Dinovo
vs non Dinovo. It seems that even though the air protocol is the same,
the Dinovo receivers have some special handling for the kbd touchpad where
as the non Dinovo receivers just send the same HID reports as for the normal
mouse.

I paired both the Dinovo Edge + a BT mouse (you can pair any BT mouse,
just press the pair button on the receiver and then on the mouse) with:

1. The MX5000 receiver as the RH bugzilla reporter is doing

In this case both the kbd-touchpad and the actual mouse send INPUT(2)
reports (there is no INPUT(5) in the descriptors).

2. The Dinovo Edge receiver. In this case the kbd-touchpad sends
INPUT(5) reports where as the actual mouse sends INPUT(2) reports.

I can see 2 reasons why Logitech did this:
1. tell apart kbd-touchpad events from actual mouse events
2. -127 - 127 hwheel range instead of -7 - 7, better for the infinite scrolling feature
  of the round touchpad (in horizontal direction)

No idea why they did not just enable INPUT(5) reporting on all
receivers though.

Anyways with the above knowledge I think I can write a nice patch
for this; and I've also found the hid-lg.c bit which needs to move
to hid-logitech-hidpp.c to keep the MEDIA key working on the Dinovo
Mini.

I hope to have a patch ready for your testing for this soon.

Regards,

Hans

