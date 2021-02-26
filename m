Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F89325BA5
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 03:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhBZCZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 21:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbhBZCZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 21:25:29 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A773C061786
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 18:24:49 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id k2so2713169ioh.5
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 18:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JZKa2PXVjE98EtfWOINEVIYizzKlapAufh9CNuvXzRs=;
        b=Nqm0K2Wl5L9Bh31keiE/NWxDHMAbDnSmjfWyhVlPLDqcOdyz+GkVrcpoBPxn3pbOPg
         tmU9pGjLAF2pUzT1Peq5a3Mv7V6Ey8e71gV6pJhiB6qOwao8UxuusymhUuLY7sd0OYNe
         m+u7aT7VkK/MoyW8xm/h/WcSN6IbOUGnvwvKQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JZKa2PXVjE98EtfWOINEVIYizzKlapAufh9CNuvXzRs=;
        b=Rgbbl/c71UNov33+/nace1d4n8/TGNesbD4LfM4a4st96DhAxzgxCqmeQ334gBLQkd
         MSDb9CvZX7BxGFD9ryjZ0AsJ6xv6HsJMBATqLTcRbxmdKtEcQa/qE9t/f5nJptOzYAm9
         tk8o+A3NSgkJSF2iyAZ4YC3wQLOaPpVVQqfU3tfVXgkadnFD48105dnomqQeNVTGAQcB
         L35EHcD8SEfSvZlQ5DHoF5dyu0MTNBF497kWXHjHVfThx+IkLpedoIpPoUgXkV2hrRgn
         PLsDmPamvHbWMvgYQdAklhaurjTGuIgbtF7PcTxuk0kk65Fqf6NmMuc67bBJ4gojOZXR
         S72g==
X-Gm-Message-State: AOAM530ZLG4biJM66yL9X4A9hQ81SL4IrS6w78LYwzW7KKNB66U4AftK
        QOMsPICBfTPKpkPJQzHwGjcE7Q==
X-Google-Smtp-Source: ABdhPJw4/sbeSSDZyzuNPOp6w5utYbvsLPgeOzPYblgYrJTdkqObNyVQqYWMP01iEmmzkmomuXBH3g==
X-Received: by 2002:a02:94cb:: with SMTP id x69mr801657jah.8.1614306288659;
        Thu, 25 Feb 2021 18:24:48 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i67sm2026484ioa.3.2021.02.25.18.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 18:24:48 -0800 (PST)
Subject: Re: [PATCH 5.10 00/23] 5.10.19-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210225092516.531932232@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <37c37acb-0098-f4d8-8948-c1694cb633ee@linuxfoundation.org>
Date:   Thu, 25 Feb 2021 19:24:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/25/21 2:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.19 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Feb 2021 09:25:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
