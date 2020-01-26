Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E223149CE4
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 21:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgAZUqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 15:46:55 -0500
Received: from mout.gmx.net ([212.227.15.15]:35045 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgAZUqy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Jan 2020 15:46:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1580071608;
        bh=fQjeQlrcQVER7/AQzwGNAU/KC+GHhlR+FAVMtuxS1ok=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=CZFWOc3YKzyub/PBLDdgw7ILkhC2NJXCUHdv4xUpC4Ov+srbv5IWg+zsuH6Naap62
         Un8X2yJNDIK0IzDwnRXdN7t479fZ3uXHvqBoqry5EQIlB60/XxKGckt1JtcbNuLpYz
         JrbI51oVMKlmJRJg6MM8KcDpvLZoz4nd3JboyQg8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.210] ([79.213.222.219]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MfpOd-1jWmJN2J5d-00gH9f; Sun, 26
 Jan 2020 21:46:48 +0100
Subject: Re: [PATCH v2] USB: uas: Add the no-UAS quirk for JMicron JMS561U
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
References: <20200125064838.2511-1-timschumi@gmx.de>
 <20200125170030.25331-1-timschumi@gmx.de>
 <fccf2105-d415-7f44-e111-729d2d517ea7@redhat.com>
 <f9643202-c029-efe1-c213-b54b2ccf9c47@gmx.de>
 <f6153a2c-fdad-09e4-53f9-0bc99d383c0f@redhat.com>
From:   Tim Schumacher <timschumi@gmx.de>
Message-ID: <08db95d1-3d0c-db53-314f-c8bd634d04f7@gmx.de>
Date:   Sun, 26 Jan 2020 21:46:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f6153a2c-fdad-09e4-53f9-0bc99d383c0f@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:wYcvAVpqLMoWT6BfWQBq6R7p6pi+j3uj+GandEdk5Yc3uN5gmg2
 g1F9HYNt50cClZ6l910Q64auxpM/oQsAgRe8EIEPw4ISI3EASTQq6Ub0nmk3K3JOfwsmtLz
 DfMhrSV+gc6fVsJZZ35c9NSy7Th28mkc0l8/pcaGki0PfZgjA8w0zzDqSM5nRHbX3cqrWif
 pT3ERz4KpYLT455739VkA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:lb7LP2Taiw8=:xKE08hU9J8bTma0SQTfizp
 HdHD162WrBGjx+ukJngV0BqjTCDYc2rC1HUHy5Xv+vUtXZI21kUnF9vwMF665SYjiA4e6ndHm
 +V9CREYxHOAIW/t6RbLzfL8cyOVinHJ1g2IK3POjJrrbwu9lmzJkXggyf9c0kANfQ6HzyIea1
 pnHGSwJ7U595ZG3Nx0j66etS+RRiKY1OoN+f8zunM+PbAn8+poYg43q6UxAAEdUS1lwURTADB
 G9v+lixPlPSzBado8NDLgNoDcUEsCAtQBmTZjz2iUjNGl33LGvfe4656aRaPYC9/sAAAJTiLp
 NczkJJYLMYvAyEFagT9723H+gocIbp5IDKh3bLwm3VR2o7W2C8YeHDICsGfHdieJcIx1blnVo
 cvzfnHXxrHTB6BgQYLt5fFWEJbEaXY+ZUwHgQykpEj+4UZUQRfihh7D+KuRklVmB6zYs0Dq5l
 yJZTqchMwlKGERS1LhtK9kOQZbFC0UrP4IoKPwhbPmbW9+XrHahmKtZkg4a/W/lR49NhLJA+3
 amo7kruhR1m5aaf1YiMDBTzZfd8Ts23AIFbyOSmCfGDcOi/B5ZSmGwn0AQyIz1pxZTS3HaPSV
 KtanEApUqWjlqk84WO0jxbgIy1tqy1RIuxg8IK5LvcunNH6spu6G/anmfDslG114vWPwbc8mq
 WOSRoj1zjBRrTosIiU8Y27/Q9RoOwXAa61uPF+Ktg8JiZYCkIbozOBi38JDX61gqBSt0Sxs+o
 V/w5AsQ6sfcNvEOZiATH/ad1ozSfMpCcTkFd31c8CvPiwuyZ7FzXCBbyIO0jmcJuy/QNC3t6I
 FH3U+D7t7Be9TabhDLsReb7Fs3V3M8deLlPmcMB9Txt+emIKUy0BnyhupESGZ+6AUeLBjDgmY
 sSWFOn2E/TYNYEx+Eoc7WU5DsLyPjCvHnHu3usHd/+leFRTnrqXpZXLg7pEE1bx9IREQTLRP7
 N8cvRucDYYqbrTdKbQKUaUQkH5IEIVVRWfv9Hbt/eDD+H0QCh2ol7PxN0UeUVO4fZ0+mBvVRt
 8m9DOfyn6/J6j1uz4MU/IX9BLJFdyuPg95Pi+ZM10kNXgFEJ4mfpgBdAo5/Q8bXaE3Cgoj47B
 b4Dy0oTcP6fL5+EtVoHwljNLTfeOE2w4tG+KE3OBoqVCQFFbpSoIsI5ZprlIMhfkeJ2TfSAcP
 2yiqUnb3a733t2dH/cAvGdG+q4e6iHjIw6rOYYF2+k1o1tNI696DgqeXxk2prjcVv22dMvZoU
 wM4Z+Bnlx//xqJMKR
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26.01.20 16:21, Hans de Goede wrote:
> Hi,
>
> On 25-01-2020 20:59, Tim Schumacher wrote:
>> On 25.01.20 19:37, Hans de Goede wrote:> Hi,
>>>
>>> On 1/25/20 6:00 PM, Tim Schumacher wrote:
>>>> The JMicron JMS561U (notably used in the Sabrent SATA-to-USB
>>>> bridge) appears to have UAS-related issues when copying large
>>>> amounts of data, causing it to stall.
>>>>
>>>> Disabling the advertised UAS (either through a command-line
>>>> quirk or through this patch) mitigates those issues.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Tim Schumacher <timschumi@gmx.de>
>>>
>>> Hmm, this is a quiete popular usb2sata bridge and disabling uas
>>> is quite bad for performance.
>>
>> I haven't been able to notice any slowdown myself, averaging 350MB/s
>> while copying large files, before and after the patch. However, from
>> what I've been able to grasp, the actual advantage of UAS seems to
>> be located in even higher speeds, which I can't properly test with my
>> equipment.
>
> The big difference is not so much linear throughput, as well as
> iops / random access patterns. UAS allows sending multiple data
> requests to the disk at once, which the old bulk mass storage
> protocol does not allow.
>
> Chances are that the times when you are seeing the hangs you
> are also accessing the disk in some other way while copying a large
> file. With the old mass storage protocol in this case the copy
> will pause and then your other access will happen and then the copy
> will resume. UAS allows both to happen "at once" and SSDs are very good
> at this. As you can imagine making the SSD do multiple things at once
> it is also something which really pushes the power-requirements up.

That makes sense, I haven't thought much about that.

Let's put this patch on hold then until I can figure out whether
it really is a power limit that I'm hitting.

>
>> It's a valid concern though, since SATA 3 theoretically goes way
>> higher than what I can reach.
>>
>>>
>>> I notice that there is no link to a bug report and AFAIK we have
>>> no one else reporting this issue.
>>
>> I haven't specifically looked on the kernel bug tracker yet, but I
>> found similiar UAS-related issues talking about the JMicron JMS567
>> and JMS579 on the Ubuntu kernel bug tracker [1], as well as the
>> Raspberry Pi bug tracker [2].
>>
>> If it helps, I can make this a proper bug report first so that other
>> people can chime in, instead of burying the discussion in the mailing
>> list.
>>
>> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1789589
>
> "When the device is under load and more than 1 hardrive is acessed,
> the USB enclosure frequently restarts."
>
> In other words, when I cause the power consumption to go through the
> roof things crash. This smells very much like (yet another) power-supply
> problem.
>
>> [2] https://github.com/raspberrypi/linux/issues/3070
>
> Raspberry Pi's are notorious for having issues supplying enough power
> to their USB ports due to the self-resetting electronic fuses they
> are using, which increase there resistance when the current demand
> peaks, which causes a voltage drop.
>
>
>>
>>>
>>> So this feels like a much too big hammer for the problem which you
>>> are seeing.
>>>
>>> When you say "stall" what exactly happens? Do you see any errors
>>> in dmesg for example?
>>
>> Basically, the transfer just freezes at one point (be it an actual
>> file transfer or just browsing directories quite fast), and a few
>> seconds later, UAS-related errors start appearing in dmesg.
>>
>> At this point, the device either never recovers and requires a reconnec=
t
>> to work correctly or it eventually recovers (after about 15 to 20
>> seconds) and continues the transfer as expected.
>>
>> A dmesg of the device failing to recover can be found here: [3]
>>
>> I can't reproduce a case where the device recovers right now, but
>> I found a StackExchange question with the same problem and an attached
>> dmesg. The general content of those error messages (maybe apart
>> from the hex output) is similiar to what I've been seeing: [4]
>>
>> I'll try and see if I can hit a recoverable error myself in the next
>> few days.
>>
>> [3] https://pastebin.com/raw/ny128rB4
>
> Ok, so what we are seeing there is that the usb-sata bridge has basicall=
y
> completely crashed. Normally it should always recover from a crash.
>
> This really feels like a brownout (supply voltage too low) event has
> happened, as that is typically the only thing which will hang the
> bridge like this.
>
>> [4] https://pastebin.com/raw/i7KLzy6i
>>
>>>
>>> Also note that using UAS, since it has much better performance,
>>> will often expose bugs which are not caused by it. One typical
>>> example is bus-powered devices where the USB port does not deliver
>>> enough power (typically the driver draws more then the port
>>> guanrantees). Copying large amounts of data on a fast device is
>>> a good way to make the current consumption go up and thus
>>> trigger these kind of issues.=A0 Does the driver enclosure
>>> you see this on use a separate power supply, or is it
>>> bus-powered?
>>
>> It is indeed a bus-powered enclosure/adapter, which I'm using with
>> an USB 3.0 port. The attached SSD is rated for 5V/0.7A. However,
>> (as mentioned above) I am reaching the same read speeds with and
>> without UAS, so I'm not quite sure whether it really is a power limit
>> caused by heavy load.
>
> As I've tried to explain above, UAS allows more then one command
> to be outstanding at once. Even if you are only copying a single file
> then the Linux kernel will send more requests for blocks further ahead
> in the file. This will make the SSD work harder to put the data in its
> buffer, so even if the average through put stays the same the peak
> energy consumption of the SSD may increase.
>
> So far I've not really heard or seen anything which indicates that
> there is a systematic problem with the JMS561U bridge. I'm actually
> pretty sure you will find similar bug reports for Windows...

I set up my Windows installation again, so I'll check whether I get
similiar issues on there.

>
> Have you tried using the drive in a different USB-3 port (on
> a different machine perhaps) and/or with a different (shorter) USB3
> cable?

I have tried this on both my PC (both front- and back-facing ports) and
my Laptop, the latter failing as well, but less often.

The cable is unfortunately joined to the enclosure itself, so I can't
try a different one.

>
> Regards,
>
> Hans
>

I'll try a few things in the next days to figure out whether I can confirm
that this is a power-related issue or if it happens on other platforms and
computers.

If I can't find anything related to those two causes, I'll probably report
back with more information.

Tim

>
>
>>>> ---
>>>> v2: Fixed entry order. Also, CCing the correct people now.
>>>> ---
>>>>  =A0=A0 drivers/usb/storage/unusual_uas.h | 7 +++++++
>>>>  =A0=A0 1 file changed, 7 insertions(+)
>>>>
>>>> diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/=
unusual_uas.h
>>>> index 1b23741036ee..a590f4a0d4b9 100644
>>>> --- a/drivers/usb/storage/unusual_uas.h
>>>> +++ b/drivers/usb/storage/unusual_uas.h
>>>> @@ -73,6 +73,13 @@ UNUSUAL_DEV(0x152d, 0x0578, 0x0000, 0x9999,
>>>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>>>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 US_FL_BROKEN_FUA),
>>>>
>>>> +/* Reported-by: Tim Schumacher <timschumi@gmx.de> */
>>>> +UNUSUAL_DEV(0x152d, 0x1561, 0x0000, 0x9999,
>>>> +=A0=A0=A0=A0=A0=A0=A0 "JMicron",
>>>> +=A0=A0=A0=A0=A0=A0=A0 "JMS561U",
>>>> +=A0=A0=A0=A0=A0=A0=A0 USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>>>> +=A0=A0=A0=A0=A0=A0=A0 US_FL_IGNORE_UAS),
>>>> +
>>>>  =A0=A0 /* Reported-by: Hans de Goede <hdegoede@redhat.com> */
>>>>  =A0=A0 UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
>>>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "VIA",
>>>> --
>>>> 2.25.0
>>>>
>>>
>>
>
