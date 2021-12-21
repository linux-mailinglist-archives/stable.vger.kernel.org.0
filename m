Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A4947C5FB
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 19:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbhLUSLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 13:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhLUSLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 13:11:02 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6A4C061574;
        Tue, 21 Dec 2021 10:11:02 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id g2so10457666pgo.9;
        Tue, 21 Dec 2021 10:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=60PcoFBXkpHH8tFBM2IBep4sOYr978ha6EWUV4ZY7X4=;
        b=h0tYups5FGvH0lnBSpzOR3AcWM5aGsXgsLb/pK+t8stGrr35Wm9KDT8VEILYYzstv9
         yW88hzbBIKKytWeH7WWm9D21gh3/0x0csmaYpgaNkFaNdoHnUq4DRGI2iIsM5IRxvLFO
         igm6SYe+RV3T75alMmbf7hgw3CC+xjat+4R6gKgbZKeR8TBlYOfqhbsufJbZrFETkih6
         E0srMrNPIO5mRWEPmSc0MEyspc7BZb+SCx8w2/qX5RDm3KG3TGKna375QykmTDuwcbtf
         wNI25PFJeLe0klfFjiomKOdn7P0SHTL0MRW1jLlI1X/KcCS96TdaDCz0wbffW+mtnZ8p
         BEHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=60PcoFBXkpHH8tFBM2IBep4sOYr978ha6EWUV4ZY7X4=;
        b=vc24NNaie2lGZGDuOsi2jtUUS/3Tx5QyeY8qKJg5ers9pN29dg0G9ju/Xmp6latWe1
         lcb23zp+N6CkHOdc9uqfYW1AI62zdr6G0qG+999ie/q7onLSY5phWH4Z8b+zI84834vF
         2SlRpA7eVLJF/xGVyauWX6N506g8jIXiBLqZuB/+UQ4o9r4JuKQ1n1VQZjPPCnwyUJiz
         F5lpFpCCrPCf9WizJKcFR+DJlrZEhsGCtrlYhnhT/nbiL7rgaGHLM4DQywlQ9gF+T69q
         zzN+VskTDfYK2K/Vtaz/5jz2iO5Zq5ithT9HIq25DOcSxzNwyl19dbH71ye40wT/1JQK
         14iA==
X-Gm-Message-State: AOAM532xqehSoSpRyiyEvsMCEZSXdjTy1DTckycmXIk+h0hySXgQotsw
        kGRi17k3QkaDHLIhYfpfNUm5Gz7VGKU=
X-Google-Smtp-Source: ABdhPJz05CiVltsGeOBsBEY1tHDuqF85B0PRbRlnziM+i40J9vGKjQXsQEBovQe+1F+2mr6adf8YBw==
X-Received: by 2002:a62:aa15:0:b0:4ba:ca5f:2841 with SMTP id e21-20020a62aa15000000b004baca5f2841mr4360781pff.73.1640110261135;
        Tue, 21 Dec 2021 10:11:01 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z71sm20355785pgz.52.2021.12.21.10.10.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 10:11:00 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 000/177] 5.15.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211220143040.058287525@linuxfoundation.org>
Message-ID: <1b98acd0-5f3b-fbe6-0ece-7c19ac973ed0@gmail.com>
Date:   Tue, 21 Dec 2021 10:10:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/20/2021 6:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.11 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

