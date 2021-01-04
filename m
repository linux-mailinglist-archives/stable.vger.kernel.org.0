Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8ED02E9471
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 13:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbhADMBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 07:01:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54043 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726306AbhADMBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 07:01:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609761585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pres5e8WrRpvRCj7iEQnIu8o6lrBPcNGoStEUF06tHM=;
        b=ZpQdC2mOIa7qbn1oAqbCO+f4Q/rcONdSidSZGp/8HJpjZxMVgsZqT5WfsAoy0ZGSwQTGGr
        njveq2LpA2KvanUDW11jbMFRXlwaxDwLmSiFuV35JJUfRNE9T1QJ746zPvofSaJfwQrUg3
        pThGhov62I7H5O819blXDxaeCSFwdDw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-tAgEP6pZNZS91HmR3jsd_w-1; Mon, 04 Jan 2021 06:59:42 -0500
X-MC-Unique: tAgEP6pZNZS91HmR3jsd_w-1
Received: by mail-ed1-f69.google.com with SMTP id bf13so12016666edb.10
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 03:59:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pres5e8WrRpvRCj7iEQnIu8o6lrBPcNGoStEUF06tHM=;
        b=fD88mn5Uef+XUBMM9/2eqRTJcb2XOTf8/jV2A/utXi4+BTyPUH6NtAAHNPSnXGRY2b
         g5UU5zcvLN2CBHV1wgTmzAfHO8qICSUCjo5Sz2uBy9uyLBzf7WTezMOuzXXAYkBnjdxb
         Z2vNurBroikss5g42h5dJQjOIAg90OhhjiwTsO/FeBDFo8aXBVbWjtT2DSTyZr0wSdje
         EmUZRTivfGx9l1vzpMbHhJ0z29GBHhDG6ZMK797h7HQVSm7M9mI47qC2/q4ZB7SK3GOp
         Ct3YNAICCT/G2kohFxLWBDRqSzKVLftRI8c8rrdv9ZFCY4YaFbLS2EjsvURw1PR1c8HY
         I3Kw==
X-Gm-Message-State: AOAM5330+9ERs+QBGc4pPqiJaIUPB3VsLbDk/B1SsI/IA9leW076SURq
        3GDLTOXXr5LP4YNW5DuYcgStIAEB79Zkjsf30IwObUP2O5mSy+UJ35ZqPjubzSk0+iU3xG6nTjE
        YDSqMf4gKE8nxzcNjsjRvdI9AFpF4aPm4x7FcCSOxCcUDF9TkjlV4741kJ8HnTT522Bzu
X-Received: by 2002:a17:906:d784:: with SMTP id pj4mr64447422ejb.360.1609761581027;
        Mon, 04 Jan 2021 03:59:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxtNlcqeBweOBOg+dDeiF31iBz+D6P3NJw9O4uA6DMPJS1Pge79InvCsi/rq7oRYQrdZ6wEfw==
X-Received: by 2002:a17:906:d784:: with SMTP id pj4mr64447403ejb.360.1609761580815;
        Mon, 04 Jan 2021 03:59:40 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-37a3-353b-be90-1238.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:37a3:353b:be90:1238])
        by smtp.gmail.com with ESMTPSA id 35sm43202887ede.0.2021.01.04.03.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 03:59:40 -0800 (PST)
Subject: Re: [PATCH] ACPI / scan: Don't create platform device for INT3515
 ACPI nodes
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moody Salem <moody@uniswap.org>, stable@vger.kernel.org
References: <20201223143644.33341-1-heikki.krogerus@linux.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <ae94a191-4273-0000-deda-4859034343b8@redhat.com>
Date:   Mon, 4 Jan 2021 12:59:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201223143644.33341-1-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 12/23/20 3:36 PM, Heikki Krogerus wrote:
> There are several reports about the tps6598x causing
> interrupt flood on boards with the INT3515 ACPI node, which
> then causes instability. There appears to be several
> problems with the interrupt. One problem is that the
> I2CSerialBus resources do not always map to the Interrupt
> resource with the same index, but that is not the only
> problem. We have not been able to come up with a solution
> for all the issues, and because of that disabling the device
> for now.
> 
> The PD controller on these platforms is autonomous, and the
> purpose for the driver is primarily to supply status to the
> userspace, so this will not affect any functionality.
> 
> Reported-by: Moody Salem <moody@uniswap.org>
> Fixes: a3dd034a1707 ("ACPI / scan: Create platform device for INT3515 ACPI nodes")
> Cc: stable@vger.kernel.org
> Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1883511
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Thank you for your patch, I've applied this patch to my review-hans 
branch:
https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/log/?h=review-hans

Note it will show up in my review-hans branch once I've pushed my
local branch there, which might take a while.

Once I've run some tests on this branch the patches there will be
added to the platform-drivers-x86/for-next branch and eventually
will be included in the pdx86 pull-request to Linus for the next
merge-window.

Regards,

Hans




> ---
>  drivers/platform/x86/i2c-multi-instantiate.c | 31 +++++++++++++++-----
>  1 file changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/platform/x86/i2c-multi-instantiate.c b/drivers/platform/x86/i2c-multi-instantiate.c
> index 6acc8457866e1..e1df665d3ad31 100644
> --- a/drivers/platform/x86/i2c-multi-instantiate.c
> +++ b/drivers/platform/x86/i2c-multi-instantiate.c
> @@ -166,13 +166,29 @@ static const struct i2c_inst_data bsg2150_data[]  = {
>  	{}
>  };
>  
> -static const struct i2c_inst_data int3515_data[]  = {
> -	{ "tps6598x", IRQ_RESOURCE_APIC, 0 },
> -	{ "tps6598x", IRQ_RESOURCE_APIC, 1 },
> -	{ "tps6598x", IRQ_RESOURCE_APIC, 2 },
> -	{ "tps6598x", IRQ_RESOURCE_APIC, 3 },
> -	{}
> -};
> +/*
> + * Device with _HID INT3515 (TI PD controllers) has some unresolved interrupt
> + * issues. The most common problem seen is interrupt flood.
> + *
> + * There are at least two known causes. Firstly, on some boards, the
> + * I2CSerialBus resource index does not match the Interrupt resource, i.e. they
> + * are not one-to-one mapped like in the array below. Secondly, on some boards
> + * the irq line from the PD controller is not actually connected at all. But the
> + * interrupt flood is also seen on some boards where those are not a problem, so
> + * there are some other problems as well.
> + *
> + * Because of the issues with the interrupt, the device is disabled for now. If
> + * you wish to debug the issues, uncomment the below, and add an entry for the
> + * INT3515 device to the i2c_multi_instance__ids table.
> + *
> + * static const struct i2c_inst_data int3515_data[]  = {
> + *	{ "tps6598x", IRQ_RESOURCE_APIC, 0 },
> + *	{ "tps6598x", IRQ_RESOURCE_APIC, 1 },
> + *	{ "tps6598x", IRQ_RESOURCE_APIC, 2 },
> + *	{ "tps6598x", IRQ_RESOURCE_APIC, 3 },
> + *	{ }
> + * };
> + */
>  
>  /*
>   * Note new device-ids must also be added to i2c_multi_instantiate_ids in
> @@ -181,7 +197,6 @@ static const struct i2c_inst_data int3515_data[]  = {
>  static const struct acpi_device_id i2c_multi_inst_acpi_ids[] = {
>  	{ "BSG1160", (unsigned long)bsg1160_data },
>  	{ "BSG2150", (unsigned long)bsg2150_data },
> -	{ "INT3515", (unsigned long)int3515_data },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(acpi, i2c_multi_inst_acpi_ids);
> 

