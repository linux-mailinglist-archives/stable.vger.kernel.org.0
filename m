Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F043CBFF6
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 02:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhGQAJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 20:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGQAJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 20:09:13 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD93C06175F
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 17:06:16 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id v26so12601455iom.11
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 17:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NBMqm9QbgY8pXr43Ar0+BX9+G1u/HV8S3ltMcAtx8kU=;
        b=Yx8gH1TC8ab7+WtnYQr1YUiMmbNltVYS+hGLaRZLV/Ft/0YQgoDiPbQTaBx4PxWFFM
         spEto2zKosQevQO2QD2CmOn8bZ0WhC4tehQUWVQ+kZpLzuATthjzNvd7p6JC6OwMIKNX
         m9CHbz7d+HD9id0MvqsD5PJZnCGR6Zlncak+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NBMqm9QbgY8pXr43Ar0+BX9+G1u/HV8S3ltMcAtx8kU=;
        b=qaNDj/M6oeORH3/4f/264s2409xMbdf1hjra7PFlK0WDerrVeMW58wUzvdMOgj2TMZ
         tX5gF/axsCv3OHaMQdBNNvI2gD1reg3kjEnwtQQeLSdr/K3TRgKV26gJIdxTkKZgZa0M
         OaCB/Kf8t266vZp3QCYjCTe9Ps63GCTgwoxR+4SPLCDScuFoj6YsYlixxs05c3iP+poc
         pOkyx377nFy8pWuOcMkeA/QckadZVg3iAbHt9FPja7CsSIxsojdCo+d9ZXMooawkvE4h
         73pH0Xjg0QNOCc5fEmUFjqteObcCU1ARGeIHoOPHJ1vGQmYxI4vGWlKISDwijI/DZYxk
         NO9Q==
X-Gm-Message-State: AOAM533DPu5VLkD1Bbz8jb5hXr0rKRpHTT4/JlW0qCHz9ScuSM852A3c
        97X+R6RCXoS7EKAP57jVHnyAHQ==
X-Google-Smtp-Source: ABdhPJwrPd85TTx0d5mLdbGd69KRJHwRqgQw4ejggbAGySxLdWlui281ODJm4kk8NyKpGXKhcK6ybw==
X-Received: by 2002:a5d:914a:: with SMTP id y10mr9467052ioq.140.1626480375996;
        Fri, 16 Jul 2021 17:06:15 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h13sm4994982ila.44.2021.07.16.17.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 17:06:15 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/258] 5.13.3-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210716182150.239646976@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <dc5724fb-151d-429f-8a6e-0caba4ee8fb2@linuxfoundation.org>
Date:   Fri, 16 Jul 2021 18:06:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210716182150.239646976@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/16/21 12:29 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.3 release.
> There are 258 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
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

