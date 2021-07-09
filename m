Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927223C2ACA
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 23:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhGIVaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 17:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhGIVaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 17:30:52 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211E8C0613E5
        for <stable@vger.kernel.org>; Fri,  9 Jul 2021 14:28:07 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id t39so4054656oiw.6
        for <stable@vger.kernel.org>; Fri, 09 Jul 2021 14:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qh4edRTsB2afFFaPsQqCE4vA8FR4pyqPTCpmX9vbySU=;
        b=SJZQR9auMPCeAZVtfBAwqP0iKkFKnF/mxiOLZ9TRyfPauM38QnTu3NqRRDoJuuPYbL
         nQjfQD1Dcgvb/ru/TAgD/aQWnSDLzeuzJGcbbw3AJdmRgzBRhHp9jjoTVw8jv3/MBQ+X
         6kfahjz0NFXwcxRMf8fawCNTQjqDm8OCSo9W4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qh4edRTsB2afFFaPsQqCE4vA8FR4pyqPTCpmX9vbySU=;
        b=CX9I5KbwKL0JR6fmwD4Fi6ODuHydu+tEo62pgM6nzAxDbIVUsYcrxr5uzocP0VOKcw
         mpCwxLRmxfRPo8yGlOS5bRaja7d9smzCIDLmvJ/sHz99rGSewOk0EeNiV8BKQUxdTaFC
         DZhU8E3eT/YZNijHXratmM/+ordmLkZboc0qPzk1ir/2YyMclSi8fmE52k9wFDvkI3qQ
         Y3grJEvHqUB3swgd3dKFGKWqgFKgJ3EgfglpO5Tz2kt5BuvvOs5ywHh8XWPJBg+lgw+9
         joKe32HPyQo+m3C510v4Ig6ShT9kqBGqJ4jtLp0QO4zbpCtTPt9zSLZX633raoOO7yoZ
         7/rg==
X-Gm-Message-State: AOAM530BKFClPuAhmS4VcVNm9bB7qrRHEOa/+XlegxVdeQRq9dtrmkOZ
        02evtoYMAq+ws35dNKGwGFVQjQ==
X-Google-Smtp-Source: ABdhPJw+zVNsZ/ouMYYuHErXETNmetuIKZl/ywbZTDef0QqBAE8WaQBCgva8l+SlxC2fMGJB1wwofA==
X-Received: by 2002:a54:4609:: with SMTP id p9mr28694620oip.107.1625866086391;
        Fri, 09 Jul 2021 14:28:06 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k25sm1242799ood.45.2021.07.09.14.28.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 14:28:05 -0700 (PDT)
Subject: Re: [PATCH 5.12 00/11] 5.12.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210709131549.679160341@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4b9b7a2f-b2fc-1aa1-2065-c6bab829f599@linuxfoundation.org>
Date:   Fri, 9 Jul 2021 15:28:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/9/21 7:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.16 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
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
