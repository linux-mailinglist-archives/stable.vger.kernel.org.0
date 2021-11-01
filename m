Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1DD44228A
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 22:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhKAVYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 17:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhKAVYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 17:24:38 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0AFC061714
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 14:22:04 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id k1so4570375ilo.7
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 14:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oYzijx2df439jd3pCD00esCIkzqI8D3XrV58RnI1eV8=;
        b=BFlB7WwdLjtrY9sPClqVIuB3zh7eT2X0QkavtXij5ALb5jEJYtyvC3rAV8nuPDMSTn
         3tDUqhLczm0PA2I2DquifxALR2+SAPbbpIShzLvgz5S4Capw3YmfGrdjuCTG831GD4jt
         Dz+ZHRzv2D8eaO4O9eamEIvbbAL3zkdaAUD38=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oYzijx2df439jd3pCD00esCIkzqI8D3XrV58RnI1eV8=;
        b=PZ9KFt8O2YOpASkZhZh3pbLAXc3SQJ3TjffBooJA5MMIVUYcMlan+xNdExb5mIiA9i
         i1v9BcVKjOOjAhtg68GQygsy9olGn5l8gguHokYprNyuZ1ggYGEWuBhBVxO0hItks5v9
         K+8c3hvF8hGczEE62f+ea/kv4irLA8Kgj+D5gg3CJftgLPnJMDURS3pnQZ2gCjUqvVb2
         haSWwo5jOkdSashnWCs1xs4iyIz2gAhTMDdbJDMmQn4Zo+Rty2z+MKiip3K+AqirHriI
         BYEU2ldXyZnozkyhO5+EQUBZdxmZxjQZwxCaPxwMrA/kXCw5jOWVNH4nPdUoLjQM8ov6
         oZOw==
X-Gm-Message-State: AOAM5315ESYJGOW2lWrZOnYwV9WlydSqGBcGDhze4/OJO1+hLjpaYQoe
        BwdSXnhGa598lsoy+kmhCdOhvg==
X-Google-Smtp-Source: ABdhPJwqUd87SSviQUb3oRy1ZCfXw/GmZ6Gao8lgunl9cvRB67EqltOOG6P1KJE9HjPQ4nnt+TwE5A==
X-Received: by 2002:a05:6e02:b22:: with SMTP id e2mr667061ilu.73.1635801724311;
        Mon, 01 Nov 2021 14:22:04 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id n1sm4256192ioz.51.2021.11.01.14.22.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 14:22:03 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/51] 5.4.157-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211101114235.515637019@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0effdbb8-1749-c153-7957-75e914991069@linuxfoundation.org>
Date:   Mon, 1 Nov 2021 15:22:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211101114235.515637019@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/1/21 5:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.157 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 11:42:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.157-rc2.gz
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
