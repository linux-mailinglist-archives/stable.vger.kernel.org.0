Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96C1407262
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 22:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhIJUU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 16:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbhIJUU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 16:20:57 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66044C061574;
        Fri, 10 Sep 2021 13:19:46 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id bg1so1858868plb.13;
        Fri, 10 Sep 2021 13:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=y/gZSR8qkoQo9P9xvHcf3mSQUvxlAlQxXPeEFN7ETGk=;
        b=Fy5CAolk0RZE6VracL2Mw62YYTxNaYa18v+5gcCmCailBMnv5+U+vrps2mFNNGNFoc
         dYAZWY0WaGyOLISIifwUgNDLIs83AzsgC4iZL+Y7KNtS71danS7ie22qz5mbCfOQDDk4
         D+UBUw++JvhXRFGZtVaw08kT29DWSD7BjBwcUOc76cRhuN4TE19K2wOJ/qTItAKX+WvA
         /i/dcrKodo+3qvclcZbBgLcMrseJUa/Q4anF27jLxtBw89QmnINTjnS7ZJ7hsMtbJXDB
         7BCpteP8WLLo+MeUXlUe7g7+Mn27ihZBk3CKWvlgtriC0dyyga18c3saTZhwljYDVg8e
         GuHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y/gZSR8qkoQo9P9xvHcf3mSQUvxlAlQxXPeEFN7ETGk=;
        b=6de5SrkL+woQPRimNlzlEnIcthP+Rsy6CccskNQDaHJErMSdBEaGkBeXOT7auOB1Q+
         oF7S0+LfKJ7LKQqvOGAr61J+3s00tpybaSt/2KoZySorwEUCSNbE2vwuM1ty8a1vX6Yo
         WIFJGGaoS0LHHgJk4/9Ilyb6cURm1YRErqEY7e8GCSWJ53AJ1NBsonHZoKSz6U7uFacL
         8Na6mD9/QC/JrmLQK581AA1DhcGYEi+Z50eFO4ewf79rLXfKzv/AqTYcTcEVMKRIJzRV
         8KxmN6I3HDmDeTYLnLNgbc+YILjK4Ro8pnBAyzCGTM2Jnp3Gte0bvMAxwAg+7xUd/sN5
         dfhA==
X-Gm-Message-State: AOAM531BfcSQGzdRm13E2jhWtXTiUuj10/dp62xwVVQt951pkcQ3DlRD
        d4WUb3xgAOWXqqt6MnzO5/NhV7Cf5JQ=
X-Google-Smtp-Source: ABdhPJz0/DDLpI8Eo5MbH/LxQhG1mu/BcBtDSxe42sOenaLF67nLPI4/N04uKW4qWD1uQ3L6piyaLQ==
X-Received: by 2002:a17:90a:1282:: with SMTP id g2mr11343648pja.230.1631305185877;
        Fri, 10 Sep 2021 13:19:45 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id v25sm5538823pfm.202.2021.09.10.13.19.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 13:19:45 -0700 (PDT)
Message-ID: <4723bf26-2795-dfd7-b00f-2a6ae1d8b4ee@gmail.com>
Date:   Fri, 10 Sep 2021 13:19:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 5.14 00/23] 5.14.3-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210910122916.022815161@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/10/2021 5:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.3 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
