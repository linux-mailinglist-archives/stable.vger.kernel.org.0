Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8C0E4734
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 11:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408763AbfJYJaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 05:30:02 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43384 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406381AbfJYJaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 05:30:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571995799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vevRbtxqoCdBHHto31nx9oUggsNlCQYRfoaNFkJ+hXs=;
        b=TiR6O96kQKpqcWxZybdKD+r0oUFh4RBRZfkTKiJ/Nc6Y9s2xwoNkTYQ+N1szxdfsBGbGya
        KrROakgg64XSEKRPWTObSpL7PNwLwiD3Q6wcd/m/DgQtsIr5DeOS7JcmkVMW0fGFxNwnXv
        LeFatpXQ1Jbsf1QopJy+zwMRp5auYTA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-6jtEtGISOC-ftIP49ERrwg-1; Fri, 25 Oct 2019 05:29:54 -0400
Received: by mail-wm1-f72.google.com with SMTP id z23so654687wml.0
        for <stable@vger.kernel.org>; Fri, 25 Oct 2019 02:29:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qLqWfDn7mttDDHUevmNrSUhDR74CF88kXKgpUOWtbNg=;
        b=KuiUa3U8O7/g5gJ2VtITXjbR4AUyBpPDVg8k8o5SL2JqR6HaE1vnLQ3ex9iC5S1GcL
         zsJOrCl53u4PDJky5sPHlR78z+6CIvyk8ArdAp6QeRL4U0B15jnIe83Vy3vpaPflR6eR
         CYRwFl7ROuVyuV+u3kKDajSDu05DXuCFawkxfLmBbo6gR/RpYHrJQrJsWmKMKxIQY2g2
         UBx44HdPvHY8Q3UrYr7wtBsJn+SOoVCzWYPC809X/B0O8ZVK0oycK3Wvb+Rd4RqXzQne
         3Al6NYq4sa17owC1/QHo31V8/oqHUTfSoj/FQA8b95GBR263CugtofdfBh+a98vSS4YG
         gsuA==
X-Gm-Message-State: APjAAAU0FCc+f+gK+Vv8JlMEhX+lq35m56bVe7b5EpOj2SzvIRbiINI6
        GCeGtLzRjJ7CoQkgDDF2/PtjAcLCxI8UVjl/oGCDaiA01dQwSvoZ2zIApBEp23s6YWMw4LfpD2k
        WKhRg8qT4XZKKBPmr
X-Received: by 2002:a5d:544d:: with SMTP id w13mr2065031wrv.19.1571995792415;
        Fri, 25 Oct 2019 02:29:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwagQDB0UO+vgjG8JkAkRqg1Pq1nfCRIE0Bf7Oco15MK15VwryPFdAJBEpLLvQ98b8H6sRGkg==
X-Received: by 2002:a5d:544d:: with SMTP id w13mr2065006wrv.19.1571995792104;
        Fri, 25 Oct 2019 02:29:52 -0700 (PDT)
Received: from shalem.localdomain (2001-1c00-0c14-2800-ec23-a060-24d5-2453.cable.dynamic.v6.ziggo.nl. [2001:1c00:c14:2800:ec23:a060:24d5:2453])
        by smtp.gmail.com with ESMTPSA id v10sm1500905wrm.26.2019.10.25.02.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2019 02:29:51 -0700 (PDT)
Subject: Re: [PATCH 1/3] ACPI / LPSS: Add LNXVIDEO -> BYT I2C7 to
 lpss_device_links
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
References: <20191024212936.144648-1-hdegoede@redhat.com>
 <CAJZ5v0jDuvEBob93wgYFuz0q1QyraOtxnbs-xqBOM_87jBnKqw@mail.gmail.com>
 <5c15fd87-414a-41fb-48a2-11c675ed6cfb@linux.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <aa898bac-6636-8901-8733-d699152fb59c@redhat.com>
Date:   Fri, 25 Oct 2019 11:29:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <5c15fd87-414a-41fb-48a2-11c675ed6cfb@linux.intel.com>
Content-Language: en-US
X-MC-Unique: 6jtEtGISOC-ftIP49ERrwg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 25-10-2019 01:18, Pierre-Louis Bossart wrote:
>=20
>=20
> On 10/24/19 4:34 PM, Rafael J. Wysocki wrote:
>> On Thu, Oct 24, 2019 at 11:29 PM Hans de Goede <hdegoede@redhat.com> wro=
te:
>>>
>>> So far on Bay Trail (BYT) we only have been adding a device_link adding
>>> the iGPU (LNXVIDEO) device as consumer for the I2C controller for the
>>> PMIC for I2C5, but the PMIC only uses I2C5 on BYT CR (cost reduced) on
>>> regular BYT platforms I2C7 is used and we were not adding the device_li=
nk
>>> sometimes causing resume ordering issues.
>>>
>>> This commit adds LNXVIDEO -> BYT I2C7 to the lpss_device_links table,
>>> fixing this.
>>>
>>> Cc: stable@vger.kernel.org
>>
>> Thanks for these fixes, but it would be kind of nice to have Fixes:
>> tags for them too.
>=20
> Nice, this removes the warnings I saw on Asus T100TA
> [=C2=A0=C2=A0 56.015285] i2c_designware 80860F41:00: Transfer while suspe=
nded
>=20
> Thanks Hans! Feel free to take the following tag for your v2.
>=20
> Tested-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

Thanks, but I've already send out v2 (without you in the Cc since nothing w=
as changed)
I've added your tested-by to my local version in case another revision is n=
ecessary.

> Maybe an unrelated point, but with this series I now see a new message (l=
ogged only once):
> [=C2=A0=C2=A0 46.888703] ACPI: button: The lid device is not compliant to=
 SW_LID.

Yes the iGPU _PS0 method seems to much with the LID switch status, but this=
 is
harmless this happens on a lot of laptops. TBH I wonder if we should not ju=
st
remove this message?

> Not sure what exactly this is about, but it may be linked to the fact tha=
t the power button is useless to resume and somehow I have to close/reopen =
the lid to force the device to resume.

The powerbutton not working is likely unrelated and TBH is a bit surprising=
 I
do not have a T100TA at hand atm, but on the closely related T200TA it work=
s fine.

I think your kernel .config may have some settings which cause this. Specif=
ically
for the powerbutton to work, it must work as a GPIO-button.

Can you try:

sudo evemu-record

You should then see something like this:

Available devices:
/dev/input/event0:      Lid Switch
/dev/input/event1:      Sleep Button
/dev/input/event2:      Asus Keyboard
/dev/input/event3:      Asus Keyboard
/dev/input/event4:      Asus TouchPad
/dev/input/event5:      SIS0817:00 0457:1084
/dev/input/event6:      Video Bus
/dev/input/event7:      Asus Wireless Radio Control
/dev/input/event8:      Intel HDMI/DP LPE Audio HDMI/DP,pcm=3D0
/dev/input/event9:      Intel HDMI/DP LPE Audio HDMI/DP,pcm=3D1
/dev/input/event10:     PC Speaker
/dev/input/event11:     Asus WMI hotkeys
/dev/input/event12:     gpio-keys
/dev/input/event13:     gpio-keys
/dev/input/event14:     bytcr-rt5640 Headset

Then select the second gpio-keys, so in my case I enter: "13<enter>"

Then in the output you should see:

#   Event type 1 (EV_KEY)
#     Event code 116 (KEY_POWER)
#     Event code 125 (KEY_LEFTMETA)
#     Event code 561 ((null))

Among more output, now press the powerbutton, then you should see:

E: 0.000001 0001 0074 0001      # EV_KEY / KEY_POWER            1
E: 0.000001 0000 0000 0000      # ------------ SYN_REPORT (0) ---------- +0=
ms
E: 0.121208 0001 0074 0000      # EV_KEY / KEY_POWER            0
E: 0.121208 0000 0000 0000      # ------------ SYN_REPORT (0) ---------- +1=
21ms

After which the machine suspends. Then press it again and the machine shoul=
d
wakeup (note it does not matter how you put it to sleep) on some devices yo=
u
may now see another power-button press for the wake-up. Note note all deskt=
op-
environments handle the second power-button press well. Some immediately
re-suspend again, which may be what you are seeing.

I tried to fix this on the kernel side, but the wakeup press being reported=
 is
a feature Android relies on to no immediately resuspend if woken up another=
 way
so the input kernel folks nacked filtering out the second press. Instead I'=
ve
fixed this in userspace for gnome with this commit:

https://gitlab.gnome.org/GNOME/gnome-settings-daemon/commit/f2ae8a3b9905cde=
7a9c12f78cb84689e97203380

So it could also be that this is what you are seeing. If that is the case
then a single attempt to suspend + resume via power-button + second resume
attempt with the LID should result in 2 suspends/resumes showing in dmesg
and you should see they wakeup-powerbutton press in evemu-record.

One possible fix for this would be to switch your DE to a recent GNOME.

Regards,

Hans








>=20
> if it helps here are the traces for 2 cycles of suspend/resume.
>=20
> [=C2=A0=C2=A0 34.242313] PM: suspend entry (s2idle)
> [=C2=A0=C2=A0 34.246896] Filesystems sync: 0.004 seconds
> [=C2=A0=C2=A0 34.247265] Freezing user space processes ... (elapsed 0.001=
 seconds) done.
> [=C2=A0=C2=A0 34.249250] OOM killer disabled.
> [=C2=A0=C2=A0 34.249253] Freezing remaining freezable tasks ... (elapsed =
0.000 seconds) done.
> [=C2=A0=C2=A0 34.250195] printk: Suspending console(s) (use no_console_su=
spend to debug)
> [=C2=A0=C2=A0 41.251352] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
> [=C2=A0=C2=A0 41.252948] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
> [=C2=A0=C2=A0 41.254530] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
> [=C2=A0=C2=A0 41.257397] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
> [=C2=A0=C2=A0 41.586893] OOM killer enabled.
> [=C2=A0=C2=A0 41.586898] Restarting tasks ... done.
> [=C2=A0=C2=A0 41.625298] video LNXVIDEO:00: Restoring backlight state
> [=C2=A0=C2=A0 41.625718] PM: suspend exit
> [=C2=A0=C2=A0 45.162584] ax88179_178a 2-1:1.0 enx00051ba24714: ax88179 - =
Link status is: 1
> [=C2=A0=C2=A0 45.171220] IPv6: ADDRCONF(NETDEV_CHANGE): enx00051ba24714: =
link becomes ready
> [=C2=A0=C2=A0 45.400724] ACPI: button: The lid device is not compliant to=
 SW_LID.
> [=C2=A0=C2=A0 58.478184] PM: suspend entry (s2idle)
> [=C2=A0=C2=A0 58.528882] Filesystems sync: 0.051 seconds
> [=C2=A0=C2=A0 58.529354] Freezing user space processes ... (elapsed 0.004=
 seconds) done.
> [=C2=A0=C2=A0 58.533708] OOM killer disabled.
> [=C2=A0=C2=A0 58.533712] Freezing remaining freezable tasks ... (elapsed =
0.000 seconds) done.
> [=C2=A0=C2=A0 58.534648] printk: Suspending console(s) (use no_console_su=
spend to debug)
> [=C2=A0=C2=A0 63.084134] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
> [=C2=A0=C2=A0 63.085736] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
> [=C2=A0=C2=A0 63.087337] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
> [=C2=A0=C2=A0 63.090241] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
> [=C2=A0=C2=A0 63.420651] OOM killer enabled.
> [=C2=A0=C2=A0 63.420656] Restarting tasks ... done.
> [=C2=A0=C2=A0 63.458493] video LNXVIDEO:00: Restoring backlight state
> [=C2=A0=C2=A0 63.458918] PM: suspend exit
> [=C2=A0=C2=A0 66.862343] ax88179_178a 2-1:1.0 enx00051ba24714: ax88179 - =
Link status is: 1
> [=C2=A0=C2=A0 66.869564] IPv6: ADDRCONF(NETDEV_CHANGE): enx00051ba24714: =
link becomes ready
>=20

