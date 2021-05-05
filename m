Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F46F3749E2
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 23:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhEEVHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 17:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbhEEVHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 17:07:02 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E60DC061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 14:06:04 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id j17so2380466qtx.6
        for <stable@vger.kernel.org>; Wed, 05 May 2021 14:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mefZcb1pNDWUeUshjW1gdp4/6sJZQmHB9uptTn/JTsM=;
        b=b/yl1HCmwF+IovbU2KdNTFUYQKvomccBdoOy0h5igW+Jfj/AA8JhuY+byu9fokqH+9
         0uV570RfkmRKTQ2YVgSuVbPMH24L9RXTZC9HvitdxE8oMySv0+WeJxU5BndioS6YO4SQ
         2irO1EYhOJ4fFmP8J9AxUshpvjExNnFsRHIFU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mefZcb1pNDWUeUshjW1gdp4/6sJZQmHB9uptTn/JTsM=;
        b=cdLBRj4NTW+gsw04WWzEuphfmejsZjhLjj/vQ8V834uBoHOgBOb8hXTSFRzfqdgfWZ
         +26AakCSo0c4+cSj/+OHHWB6GduVYtg2Z5gbPtwOBW8cHOPg4yLAzA+vzDbVrJAVvpMU
         kasJLS2z9YeM4jtHQPLqhk7tuwaJx/MFaKOhYDsO4IX1MKnN6XGG22eK+uLc2vgkuIAA
         YNrC8Jbw9fNoebpz7W6f43ZsunIvXYAvt9vs5lLjRTSAcddRXsEZ3qvklMGhwzYWqvwO
         zOK/ZUfwzvVUeM61+ofOA6HLVLraiKq9VI4/SrwU/ofQeVdjuGF2HDKE7FqdGwJ81DPS
         gyHg==
X-Gm-Message-State: AOAM532WEnUrmANC3IL/av2UwAsU7Pu7EJUpM7wCZmOmsiPU2mdZy+mU
        ZDKpCEPLkpxFjNXlLSOIthZesg==
X-Google-Smtp-Source: ABdhPJwwDEzSbkM/2Qq9tzFSoxDPmWMGdSygadAbYCrcOaVOYbR+UEK6FRlWHF1GGdLJF51vD6Inlg==
X-Received: by 2002:ac8:6909:: with SMTP id e9mr576403qtr.338.1620248763926;
        Wed, 05 May 2021 14:06:03 -0700 (PDT)
Received: from [192.168.151.33] (50-232-25-43-static.hfc.comcastbusiness.net. [50.232.25.43])
        by smtp.gmail.com with ESMTPSA id a10sm442040qtm.16.2021.05.05.14.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 14:06:03 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/15] 4.19.190-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210505120503.781531508@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8ee68f50-1300-bb0c-3f87-4c6bd5129b3f@linuxfoundation.org>
Date:   Wed, 5 May 2021 17:06:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210505120503.781531508@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/5/21 8:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.190 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 12:04:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.190-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
