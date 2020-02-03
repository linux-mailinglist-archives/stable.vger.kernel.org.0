Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC6E150FFA
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 19:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgBCSwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 13:52:22 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56342 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728707AbgBCSwV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 13:52:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580755940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WxxqmNqN4+u9WuwjHeqcGXqvaUr6K7Pz14tR1poHNLU=;
        b=UqQygm24Vc8Z1JtMehZ/fJv1r8KGmdwa2Ewsy+5XHFWZSM7jX8/+LA2XkS0fE9f1n3tcop
        Lpy9AksBA8G/mb0AmAvdXno20S2i5zmY+ohYUAioqFjCCJbotwE2bpLABLNTkgeWKSx+pH
        VjAHFZynLC9cpWbqChC0ryExvd7qi0o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-WcQd2rkJO2GDzUiRzr74mg-1; Mon, 03 Feb 2020 13:52:14 -0500
X-MC-Unique: WcQd2rkJO2GDzUiRzr74mg-1
Received: by mail-wr1-f69.google.com with SMTP id w17so3595936wrr.9
        for <stable@vger.kernel.org>; Mon, 03 Feb 2020 10:52:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WxxqmNqN4+u9WuwjHeqcGXqvaUr6K7Pz14tR1poHNLU=;
        b=CuPeu/6Q8/8uZLI6hfRJIfHvpKZiLgMAdHWP83/DdDPcTp2ffn9BxyDF5szcPMLxZH
         G0pra9UYtjkaJIzwkj6d6ws0tZfHqzq5nJhInkHyOhAkxhH/tFeJB5JOMJXFd8yscp2i
         sNKAgwXFjtwCMLgHhrnanWP+a+lsKNO4f16QQIyfo21ngywK9ZFgxsKCYn2SD0WG4oyG
         dBifG5AKZPlCeuzbEmtcYtP8x/umrNxC/wiKfHmb5Evm1Re0RVFrd9VaLJjxomUSltHT
         c27gZ4XfHeG6zpW2sGracHgOH2DOVhUtg49+VP3amHp3BUfTiWcdQS+0ZNR0qS8iNLSd
         zkbQ==
X-Gm-Message-State: APjAAAXsWOBwaGlELxAzY0TU0I7DPhsa8t4x3Kj/Z5DVuKy676NockEe
        zVg/hglTKLXxPFE0epxxAWqu2ObAg5STs7C5B2jvoI9rFZoXsNMvnuXtAx9eC0aLYVigDx2srxR
        qASe9Iz4iZDnCnwpO
X-Received: by 2002:a5d:6b88:: with SMTP id n8mr17926069wrx.288.1580755933570;
        Mon, 03 Feb 2020 10:52:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqyQd1U+egjG9xO3itB9VTUpOv9w+NsmegmdKhmDD/KKyVNGqnfFGK8XCVTMu/uSyWv+dHEwnw==
X-Received: by 2002:a5d:6b88:: with SMTP id n8mr17926053wrx.288.1580755933381;
        Mon, 03 Feb 2020 10:52:13 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id z19sm331883wmi.35.2020.02.03.10.52.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 10:52:12 -0800 (PST)
Subject: Re: [PATCH v2] HID: ite: Only bind to keyboard USB interface on Acer
 SW5-012 keyboard dock
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>,
        =?UTF-8?Q?Zden=c4=9bk_Rampas?= <zdenda.rampas@gmail.com>
References: <20200201115648.3934-1-hdegoede@redhat.com>
 <CAO-hwJK0BjKQMeUT11MxR4TaDN4sdMvN-4YtVBk+V_-JBOrEuw@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <4dc29694-8a7c-40bc-dfd5-97cb4ce8112c@redhat.com>
Date:   Mon, 3 Feb 2020 19:52:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAO-hwJK0BjKQMeUT11MxR4TaDN4sdMvN-4YtVBk+V_-JBOrEuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

HI,

On 03-02-2020 16:14, Benjamin Tissoires wrote:
> On Sat, Feb 1, 2020 at 12:56 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Commit 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboard
>> dock") added the USB id for the Acer SW5-012's keyboard dock to the
>> hid-ite driver to fix the rfkill driver not working.
>>
>> Most keyboard docks with an ITE 8595 keyboard/touchpad controller have the
>> "Wireless Radio Control" bits which need the special hid-ite driver on the
>> second USB interface (the mouse interface) and their touchpad only supports
>> mouse emulation, so using generic hid-input handling for anything but
>> the "Wireless Radio Control" bits is fine. On these devices we simply bind
>> to all USB interfaces.
>>
>> But unlike other ITE8595 using keyboard docks, the Acer Aspire Switch 10
>> (SW5-012)'s touchpad not only does mouse emulation it also supports
>> HID-multitouch and all the keys including the "Wireless Radio Control"
>> bits have been moved to the first USB interface (the keyboard intf).
>>
>> So we need hid-ite to handle the first (keyboard) USB interface and have
>> it NOT bind to the second (mouse) USB interface so that that can be
>> handled by hid-multitouch.c and we get proper multi-touch support.
>>
>> This commit changes the hid_device_id for the SW5-012 keyboard dock to
>> only match on hid devices from the HID_GROUP_GENERIC group, this way
>> hid-ite will not bind the the mouse/multi-touch interface which has
>> HID_GROUP_MULTITOUCH_WIN_8 as group.
>> This fixes the regression to mouse-emulation mode introduced by adding
>> the keyboard dock USB id.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboard dock")
>> Reported-by: Zdeněk Rampas <zdenda.rampas@gmail.com>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>> Changes in v2:
>> - Extend hid_device_id to also match on the HID_GROUP_GENERIC group,
>>    instead of adding a match callback which peeks at the USB descriptors
> 
> Thanks for the quick revision.
> 
> Applied to for-5.6/upstream-fixes
> 
> And for the record, 2 MR have been added to hid-tools for regression testing:
> - https://gitlab.freedesktop.org/libevdev/hid-tools/merge_requests/70
> (keyboard and wifi key)
> - https://gitlab.freedesktop.org/libevdev/hid-tools/merge_requests/69
> (touchpad, which currently fails on Linux master unless this patch
> gets in)

Cool, thank you for doing that.

Regards,

Hans


>> ---
>>   drivers/hid/hid-ite.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
>> index c436e12feb23..6c55682c5974 100644
>> --- a/drivers/hid/hid-ite.c
>> +++ b/drivers/hid/hid-ite.c
>> @@ -41,8 +41,9 @@ static const struct hid_device_id ite_devices[] = {
>>          { HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE8595) },
>>          { HID_USB_DEVICE(USB_VENDOR_ID_258A, USB_DEVICE_ID_258A_6A88) },
>>          /* ITE8595 USB kbd ctlr, with Synaptics touchpad connected to it. */
>> -       { HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS,
>> -                        USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
>> +       { HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
>> +                    USB_VENDOR_ID_SYNAPTICS,
>> +                    USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
>>          { }
>>   };
>>   MODULE_DEVICE_TABLE(hid, ite_devices);
>> --
>> 2.23.0
>>
> 

