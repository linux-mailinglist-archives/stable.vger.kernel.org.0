Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A131432A64
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 01:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhJRXmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 19:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhJRXmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 19:42:18 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1B7C06161C;
        Mon, 18 Oct 2021 16:40:06 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so1862302ote.8;
        Mon, 18 Oct 2021 16:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jj4zvpwhyL+DM5ytDW0+VzKKeXHo51V10K/t+E8jPKs=;
        b=jM80BPjYm+82X99id/odwTUhVJnD3j9U5LABfOGo4hR3Uh+S43oI3LDj8WWVmxoC9r
         Y5MDOwhJDPseXBIxbOoc6wW+HGoPGYsyjO31CYyNnPyHuHu6wX6zwF4iUWS7ev/xf4wd
         eSSaYfyef0JUXAjdjxkFYTWLeL9A3M1gdAiLqPs5nNJsTTbCVVk3HtOcKk6GaJxm7DYO
         Vxi5cEPAN/KLvnALUPaGEQisgwGOsf2m67Ks3Ly8PajxAgMrO89DfFTr1qjdzY1lmUEy
         RGVCo4OnRbV4d9XHjECYdJi9uTFPdD+bd/ouCZX+BDNlSkEH1Ve15JTGydlq8YKYRM1H
         uoqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jj4zvpwhyL+DM5ytDW0+VzKKeXHo51V10K/t+E8jPKs=;
        b=gZtSKzubQG0MI93oCMMyPffbELwJs7HHRX1SyhERyPx6YghQggnNd8yIbGunpLgnOy
         PAEL2dDsTZZ8dZu7O06aTtjH/U3whf36cN2P/lcoaHsdip467jXHtKy2YZddwvD2l9Ir
         BSsVFeCDEJkflUAjAYnLe+GyA6oDL0wtvcD26Kw90vpn5GLOemhfmbdzohlC8gQdGz5M
         sgoprlTQcKwezJIFXifw5spG8RZ9MR9C80LhUvRPl82ildDwATJ+LXRl5IJxF/EQuPXZ
         DDBHmS8YZXC004quQVGo3eRHgGiiuH9Ooolv3bf5PaKM+DFwX7sqLOjq4HVMdJwt91G4
         2HVA==
X-Gm-Message-State: AOAM531yOfiWaMV93wqiOqk/S8C0f6EUaTaUeX0kWZ5/cQY3UVwiyK/l
        Y6+1k9F/nFooQptTQle3D2XFhDDHPgM=
X-Google-Smtp-Source: ABdhPJydrsCOy7CFiBSCpglLowmPs8aD7MpTG6GpLJqmHASqxTcuN+VVh6wr0DSJ+3pjpXXHz7TOLg==
X-Received: by 2002:a9d:7681:: with SMTP id j1mr2336142otl.367.1634600405984;
        Mon, 18 Oct 2021 16:40:05 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z8sm2693597oof.47.2021.10.18.16.40.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 16:40:05 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.14 000/151] 5.14.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211018132340.682786018@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <8289a310-d0f3-54ee-bcd1-50d172cffd27@roeck-us.net>
Date:   Mon, 18 Oct 2021 16:40:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/18/21 6:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.14 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
> 

Building arm64:allmodconfig ... failed
--------------
Error log:
drivers/firmware/arm_ffa/bus.c:96:27: error: initialization of 'int (*)(struct device *)' from incompatible pointer type 'void (*)(struct device *)' [-Werror=incompatible-pointer-types]
    96 |         .remove         = ffa_device_remove,
       |                           ^~~~~~~~~~~~~~~~~
drivers/firmware/arm_ffa/bus.c:96:27: note: (near initialization for 'ffa_bus_type.remove')

Guenter
