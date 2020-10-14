Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55ACE28E197
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 15:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgJNNqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 09:46:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27146 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728909AbgJNNqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 09:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602683175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wz5wOwKo0yVq73Er/y/1PB95j1y0IW2kymLlsiYsZYA=;
        b=UJrwxGIOmhCOV+Vmt9r8aUUH7rG+fSm+Cuy1z/0gzEvmltJcg+rUbBlJ3ykIRBnhUIB/Yo
        SajsqmgLL2iUQJWd3a8y3BHxdQxuUwMpiPYFiX9TBGtDsFOIuTl7OT6U8TY+hENXZHp9gN
        PHk5L+drhNrg3rlxf5rngTuD9MOkuWg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-VpBxPRvoPxefoNF_MvUiRw-1; Wed, 14 Oct 2020 09:46:11 -0400
X-MC-Unique: VpBxPRvoPxefoNF_MvUiRw-1
Received: by mail-ej1-f72.google.com with SMTP id x12so1187029eju.22
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 06:46:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wz5wOwKo0yVq73Er/y/1PB95j1y0IW2kymLlsiYsZYA=;
        b=Zh20zzqACbrQkRiCgFAlKz0iYAz5wyXgMIbsjIuDkiokz5G81c6YSklpikiqzHjd9V
         4AAPQdVdO7z7Ia5m/GzOjWiOTpCZx6EBcN2Q2AuR0BKnQuivBd7ppJfu2lR3ASgcxzx4
         QHlp/X1/2Cn3XM563xf4R+VTcD6/f9nWO1YZpOtyGeKnSBoZthQBWRFnpUjpnLB1OHd9
         s96JU82/4JBzVtwQUTuSy4QRBGwsWgB+yi5Hcx7FdHjJS/jqP7iSKwWaTV2syW8Mzrx2
         dew6AOKcw1V/+zy5ODy+xjw3YJjcH33VFWZ2D2qFnQ3x7q6WsOZrd/+kU2z5DMtAkRpa
         Yl1A==
X-Gm-Message-State: AOAM531u3W0jwaRSQ7PmA930iS76woYgU9+2qNh1eoS6Gyb9Vc/uPT3N
        PbRm7kPaIY9W/0K5RAsogCRe/uL1ertXxO6FK/gHE7+Bf4kbt1eLTXjQnQR3EFdk0bBPqFw7q/3
        rJYGWX8zvMybU6YCq
X-Received: by 2002:a17:906:a0cb:: with SMTP id bh11mr5532307ejb.314.1602683170480;
        Wed, 14 Oct 2020 06:46:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwb1nM/ZqfaRSOoR+zmuMc2x55E7Mkc/9Q5kPU90Nyx6UJvLiTtXmO9Wmhqbb2jybKDvwDJ7Q==
X-Received: by 2002:a17:906:a0cb:: with SMTP id bh11mr5532280ejb.314.1602683170246;
        Wed, 14 Oct 2020 06:46:10 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id k26sm1766239eji.22.2020.10.14.06.46.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 06:46:09 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.8 17/20] i2c: core: Call
 i2c_acpi_install_space_handler() before i2c_acpi_register_devices()
From:   Hans de Goede <hdegoede@redhat.com>
To:     kieran.bingham@ideasonboard.com, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org
References: <20200921144027.2135390-1-sashal@kernel.org>
 <20200921144027.2135390-17-sashal@kernel.org>
 <1977b57b-fae6-d9d4-e6bf-3d4013619537@ideasonboard.com>
 <bbeb7cae-d856-bb25-4602-8dd3bae62773@redhat.com>
Message-ID: <d1318f56-e610-b095-6d8c-37f94444882e@redhat.com>
Date:   Wed, 14 Oct 2020 15:46:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bbeb7cae-d856-bb25-4602-8dd3bae62773@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

On 10/14/20 1:23 PM, Hans de Goede wrote:
> Hi,
> 
> On 10/14/20 1:09 PM, Kieran Bingham wrote:
>> Hi Hans, Sasha,
>>
>> As mentioned on https://github.com/linux-surface/kernel/issues/63, I'm
>> afraid I've bisected a boot time issue on the Microsoft Surface Go 2 to
>> this commit on the stable 5.8 tree.
>>
>> The effect as reported there is that the boot process stalls just after
>> loading the usbhid module.
>>
>> Typing, or interacting with the Keyboard (Type Cover) at that point
>> appears to cause usb bus resets, but I don't know if that's a related
>> symptom or just an effect of some underlying root cause.
>>
>> I have been running a linux-media kernel on this device without issue.
>>
>> Is this commit in 5.9? I'll build a vanilla v5.9 kernel and see if it
>> occurs there too.
> 
> Yes the commit is in 5.9 too. Still would be interesting to see if 5.9 hits
> this issue too. I guess it will, but as I mentioned in:
> 
> https://github.com/linux-surface/kernel/issues/63
> 
> I do not understand why this commit is causing this issue.
> 
> So I just checked and the whole acpidump is not using I2C
> opregion stuff at all:
> 
> [hans@x1 microsoft-surface-go2]$ ack GenericSerialBus *.dsl
> [hans@x1 microsoft-surface-go2]$
> 
> And there is only 1 _REG handler which is for the
> embedded-controller.
> 
> So this patch should not make a difference at all on the GO2,
> other then maybe a subtle timing difference somewhere ... ?

Thanks to Maximilian Luz sharp eyes this is explained now,
despite the name of the i2c_acpi_install_space_handler()
it also had a acpi_walk_dep_device_list() call hidden in
there, so the "i2c: core: Call i2c_acpi_install_space_handler()
before i2c_acpi_register_devices()" also moved that
acpi_walk_dep_device_list() earlier.

I've given Kieran a patch to test which in essence reverts
the part where the acpi_walk_dep_device_list() call is also
moved earlier and that fixes the Surface Go 2 not booting.

I will submit this fix upstream right away and I'll also
send a separate mail to Greg / stable@vger to see if Greg
is willing to make an exception and at this to the stable
series before it hits Linus' tree.

Regards,

Hans


