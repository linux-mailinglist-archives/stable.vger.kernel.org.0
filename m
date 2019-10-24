Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E25E374B
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 17:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391245AbfJXP5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 11:57:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50453 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389313AbfJXP5V (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 11:57:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571932641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gXiCj2zY2Ut1vFe48odKp1CcDmx3S+KKbQVXOdnSjyw=;
        b=VbLP9DeuhrQAPxgjjRJ7H+rdwDSyRqU4Cy5drWxqpHD7wShHh9z3XGmLwVC/C45KSPfgo4
        L0XovshgJideFPqXUWqIXacekfOAYI7jFTNAAOUD8MhJrOgDsUn7M1nc5yVVsXwc71tFBe
        uL+k9Ky4goZwrZrxTCRgxSV6OYyC9Ug=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-ClHpqv9-OreWZoqfqWOZUg-1; Thu, 24 Oct 2019 10:31:35 -0400
Received: by mail-wr1-f70.google.com with SMTP id q14so1378213wrw.4
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 07:31:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T/Xlag7Vv94i/fFZydhE/2Ef/Fmjkx03xUXJUBM16NE=;
        b=SZv79U5N1bEQoE0n8K087MXWKrHWgNYnTuuPW+W4CD+5lwa681nftsJFHXo/ZfixXa
         yrAHUv2xmybZuwY7cLRytCL1NMVttoV+bEbEA3ZlJ32yqilOMvOy989VTqfmPoxMoaWy
         Afbpml/ZwS7/OZPM3yhvq1seK16goYTs5M+oPRgLwz3Hg9jIX4T4dlUPTXePs8LH7XvS
         p4z7/cs3QapdkbzHw7BfE9SX6845JM7NHgbcn8SCwI/1gcA8+jNDDTfvSXx7WjIqKFtf
         Nj1RFtspF4GwFqTQdT9pK/K+EGi4l9UObjSRSOVjNUCxLSKP6zxf75q3o3cC+KwCQHXk
         cl+g==
X-Gm-Message-State: APjAAAWqvkWCuOjjsvZk3tUDkgW6TxlikkOBIOwjNzfeRumJJiyx4eP3
        VrjFDEmEqLx2lnxO8pCdw69/Etts0W1tksmf2aILQCOal4A8bILF8Bn2AAQQpfIXPW09alfEkcs
        VbSfAkuJAmZJle1KM
X-Received: by 2002:adf:bd8f:: with SMTP id l15mr4084410wrh.362.1571927246888;
        Thu, 24 Oct 2019 07:27:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyHFHFBiqf2jd4RSI7FQ83LyEV3UvhtzKxFIwh4b5Evb3qiH8AY4i0BFMxyaOtnXcmlN/ePXg==
X-Received: by 2002:adf:bd8f:: with SMTP id l15mr4084393wrh.362.1571927246663;
        Thu, 24 Oct 2019 07:27:26 -0700 (PDT)
Received: from shalem.localdomain (2001-1c00-0c14-2800-ec23-a060-24d5-2453.cable.dynamic.v6.ziggo.nl. [2001:1c00:c14:2800:ec23:a060:24d5:2453])
        by smtp.gmail.com with ESMTPSA id w18sm7921842wrl.75.2019.10.24.07.27.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2019 07:27:25 -0700 (PDT)
Subject: Re: [PATCH] tpm: Switch to platform_get_irq_optional()
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
References: <20191019094528.27850-1-hdegoede@redhat.com>
 <20191021154942.GB4525@linux.intel.com>
 <80409d36-53fa-d159-d864-51b8495dc306@redhat.com>
 <20191023113733.GB21973@linux.intel.com>
 <d6adeb21-f7b3-5c64-fa32-03a8ee21cc53@redhat.com>
 <20191024142519.GA3881@linux.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <c6a0c3e3-c5c8-80d9-b6b6-bf45d66f4b32@redhat.com>
Date:   Thu, 24 Oct 2019 16:27:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024142519.GA3881@linux.intel.com>
Content-Language: en-US
X-MC-Unique: ClHpqv9-OreWZoqfqWOZUg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 24-10-2019 16:25, Jarkko Sakkinen wrote:
> On Wed, Oct 23, 2019 at 04:32:57PM +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 23-10-2019 13:37, Jarkko Sakkinen wrote:
>>> On Mon, Oct 21, 2019 at 05:56:56PM +0200, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 21-10-2019 17:49, Jarkko Sakkinen wrote:
>>>>> On Sat, Oct 19, 2019 at 11:45:28AM +0200, Hans de Goede wrote:
>>>>>> Since commit 7723f4c5ecdb ("driver core: platform: Add an error mess=
age to
>>>>>> platform_get_irq*()"), platform_get_irq() will call dev_err() on an =
error,
>>>>>> as the IRQ usage in the tpm_tis driver is optional, this is undesira=
ble.
>>>>>>
>>>>>> Specifically this leads to this new false-positive error being logge=
d:
>>>>>> [    5.135413] tpm_tis MSFT0101:00: IRQ index 0 not found
>>>>>>
>>>>>> This commit switches to platform_get_irq_optional(), which does not =
log
>>>>>> an error, fixing this.
>>>>>>
>>>>>> Cc: <stable@vger.kernel.org> # 5.4.x
>>>>>
>>>>> Incorrect format (should be wo '<' and '>').
>>>>
>>>> According to:
>>>>
>>>> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.htm=
l
>>>>
>>>> the '<' and '>' should be added when adding a # <kerner>
>>>
>>> OK, right so it was. This first patch that I'm reviewing with such
>>> commit.
>>>
>>>>> Also, not sure why this should be backported to stable kernel anyway.
>>>>
>>>> Because false-positive error messages are bad and cause users to
>>>> file false-positive bug-reports.
>>>
>>> Neither categorizes into a regression albeit being unfortunate
>>> glitches.
>>
>> The stable series also does other small fixes, such as adding new
>> pci/usb-ids, etc. This clearly falls within this. IMHO ideally this
>> should go to a 5.4-rc# making the whole discussion moot, but since
>> I was afraid it would not make 5.4, I added the Cc: stable.
>=20
> I get adding PCI/USB id as it extends the hardware support for the
> stable kernel without risking its stability. This patch is factors
> less useful.

It also has about 0% chance of causing regressions and it does
help to avoid false--positive bug reports.

TBH I'm quite surprised we are even having this discussion...

Regards,

Hans

