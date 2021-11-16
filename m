Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E49453AD2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 21:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbhKPUXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 15:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhKPUXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 15:23:40 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F7CC061570;
        Tue, 16 Nov 2021 12:20:42 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id u74so1072767oie.8;
        Tue, 16 Nov 2021 12:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jGEgjzo3aB9G9M3q7RtM/mjI4HuuwL0+Wiow52BseYQ=;
        b=NenCIdyYETLLyqXzJEIM6Sw1m6ySjSDlzxbNSWOJQAC8olgcXM5KGsUB6/VrVQ8H7f
         J0KnqY+ANme3dJeCzViiKWas89EM9RYGFHORsStsQRUNY9EgvMoa9+mZkn/fjIi5Wh2v
         /DpuPYq53/Wiq3DLl7w6vh3RLJbuSMnq7Yn6f0kKeYABj2mY330IQYphS+xXd/ygc80N
         DB9MnllhaHGhN6U9DHEfJlazBa6p/GxNyqoZWbdYtQlqy+UEF8V28vqHAleJ5KDIfIDC
         j10Y2rXx7Q/DfzMBW2yFvKArqscT+/Z7XKF4jl7xLpETmWYT/B6kjixv4e0ZPGFy3+eb
         MZiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jGEgjzo3aB9G9M3q7RtM/mjI4HuuwL0+Wiow52BseYQ=;
        b=NVtohi3wzYfVnjzDxfGaAfwQkmxP3DWQi5EmDRHTmrig2fRtS6ojj6B6a9/QFoZFhF
         r+xgr5sbyJ/qrXWg8bKZocTDb09dks2h5KsatGyvA+j5wrp5vR/vF5J87Sbfimk/nOgS
         B5jxnlr1nrGdcKPRmUuhZuaGAM3WIq3aQIMSRFUK+EHCjMei6089Z1Dncrs3rvIkg63T
         qiaWpXQZYDH5IwsFFOnzuqVPOmOvz/tth+2UjEdqT7bBatk6uCaIeG0s69NNkukY2fyE
         JC/wMBr1zP9rM8+7Kh2U/MNW9G2aTNn1de3cQsilc2CzMlu0jbTZ9d1+xyFfouLmJHav
         YWFg==
X-Gm-Message-State: AOAM532yg3ONOfNncKjBGZgCHJ4xIIDLTXm5DN4KYHMtTedcVGzc6Oh5
        L6ZxEWk//Ahm2sS+UjbBMGygSvBeSy4=
X-Google-Smtp-Source: ABdhPJzifnHl3i0tztvICOhP/4WlSJYjZ8t6hbV6aNaJ4McaGXN8omZecQ67IW1EATOwQ4cODw38rg==
X-Received: by 2002:a05:6808:159a:: with SMTP id t26mr56975372oiw.106.1637094041790;
        Tue, 16 Nov 2021 12:20:41 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g26sm3859179ots.25.2021.11.16.12.20.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 12:20:41 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.10 000/578] 5.10.80-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211116142545.607076484@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <4ce78f7d-0735-5895-8995-84cef2bffc3e@roeck-us.net>
Date:   Tue, 16 Nov 2021 12:20:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211116142545.607076484@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/21 7:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 578 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 

Building m68k:defconfig ... failed
Building m68k:allmodconfig ... failed
------------
drivers/block/ataflop.c: In function 'atari_cleanup_floppy_disk':
drivers/block/ataflop.c:2066:17: error: implicit declaration of function 'blk_cleanup_disk'

drivers/block/ataflop.c: In function 'atari_floppy_init':
drivers/block/ataflop.c:2133:15: error: implicit declaration of function '__register_blkdev'

