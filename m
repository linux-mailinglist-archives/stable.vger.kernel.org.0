Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A464897B4
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 12:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244866AbiAJLmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 06:42:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56854 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244920AbiAJLln (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 06:41:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641814901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SsWQC8aTb+0uRe3yU+LwCtHB9iia3Osu0BBlRAz4Dj0=;
        b=futY8jD0bx8u3ZSMnv4xgVIkFqrhmEe+8+MLM0VPZ3PsOL/6dk0pboyomFGeZd1a74uiu0
        m+FwRJZPjaSuc8phiWgxZo3dFjL4tLc7fKpsb2qqPFc6SubbUA9M7f3crgEtNdlRCHF1ei
        tNY8L593iJCCbF0goOuMUNWzHjTpnEA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-2PKsCgLsNBeRZ005B52PnA-1; Mon, 10 Jan 2022 06:41:40 -0500
X-MC-Unique: 2PKsCgLsNBeRZ005B52PnA-1
Received: by mail-ed1-f70.google.com with SMTP id y10-20020a056402358a00b003f88b132849so9917750edc.0
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 03:41:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SsWQC8aTb+0uRe3yU+LwCtHB9iia3Osu0BBlRAz4Dj0=;
        b=DGe4bmLuR6TEc3gz/AQ2F3dlvhL1U/E6aScr/Wh05wRyA433+aQJ8NQl9E/8ZpqvWs
         tUW49dxFvcmtfm5hlCbFinyTzrW30vEeBpmZuRP52CkeefaK1aVHGowLN20VSg68YxId
         X7Kd2OqtprXAzN/zkeF1fpOuk2YX/z57MQKRmU4tevOjM2aAzfS4nDleHtNsSpGRIz6i
         Qqr3irlexEFnc8qydUYQwhvXe3JkALcF5EawE4Wp/P5rgSGm5UOaDA4q7XYXFNUvqwYB
         aNewK9d2scgcRcAl6w2sP17TY0azevy6NpPlG8NdaP4qMJ57nDMU+H7pGd30855O66FL
         aRew==
X-Gm-Message-State: AOAM531hi3UO0yRBUct7zH7o+sdvpLOu/j/wTY5ZOFTYYmi/XDVP5H7Q
        tQyMfjwj7jTZQRHeHrDLHjXhNyUujAEABwnFqufouVxXfcE8Bxq8mJkR2YHP6SnTf/15l1SmsEC
        sj2I0Rt/Sf0C7um3N
X-Received: by 2002:a17:907:a420:: with SMTP id sg32mr1390942ejc.310.1641814899128;
        Mon, 10 Jan 2022 03:41:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwa47UJCAu9cZOZqhb8987Jy+Gr9KRUjqDbs/oRBNFOeATkg186ylFpwptic1AlmBR/yUCuXg==
X-Received: by 2002:a17:907:a420:: with SMTP id sg32mr1390927ejc.310.1641814898923;
        Mon, 10 Jan 2022 03:41:38 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id j21sm2321879ejj.133.2022.01.10.03.41.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 03:41:38 -0800 (PST)
Message-ID: <c992ece7-6878-a39e-0386-5a499265c4cb@redhat.com>
Date:   Mon, 10 Jan 2022 12:41:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v6] x86/PCI: Ignore E820 reservations for bridge windows
 on newer systems
Content-Language: en-US
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
Cc:     linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Benoit_Gr=c3=a9goire?= <benoitg@coeus.ca>,
        Hui Wang <hui.wang@canonical.com>, stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
References: <20211217141348.379461-1-hdegoede@redhat.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20211217141348.379461-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

On 12/17/21 15:13, Hans de Goede wrote:
> Some BIOS-es contain a bug where they add addresses which map to system
> RAM in the PCI host bridge window returned by the ACPI _CRS method, see
> commit 4dc2287c1805 ("x86: avoid E820 regions when allocating address
> space").
> 
> To work around this bug Linux excludes E820 reserved addresses when
> allocating addresses from the PCI host bridge window since 2010.
> 
> Recently (2019) some systems have shown-up with E820 reservations which
> cover the entire _CRS returned PCI bridge memory window, causing all
> attempts to assign memory to PCI BARs which have not been setup by the
> BIOS to fail. For example here are the relevant dmesg bits from a
> Lenovo IdeaPad 3 15IIL 81WE:
> 
>  [mem 0x000000004bc50000-0x00000000cfffffff] reserved
>  pci_bus 0000:00: root bus resource [mem 0x65400000-0xbfffffff window]
> 
> The ACPI specifications appear to allow this new behavior:
> 
> The relationship between E820 and ACPI _CRS is not really very clear.
> ACPI v6.3, sec 15, table 15-374, says AddressRangeReserved means:
> 
>   This range of addresses is in use or reserved by the system and is
>   not to be included in the allocatable memory pool of the operating
>   system's memory manager.
> 
> and it may be used when:
> 
>   The address range is in use by a memory-mapped system device.
> 
> Furthermore, sec 15.2 says:
> 
>   Address ranges defined for baseboard memory-mapped I/O devices, such
>   as APICs, are returned as reserved.
> 
> A PCI host bridge qualifies as a baseboard memory-mapped I/O device,
> and its apertures are in use and certainly should not be included in
> the general allocatable pool, so the fact that some BIOS-es reports
> the PCI aperture as "reserved" in E820 doesn't seem like a BIOS bug.
> 
> So it seems that the excluding of E820 reserved addresses is a mistake.
> 
> Ideally Linux would fully stop excluding E820 reserved addresses,
> but then the old systems this was added for will regress.
> Instead keep the old behavior for old systems, while ignoring
> the E820 reservations for any systems from now on.
> 
> Old systems are defined here as BIOS year < 2018, this was chosen to make
> sure that E820 reservations will not be used on the currently affected
> systems, while at the same time also taking into account that the systems
> for which the E820 checking was originally added may have received BIOS
> updates for quite a while (esp. CVE related ones), giving them a more
> recent BIOS year then 2010.
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206459
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1868899
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1871793
> BugLink: https://bugs.launchpad.net/bugs/1878279
> BugLink: https://bugs.launchpad.net/bugs/1931715
> BugLink: https://bugs.launchpad.net/bugs/1932069
> BugLink: https://bugs.launchpad.net/bugs/1921649
> Cc: Benoit Grégoire <benoitg@coeus.ca>
> Cc: Hui Wang <hui.wang@canonical.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v6:
> - Remove the possibility to change the behavior from the commandline
>   because of worries that users may use this to paper over other problems

ping ?

Regards,

Hans







> Changes in v5:
> - Drop mention of Windows behavior from the commit msg, replace with a
>   reference to the specs
> - Improve documentation in Documentation/admin-guide/kernel-parameters.txt
> - Reword the big comment added, use "PCI host bridge window" in it and drop
>   all refences to Windows
> 
> Changes in v4:
> - Rewrap the big comment block to fit in 80 columns
> - Add Rafael's Acked-by
> - Add Cc: stable@vger.kernel.org
> 
> Changes in v3:
> - Commit msg tweaks (drop dmesg timestamps, typo fix)
> - Use "defined(CONFIG_...)" instead of "defined CONFIG_..."
> - Add Mika's Reviewed-by
> 
> Changes in v2:
> - Replace the per model DMI quirk approach with disabling E820 reservations
>   checking for all systems with a BIOS year >= 2018
> - Add documentation for the new kernel-parameters to
>   Documentation/admin-guide/kernel-parameters.txt
> ---
> Other patches trying to address the same issue:
> https://lore.kernel.org/r/20210624095324.34906-1-hui.wang@canonical.com
> https://lore.kernel.org/r/20200617164734.84845-1-mika.westerberg@linux.intel.com
> V1 patch:
> https://lore.kernel.org/r/20211005150956.303707-1-hdegoede@redhat.com
> ---
>  arch/x86/kernel/resource.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/resource.c b/arch/x86/kernel/resource.c
> index 9b9fb7882c20..9ae64f9af956 100644
> --- a/arch/x86/kernel/resource.c
> +++ b/arch/x86/kernel/resource.c
> @@ -1,4 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0
> +#include <linux/dmi.h>
>  #include <linux/ioport.h>
>  #include <asm/e820/api.h>
>  
> @@ -23,11 +24,31 @@ static void resource_clip(struct resource *res, resource_size_t start,
>  		res->start = end + 1;
>  }
>  
> +/*
> + * Some BIOS-es contain a bug where they add addresses which map to
> + * system RAM in the PCI host bridge window returned by the ACPI _CRS
> + * method, see commit 4dc2287c1805 ("x86: avoid E820 regions when
> + * allocating address space"). To avoid this Linux by default excludes
> + * E820 reservations when allocating addresses since 2010.
> + * In 2019 some systems have shown-up with E820 reservations which cover
> + * the entire _CRS returned PCI host bridge window, causing all attempts
> + * to assign memory to PCI BARs to fail if Linux uses E820 reservations.
> + *
> + * Ideally Linux would fully stop using E820 reservations, but then
> + * the old systems this was added for will regress.
> + * Instead keep the old behavior for old systems, while ignoring the
> + * E820 reservations for any systems from now on.
> + */
>  static void remove_e820_regions(struct resource *avail)
>  {
> -	int i;
> +	int i, year = dmi_get_bios_year();
>  	struct e820_entry *entry;
>  
> +	if (year >= 2018)
> +		return;
> +
> +	pr_info_once("PCI: Removing E820 reservations from host bridge windows\n");
> +
>  	for (i = 0; i < e820_table->nr_entries; i++) {
>  		entry = &e820_table->entries[i];
>  
> 

