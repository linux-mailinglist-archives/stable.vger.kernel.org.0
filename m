Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFA63E9ADA
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 00:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhHKWWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 18:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbhHKWWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 18:22:22 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C962C0613D3
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 15:21:58 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 108-20020a9d01750000b029050e5cc11ae3so5264132otu.5
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 15:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qfDybUoZkjjGqd8k6LH06LBo3s0QPbePcL0eLlXyFyM=;
        b=begOlsIv9ct8iYJvgzso9OvpwsHCMi1CqC5Il080u6aT8w0GCoaxto66GXPPXWGRO3
         y1azccZOtVcaQhmjRZwZD6uRZyQAxQQe8LGMTUrFqaZMQxzZFarrlbr1GJG64TifPApn
         BPg+90VRNH/9o96V5F9UMZABUGW/p8rx35i1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qfDybUoZkjjGqd8k6LH06LBo3s0QPbePcL0eLlXyFyM=;
        b=X1YDuf+tGJorKBfNFWA5idWXrTq7/SZZKd4STbHNNIB8blASbGAaoIPRe4Z4T9l9VF
         3nRbTLummQZpgL8tfw31ZwO4e0H5ux5JUinl3LaU2LmLu25gVUl7NKC3xZ80fIVYfdsC
         ABtY+ghe1p2sxGK320zSxXB5Af4+gsCpZ0BtyJXYw4e6G8MWdCsko6HJKAvcdGjrEmxi
         WFnGfgZ1Jj9IrrnKIfYuXGMRp6eQnQ339xcq/8TQX1P1kE9YIx5GNaA4dq2yBCe73dZR
         8/UGa/yBNwjwQ/4AGZxssvZed0TN4gDwt/bl2awQiayNLifZg2CQuY653w2zuZS9osGL
         gHdQ==
X-Gm-Message-State: AOAM530vR4140xK7YazQlKsq/zIfEzdvVNv8FdFCAf+u43gFF9+BLJmD
        kPmtRPr3JYEXNG8LUzUhNqGfFQ==
X-Google-Smtp-Source: ABdhPJwABhwYgn5L74nZ1C04xrTRcKoDIJqrwwXxXflUpISq1xSU6jsakyriMEK8xvU4j03V68L2kw==
X-Received: by 2002:a9d:5603:: with SMTP id e3mr927990oti.178.1628720517421;
        Wed, 11 Aug 2021 15:21:57 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l9sm196548otr.34.2021.08.11.15.21.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 15:21:57 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/85] 5.4.140-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <dae9ef08-52be-f208-483c-13abd30c6f21@linuxfoundation.org>
Date:   Wed, 11 Aug 2021 16:21:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/21 11:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.140 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.140-rc1.gz
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
