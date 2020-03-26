Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC931941B4
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 15:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgCZOkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 10:40:10 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:56551 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726270AbgCZOkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 10:40:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585233607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+7pmCD6xkvohHHddYnsCqDnepGY6BXTnj0qYSuEg3+o=;
        b=Y53jHnPSQWAak2bB6QEoCExhoTLaoCFluqjSly5wf5btX5+tZM4bV6ZIM6ntIEnW3XOmtp
        eCZBzBp5Dzz6QBTL1Q/3GaS1FCHBaEl+F1orGfKHWkQFN4BuzJxB0MO/s4YoLhhpib2SQ8
        FLt2TTPdh9PMRvSqNPFBo+vEaLgvwLQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-IjCw0Z1ZNMuGr3p-aQ_OKQ-1; Thu, 26 Mar 2020 10:40:06 -0400
X-MC-Unique: IjCw0Z1ZNMuGr3p-aQ_OKQ-1
Received: by mail-wr1-f70.google.com with SMTP id o18so3138755wrx.9
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 07:40:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+7pmCD6xkvohHHddYnsCqDnepGY6BXTnj0qYSuEg3+o=;
        b=EDUb8x16yKz77nDeAo3EmoKVxrMU9hdDKpoAqMqzstzi/6mXex/psfMFHXLnP++O18
         tlg5o69x8PYS1gxeSnCJPBS8FTd0+Ar5njAp+foSo0sKHhz7Xyj/0RFB9D/eY8cgSIHE
         CIVlQChfkqbNlpMaTNu0uz1h/z/ZbGcKOPofOuydw9iYAc+tksaA7avOGO8hYfp9tG0C
         7WhoutZc0cydKBs6pkKA6kdMH5DzqVTNJGOT0QfkVBuMGnFJpDyvTB9lkYzo/ViTKmEz
         5ZlUENWTzOcMUIuDmVZqirtYvR+WuuEZZOGa0j6EY23UolmrXJAPqBfUrwq02nJrMUsb
         vBlw==
X-Gm-Message-State: ANhLgQ3tDeUjCIInVc+7fxQiWJg1MM1kRB1WKVZJTuv7yvNNtpW4aTaF
        JcIzmha7f+YLnyZnIPsylmXFOSPJgW9SyxXU2gUvCSX9YOsQk0ERRlASC+AOmfEwlJR2Yab9Dy0
        qzyD2fYFIzCVx256O
X-Received: by 2002:a1c:6189:: with SMTP id v131mr264484wmb.69.1585233603044;
        Thu, 26 Mar 2020 07:40:03 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvp7YcX7Ls4EGXd0g/RUn4KiZ4RV7SEah48CmNsQxuH61q4u7mY8ers7fJTz58/DfbDHlIv4Q==
X-Received: by 2002:a1c:6189:: with SMTP id v131mr264387wmb.69.1585233601849;
        Thu, 26 Mar 2020 07:40:01 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-fc7e-fd47-85c1-1ab3.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:fc7e:fd47:85c1:1ab3])
        by smtp.gmail.com with ESMTPSA id b67sm3771271wmh.29.2020.03.26.07.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 07:40:01 -0700 (PDT)
Subject: Re: [PATCH] drm/vboxvideo: Add missing
 remove_conflicting_pci_framebuffers call
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        stable <stable@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
References: <20200325144310.36779-1-hdegoede@redhat.com>
 <20200326112959.GZ2363188@phenom.ffwll.local>
 <8b9d940d-b236-062d-4ac3-c7462090066f@redhat.com>
 <CAKMK7uHA+uefrWVR42wTss65mq_D4q5odfePm6uj399emkWx8w@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <8fbfde07-be1e-c8c8-2ff4-c7b64c3f150d@redhat.com>
Date:   Thu, 26 Mar 2020 15:39:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAKMK7uHA+uefrWVR42wTss65mq_D4q5odfePm6uj399emkWx8w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/26/20 2:39 PM, Daniel Vetter wrote:
> On Thu, Mar 26, 2020 at 2:18 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Hi,
>>
>> On 3/26/20 12:29 PM, Daniel Vetter wrote:
>>> On Wed, Mar 25, 2020 at 03:43:10PM +0100, Hans de Goede wrote:
>>>> The vboxvideo driver is missing a call to remove conflicting framebuffers.
>>>>
>>>> Surprisingly, when using legacy BIOS booting this does not really cause
>>>> any issues. But when using UEFI to boot the VM then plymouth will draw
>>>> on both the efifb /dev/fb0 and /dev/drm/card0 (which has registered
>>>> /dev/fb1 as fbdev emulation).
>>>>
>>>> VirtualBox will actual display the output of both devices (I guess it is
>>>> showing whatever was drawn last), this causes weird artifacts because of
>>>> pitch issues in the efifb when the VM window is not sized at 1024x768
>>>> (the window will resize to its last size once the vboxvideo driver loads,
>>>> changing the pitch).
>>>>
>>>> Adding the missing drm_fb_helper_remove_conflicting_pci_framebuffers()
>>>> call fixes this.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 2695eae1f6d3 ("drm/vboxvideo: Switch to generic fbdev emulation")
>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>> ---
>>>>    drivers/gpu/drm/vboxvideo/vbox_drv.c | 4 ++++
>>>>    1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/drivers/gpu/drm/vboxvideo/vbox_drv.c b/drivers/gpu/drm/vboxvideo/vbox_drv.c
>>>> index 8512d970a09f..261255085918 100644
>>>> --- a/drivers/gpu/drm/vboxvideo/vbox_drv.c
>>>> +++ b/drivers/gpu/drm/vboxvideo/vbox_drv.c
>>>> @@ -76,6 +76,10 @@ static int vbox_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>>       if (ret)
>>>>               goto err_mode_fini;
>>>>
>>>> +    ret = drm_fb_helper_remove_conflicting_pci_framebuffers(pdev, "vboxvideodrmfb");
>>>> +    if (ret)
>>>> +            goto err_irq_fini;
>>>
>>> To avoid transient issues this should be done as early as possible,
>>> definitely before the drm driver starts to touch the "hw".>
>>
>> Ok will fix and then push this to drm-misc-next-fixes, thank you.
>>
>>> With that
>>>
>>> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>>
>>> I do wonder though why the automatic removal of conflicting framebuffers
>>> doesn't work, fbdev should already do that from register_framebuffer(),
>>> which is called somewhere in drm_fbdev_generic_setup (after a few layers).
>>>
>>> Did you check why the two framebuffers don't conflict, and why the uefi
>>> one doesn't get thrown out?
>>
>> I did not check, I was not aware that this check was already happening
>> in register_framebuffer(). So I just checked and the reason why this
>> is not working is because the fbdev emulation done by drm_fbdev_generic_setup
>> does not fill in fb_info.apertures->ranges[0] .
>>
>> So fb_info.apertures->ranges[0].base is left as 0 which does not match
>> with the registered efifb's aperture.
>>
>> We could try to fix this, but that is not entirely trivial, we would
>> need to pass the pci_dev pointer down into drm_fb_helper_alloc_fbi()
>> then and then like remove_conflicting_pci_framebuffers() does add
>> apertures for all IORESOURCE_MEM PCI bars, but that would conflict
>> with drivers which do rely on drm_fb_helper_alloc_fbi() currently
>> allocating one empty aperture and then actually fill that itself...
> 
> You don't need the pci device, because resources are attached to the
> struct device directly. So you could just go through all
> IORESOURCE_MEM ranges, and add them. And the struct device we always
> have through drm_device->dev. This idea just crossed my mind since you
> brought up IORESOURCE_MEM, might be good to try that out instead of
> having to litter all drivers with explicit removal calls. The explicit
> removal is really only for races (vga hw tends to blow up if 2 drivers
> touch it, stuff like that), or when there's resources conflicts. Can
> you try to look into that?

Interesting idea, but I'm afraid that my plate is quite full with a lot of
more urgent things atm, so I really do not have time for this, sorry.

Regards,

Hans

