Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8041497B1
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 20:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgAYT7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 14:59:32 -0500
Received: from mout.gmx.net ([212.227.15.15]:55045 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgAYT7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Jan 2020 14:59:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1579982367;
        bh=Qmh3A/3Tiq3eMGvI/r8XvyFyhs1aZcEAlUzD1Jfz/SA=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=PV+B7i1uWYW9EsS7sOoNw+husq96QvbayOYMvrcGky46o6DG2od32mM4wTL+DSuxc
         unQxXxyID+k4ZhzSCUy/3iOU8LHpyJefW46Bt8xS5sbt90Hadw/NGw805BBIGThuof
         W2PzwcH1P6SPffqmg0/wKLFJrQgI5LYiXUYPcvh8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.210] ([79.213.222.219]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MjjCL-1jKM5M2JEB-00lCLt; Sat, 25
 Jan 2020 20:59:27 +0100
Subject: Re: [PATCH v2] USB: uas: Add the no-UAS quirk for JMicron JMS561U
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
References: <20200125064838.2511-1-timschumi@gmx.de>
 <20200125170030.25331-1-timschumi@gmx.de>
 <fccf2105-d415-7f44-e111-729d2d517ea7@redhat.com>
From:   Tim Schumacher <timschumi@gmx.de>
Message-ID: <f9643202-c029-efe1-c213-b54b2ccf9c47@gmx.de>
Date:   Sat, 25 Jan 2020 20:59:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <fccf2105-d415-7f44-e111-729d2d517ea7@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:M0NC9qyN3PnRTExu3reattDpcaFELKGMY7XbNZsHwEWoT6m13rn
 30mQccjx7ffbeW20cEBbkBGK99ZD57V80C0OnSBdwFKhluKd6cLAd8fzh1cltHRCtyqqfkm
 hNzS1DPGKD7qG2YZXZkI0oN5rFco+YYzbqLYmEZeJC/nLZ2X3IkNCWjW6KX5qE08IJU3CuR
 ufgP3QV84KWPYA7AQ/e0g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sX5tXol89BY=:zVEMR+yWXTdviga3Dc4ATX
 +7BIG8AkpFiMAd2dIgTqX1qiI8oNB6WFBA5z+q+lR5bkziWgP8XpFmawkWNqOmUwu2uhXykLT
 AMaZ6scpc13jZsyL4d4TDQrGImhx4C56AREagW52bXzwmC7oB1pNgojoil2VpCKfsOlsbpr8U
 S95Q02PlL+n4ChePSncGAx/3pQugGEbloL+LCONOAVYlo7JMfIiP7LJbqQcz25SvrU0HouG3z
 O19WhjRx4nEDSf1ctEqSCGazjZRJw401FcU0CP3j9sMSR//jX6YYSfPwD7+mvTOTeBNXAEWTJ
 id+D7FktRXlRfu5ZF5ykMx6+3lXOw6OS1CoQ9HK58/Uq0sqEYf1GYKTn3XY/Cf8HpZUqnH1X4
 yR+ftDIRLY9a7PRxHXerZobJ5lQkTS4z04Ml0sEMwqZT1kYpvE3jtajVYGx82eVWRZGpMWpbN
 olFMkYEygBwYwFo5C1yCN7o6ds/dTwB/zI2PKiNvKQwlm9cvRaIKYKDOSJC8IDQs3aea+/wNg
 CLdE3fGdjh8fPP/RT7JxbPLHUNFr5OS+cWTIn0VOXWkQyHfVoHb5bxOOum8mkVCy6CqixLn1i
 CGOXkgn+ZolSe2GY47q1s41TAv9QBWoDghDmu1u04n3wdvLbdpTRH15qquvP1WgS4kHMcNUsV
 aHOKMNyQ+jMukE3IPy8VquHwcNMs+Z6zNdcdhP5cQcnmM1ugprhogttByvW+pwIH4d5rKvcM+
 NEPNRkpH4sTeXjEQR9lkIVrRAWkGqlit2OSNunEkAGt4cJGimska84VaCXKvGdpTCrE0AWoSE
 x3PT1FdCkDE5/qlBi8HbgYebH+TnTOplfrXTl2rg95W2PS+0sSsU5ZE5j7E2cBfK+j/O3JPvl
 hwOKv7XP2QefHxPRw8CYj+PnprV7YDtXjdKQCGp9W36oEj1/ojbyegQwDq6PKfycMAg7UB3uR
 8Z99aFy75iQYdv9O9108uJMi7zCD2nKoioSof8DdJ02+vsITOjCDSlUwi5FyG4Zy+kR/qIKfa
 C5V2dmBOetUiN0RG8EfNNJSvKlOAZMh5Y9QVo597K5u4IhLslb1hF4f/c1TxlXXoqE8gw5XCC
 65UyEamJoLxHCQopfwvM0biMCo1X6Atk/ImDGAdX2dEAo/sUQFLnLHdUhWPciCzmR8CX0oHJ6
 NghQ0sYQ537eDPNa+OJC7+JHB/wzQKcSeJatNRSBxeZtw8MpeT+lGdoVKVDMS7Hq58FrFkWRb
 jEkyXH+iMC+0nkgyt
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25.01.20 19:37, Hans de Goede wrote:> Hi,
>
> On 1/25/20 6:00 PM, Tim Schumacher wrote:
>> The JMicron JMS561U (notably used in the Sabrent SATA-to-USB
>> bridge) appears to have UAS-related issues when copying large
>> amounts of data, causing it to stall.
>>
>> Disabling the advertised UAS (either through a command-line
>> quirk or through this patch) mitigates those issues.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Tim Schumacher <timschumi@gmx.de>
>
> Hmm, this is a quiete popular usb2sata bridge and disabling uas
> is quite bad for performance.

I haven't been able to notice any slowdown myself, averaging 350MB/s
while copying large files, before and after the patch. However, from
what I've been able to grasp, the actual advantage of UAS seems to
be located in even higher speeds, which I can't properly test with my
equipment.

It's a valid concern though, since SATA 3 theoretically goes way
higher than what I can reach.

>
> I notice that there is no link to a bug report and AFAIK we have
> no one else reporting this issue.

I haven't specifically looked on the kernel bug tracker yet, but I
found similiar UAS-related issues talking about the JMicron JMS567
and JMS579 on the Ubuntu kernel bug tracker [1], as well as the
Raspberry Pi bug tracker [2].

If it helps, I can make this a proper bug report first so that other
people can chime in, instead of burying the discussion in the mailing
list.

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1789589
[2] https://github.com/raspberrypi/linux/issues/3070

>
> So this feels like a much too big hammer for the problem which you
> are seeing.
>
> When you say "stall" what exactly happens? Do you see any errors
> in dmesg for example?

Basically, the transfer just freezes at one point (be it an actual
file transfer or just browsing directories quite fast), and a few
seconds later, UAS-related errors start appearing in dmesg.

At this point, the device either never recovers and requires a reconnect
to work correctly or it eventually recovers (after about 15 to 20
seconds) and continues the transfer as expected.

A dmesg of the device failing to recover can be found here: [3]

I can't reproduce a case where the device recovers right now, but
I found a StackExchange question with the same problem and an attached
dmesg. The general content of those error messages (maybe apart
from the hex output) is similiar to what I've been seeing: [4]

I'll try and see if I can hit a recoverable error myself in the next
few days.

[3] https://pastebin.com/raw/ny128rB4
[4] https://pastebin.com/raw/i7KLzy6i

>
> Also note that using UAS, since it has much better performance,
> will often expose bugs which are not caused by it. One typical
> example is bus-powered devices where the USB port does not deliver
> enough power (typically the driver draws more then the port
> guanrantees). Copying large amounts of data on a fast device is
> a good way to make the current consumption go up and thus
> trigger these kind of issues.  Does the driver enclosure
> you see this on use a separate power supply, or is it
> bus-powered?

It is indeed a bus-powered enclosure/adapter, which I'm using with
an USB 3.0 port. The attached SSD is rated for 5V/0.7A. However,
(as mentioned above) I am reaching the same read speeds with and
without UAS, so I'm not quite sure whether it really is a power limit
caused by heavy load.

>
> Regards,
>
> Hans
>

Tim

>
>> ---
>> v2: Fixed entry order. Also, CCing the correct people now.
>> ---
>>    drivers/usb/storage/unusual_uas.h | 7 +++++++
>>    1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/un=
usual_uas.h
>> index 1b23741036ee..a590f4a0d4b9 100644
>> --- a/drivers/usb/storage/unusual_uas.h
>> +++ b/drivers/usb/storage/unusual_uas.h
>> @@ -73,6 +73,13 @@ UNUSUAL_DEV(0x152d, 0x0578, 0x0000, 0x9999,
>>    		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>>    		US_FL_BROKEN_FUA),
>>
>> +/* Reported-by: Tim Schumacher <timschumi@gmx.de> */
>> +UNUSUAL_DEV(0x152d, 0x1561, 0x0000, 0x9999,
>> +		"JMicron",
>> +		"JMS561U",
>> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>> +		US_FL_IGNORE_UAS),
>> +
>>    /* Reported-by: Hans de Goede <hdegoede@redhat.com> */
>>    UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
>>    		"VIA",
>> --
>> 2.25.0
>>
>
