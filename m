Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F18242728A
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 22:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243243AbhJHUuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 16:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242602AbhJHUuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 16:50:16 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D65C061570
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 13:48:20 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id n64so15363352oih.2
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 13:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DRQf0MUrgUZUm+PsaEtJGp67Ew+5OIgseGGqoj+Yb2w=;
        b=YvAdURRvhPql8v6ErQJAvYRHcit/gGTbkGSBToB/9ZCXe2HtJPWrmbEiV7zOTQZFA5
         lGIvIUdM0Vka28EZI2NDpaaedTnNTlyrysiRKSzrTZVA480+ta591qklOE7uQ/HFHrpT
         wipts+C/ePj//aSXsfhs9LjShUIhYKOLTIyfM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DRQf0MUrgUZUm+PsaEtJGp67Ew+5OIgseGGqoj+Yb2w=;
        b=mZRDnOAz1/e/CDQRNsOORLQfeyD+HeavgVSkE5IhoWYWfw4DIPYIEOZjEBVgI58BJT
         0r5XBqUoy7vsVZ9WXdZBrH363mp/lXrqSeJmYceG7npdk7JrVkmEJzjLvOBEOk/LAyg3
         ewlIlaFJQ8mU5RPshbUk/G2cNzvK3PWqPQdbxRfy6fIS20d1kBs9mGENMZkDku6GszuG
         wbxMFqiG/isE3MNQlVMllh0U5BRn9UBFamFsmU/08GokYZhqPX2GquZry+L/aDZOF68L
         yxamaq9d0Moq3TAydHSPUeWSx4sKBqG2m3m40w5hXbAeFvF8FTOfVEeNYCyC5bm/X3kt
         OBZA==
X-Gm-Message-State: AOAM533XVPkzyl7/xZYL+g5kLdxv+wLc28U6CkQiKqhlVpiO2PeTGqWT
        zz05rgi78BqmBuxXYUfhJDFSmg==
X-Google-Smtp-Source: ABdhPJyfGZTgC/6A/0NZK3aaYcd6Qt3RbwM60vPYvmfjV4Z24yVF1ZXhLttunzbeZKLo75DzSF4HJQ==
X-Received: by 2002:aca:d988:: with SMTP id q130mr9327961oig.148.1633726099997;
        Fri, 08 Oct 2021 13:48:19 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i24sm97285oie.42.2021.10.08.13.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 13:48:19 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/12] 4.19.210-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211008112714.601107695@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <630d0a3d-ff6c-168d-ab0b-c7aeb6a6bb33@linuxfoundation.org>
Date:   Fri, 8 Oct 2021 14:48:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211008112714.601107695@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/21 5:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.210 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.210-rc1.gz
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

