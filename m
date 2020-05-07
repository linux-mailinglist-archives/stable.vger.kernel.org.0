Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF3F1C8675
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 12:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgEGKPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 06:15:30 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50370 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725879AbgEGKPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 06:15:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588846527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=28J0wM8FSO+gLlCMWFny6wSN2sJ0Eg75ZijOfB4R940=;
        b=B5QYluKJS6X49b7fIIO2GeuXEVIneLUcmrF2AjZsp3wWy/Kz9eafomixZr734HSNnqciEo
        jwKflSrw3arVtCR/QtTBy+f/14mS9Z26GlahkHEmrOp6sUluLk6gRBhM+p/i4eO66Vi24W
        OsYTS51Bvv7F+fBn5mRgQa4HpBJo1Is=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-X8sj_PfZPee6goDxWqAbSQ-1; Thu, 07 May 2020 06:15:12 -0400
X-MC-Unique: X8sj_PfZPee6goDxWqAbSQ-1
Received: by mail-wr1-f70.google.com with SMTP id d16so2145236wrv.18
        for <stable@vger.kernel.org>; Thu, 07 May 2020 03:15:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=28J0wM8FSO+gLlCMWFny6wSN2sJ0Eg75ZijOfB4R940=;
        b=EbZQzQVo3IAFv5rkIu+yVPYT1fMkY8tF98pvkMABxii8UkeaBaeE/NwbBRbBuOyRmz
         JIqPHyqRzsUJOVgMnGYunKia7mosN4ASS7Is16luKTMxr+7bN/87CGAgYTlVEW4aPhL0
         WKlrSlZco+yIFtUboF6I7PQ7WVlZPjCC9oWL4qsQiHe5uOj+FpOLuy318iNGiykxb2Cr
         u2MnY8c4SIUQOZ3MxwdQiEPvpQDfc86560jQ+fW6Vd6dj0RNgDpkp1ca/4wsAmJuiLex
         +4qAQE19Rsp8Ws8/66Np6YuJTL5jKOwamu7iq3vNEGzdxM3jm4QA39AlKypdA4ZhA3nF
         t3lg==
X-Gm-Message-State: AGi0PuaGOLfBxzxHZgkqzKF6seEl7awVaSQesi2k9YyqyK54sz6jn9Ma
        UFUsOaHR81cSqPbi5O+85FTMJuZIAZvpTpjvUold5tWo7opR/CjKa+rAGhFado1hRUhhXWcFcB8
        aWS9S85fzuTuB7t1s
X-Received: by 2002:a5d:5646:: with SMTP id j6mr15696579wrw.207.1588846510766;
        Thu, 07 May 2020 03:15:10 -0700 (PDT)
X-Google-Smtp-Source: APiQypK2xT6JtFSwdPS8WS/+fUDarjawSg9Ssq0Uu6J56P4ODn9Q1qqkNllbI6Px2XrTjWeSd+Qr0A==
X-Received: by 2002:a5d:5646:: with SMTP id j6mr15696553wrw.207.1588846510476;
        Thu, 07 May 2020 03:15:10 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id 92sm7314402wrm.71.2020.05.07.03.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 03:15:09 -0700 (PDT)
Subject: Re: [PATCH v2] pinctrl: cherryview: Ensure _REG(ACPI_ADR_SPACE_GPIO,
 1) gets called
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-gpio@vger.kernel.org,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>
References: <20200504145957.480418-1-hdegoede@redhat.com>
 <20200506064057.GU487496@lahna.fi.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <f7ebb693-94ec-fd9f-c0a8-cfe8f9d4e9bf@redhat.com>
Date:   Thu, 7 May 2020 12:15:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200506064057.GU487496@lahna.fi.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 5/6/20 8:40 AM, Mika Westerberg wrote:
> +Rafael and ACPICA folks.
> 
> On Mon, May 04, 2020 at 04:59:57PM +0200, Hans de Goede wrote:
>> On Cherry Trail devices there are 2 possible ACPI OpRegions for
>> accessing GPIOs. The standard GeneralPurposeIo OpRegion and the Cherry
>> Trail specific UserDefined 0x9X OpRegions.
>>
>> Having 2 different types of OpRegions leads to potential issues with
>> checks for OpRegion availability, or in other words checks if _REG has
>> been called for the OpRegion which the ACPI code wants to use.
>>
>> The ACPICA core does not call _REG on an ACPI node which does not
>> define an OpRegion matching the type being registered; and the reference
>> design DSDT, from which most Cherry Trail DSDTs are derived, does not
>> define GeneralPurposeIo, nor UserDefined(0x93) OpRegions for the GPO2
>> (UID 3) device, because no pins were assigned ACPI controlled functions
>> in the reference design.
>>
>> Together this leads to the perfect storm, at least on the Cherry Trail
>> based Medion Akayo E1239T. This design does use a GPO2 pin from its ACPI
>> code and has added the Cherry Trail specific UserDefined(0x93) opregion
>> to its GPO2 ACPI node to access this pin.
>>
>> But it uses a has _REG been called availability check for the standard
>> GeneralPurposeIo OpRegion. This clearly is a bug in the DSDT, but this
>> does work under Windows.
> 
> Do we know why this works under Windows? I mean if possible we should do
> the same and I kind of suspect that they forcibly call _REG in their
> GPIO driver.

Windows has its own ACPI implementation, so it could also be that their
equivalent of the:

         status = acpi_install_address_space_handler(handle, ACPI_ADR_SPACE_GPIO,
                                                     acpi_gpio_adr_space_handler,
                                                     NULL, achip);

Call from drivers/gpio/gpiolib-acpi.c indeed always calls _REG on the handle
without checking that there is an actual OpRegion with a space-id
of ACPI_ADR_SPACE_GPIO defined, as the ACPICA code does.  Note that the
current ACPICA code would require significant rework to allow this, or
it would need to add a _REG call at the end of acpi_install_address_space_handler(),
potentially calling _REG twice in many cases.

We could move the manual _REG call I'm adding to pinctrl-cherry-view.c
but that has the same issue of calling _REG twice in many cases.

Most (all?) _REG implementations are fine with that, as they just set a
variable to 1 (to the Arg1 value). Still calling _REG twice is something
which we might want to avoid.

As a compromise I've chosen to add the extra unconditional _REG call
to pinctrl-cherryview.c because:

1. The problem in the DSDT in question stems from there being 2
different OpRegions for accessing GPIOs which AFAIK is unique to
cherryview

2. I've seen many many cherryview DSDT-s and as such I'm confident
that calling _REG twice is not an issue on cherryview.

> Are the ACPI tables from this system available somewhere?

Here you go:
https://fedorapeople.org/~jwrdegoede/medion-e1239t-dsdt.dsl

The problem is that on line 12624 there is a GPO2.AVBL == One
check, before GPO2.DCDT is used. If you then look at line
17688 you see that _REG for the GPO2 device checkes for a
space-id of 8 (ACPI_ADR_SPACE_GPIO) to set AVBL

But the only OpRegion defined for the GPO2 device, and the
OpRegion to which GPO2.DCDT is mapped is the cherryview
UserDefined 0x93 GPIO access OpRegion, see line 17760.
Since there is no OpRegion for the ACPI_ADR_SPACE_GPIO
space-id, ACPICA never calls _REG with Arg0 == 8.

So as already mentioned the problem stems from the confusion
of there being 2 different OpRegions for accessing GPIOs
on cherryview.

Regards,

Hans



>> This issue leads to the intel_vbtn driver
>> reporting the device always being in tablet-mode at boot, even if it
>> is in laptop mode. Which in turn causes userspace to ignore touchpad
>> events. So iow this issues causes the touchpad to not work at boot.
>>
>> Since the bug in the DSDT stems from the confusion of having 2 different
>> OpRegion types for accessing GPIOs on Cherry Trail devices, I believe
>> that this is best fixed inside the Cherryview pinctrl driver.
>>
>> This commit adds a workaround to the Cherryview pinctrl driver so
>> that the DSDT's expectations of _REG always getting called for the
>> GeneralPurposeIo OpRegion are met.
> 
> I would like to understand the issue bit better before we do this.
> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>> Changes in v2:
>> - Drop unnecessary if (acpi_has_method(adev->handle, "_REG")) check
>> - Fix Cherryview spelling in the commit message
>> ---
>>   drivers/pinctrl/intel/pinctrl-cherryview.c | 18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl/intel/pinctrl-cherryview.c
>> index 4c74fdde576d..4817aec114d6 100644
>> --- a/drivers/pinctrl/intel/pinctrl-cherryview.c
>> +++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
>> @@ -1693,6 +1693,8 @@ static acpi_status chv_pinctrl_mmio_access_handler(u32 function,
>>   
>>   static int chv_pinctrl_probe(struct platform_device *pdev)
>>   {
>> +	struct acpi_object_list input;
>> +	union acpi_object params[2];
>>   	struct chv_pinctrl *pctrl;
>>   	struct acpi_device *adev;
>>   	acpi_status status;
>> @@ -1755,6 +1757,22 @@ static int chv_pinctrl_probe(struct platform_device *pdev)
>>   	if (ACPI_FAILURE(status))
>>   		dev_err(&pdev->dev, "failed to install ACPI addr space handler\n");
>>   
>> +	/*
>> +	 * Some DSDT-s use the chv_pinctrl_mmio_access_handler while checking
>> +	 * for the regular GeneralPurposeIo OpRegion availability, mixed with
>> +	 * the DSDT not defining a GeneralPurposeIo OpRegion at all. In this
>> +	 * case the ACPICA code will not call _REG to signal availability of
>> +	 * the GeneralPurposeIo OpRegion. Manually call _REG here so that
>> +	 * the DSDT-s GeneralPurposeIo availability checks will succeed.
>> +	 */
>> +	params[0].type = ACPI_TYPE_INTEGER;
>> +	params[0].integer.value = ACPI_ADR_SPACE_GPIO;
>> +	params[1].type = ACPI_TYPE_INTEGER;
>> +	params[1].integer.value = 1;
>> +	input.count = 2;
>> +	input.pointer = params;
>> +	acpi_evaluate_object(adev->handle, "_REG", &input, NULL);
>> +
>>   	platform_set_drvdata(pdev, pctrl);
>>   
>>   	return 0;
>> -- 
>> 2.26.0
> 

