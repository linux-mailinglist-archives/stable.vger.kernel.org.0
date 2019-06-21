Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 705B44E635
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 12:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfFUKgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 06:36:22 -0400
Received: from mout.gmx.net ([212.227.15.19]:42117 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbfFUKgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Jun 2019 06:36:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1561113373;
        bh=FZ3nDCFIqN8mN8VuNfZpLg/uHuIVZrVV40D1UObVCuU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=gYr0XtF0rerojtRGK8y/dL+tkZbUSPRjbMslTtDKogey4krDMF5xZFRZJmBNxegfD
         s21QimIAafXavDd8y4AJWZxpSp4Hw5iPvnwI6aLRPjbbcAu9YKCPtF6/wJbCOr21rH
         8aIKi3VjdjyomNJFSsEj3TdZi9ckSBM+lzf0OymQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.129.11] ([95.91.214.138]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MqJm5-1iRIlz3LEJ-00nOdZ; Fri, 21
 Jun 2019 12:36:12 +0200
Subject: Re: [PATCH] hid: add another quirk for Chicony PixArt mouse
To:     Oleksandr Natalenko <oleksandr@redhat.com>,
        Jiri Kosina <jikos@kernel.org>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        "Herton R . Krzesinski" <herton@redhat.com>,
        Oliver Neukum <oneukum@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20190621091736.14503-1-oleksandr@redhat.com>
 <20190621093920.qlnhbneoww7c6axw@butterfly.localdomain>
From:   Sebastian Parschauer <s.parschauer@gmx.de>
Message-ID: <b3cbee0c-07ef-5943-cc8f-f4fa0f854440@gmx.de>
Date:   Fri, 21 Jun 2019 12:36:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190621093920.qlnhbneoww7c6axw@butterfly.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:W6/wR0IEZxVWoFe2j3QAOvBtKC2Xi4gdB1zncHkFkRFdu1PvOnC
 LUlGvs/BfhzcPJ9q8EOz67FesZKKEVP3CQ6Le+RRDZXpLtFZ5h5Xv384Vy5ekSRFR0Y4wpl
 O/6LyJbQHfwOTKpPI8QwGoFJIxeWekMX79OEX0/GTp4yfhMy0qpBB78yPcRigLnMcOpd0ow
 UVZ72vpmXGy/eXXG68Yrg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:msNBR1fBoEY=:qpSyOprnk90y65UWlATTK6
 rFfO7TF0dwDTJNSlKZAuuLb2wceeqVnbEkCwLjMpTsj3RhTQFZGJa9OAAlQfClTazSonRPne5
 n67Hgapw6T254h76q43hrRBlh+7K3KNaQYKFH8OB7aFWRCqnq2ASatNHviuhtWMMsbs4kwPQV
 zGOD2TD94cu9/zDPdJJYka3CvLB9IrTgKuiUuKeSTJfAEIc2vqPbwzbkfVT8PPosRhUB8SqkW
 FcyNTH6cA02RV51SjPSHGe+fCx4TB/dA/C0A1HqHyrF1n62kEdgQ0a5mqULqz2K2hgxcQCPL/
 E9Gu36ou8xRHQB4ccSpXKlFm4ZY7++mI2YUiv4CKVgLFo+9Y6NOmmrDIPwyWBKlVNKRqjYMC5
 G/T0OC0ruy6k3f4/efxmoL0LrST7c6i20U4JEhaYL6eBZWf4vQPvf3XXmRBOzIsd+2aOy0Xs/
 xnXoWkbPYOizvSeJa3gVCfcBSuacgHtgdMMJ2wDQUWqOU895tEvS3FPuncCgwGR8oDeu/aMAq
 ASpJCm3tPoQWDyHCYQKUSAbBRU6qf86V6GrhnshlwHrXSY2qp4vDIHoo8fNJCJP8dqwd4Gcca
 zbQzLgdmlxGklJ/5jEITSGAl54hCTqx3+hZlJk4ss8S+5lvEn3xIAiFaWclUq2TQ8BbLqTtsd
 fY4zVmkrzTxZX9XwuEW3ac297RGj7uEHgW7y6fiDJzZNSkVcJGMCCSk9j/Mh0ep0g2BZ6QSxo
 Yj1q7mOO+vQ4gychCo3XuBuyGHX+aD0VFAOrJ+r+Ft+JiQAFUvfG5TeKc6NBUd2lGGRwZDZ5T
 FIAn3fulwhrhtRqto3pV9HEBmzdtf/efRfObHwGko4aiyAoGf5/QkQdgKpo7CS5AGFBSoYUAU
 F6Ahf20BgQk1uInMbO9eR0MQcl/8v4Qet3rFWzBMlp+0IZzfu3YErc20e98Nu0g21ITZOkczU
 +TYxAUjds150CEibV7neYBCdb00uwXmobrqLSFlKsoVuhR/8CYsAo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks, got it on my radar already since Feb 5:

https://github.com/sriemer/fix-linux-mouse/issues/15#issuecomment-46071311=
5

If you see "Manufacturer: PixArt", then chances are high, that the
device is affected. IMHO generic quirks like described in GitHub issue
#20 would cover those easier.

Acked-by: Sebastian Parschauer <s.parschauer@gmx.de>

On 21.06.19 11:39, Oleksandr Natalenko wrote:
> Erm. Cc: s.parschauer@gmx.de instead of inactive @suse address.
>
> On Fri, Jun 21, 2019 at 11:17:36AM +0200, Oleksandr Natalenko wrote:
>> I've spotted another Chicony PixArt mouse in the wild, which requires
>> HID_QUIRK_ALWAYS_POLL quirk, otherwise it disconnects each minute.
>>
>> USB ID of this device is 0x04f2:0x0939.
>>
>> We've introduced quirks like this for other models before, so lets add
>> this mouse too.
>>
>> Link: https://github.com/sriemer/fix-linux-mouse#usb-mouse-disconnectsr=
econnects-every-minute-on-linux
>> Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
>> ---
>>   drivers/hid/hid-ids.h    | 1 +
>>   drivers/hid/hid-quirks.c | 1 +
>>   2 files changed, 2 insertions(+)
>>
>> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
>> index eac0c54c5970..69f0553d9d95 100644
>> --- a/drivers/hid/hid-ids.h
>> +++ b/drivers/hid/hid-ids.h
>> @@ -269,6 +269,7 @@
>>   #define USB_DEVICE_ID_CHICONY_MULTI_TOUCH	0xb19d
>>   #define USB_DEVICE_ID_CHICONY_WIRELESS	0x0618
>>   #define USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE	0x1053
>> +#define USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE2	0x0939
>>   #define USB_DEVICE_ID_CHICONY_WIRELESS2	0x1123
>>   #define USB_DEVICE_ID_ASUS_AK1D		0x1125
>>   #define USB_DEVICE_ID_CHICONY_TOSHIBA_WT10A	0x1408
>> diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
>> index e5ca6fe2ca57..671a285724f9 100644
>> --- a/drivers/hid/hid-quirks.c
>> +++ b/drivers/hid/hid-quirks.c
>> @@ -42,6 +42,7 @@ static const struct hid_device_id hid_quirks[] =3D {
>>   	{ HID_USB_DEVICE(USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_UC100KM), HI=
D_QUIRK_NOGET },
>>   	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_MULTI_=
TOUCH), HID_QUIRK_MULTI_INPUT },
>>   	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_PIXART=
_USB_OPTICAL_MOUSE), HID_QUIRK_ALWAYS_POLL },
>> +	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_PIXART_=
USB_OPTICAL_MOUSE2), HID_QUIRK_ALWAYS_POLL },
>>   	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELE=
SS), HID_QUIRK_MULTI_INPUT },
>>   	{ HID_USB_DEVICE(USB_VENDOR_ID_CHIC, USB_DEVICE_ID_CHIC_GAMEPAD), HI=
D_QUIRK_BADPAD },
>>   	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_3AXIS_5BUTTON_ST=
ICK), HID_QUIRK_NOGET },
>> --
>> 2.22.0
>>
>
