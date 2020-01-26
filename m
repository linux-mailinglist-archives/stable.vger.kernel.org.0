Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3087149B5E
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 16:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgAZPVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 10:21:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29718 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725908AbgAZPVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 10:21:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580052091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LchZJ++dV82ZQxtETGePbP8/DG4nvTQIBe9OJdc8KAw=;
        b=anHqm7Vm/bpAzYwXsshdwGvwwBr5wy7ksW8q+btTFITDUvQrdt+NIT5BRmNEyvwb/7sXQJ
        tXdSKIGeju9WJmRktrCFUFjktOmAOwJhyLUWfUC3/khVT5lLEY4zdru8WFaN9qPc1ghrkX
        Nh20Nymof7torumkaiU5lJ6cjzdx23Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-iuDsiBmBNYuOJpk0xzEgDA-1; Sun, 26 Jan 2020 10:21:26 -0500
X-MC-Unique: iuDsiBmBNYuOJpk0xzEgDA-1
Received: by mail-wr1-f72.google.com with SMTP id r2so4465288wrp.7
        for <stable@vger.kernel.org>; Sun, 26 Jan 2020 07:21:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LchZJ++dV82ZQxtETGePbP8/DG4nvTQIBe9OJdc8KAw=;
        b=lDP9QBzuNj8kEe0ieu2idpNXpT0xYS5JVuiEwMR8MVRdZYfoHKZGs2zS3J7guX44JR
         irg9ZIrkxpIE2XqOomHhvugEBPlldPRZZtWAwyKAbEFy57xeI+sIFMaqxU6Jph2C1ons
         nzsmuS6oVbxH6XE568CkMheIGltNX85/dpuCvk97SS05IRiTuUgDtZui0ySoLLOX2DLU
         +rUum3xPSVXR/7LJ5AUJKNwJHSfS3JEu10ZzrqAWV/1juWosqxZ9knMLsjTfXz/wdEe8
         K41E3p4xXvlpEIB+UQ8nSoQVn7j5A7xrfoEZO4Xk7DJs1lV5pJQUZFlg8qYDEDaV4owX
         81zw==
X-Gm-Message-State: APjAAAVoislaSWPHY+P3RJL6od6R3DoG18USNpnUyBgEo926yEpOqykw
        Ks1s4n92aw4dIZ4WL0Wne3/BN/b4GTA8b4A+QIuwgo1u0kdMho9ZRUgd1v7VpAssefqc+M/Hae2
        bGrrSYvAMfprcs1Ms
X-Received: by 2002:adf:9144:: with SMTP id j62mr16101174wrj.168.1580052085155;
        Sun, 26 Jan 2020 07:21:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqxP5Y6bAR0d45JY6z5RNn+gPPGT2je6DvUcKh3z/eztl5Y+1hrH7gSFm6w1R+aE0rCXfJ1uOw==
X-Received: by 2002:adf:9144:: with SMTP id j62mr16101145wrj.168.1580052084841;
        Sun, 26 Jan 2020 07:21:24 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id s15sm16234502wrp.4.2020.01.26.07.21.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 07:21:24 -0800 (PST)
Subject: Re: [PATCH v2] USB: uas: Add the no-UAS quirk for JMicron JMS561U
To:     Tim Schumacher <timschumi@gmx.de>
Cc:     stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
References: <20200125064838.2511-1-timschumi@gmx.de>
 <20200125170030.25331-1-timschumi@gmx.de>
 <fccf2105-d415-7f44-e111-729d2d517ea7@redhat.com>
 <f9643202-c029-efe1-c213-b54b2ccf9c47@gmx.de>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <f6153a2c-fdad-09e4-53f9-0bc99d383c0f@redhat.com>
Date:   Sun, 26 Jan 2020 16:21:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f9643202-c029-efe1-c213-b54b2ccf9c47@gmx.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 25-01-2020 20:59, Tim Schumacher wrote:
> On 25.01.20 19:37, Hans de Goede wrote:> Hi,
>>
>> On 1/25/20 6:00 PM, Tim Schumacher wrote:
>>> The JMicron JMS561U (notably used in the Sabrent SATA-to-USB
>>> bridge) appears to have UAS-related issues when copying large
>>> amounts of data, causing it to stall.
>>>
>>> Disabling the advertised UAS (either through a command-line
>>> quirk or through this patch) mitigates those issues.
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Tim Schumacher <timschumi@gmx.de>
>>
>> Hmm, this is a quiete popular usb2sata bridge and disabling uas
>> is quite bad for performance.
> 
> I haven't been able to notice any slowdown myself, averaging 350MB/s
> while copying large files, before and after the patch. However, from
> what I've been able to grasp, the actual advantage of UAS seems to
> be located in even higher speeds, which I can't properly test with my
> equipment.

The big difference is not so much linear throughput, as well as
iops / random access patterns. UAS allows sending multiple data
requests to the disk at once, which the old bulk mass storage
protocol does not allow.

Chances are that the times when you are seeing the hangs you
are also accessing the disk in some other way while copying a large
file. With the old mass storage protocol in this case the copy
will pause and then your other access will happen and then the copy
will resume. UAS allows both to happen "at once" and SSDs are very good
at this. As you can imagine making the SSD do multiple things at once
it is also something which really pushes the power-requirements up.

> It's a valid concern though, since SATA 3 theoretically goes way
> higher than what I can reach.
> 
>>
>> I notice that there is no link to a bug report and AFAIK we have
>> no one else reporting this issue.
> 
> I haven't specifically looked on the kernel bug tracker yet, but I
> found similiar UAS-related issues talking about the JMicron JMS567
> and JMS579 on the Ubuntu kernel bug tracker [1], as well as the
> Raspberry Pi bug tracker [2].
> 
> If it helps, I can make this a proper bug report first so that other
> people can chime in, instead of burying the discussion in the mailing
> list.
> 
> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1789589

"When the device is under load and more than 1 hardrive is acessed,
the USB enclosure frequently restarts."

In other words, when I cause the power consumption to go through the
roof things crash. This smells very much like (yet another) power-supply
problem.

> [2] https://github.com/raspberrypi/linux/issues/3070

Raspberry Pi's are notorious for having issues supplying enough power
to their USB ports due to the self-resetting electronic fuses they
are using, which increase there resistance when the current demand
peaks, which causes a voltage drop.


> 
>>
>> So this feels like a much too big hammer for the problem which you
>> are seeing.
>>
>> When you say "stall" what exactly happens? Do you see any errors
>> in dmesg for example?
> 
> Basically, the transfer just freezes at one point (be it an actual
> file transfer or just browsing directories quite fast), and a few
> seconds later, UAS-related errors start appearing in dmesg.
> 
> At this point, the device either never recovers and requires a reconnect
> to work correctly or it eventually recovers (after about 15 to 20
> seconds) and continues the transfer as expected.
> 
> A dmesg of the device failing to recover can be found here: [3]
> 
> I can't reproduce a case where the device recovers right now, but
> I found a StackExchange question with the same problem and an attached
> dmesg. The general content of those error messages (maybe apart
> from the hex output) is similiar to what I've been seeing: [4]
> 
> I'll try and see if I can hit a recoverable error myself in the next
> few days.
> 
> [3] https://pastebin.com/raw/ny128rB4

Ok, so what we are seeing there is that the usb-sata bridge has basically
completely crashed. Normally it should always recover from a crash.

This really feels like a brownout (supply voltage too low) event has
happened, as that is typically the only thing which will hang the
bridge like this.

> [4] https://pastebin.com/raw/i7KLzy6i
> 
>>
>> Also note that using UAS, since it has much better performance,
>> will often expose bugs which are not caused by it. One typical
>> example is bus-powered devices where the USB port does not deliver
>> enough power (typically the driver draws more then the port
>> guanrantees). Copying large amounts of data on a fast device is
>> a good way to make the current consumption go up and thus
>> trigger these kind of issues.  Does the driver enclosure
>> you see this on use a separate power supply, or is it
>> bus-powered?
> 
> It is indeed a bus-powered enclosure/adapter, which I'm using with
> an USB 3.0 port. The attached SSD is rated for 5V/0.7A. However,
> (as mentioned above) I am reaching the same read speeds with and
> without UAS, so I'm not quite sure whether it really is a power limit
> caused by heavy load.

As I've tried to explain above, UAS allows more then one command
to be outstanding at once. Even if you are only copying a single file
then the Linux kernel will send more requests for blocks further ahead
in the file. This will make the SSD work harder to put the data in its
buffer, so even if the average through put stays the same the peak
energy consumption of the SSD may increase.

So far I've not really heard or seen anything which indicates that
there is a systematic problem with the JMS561U bridge. I'm actually
pretty sure you will find similar bug reports for Windows...

Have you tried using the drive in a different USB-3 port (on
a different machine perhaps) and/or with a different (shorter) USB3
cable?

Regards,

Hans



>>> ---
>>> v2: Fixed entry order. Also, CCing the correct people now.
>>> ---
>>>    drivers/usb/storage/unusual_uas.h | 7 +++++++
>>>    1 file changed, 7 insertions(+)
>>>
>>> diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
>>> index 1b23741036ee..a590f4a0d4b9 100644
>>> --- a/drivers/usb/storage/unusual_uas.h
>>> +++ b/drivers/usb/storage/unusual_uas.h
>>> @@ -73,6 +73,13 @@ UNUSUAL_DEV(0x152d, 0x0578, 0x0000, 0x9999,
>>>            USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>>>            US_FL_BROKEN_FUA),
>>>
>>> +/* Reported-by: Tim Schumacher <timschumi@gmx.de> */
>>> +UNUSUAL_DEV(0x152d, 0x1561, 0x0000, 0x9999,
>>> +        "JMicron",
>>> +        "JMS561U",
>>> +        USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>>> +        US_FL_IGNORE_UAS),
>>> +
>>>    /* Reported-by: Hans de Goede <hdegoede@redhat.com> */
>>>    UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
>>>            "VIA",
>>> -- 
>>> 2.25.0
>>>
>>
> 

