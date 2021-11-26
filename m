Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D60645F59B
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 21:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbhKZUD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 15:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237023AbhKZUB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 15:01:58 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01731C061398;
        Fri, 26 Nov 2021 11:44:26 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id j18so7481114ljc.12;
        Fri, 26 Nov 2021 11:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LhfiTiSPr6U9EzrG/017Ob7ki0TnlL7wg63Q7re9Hc4=;
        b=TX6p/73hhnRzn+p5uW3gsHUKNm6TIzfgkhUb0KnmBTyO65T5au3/V24FPKkPuCbwsK
         pJJlAYyCOUss658SgHRBd0lHdZhkwwQiSPsHf5FG7DLEVESv0Atxvk+qMNkGZ/iGcYje
         gHM8ijqZWtPXZQTipMQHz7n9D3ZXxOSmV18Pfir0kddr2uRsBViGUjBc3ly9qMr2qfIS
         2b05UamKKE+gecOJ1LUl+BDpEQco9zMBZpfIWqjI9+n7v1o80WotWGGvD5n5ZmZmCxKe
         y0V5e8QuC8MtSYa7YGqtJmktu7IR9Dx0uVVBVFdrLCcggP+Q570TJa4Yb3ygvmDjbBx8
         /dZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LhfiTiSPr6U9EzrG/017Ob7ki0TnlL7wg63Q7re9Hc4=;
        b=VtKgGZ7atpfy+nEQizdoHt6DzXz8qw4i9Ah3EECQCQiVaV8NrA6Cnfg2mVNiFx+sjN
         ueKpjD4XsShoc38eJ5htE5QVX0RUMDE+zuwb8f/u4yBdPeRueew0OMp2su7XIW5pA+qK
         TRzicK3FggbA5PIO3/7C4exqTImprgz0FTUyHuXGpqEtmweKsXwUdz5AunzQQHvdF1lQ
         56X+KbZVQAKAN5vs2/YPef7f4L1whcYXz544FnGTuxux0gN1Hbxroq/re2/U7k91Nyd9
         hU2U06hIIdaEtlC4oy4Mjj9b1XoP5yEBY0fYviSy2w0J6N6mlVvuuoK/kSdBz/8OvALq
         IqtQ==
X-Gm-Message-State: AOAM533jZJEvUyL5zXm14liv0Fo/+6ETg9dOa6/ZtLruUYnA7SsAbfoS
        bDyur7NhgPOMgWlhdAdQ9+Q=
X-Google-Smtp-Source: ABdhPJyBox7L7TzWrsAMa6WlW7ukXZfjn8IG2Ndu9PebHpBCcEoVc3vE5gTisBKiOPL0q/MgM1AHUA==
X-Received: by 2002:a2e:8693:: with SMTP id l19mr34087642lji.452.1637955864353;
        Fri, 26 Nov 2021 11:44:24 -0800 (PST)
Received: from [192.168.1.103] ([178.176.72.184])
        by smtp.gmail.com with ESMTPSA id l19sm661511lji.27.2021.11.26.11.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 11:44:24 -0800 (PST)
Subject: Re: [PATCH -next V5 2/2] sata_fsl: fix warning in remove_proc_entry
 when rmmod sata_fsl
To:     Baokun Li <libaokun1@huawei.com>, damien.lemoal@opensource.wdc.com,
        axboe@kernel.dk, tj@kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yebin10@huawei.com, yukuai3@huawei.com, stable@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
References: <20211126020307.2168767-1-libaokun1@huawei.com>
 <20211126020307.2168767-3-libaokun1@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <d54fd029-77e3-524a-65ab-90761338e1db@gmail.com>
Date:   Fri, 26 Nov 2021 22:44:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211126020307.2168767-3-libaokun1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/26/21 5:03 AM, Baokun Li wrote:

> Trying to remove the fsl-sata module in the PPC64 GNU/Linux
> leads to the following warning:
>  ------------[ cut here ]------------
>  remove_proc_entry: removing non-empty directory 'irq/69',
>    leaking at least 'fsl-sata[ff0221000.sata]'
>  WARNING: CPU: 3 PID: 1048 at fs/proc/generic.c:722
>    .remove_proc_entry+0x20c/0x220
>  IRQMASK: 0
>  NIP [c00000000033826c] .remove_proc_entry+0x20c/0x220
>  LR [c000000000338268] .remove_proc_entry+0x208/0x220
>  Call Trace:
>   .remove_proc_entry+0x208/0x220 (unreliable)
>   .unregister_irq_proc+0x104/0x140
>   .free_desc+0x44/0xb0
>   .irq_free_descs+0x9c/0xf0
>   .irq_dispose_mapping+0x64/0xa0
>   .sata_fsl_remove+0x58/0xa0 [sata_fsl]
>   .platform_drv_remove+0x40/0x90
>   .device_release_driver_internal+0x160/0x2c0
>   .driver_detach+0x64/0xd0
>   .bus_remove_driver+0x70/0xf0
>   .driver_unregister+0x38/0x80
>   .platform_driver_unregister+0x14/0x30
>   .fsl_sata_driver_exit+0x18/0xa20 [sata_fsl]
>  ---[ end trace 0ea876d4076908f5 ]---
> 
> The driver creates the mapping by calling irq_of_parse_and_map(),
> so it also has to dispose the mapping. But the easy way out is to
> simply use platform_get_irq() instead of irq_of_parse_map(). Also
> we should adapt return value checking and propagate error values.
> 
> In this case the mapping is not managed by the device but by
> the of core, so the device has not to dispose the mapping.
> 
> Fixes: faf0b2e5afe7 ("drivers/ata: add support to Freescale 3.0Gbps SATA Controller")
> Cc: stable@vger.kernel.org
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

MBR, Sergei
