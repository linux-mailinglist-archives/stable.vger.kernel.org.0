Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAD94A5233
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 23:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiAaWRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 17:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbiAaWRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 17:17:12 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BA8C06173B
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 14:17:11 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id i62so18883076ioa.1
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 14:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4LJ7NCNiEiXtxFGZ6pxZyvHdh9yeGGVrpPotZxH0zYw=;
        b=GBlbJ9W15OO7ERVEsKV4c3BfZ4O7MRCqyhmsTXBIKm6ayNEgyB4Z1/Zi0I731bqTb/
         Mmoezq3MmJQIO+e3oTdj/p5FP3FWd/4dH/iM12QQgkJqfeZ0HtaxcYth48JiOOnfUAly
         mD+FJxtxnU6ajMfzU/uQzZljYev/ItsIpBtKk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4LJ7NCNiEiXtxFGZ6pxZyvHdh9yeGGVrpPotZxH0zYw=;
        b=E+nRxqBPbIFnm/sq7X5OMlxIt6RDX+4cO5bwVTlZs598dcGBIN/lTqFn4rVTLIqkxn
         Zu/iN9j6Mc01W4VeBykHSAZawDJPLSxBNxg7hbEIJtKTNEFK4C9eHaHr4B4lV6ubXwzC
         axpTH7FYmkKIMi0ObHGLT0Mb3GFFODpPN9CIGIg7DDuxJZoBaFv/Et8uRcMGc+slE/Zy
         LJlYPlKY8OVxx63D27XK+ezIsfJUmzbe8TSkoTevaXZ84eO7SfjqQCWAyE1MLblOoFuc
         +RnAI1UFTk/SxJGGobUwX42uX0bU4lREgCZeeMmaHFujFsZ/3Kd/P6ySUhyEeDsR2jOT
         iTKQ==
X-Gm-Message-State: AOAM531d/jwQG7kn9mlBBPLfDyH56RjD/lmfjQ+7Xe8XwjCfh5BtXDuM
        UGFcrawZZm8SmG1JQJcBlCjGBA==
X-Google-Smtp-Source: ABdhPJzhvQe2AZqsRoS0h4hkdSuxFo/HzWtsgHMly5C0QAVd7CT0Npm6KjD135JXtX0Ha0A3oI38pw==
X-Received: by 2002:a05:6602:1507:: with SMTP id g7mr7312691iow.7.1643667431350;
        Mon, 31 Jan 2022 14:17:11 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id k13sm18606930ili.22.2022.01.31.14.17.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 14:17:11 -0800 (PST)
Subject: Re: [PATCH 5.10 000/100] 5.10.96-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <bc036010-8f68-53c4-ad65-c3df0f6773e9@linuxfoundation.org>
Date:   Mon, 31 Jan 2022 15:17:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/31/22 3:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.96 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.96-rc1.gz
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
