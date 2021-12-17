Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B4F478609
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 09:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhLQIN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 03:13:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230247AbhLQIN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 03:13:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639728805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TMi8vKGEoNZOeoc9Y+ptTHulTv0+P5nlOPdCCjIwf54=;
        b=eus8voLDo4kLNgBjG7RkgTFNkNCRGeFoftHXowKNxTbu28kcBOzQ4iLAqTVJ+WPjSkbhj5
        o8w14YmjvtmC66BM9SuDH/9hxanjTfd3zqCrMbMCcrywILH9ZwAfLzYYs0JlKRWLyqwi/e
        7Bhm/y+oNtyrUWR4uOGMn2dWjKbJNFw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-qYm-I92cN4OQeY0XmPj6tw-1; Fri, 17 Dec 2021 03:13:22 -0500
X-MC-Unique: qYm-I92cN4OQeY0XmPj6tw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 645A185EE60;
        Fri, 17 Dec 2021 08:13:20 +0000 (UTC)
Received: from [10.39.193.177] (unknown [10.39.193.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC4AD163D2;
        Fri, 17 Dec 2021 08:13:16 +0000 (UTC)
Message-ID: <42903605-7e8b-4e84-fcd6-1b23169b8639@redhat.com>
Date:   Fri, 17 Dec 2021 09:13:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: FWD: Holtek mouse stopped working after kernel upgrade from
 5.15.7 to 5.15.8
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     tlinux@cebula.eu.org, linux-input@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <e4efbf13-bd8d-0370-629b-6c80c0044b15@leemhuis.info>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
In-Reply-To: <e4efbf13-bd8d-0370-629b-6c80c0044b15@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 12/17/21 08:00, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker speaking.
> 
> I noticed a bugreport from Tomasz C. (CCed) that sounds a lot like a
> regression between v5.15.7..v5.15.8 and likely better dealt with by email:
> 
> To quote from: https://bugzilla.kernel.org/show_bug.cgi?id=215341
> 
>> After updating kernel from 5.15.7 to 5.15.8 on ArchLinux distribution, Holtek USB mouse stopped working.
>> Exact model:
>> 04d9:a067 Holtek Semiconductor, Inc. USB Gaming Mouse
>>
>> The dmesg output for this device from kernel version 5.15.8:
>>
>> [    2.501958] usb 2-1.2.3: new full-speed USB device number 6 using ehci-pci
>> [    2.624369] usb 2-1.2.3: New USB device found, idVendor=04d9, idProduct=a067, bcdDevice= 1.16
>> [    2.624376] usb 2-1.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> [    2.624379] usb 2-1.2.3: Product: USB Gaming Mouse
>> [    2.624382] usb 2-1.2.3: Manufacturer: Holtek
>>
>> After disconnecting and connecting the USB:
>>
>> [   71.976731] usb 2-1.2.3: USB disconnect, device number 6
>> [   75.013021] usb 2-1.2.3: new full-speed USB device number 8 using ehci-pci
>> [   75.135865] usb 2-1.2.3: New USB device found, idVendor=04d9, idProduct=a067, bcdDevice= 1.16
>> [   75.135873] usb 2-1.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> [   75.135877] usb 2-1.2.3: Product: USB Gaming Mouse
>> [   75.135880] usb 2-1.2.3: Manufacturer: Holtek
>>
>>
>> On kernel version 5.15.7:
>>
>> [    2.280515] usb 2-1.2.3: new full-speed USB device number 6 using ehci-pci
>> [    2.379777] usb 2-1.2.3: New USB device found, idVendor=04d9, idProduct=a067, bcdDevice= 1.16
>> [    2.379784] usb 2-1.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> [    2.379787] usb 2-1.2.3: Product: USB Gaming Mouse
>> [    2.379790] usb 2-1.2.3: Manufacturer: Holtek
>> [    2.398578] input: Holtek USB Gaming Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.3/2-1.2.3:1.0/0003:04D9:A067.0005/input/input11
>> [    2.450977] holtek_mouse 0003:04D9:A067.0005: input,hidraw4: USB HID v1.10 Keyboard [Holtek USB Gaming Mouse] on usb-0000:00:1d.0-1.2.3/input0
>> [    2.451013] holtek_mouse 0003:04D9:A067.0006: Fixing up report descriptor
>> [    2.452189] input: Holtek USB Gaming Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.3/2-1.2.3:1.1/0003:04D9:A067.0006/input/input12
>> [    2.468510] usb 2-1.2.4: new high-speed USB device number 7 using ehci-pci
>> [    2.503913] holtek_mouse 0003:04D9:A067.0006: input,hiddev96,hidraw5: USB HID v1.10 Mouse [Holtek USB Gaming Mouse] on usb-0000:00:1d.0-1.2.3/input1
>> [    2.504105] holtek_mouse 0003:04D9:A067.0007: hiddev97,hidraw6: USB HID v1.10 Device [Holtek USB Gaming Mouse] on usb-0000:00:1d.0-1.2.3/input2
>>
>> Rolling back the kernel to version 5.15.7 solves the problem.

Oops, sorry. An overlook from a precedent commit.

Can you confirm the following patch works? (and also tell me if the
links I put are sufficient for regzbot)
---
rom 8f38596f2620c4b22ff9e2622917ac2b69aa8320 Mon Sep 17 00:00:00 2001
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date: Fri, 17 Dec 2021 09:03:32 +0100
Subject: [PATCH] HID: holtek: fix mouse probing

An overlook from the previous commit: we don't even parse or start the
device, meaning that the device is not presented to user space.

Fixes: 93020953d0fa ("HID: check for valid USB device for many HID drivers")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215341
Link: https://lore.kernel.org/regressions/e4efbf13-bd8d-0370-629b-6c80c0044b15@leemhuis.info/
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
  drivers/hid/hid-holtek-mouse.c | 15 +++++++++++++++
  1 file changed, 15 insertions(+)

diff --git a/drivers/hid/hid-holtek-mouse.c b/drivers/hid/hid-holtek-mouse.c
index b7172c48ef9f..7c907939bfae 100644
--- a/drivers/hid/hid-holtek-mouse.c
+++ b/drivers/hid/hid-holtek-mouse.c
@@ -65,8 +65,23 @@ static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
  static int holtek_mouse_probe(struct hid_device *hdev,
  			      const struct hid_device_id *id)
  {
+	int ret;
+
  	if (!hid_is_usb(hdev))
  		return -EINVAL;
+
+	ret = hid_parse(hdev);
+	if (ret) {
+		hid_err(hdev, "hid parse failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	if (ret) {
+		hid_err(hdev, "hw start failed: %d\n", ret);
+		return ret;
+	}
+
  	return 0;
  }
  
-- 
2.31.1
---

Cheers,
Benjamin

> 
> [TLDR for the rest of the mail: adding this regression to regzbot; most
> text you find below is compiled from a few templates paragraphs some of
> you might have seen already.]
> 
> To be sure this issue doesn't fall through the cracks unnoticed, I'm
> adding it to regzbot, my Linux kernel regression tracking bot:
> 
> #regzbot introduced v5.15.7..v5.15.8
> #regzbot title usb: Holtek mouse stopped working
> 
> Reminder: when fixing the issue, please add a 'Link:' tag with the URL
> to this report and the bugzilla ticket, then regzbot will automatically
> mark the regression as resolved once the fix lands in the appropriate
> tree. For more details about regzbot see footer.
> 
> Ciao, Thorsten (wearing his 'Linux kernel regression tracker' hat).
> 
> P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
> on my table. I can only look briefly into most of them. Unfortunately
> therefore I sometimes will get things wrong or miss something important.
> I hope that's not the case here; if you think it is, don't hesitate to
> tell me about it in a public reply. That's in everyone's interest, as
> what I wrote above might be misleading to everyone reading this; any
> suggestion I gave thus might sent someone reading this down the wrong
> rabbit hole, which none of us wants.
> 
> BTW, I have no personal interest in this issue, which is tracked using
> regzbot, my Linux kernel regression tracking bot
> (https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
> this mail to get things rolling again and hence don't need to be CC on
> all further activities wrt to this regression.
> 
> 

