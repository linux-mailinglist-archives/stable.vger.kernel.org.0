Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FF048F378
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 01:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiAOAZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 19:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbiAOAZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 19:25:58 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9755BC06161C
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 16:25:58 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id a2so3849442ilr.0
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 16:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jqBsAyPlmSk7R4uqCTC/cP9ifuu7TTprrfwKGk53Mas=;
        b=NMf7bOm2+8TZlfaQBgd690WQw1rNXE302MroUTz4OizhR/VtxJ2/myW5Wc5QuXqemH
         CWSWJuOGdNwcMWPk1i2YFJV8nkMblEQ2hRR0GGrKA3uFBPzGytT3msZUS08EWxZ8LXO6
         9MIJk2Hy1NSwRc71QGUcVJXT309FxojOY021I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jqBsAyPlmSk7R4uqCTC/cP9ifuu7TTprrfwKGk53Mas=;
        b=MDcnnGUZExH9jE43UWIMFBu/uTCVdiV75TMvX9OnY9BmiqV5XYTxsedZRSNUc8sYuK
         B87wz3FPvTXiHVLrxL7c7VLkV4OGaxTxYWFkfCU0N5bm4DUc+u8AINvx3KrGyzStN3sR
         EIUXQtWzVtnWwtBUWmAIRo37pE9thwZL2F3Jw2amRZrEfwlCrqByC03L2OKwoVVlaSdk
         xra9xiNGz3A2wDJT/3VeH/cDGLZu4b0sxWYH1xS6mawu8tOx+pJM7Q3L3PCSdXsxhwth
         GqRB+6QFSEzdCH7rlMvITTcdhYcf0Gt1+qT1a6uwNvo2LdSLwfH88ORavdn9aY9dblWA
         FuEg==
X-Gm-Message-State: AOAM532igQuDYexiIb/yjY8+WAoMMW7RA3CVKauLE2C0XxD/eOfcUFAX
        Q6dR4ThOYK+REU6w+Nha9Nw7fg==
X-Google-Smtp-Source: ABdhPJy7qUV4TgCkS98bpE1idKbssv7nEoQqFg/1GTESU8+8uwUkjHu8fCNeUFam6yGzm5VpuWUq8g==
X-Received: by 2002:a05:6e02:1449:: with SMTP id p9mr6171036ilo.66.1642206357987;
        Fri, 14 Jan 2022 16:25:57 -0800 (PST)
Received: from [192.168.1.128] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g10sm5410051ilf.46.2022.01.14.16.25.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 16:25:57 -0800 (PST)
Subject: Re: [PATCH 5.10 00/25] 5.10.92-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220114081542.698002137@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c328bf94-ed40-40e9-c1b5-ae500c51c323@linuxfoundation.org>
Date:   Fri, 14 Jan 2022 17:25:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/22 1:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.92 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.92-rc1.gz
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
