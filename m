Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66556454847
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbhKQOQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbhKQOQt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 09:16:49 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A78C061570;
        Wed, 17 Nov 2021 06:13:50 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so4951005otj.7;
        Wed, 17 Nov 2021 06:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c5Y/+SnKjEvbmFXUQjDgwrGed15UEG+KOomgxz/Nf+M=;
        b=ChfaFr1b6kZT7YgJtCt8QKRxOBOhzUxjlFJvm2H5483CtNk5ugU3IrtvkerU8hNiyU
         jfA2kdVeAmdrvQ5GnFnuGdUc7lk6Rq2mjUdPtjqAOuQ31Ih5e7b377ozGAZQ8g7sXAHf
         r9iqHtWIvBgkjBx1X7DWEb68GjYaYH3DiixQGvy3NBx5UnzGSCasshoFqhkICn/qB9AQ
         DQywGUxTThqSX21CF+6C1ah9048oIuIVmZ8qYVIYu/V+cK2s1GWwDxFM3UfHkVfHW/O6
         FZyh8uegz800DcONDMuYEF7RiYPd5eWHD6CfsaSwPlGyyGIHUW5O8Sihxa7ujsSF3EBQ
         2bJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c5Y/+SnKjEvbmFXUQjDgwrGed15UEG+KOomgxz/Nf+M=;
        b=QRR8r2P3ZL9sEcwYjsir97Jc4utFHANvderEz9zdap0UOsnoZrBrt/mmnRiLEYezyU
         g6GKWE084fjbQQtgKSrXTuxjpB09rINYnZwo8P7lYF5Mqu82GQSLXZXsCPJWu6aD3OO9
         Pvzh4mxvhMhmpU2MXTJWHvQQNCM0bzkAL/EmmWbPPNd/NnXApeHg6C3FY+FgCJCP+AEN
         t+xfD6fJ37YaCkiCs5FpP4mhLbANCLFTV9PhCJ5w2ucHrbcbByQlH4cbZvn62scuvIdH
         +KhDKj7JpslHwxxXy9YZ9ISCegZgi5N4s6oikMJsBAmnAh22yigKz/atB3S4QwkVzycB
         q+qQ==
X-Gm-Message-State: AOAM533q2l0LJQi1h8V6CS9vxy6oho3HuzvmZJIIeX0N4Vb2h8v5B9w0
        TM4yhOlo3EcDTVOwCPOsWdKy4Tf+fME=
X-Google-Smtp-Source: ABdhPJwCzhBygLB4APQZIVLFJmyvt0050bRpxs+zSR1grWXS5+whNS0ygFRQl7PwYc6u2A2ihkn4nQ==
X-Received: by 2002:a05:6830:4d:: with SMTP id d13mr14337849otp.45.1637158430076;
        Wed, 17 Nov 2021 06:13:50 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y9sm3656912oon.8.2021.11.17.06.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 06:13:49 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211117101657.463560063@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
Message-ID: <81192f2a-afe7-1eee-847a-f8103a6d7cd1@roeck-us.net>
Date:   Wed, 17 Nov 2021 06:13:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211117101657.463560063@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/17/21 2:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 923 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Nov 2021 10:14:52 +0000.
> Anything received after that time might be too late.
> 

Build is still broken for m68k.

drivers/block/ataflop.c: In function 'atari_cleanup_floppy_disk':
drivers/block/ataflop.c:2050:17: error: implicit declaration of function 'blk_cleanup_disk'
drivers/block/ataflop.c: In function 'atari_floppy_init':
drivers/block/ataflop.c:2065:15: error: implicit declaration of function '__register_blkdev'

Are you sure you want to carry that patch series into v5.10.y ? I had to revert
pretty much everything to get it to compile. It seems to me that someone should
provide a working backport if the series is needed/wanted in v5.10.y.

Guenter
