Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6EB47C588
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 18:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240735AbhLURzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 12:55:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43745 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240733AbhLURzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 12:55:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640109309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I2k5XFYRrsbB3tGhhr5j+LEBWGSmCxctS5XQHuzVnkM=;
        b=OhZ7xhZ6ddzkEqud+WMyoz91TEIa++XoJDxMbmNqrYSepS+1Bstd4C/4MA0xuTtdjJVGaE
        i2GjG+cNW5CtFUDPo057324LqvXUCgw1pEeytabqERoLhpdWBZe210HB0zXYw0WZbIFp4w
        PuVuQjMwojUDSp9wGRA2fqqRQ7dVWXM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-sVa66GxxPYqT05ZV68uFhw-1; Tue, 21 Dec 2021 12:55:08 -0500
X-MC-Unique: sVa66GxxPYqT05ZV68uFhw-1
Received: by mail-ed1-f70.google.com with SMTP id d7-20020aa7ce07000000b003f84e9b9c2fso6111625edv.3
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 09:55:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=I2k5XFYRrsbB3tGhhr5j+LEBWGSmCxctS5XQHuzVnkM=;
        b=GBjeTM57Kq3JyjCFsHwo8w3DoIKyDTjYbsKYOabf6i7IFKoCpDhsnVaVGEeQVAKEz4
         +100M0zA2VkUV/AhwObjIrMqZnWo8r5wbSvM3swOgmPqXAtdU8HRA7EFabtSfxFH5sta
         idF9XfWTk1SUyzG26iSWoQOdHXO20hw8/ndqWNSF8ymfey0deLy6CEg4SO+VmrowSUq0
         pWeV3ZKQXHeGgykNKe3FCVBVhqRhlJgHM1T2kjQ0PdO6MFVBtWZjBRIfElhwL8qYDaqg
         Dr+DiqcKNEy6PHy4y+9WFOmyxj2RlmAQ7p5zU9FsLSdUYbNm9PFQOX8W4FjbGtL2f7Dd
         F7GQ==
X-Gm-Message-State: AOAM531U0MOKETeafSW1BJuGxsRd2aMtvEqjlrzei3R86JvUU3ccbedo
        nqUmyYncyomlIoabiWsn1lExDK3P4nR7z7yKDkq+9vSoy6Tu15ocJp4LI7Nna2oBePrgUidUdsf
        wuuplaApby6ukXPsg
X-Received: by 2002:a17:906:86cb:: with SMTP id j11mr3576138ejy.769.1640109307218;
        Tue, 21 Dec 2021 09:55:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxYp/ADAhlTD7Yjbjwa+evtVYy5o74hTjTJKKd54AGZ2XduOXFy5sazSs+o1lBiY/2T0llpPw==
X-Received: by 2002:a17:906:86cb:: with SMTP id j11mr3576125ejy.769.1640109307064;
        Tue, 21 Dec 2021 09:55:07 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id qw4sm2271588ejc.55.2021.12.21.09.55.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 09:55:06 -0800 (PST)
Message-ID: <2eb39ddd-9699-ea50-a41e-c39a31134698@redhat.com>
Date:   Tue, 21 Dec 2021 18:55:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] platform/x86: amd-pmc: only use callbacks for suspend
Content-Language: en-US
To:     Mario Limonciello <mario.limonciello@amd.com>,
        Mark Gross <mgross@linux.intel.com>,
        "open list:X86 PLATFORM DRIVERS" 
        <platform-driver-x86@vger.kernel.org>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     stable@vger.kernel.org
References: <20211210143529.10594-1-mario.limonciello@amd.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20211210143529.10594-1-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 12/10/21 15:35, Mario Limonciello wrote:
> This driver is intended to be used exclusively for suspend to idle
> so callbacks to send OS_HINT during hibernate and S5 will set OS_HINT
> at the wrong time leading to an undefined behavior.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Thank you for your patch, I've applied this patch to my review-hans 
branch:
https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/log/?h=review-hans

I will also add this to the fixes branch and include it in my
next fixes pull-req for 5.17.

Once I've run some tests on this branch the patches there will be
added to the platform-drivers-x86/for-next branch and eventually
will be included in the pdx86 pull-request to Linus for the next
merge-window.

Regards,

Hans

> ---
>  drivers/platform/x86/amd-pmc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
> index 841c44cd64c2..230593ae5d6d 100644
> --- a/drivers/platform/x86/amd-pmc.c
> +++ b/drivers/platform/x86/amd-pmc.c
> @@ -508,7 +508,8 @@ static int __maybe_unused amd_pmc_resume(struct device *dev)
>  }
>  
>  static const struct dev_pm_ops amd_pmc_pm_ops = {
> -	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(amd_pmc_suspend, amd_pmc_resume)
> +	.suspend_noirq = amd_pmc_suspend,
> +	.resume_noirq = amd_pmc_resume,
>  };
>  
>  static const struct pci_device_id pmc_pci_ids[] = {
> 

