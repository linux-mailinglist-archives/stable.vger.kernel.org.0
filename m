Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8A6412CEC
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 04:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241621AbhIUCs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 22:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242822AbhIUCFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 22:05:23 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541C9C144299;
        Mon, 20 Sep 2021 11:18:21 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id v19so12605759pjh.2;
        Mon, 20 Sep 2021 11:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZBgRiUJMyx1lo7Hif6dXPstNr+yKL09gi7cDYItJyhw=;
        b=NJ2cZB3xj8VNQGFQUOoeLgCJeVi58BhcRielrEPD5zNmzt816fR9X8S3uyJgekMM68
         Br6wUAuXo4kpKLp5nhxMsLCAxXjYauXnG7kp5zgQ8R5DZhw1r0UOAlcUMonbW5smese1
         MCWoVNn+o8VdYEd2gm9diqS6PDrU3kgcV4Ii4JQHjJDrn3tWg/XU3AR7EZ4diFEZAT5y
         CLG9nkkPa7tJcRnbmvQIogtUA7p0DwtlhOUk/iFEpf4XHM+CkfyNpQfiUJiWGOMcrWOz
         d0+eSmDlOVZXlkq8GQq/uzQY0N5X9wBsi2jCSN/7m/1pWx6v7jHyjmUCSyGrJCo8sTpw
         KmOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZBgRiUJMyx1lo7Hif6dXPstNr+yKL09gi7cDYItJyhw=;
        b=GBn5GrSkJH+/9P2lDcptp5jsK33d9Dwje+XI8uugBSn7y38ON/HWo31MReg3nXMFkq
         6kIARdTnnJdudxPkLfFgYIvYsgrT1G3+DQdckPWeqpHFhEvA6b1BKfUlaebDMPYWjOsB
         ep/tmCOU51iwJ9HBouMO9+ikqsm1JhfNHjPE+AWxsDKcif57jxrCvZFC+iRmoGiA94xZ
         iOklJsJcC6HNyP4Ezt0GsNPKltSREGYybj1fpyPLySHPPDFhydBu53E5rLCofFysHS7v
         Nl5zDQJlHmEVLMT+Kflrt2E6a1eR1Gn5qTHtHB4mGBg6ngsJc8DokddD3OibfE3KoIAF
         WFqA==
X-Gm-Message-State: AOAM531JRFFAlQVgyw/SCfy4Haiky/bX4UNvNYsHEvifLPfLEYvq1QMa
        igy1cvhtQ1ZbjTbXSkL0FPYa1aYzFOo=
X-Google-Smtp-Source: ABdhPJyUcXMEdHUeoDWdXwly0Pc/+Dc3JvaCznRB0iBTalzIsvv8sMvX6Wcv9qaaRVaKYc7fWceMDg==
X-Received: by 2002:a17:90a:1904:: with SMTP id 4mr352063pjg.191.1632161900406;
        Mon, 20 Sep 2021 11:18:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j6sm14474880pfn.107.2021.09.20.11.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 11:18:19 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/260] 5.4.148-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210920163931.123590023@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <420f77a8-c0b8-0697-2895-7fc53f7f1f12@gmail.com>
Date:   Mon, 20 Sep 2021 11:18:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 9:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.148 release.
> There are 260 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.148-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
