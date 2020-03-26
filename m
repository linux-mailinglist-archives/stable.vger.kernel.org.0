Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37961193F96
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 14:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgCZNSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 09:18:34 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:59139 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726281AbgCZNSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 09:18:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585228713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s/zfRe7WbIKDZu9rHgVTTfByJPyfRtrbOIZkKq03EzA=;
        b=B8FMseCLOVcGbS9VRAZ0JDp2V+D7Mlmw+OHAyzwwuOSVXEu8JQXzhWUPKVxGqFY7f+sPYv
        o+8r49kUFbrbS9sQge3E696anSo3xPk/ikIlZEqNftxwYjcQaDdSeT4h0mMCWypUQUzAO+
        FRK7QYIyk+hfhClUnANtjuNgaImhmGw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-OmouecM_OyCvITMuGxKUmw-1; Thu, 26 Mar 2020 09:18:31 -0400
X-MC-Unique: OmouecM_OyCvITMuGxKUmw-1
Received: by mail-wm1-f70.google.com with SMTP id t22so2159247wmt.4
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 06:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s/zfRe7WbIKDZu9rHgVTTfByJPyfRtrbOIZkKq03EzA=;
        b=Xxmn1VhUSGyNZCb5rboOouTiy2NMU883Zz9m/YrnHJ9y/445a65sEV78n7G//sgBFm
         vajfhjPCl/psKbznWoGmMM0Nyn7LpctST7CQR3h6F7jDuMtdNruG+hW9FcOkj9j3ojUu
         jy+MgSKd9zL5UolmloEr+JfSqTRDgGofhEp0lX/SiKhx9NhewAYAGRr/iQdYwvsFGcDG
         Ex/XqeD0BaNQeOxTpt1z+8cJ6B6mP+Tdyr1KYFsZuTpDXMjwR2La4/kjEBr3fUL5eo+w
         jee8D352jWJU16eOCMkZFuWf9wNXtPRAoB5OUWwjUWmgScjZcjN28HWrnVY/lFU/uuiq
         CLUQ==
X-Gm-Message-State: ANhLgQ2b43N8xIsdYWY67/fOF6BNYi82aQyPrn93jG0tIBr3jKWsnRZ6
        wyembuS8M1RgdmOSxcsfcOOJ4E4tXki+knGcOWfGvVeB1P6NYYiyDEALCtoyUdrrQTue43YxKIH
        fwvhll/pJUNuOCoLm
X-Received: by 2002:a1c:5443:: with SMTP id p3mr2970849wmi.149.1585228710005;
        Thu, 26 Mar 2020 06:18:30 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuhyYp2unZxtr+DOf6fOQ0tX3xjuk3Q++2CvHmFNv4DrlQv37bTzqulHfDpF1n0aBB5aBJ8JQ==
X-Received: by 2002:a1c:5443:: with SMTP id p3mr2970830wmi.149.1585228709763;
        Thu, 26 Mar 2020 06:18:29 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-fc7e-fd47-85c1-1ab3.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:fc7e:fd47:85c1:1ab3])
        by smtp.gmail.com with ESMTPSA id g127sm3582543wmf.10.2020.03.26.06.18.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 06:18:29 -0700 (PDT)
Subject: Re: [PATCH] drm/vboxvideo: Add missing
 remove_conflicting_pci_framebuffers call
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
References: <20200325144310.36779-1-hdegoede@redhat.com>
 <20200326112959.GZ2363188@phenom.ffwll.local>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <8b9d940d-b236-062d-4ac3-c7462090066f@redhat.com>
Date:   Thu, 26 Mar 2020 14:18:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326112959.GZ2363188@phenom.ffwll.local>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/26/20 12:29 PM, Daniel Vetter wrote:
> On Wed, Mar 25, 2020 at 03:43:10PM +0100, Hans de Goede wrote:
>> The vboxvideo driver is missing a call to remove conflicting framebuffers.
>>
>> Surprisingly, when using legacy BIOS booting this does not really cause
>> any issues. But when using UEFI to boot the VM then plymouth will draw
>> on both the efifb /dev/fb0 and /dev/drm/card0 (which has registered
>> /dev/fb1 as fbdev emulation).
>>
>> VirtualBox will actual display the output of both devices (I guess it is
>> showing whatever was drawn last), this causes weird artifacts because of
>> pitch issues in the efifb when the VM window is not sized at 1024x768
>> (the window will resize to its last size once the vboxvideo driver loads,
>> changing the pitch).
>>
>> Adding the missing drm_fb_helper_remove_conflicting_pci_framebuffers()
>> call fixes this.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 2695eae1f6d3 ("drm/vboxvideo: Switch to generic fbdev emulation")
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/gpu/drm/vboxvideo/vbox_drv.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/vboxvideo/vbox_drv.c b/drivers/gpu/drm/vboxvideo/vbox_drv.c
>> index 8512d970a09f..261255085918 100644
>> --- a/drivers/gpu/drm/vboxvideo/vbox_drv.c
>> +++ b/drivers/gpu/drm/vboxvideo/vbox_drv.c
>> @@ -76,6 +76,10 @@ static int vbox_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>   	if (ret)
>>   		goto err_mode_fini;
>>   
>> +	ret = drm_fb_helper_remove_conflicting_pci_framebuffers(pdev, "vboxvideodrmfb");
>> +	if (ret)
>> +		goto err_irq_fini;
> 
> To avoid transient issues this should be done as early as possible,
> definitely before the drm driver starts to touch the "hw".>

Ok will fix and then push this to drm-misc-next-fixes, thank you.

> With that
> 
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> I do wonder though why the automatic removal of conflicting framebuffers
> doesn't work, fbdev should already do that from register_framebuffer(),
> which is called somewhere in drm_fbdev_generic_setup (after a few layers).
> 
> Did you check why the two framebuffers don't conflict, and why the uefi
> one doesn't get thrown out?

I did not check, I was not aware that this check was already happening
in register_framebuffer(). So I just checked and the reason why this
is not working is because the fbdev emulation done by drm_fbdev_generic_setup
does not fill in fb_info.apertures->ranges[0] .

So fb_info.apertures->ranges[0].base is left as 0 which does not match
with the registered efifb's aperture.

We could try to fix this, but that is not entirely trivial, we would
need to pass the pci_dev pointer down into drm_fb_helper_alloc_fbi()
then and then like remove_conflicting_pci_framebuffers() does add
apertures for all IORESOURCE_MEM PCI bars, but that would conflict
with drivers which do rely on drm_fb_helper_alloc_fbi() currently
allocating one empty aperture and then actually fill that itself...

Regards,

Hans

