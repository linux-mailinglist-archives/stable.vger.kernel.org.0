Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A9936BC51
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 01:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbhDZXre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 19:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235654AbhDZXre (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 19:47:34 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F8BC061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 16:46:52 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id k25so14749495iob.6
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 16:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=//iXKNljqOsTTQ/4xWFpGyiiJiVWhmaCKFN92fR0b7U=;
        b=YcLa3BRm2/953qrQr0D0JtyQ0+YuCrjM50Vj4zfrDRu+V74UgoMXh6iY9VYihxC75Y
         VlGetmnqAfzobHSJOIBiY2CO4L/u0KLlzSfvLKKAOMfBERo0uxqaCrLgCUI758DoV648
         AvBhzp1mTI7uM/UmxNsaoWr+zdhQrLbz5P/KA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=//iXKNljqOsTTQ/4xWFpGyiiJiVWhmaCKFN92fR0b7U=;
        b=bu8I2Xb4KbQMMhuhjav1n/j7GicYTAnMVIJmKQAQ4ogIokTpfSjmrFwHnjJv1Wen54
         E6ejBdGoo4O+uH3DdIu50XnYPc/KMucWvIe1FDMRGE7TJh8Z1we06ZHkag5fN9hrva7q
         +UpphIfZbqy21w39rHcWYM9nbPJO73WVxMcPmtuOI4n8nLHYr1AhXMmCn7Vhd4eHTZai
         1NNiUF3G/e8pDYT7yhLHg/aVtMhEPt9+GcqjFq+UhH78SsHZSdQajXlM9djTn/qwzOI7
         YNTOMGUVNpgt/BIaEecDIoCQ02XMExJY1nCc3683QOD8Xojc5zKpk1cUYYH+qE1XRT/d
         WX6w==
X-Gm-Message-State: AOAM530+SaDYaHkKwVT6T26CNyuAhofEnp1JPtXiYdVadi9X7DwKkgmF
        che0RcVyKqvBHYFpfiUhmelx3A==
X-Google-Smtp-Source: ABdhPJyw1amPkgyi6yH/hz2OV0MRo0HIYdM9HDbULglQHI1bVHpSslnnW3oiO+QitACPI1uiotGKoA==
X-Received: by 2002:a05:6602:2f09:: with SMTP id q9mr6496569iow.207.1619480811501;
        Mon, 26 Apr 2021 16:46:51 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i17sm628615ilj.75.2021.04.26.16.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 16:46:51 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/20] 5.4.115-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210426072816.686976183@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0901b0ba-53af-d48b-71a1-b3533f0a409f@linuxfoundation.org>
Date:   Mon, 26 Apr 2021 17:46:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210426072816.686976183@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/21 1:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.115 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.115-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
