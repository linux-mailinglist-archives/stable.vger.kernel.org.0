Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634D439CF30
	for <lists+stable@lfdr.de>; Sun,  6 Jun 2021 14:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhFFM6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Jun 2021 08:58:02 -0400
Received: from mail-ej1-f44.google.com ([209.85.218.44]:33387 "EHLO
        mail-ej1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbhFFM6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Jun 2021 08:58:02 -0400
Received: by mail-ej1-f44.google.com with SMTP id g20so21996768ejt.0;
        Sun, 06 Jun 2021 05:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=tr7Lt7RoIFMihYEgMQ8zel7djKpOflGGiHAXEUE2og8=;
        b=n4mzvFOJXBwfmhZm5YxQp3b6lLP+dWQMM4k1p2JW5SCiti73aTbXq2Hd59g+4DhKzh
         g9AiGQN9pS2bW1PszWN92tLTBSsbsWjfFMSW5kI7CdqZuXmdxgVsEG4WlTyI0neR4Rs1
         GZ8cgNI6q0mWGnb67oJkSJPa5eOEMblf/IPsQb0La/sA8Y3XgAAlzZMLE4cTLzESERud
         XAphRew7Z0iHZH9P1w/veC/IgTqSGo17ybKVNBhA+15M3+RWwvv7Jd9AExRI3JSRoQJj
         vuwFNHKaXYGyCveYWCyomNcFbZWfd4GLLh5zmksVoN95Ag7uuYUSrhw8Jz9o4/hHjWsf
         E0zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=tr7Lt7RoIFMihYEgMQ8zel7djKpOflGGiHAXEUE2og8=;
        b=FOeVxIilJtUSTeY7AQ/JdfqFKBzr64ZWA4ZZRPucRmydgvJ07g8BNyg57qaTYFhrNu
         jG2DMFMWBsgMWbWQhLiOFlxcGZrJAzX6v/3FyFDLEN3si8L0AFXXz7E4oPZJpx1aqEEz
         A8X2rBfwQAIM3M6atuqKIoFu7mmboCFEjjrI6lBMDU0U6qS8OYGVf0DTAPOvfYl+hS4J
         ufsfYeFdmE4txMACEq5p+Yia6Q0jqhazPixJYdF09HNnWp1+7lE1O2os88IX9e5e4RyS
         KFFkkZWAPZHHvLC8HWV1XH9zOpZjPozbg93onABcOqi5jJ8tM9i83cwtX2UyW1vlUVxO
         5ovw==
X-Gm-Message-State: AOAM531jHT8wb3Y2lKHvr/Q9DWlDgroVcUMJrB9Fsa2fwNNBJuziDTwt
        ULJbmIH5JwKhJeAGPKihcD/h8nKpbEnqDg==
X-Google-Smtp-Source: ABdhPJw1ocmAaupeeSOMBslIlHOmexwvbZeSTqUDcWDw4VngMadVpfwumd8DzIDwr2fEkoazBj7suQ==
X-Received: by 2002:a17:907:7201:: with SMTP id dr1mr13692637ejc.19.1622984095311;
        Sun, 06 Jun 2021 05:54:55 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id bd3sm6388122edb.34.2021.06.06.05.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 05:54:54 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sun, 6 Jun 2021 14:54:53 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     =?utf-8?Q?Lauren=C8=9Biu_P=C4=83ncescu?= <lpancescu@gmail.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: EC: Look for ECDT EC after calling
 acpi_load_tables()
Message-ID: <YLzFnW8jbGb8l+is@eldamar.lan>
References: <eeb5ebeb-5313-3763-7b5b-8701e582f1fc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eeb5ebeb-5313-3763-7b5b-8701e582f1fc@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Jun 04, 2021 at 05:22:43PM +0200, Laurențiu Păncescu wrote:
> commit b1c0330823fe upstream.

This should be in any case the full commmit hash as 

"commit b1c0330823fe842dbb34641f1410f0afa51c29d3 upstream."

without shortening.

> Backport of ACPI fix for #199981 for linux-4.9.y, tested on an Asus EeePC
> 1005PE running Debian Buster.
> 
> Some systems have had functional issues since commit 5a8361f7ecce
> (ACPICA: Integrate package handling with module-level code) that,
> among other things, changed the initial values of the
> acpi_gbl_group_module_level_code and acpi_gbl_parse_table_as_term_list
> global flags in ACPICA which implicitly caused acpi_ec_ecdt_probe() to
> be called before acpi_load_tables() on the vast majority of platforms.
> 
> Namely, before commit 5a8361f7ecce, acpi_load_tables() was called from
> acpi_early_init() if acpi_gbl_parse_table_as_term_list was FALSE and
> acpi_gbl_group_module_level_code was TRUE, which almost always was
> the case as FALSE and TRUE were their initial values, respectively.
> The acpi_gbl_parse_table_as_term_list value would be changed to TRUE
> for a couple of platforms in acpi_quirks_dmi_table[], but it remained
> FALSE in the vast majority of cases.
> 
> After commit 5a8361f7ecce, the initial values of the two flags have
> been reversed, so in effect acpi_load_tables() has not been called
> from acpi_early_init() any more.  That, in turn, affects
> acpi_ec_ecdt_probe() which is invoked before acpi_load_tables() now
> and it is not possible to evaluate the _REG method for the EC address
> space handler installed by it.  That effectively causes the EC address
> space to be inaccessible to AML on platforms with an ECDT matching the
> EC device definition in the DSDT and functional problems ensue in
> there.
> 
> Because the default behavior before commit 5a8361f7ecce was to call
> acpi_ec_ecdt_probe() after acpi_load_tables(), it should be safe to
> do that again.  Moreover, the EC address space handler installed by
> acpi_ec_ecdt_probe() is only needed for AML to be able to access the
> EC address space and the only AML that can run during acpi_load_tables()
> is module-level code which only is allowed to access address spaces
> with default handlers (memory, I/O and PCI config space).
> 
> For this reason, move the acpi_ec_ecdt_probe() invocation back to
> acpi_bus_init(), from where it was taken away by commit d737f333b211
> (ACPI: probe ECDT before loading AML tables regardless of module-level
> code flag), and put it after the invocation of acpi_load_tables() to
> restore the original code ordering from before commit 5a8361f7ecce.
> 
> Fixes: 5a8361f7ecce ("ACPICA: Integrate package handling with module-level
> code")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=199981
> Reported-by: step-ali <sunmooon15@gmail.com>
> Reported-by: Charles Stanhope <charles.stanhope@gmail.com>
> Tested-by: Charles Stanhope <charles.stanhope@gmail.com>
> Reported-by: Paulo Nascimento <paulo.ulusu@googlemail.com>
> Reported-by: David Purton <dcpurton@marshwiggle.net>
> Reported-by: Adam Harvey <adam@adamharvey.name>
> Reported-by: Zhang Rui <rui.zhang@intel.com>
> Tested-by: Zhang Rui <rui.zhang@intel.com>
> Tested-by: Jean-Marc Lenoir <archlinux@jihemel.com>
> Tested-by: Laurentiu Pancescu <laurentiu@laurentiupancescu.com>
> Signed-off-by: Laurentiu Pancescu <laurentiu@laurentiupancescu.com>
> ---
>  drivers/acpi/bus.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)

For the rest, but this is more up to the stable maintainers, maybe
though eeds as well comments from the respective maintainers, it might
be an option to make it apply cleanly by first cherry-pick
a46393c02c764a9d8a3e636bfe56f9d2f6f2c397 as well (which fixes a bug on
its own as well).

Cf. https://lore.kernel.org/stable/YLzAw27CQpdEshBl@eldamar.lan/T/#m6f4a7798eb4f9b0c40e6a10a694c0a6b40ab5044

Regards,
Salvatore
