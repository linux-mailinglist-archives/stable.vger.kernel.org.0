Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356962E1F84
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 17:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgLWQfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 11:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgLWQfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 11:35:45 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95066C061794;
        Wed, 23 Dec 2020 08:35:05 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y8so9369674plp.8;
        Wed, 23 Dec 2020 08:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YKLya63O9OPmb39PggAXfzBzc8CM0KuCvVCzsL4AHrw=;
        b=CguGTLtF+TmdS1SzJqSvku4TDe/8Og2cXflNWgrkMz0EAKJMMTXTTM7Y5ItPddqz5W
         +2aGIEVLx1oVQ793XwNHOimUl7yYbFTZcgJ3vE3CxR9jqdBmeNk82SK+0DeJKmaq7426
         Wt8H5qHMIjUXlt4XNCdM7N2937pNOX6Pj5Q5OzVz7hOx5Nv/PCLXjKif3sdfhZWTZSoy
         hXncvQAsmTQb0daFhdT1dld5ZmbVKdgtrC/U+KAsRC+RixPg7NJN5muVho8BmshGqnxp
         zbWFIVzuK9kVMZ+42vhgBDVf68buhzHLMtDGfLDizEtB+yVZOnboCF1u1pNT6rISWsZA
         aQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YKLya63O9OPmb39PggAXfzBzc8CM0KuCvVCzsL4AHrw=;
        b=W33p2DAV40+IOTR+U3k4z2u3e5VHxwSPOgu3EcN2HK956QORqJZxG4puoN7amMKhWd
         eQFY2QeHt0v4VQ8Dx0TL9jJyEY7KZwWwD3HO1iyz24Wqpr+S5NmcNkfOcDkLfXwMciou
         FSz+kYIKrPeylSUKm/1e7z8gUShd2JlJt+r8/6qD+y1ie/gvzXXXykBRMTFEmVbEtSV5
         TLNnRM7a7yzRMGjp1qtfyJfzRl807BA2yZb8qhVpzpJuyFv954A6yuOeuW/LQIZ29uFJ
         HhRYZK7BqtvUS6oSJhxyRbSWgivOWH+uc7+ZSOQBxIPyrZyvYZdNJ6LU1hi1NUTHEejZ
         EQLg==
X-Gm-Message-State: AOAM531yNyYCMVHWoHVI5AUPtkSOGLjin5CM1tr6V3mwBITpCuxMvUxF
        7exFj+d0dr4ZYw6EbbCkubR5mO0hkp7vCy7UgyE=
X-Google-Smtp-Source: ABdhPJyKc3NwgiBD9RfcHWJAcTPoN1uetzI1b87xhDxBNF6fNypqVKlIzypC4UZBz88rxxMUy9n/hSGbYNh9Zp1djrA=
X-Received: by 2002:a17:90a:1050:: with SMTP id y16mr447073pjd.181.1608741305080;
 Wed, 23 Dec 2020 08:35:05 -0800 (PST)
MIME-Version: 1.0
References: <20201223143644.33341-1-heikki.krogerus@linux.intel.com>
In-Reply-To: <20201223143644.33341-1-heikki.krogerus@linux.intel.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 23 Dec 2020 18:34:48 +0200
Message-ID: <CAHp75Vc=m+9qpCyY-vfAdNttFkZCN4u6JQKdjWV6b2=iU95t9w@mail.gmail.com>
Subject: Re: [PATCH] ACPI / scan: Don't create platform device for INT3515
 ACPI nodes
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Moody Salem <moody@uniswap.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 4:40 PM Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
>
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

BugLink: ?

> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  drivers/platform/x86/i2c-multi-instantiate.c | 31 +++++++++++++++-----
>  1 file changed, 23 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/platform/x86/i2c-multi-instantiate.c b/drivers/platform/x86/i2c-multi-instantiate.c
> index 6acc8457866e1..e1df665d3ad31 100644
> --- a/drivers/platform/x86/i2c-multi-instantiate.c
> +++ b/drivers/platform/x86/i2c-multi-instantiate.c
> @@ -166,13 +166,29 @@ static const struct i2c_inst_data bsg2150_data[]  = {
>         {}
>  };
>
> -static const struct i2c_inst_data int3515_data[]  = {
> -       { "tps6598x", IRQ_RESOURCE_APIC, 0 },
> -       { "tps6598x", IRQ_RESOURCE_APIC, 1 },
> -       { "tps6598x", IRQ_RESOURCE_APIC, 2 },
> -       { "tps6598x", IRQ_RESOURCE_APIC, 3 },
> -       {}
> -};
> +/*
> + * Device with _HID INT3515 (TI PD controllers) has some unresolved interrupt
> + * issues. The most common problem seen is interrupt flood.
> + *
> + * There are at least two known causes. Firstly, on some boards, the
> + * I2CSerialBus resource index does not match the Interrupt resource, i.e. they
> + * are not one-to-one mapped like in the array below. Secondly, on some boards
> + * the irq line from the PD controller is not actually connected at all. But the

irq -> IRQ

> + * interrupt flood is also seen on some boards where those are not a problem, so
> + * there are some other problems as well.
> + *
> + * Because of the issues with the interrupt, the device is disabled for now. If
> + * you wish to debug the issues, uncomment the below, and add an entry for the
> + * INT3515 device to the i2c_multi_instance__ids table.

Extra _ (underscore).

> + *
> + * static const struct i2c_inst_data int3515_data[]  = {
> + *     { "tps6598x", IRQ_RESOURCE_APIC, 0 },
> + *     { "tps6598x", IRQ_RESOURCE_APIC, 1 },
> + *     { "tps6598x", IRQ_RESOURCE_APIC, 2 },
> + *     { "tps6598x", IRQ_RESOURCE_APIC, 3 },
> + *     { }
> + * };
> + */
>
>  /*
>   * Note new device-ids must also be added to i2c_multi_instantiate_ids in
> @@ -181,7 +197,6 @@ static const struct i2c_inst_data int3515_data[]  = {
>  static const struct acpi_device_id i2c_multi_inst_acpi_ids[] = {
>         { "BSG1160", (unsigned long)bsg1160_data },
>         { "BSG2150", (unsigned long)bsg2150_data },
> -       { "INT3515", (unsigned long)int3515_data },

Perhaps also comment it out and refer to the above note?

>         { }
>  };
>  MODULE_DEVICE_TABLE(acpi, i2c_multi_inst_acpi_ids);
> --
> 2.29.2
>


-- 
With Best Regards,
Andy Shevchenko
