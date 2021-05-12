Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECFB37EF93
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhELXNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 19:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443377AbhELWSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 18:18:01 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B0BC0613ED
        for <stable@vger.kernel.org>; Wed, 12 May 2021 15:13:27 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id i7so15742789ioa.12
        for <stable@vger.kernel.org>; Wed, 12 May 2021 15:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1clSlFD68O20p4Y5ZkdY4NsvUgo94JLDLObr9UbRmHo=;
        b=a0EWdWzx8+oGVkOPVhGM7IeDfXokt9QZJSqvW4sbRSd5OgcISioX74hXKf1p8aEK4f
         /zVs2DegHIefsduvk6pRxLuDYiQgE7UiHO7uThmZUXgsOCN78x4eod18nfPZ02q8Aq0Y
         eLwBHec4q70h3T6xqvB9qFfdq1ntZX5wldF5k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1clSlFD68O20p4Y5ZkdY4NsvUgo94JLDLObr9UbRmHo=;
        b=XViPP1KRY3TEvZ39ESFwsjx4iZrqWjJ8eXcXov86oenSeoG7jBf89iMOY2CHj1iMag
         qHIpflkbGjTOJTyDFum4gnmCOO8S6vjd9m8tS263w1yAOqiP1No7qVEN51h8UWiqUdMI
         Uk6gqMF7PAWy1eS+jStKAe6K6u/as7JEEMEsAgNtqkofNm0AMxwSVWsuQ1HCAghLkPlh
         fjceAXP7tou/4TWUJ20ZduNjve2rXt68Ik2MYF9Tb1+DMe2rJWCIr6ZxpY1xFkaLbnva
         zFNFNXmtfqrbn7kUxy/Sz0nq1EuZ2Y49dS6uVuQb9Vp/nLsuMHOe00h3y7/ikdx/mM+8
         9FtQ==
X-Gm-Message-State: AOAM530s5OF28MEupv4jNL8YuW/7X8d/a8VyrvQL5M55azA2dSreSKNy
        9pnkE3LF40IKi2rf8tYJEWi47Q==
X-Google-Smtp-Source: ABdhPJxckEnUmG6/RZEDyLzNSGIybLU6ra6GC4QFHzQhTlKohG5YCv6qVrbAFgsnxIukPt5QFDhaCg==
X-Received: by 2002:a5d:848a:: with SMTP id t10mr28677843iom.68.1620857606957;
        Wed, 12 May 2021 15:13:26 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s17sm508671ilt.77.2021.05.12.15.13.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 15:13:26 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/530] 5.10.37-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4c283d7d-42d7-b3a9-eda0-3a42de98d7d6@linuxfoundation.org>
Date:   Wed, 12 May 2021 16:13:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/12/21 8:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.37 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.37-rc1.gz
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

