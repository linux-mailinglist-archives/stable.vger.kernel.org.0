Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A82748532A
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 14:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbiAENCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 08:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiAENCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 08:02:48 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE389C061784
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 05:02:48 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so3856978pjj.2
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 05:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Sq+YH2KnVlJmyDADPywaTY6NZXadER99K34iexlNEOg=;
        b=mQbEx4V+V2082a2bb/S8PC8XHXOsWFmmwHFYsIQXwIQjf3HnzjGrvkc5eEOOXh5FiC
         /6Rqe09RXtRu3K+TC+7n+rJMwPte7xJdVO16Ezel/wh6rQ2XBSIXfKiyoRoyFyVSoyox
         IOH8F8XsPeIdk5yk0Bj8V9njmhMivvAKmBydfcAbZ9nJVsy8hrP7ZcwMi+k56ZH/xCSd
         2eYukq6BSIG/EfolWK8DiUCRxbI8xCIfEYvVubsAdISd9PNMi6giRv6f7BvkhJ8u23se
         IZbPqEnDF8CYamG149H+9O8kUPDfafFgqdGOW2ZvpTOFciWdpYMFeM0QBTnj8Q+OYaPG
         9wDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Sq+YH2KnVlJmyDADPywaTY6NZXadER99K34iexlNEOg=;
        b=dN08Z9UYU2h9Qzhz69Gb0pqvExj/JEmebHunkGIncYBmOn4eyrwnwv+q7Vook7avI3
         nShVFGlujvqP6IRh8ifdV7NuI1UhY5XLB25ZzVUtw5ANkdSheANK/GkGYIK2zxoM1qf+
         EUYvrb7a1T1wWo25BTY45oJcTH56YsvTKMCjqTphRyMiN03RyIjBy03RQaNhKZfcWSGC
         cc2pi3jFeXH1TmDdmVRYRRjy/lqFTJzYJ9OMGjo70pToNSXwblv5MW0D1Vsm8TAWTcJS
         36ZyYi3ESJdMZiWTZJRsmn1a9w002KHVQrPDkJbJ3KUYTwGxTGZSWkGfFxGSXyg47NIt
         49Qw==
X-Gm-Message-State: AOAM5317++Sm/EcedQ7BaK3NnhC0RlrtmDSYnytlbwi8orcV4CBF12EQ
        hieMLXK/THPCRZxOpRFo1J/SqA==
X-Google-Smtp-Source: ABdhPJxZAUHBZj/r8O2FDVuO/e69DeFHSxlrAVCqW9SXxGAKBkAh5zaSizG4QnbxtPyK6Rg03RO9Lg==
X-Received: by 2002:a17:903:1249:b0:149:a59c:145a with SMTP id u9-20020a170903124900b00149a59c145amr26404893plh.108.1641387768366;
        Wed, 05 Jan 2022 05:02:48 -0800 (PST)
Received: from [192.168.1.32] ([122.164.22.119])
        by smtp.gmail.com with ESMTPSA id s9sm36687827pfw.174.2022.01.05.05.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 05:02:47 -0800 (PST)
Message-ID: <54461ffb9ebe34e673e6730f3e9cc94218ad2f49.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.15 00/72] 5.15.13-rc2 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Date:   Wed, 05 Jan 2022 18:32:43 +0530
In-Reply-To: <20220104073845.629257314@linuxfoundation.org>
References: <20220104073845.629257314@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-01-04 at 08:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.13 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.13-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
 hello,

There was a compilation error....

-----------x--------------x------------------x--
MODPOST vmlinux.symvers
  MODINFO modules.builtin.modinfo
  GEN     modules.builtin
BTF: .tmp_vmlinux.btf: pahole (pahole) is not available
Failed to generate BTF for vmlinux
Try to disable CONFIG_DEBUG_INFO_BTF
make: *** [Makefile:1183: vmlinux] Error 1


---------x--------------x-------------x---

i did CONFIG_DEBUG_INFO_BTF=n  in .config and then compilation was
success.

Compiled and booted  5.15.13-rc2+. dmesg gave no major  problems.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology - autonomous
