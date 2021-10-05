Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3ED1422FDA
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 20:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhJESXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 14:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234925AbhJESXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 14:23:32 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95343C06174E
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 11:21:41 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id b78so66036iof.2
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 11:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YwnC8hpn+FIOkts5Uv8OyhoB4r22VJdfWW6CyG0jPeA=;
        b=BnEY81RueuL6B69bIDQ3xWUys2wx3nEKyoAvNxeHfgoXy7MszdX7mFoTBnGqg7nArI
         q/BTYo7U2l453aFsJE2JFTgCOAspmqAXj3vlVYd6W6thYP5hePGv+eNnmC2aQETAJdcB
         aIPRQ1G0SgqiklWQyJnNw/19BLzEfOF/jMuvA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YwnC8hpn+FIOkts5Uv8OyhoB4r22VJdfWW6CyG0jPeA=;
        b=rEkpifkzhsRsTtBzeknqiC+/mBtcDFuHieuym+O+8a/BodG7K4xpt57+aXkz98NoqE
         QE4BTO9FM7rqKAZAmCXVdF4FZiR6M2DQxCTKQQHmjMNwVe5UwthNPSnR341qpa5BPXbc
         khdpQeshsiIcRHaceeTUjlo4U72Z8ptpMKJI9aCs4d3n8eWYqtqTjkELE9Do17tgEQJD
         YOPvzPZJs+t1T+oUB5x4xI/MqhobTKDOFn2SExwsPU5ywnwuOSr3Gwn//izSGdjjsmHM
         BU5yvyPbQE3scgiDegfyjho8Rgb338wWElrh7z7cxoq8fnYfeowvV9JGgaVvcLit3ecE
         RaSA==
X-Gm-Message-State: AOAM5332y/W1MBJw9EUzNVIsKk4oNvPRFHllGZxXyRFW/+BypyljN2mh
        +Cv3ohoOhkuWfyPJS3rtRhdtzw==
X-Google-Smtp-Source: ABdhPJyKZ/xZjExSgGSFijfsmiVl0qSFtdtmiCWGmseIr6KTEHF7GSZZFpw6Q/YP1Boo9TbvNShErQ==
X-Received: by 2002:a6b:f111:: with SMTP id e17mr3301290iog.147.1633458100842;
        Tue, 05 Oct 2021 11:21:40 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o11sm13097722ilu.0.2021.10.05.11.21.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 11:21:40 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/173] 5.14.10-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211005083311.830861640@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <41227f84-832d-1939-f4c7-8d19c6e764a9@linuxfoundation.org>
Date:   Tue, 5 Oct 2021 12:21:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211005083311.830861640@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/5/21 2:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
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
