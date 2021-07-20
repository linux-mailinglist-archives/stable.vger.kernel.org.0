Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD733CF0E5
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 02:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242364AbhGTAC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 20:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241473AbhGSXuY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 19:50:24 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F517C061794
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 17:28:19 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id p67so22776797oig.2
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 17:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7vZ8NjLoSgDSn8ltcT7clHGhNAnF8/t8ejSaR9tzW7M=;
        b=XfAqn13t1F3Pf7Zhcg1U3lCLbkBF03PFNySpddQs1rOzI/m3QlSTFLeFmslLrYvqjY
         bZ5w0nzDS4AV1ukxqy449y5fqxQ5+G8mHfzTuVvW419bE9Op44tWSJxRDbOGudQzhN84
         FFqEP6CmPmLh8F3q4Shy/vKXWHgEzoXpHlrro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7vZ8NjLoSgDSn8ltcT7clHGhNAnF8/t8ejSaR9tzW7M=;
        b=S+0DpwJN/dkbChbQrUCgrswzU0W9UDZnHyw7aOFkw4FqlqL9fZ7+bp/UWpjZ6+vxGh
         1TUKiMXvUUYVRHwnClBpVEKUYO0M8lcK6d31DyYCrPA17Wc8vWkhHwSiMEvCsYeO5vkL
         qAfokrAragHJ5tGBHbXYqyKAEQxgNHnkXtQ6HOQpUqqc2oKKqGdS3lUBnMKIOyzKYyhP
         FNEbUXtTX156DuAXf5Ylj5pAATeMp/jDIQEYApGMGc3T9WXLft1X8tc/vJJXTc8iFZJd
         S+KbZFM9BCxMF8qBRSU97K+TB6ygXZrTY2Oa1zXkOSkE5BtbRr+U5vYK8+vln+lU0K9u
         q/LQ==
X-Gm-Message-State: AOAM5301izuzR8pHSfJX+3Zq7Q8/H6p/3ckYRbcdLsYChtsBa6JbG2Xt
        5/iEuUXe04j0a808/H4XNfTMRg==
X-Google-Smtp-Source: ABdhPJxg6JeRkJXocXIvD6d9i2tk7Njxa1NN1LRGQjk4cDBLUs77uR40VEm7W7FLoGgkLPod60QoTQ==
X-Received: by 2002:aca:1206:: with SMTP id 6mr12821195ois.148.1626740898466;
        Mon, 19 Jul 2021 17:28:18 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m129sm4067704oif.15.2021.07.19.17.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 17:28:18 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/349] 5.13.4-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210719184345.989046417@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6b200fc5-10de-4ef1-e16d-02055d32d573@linuxfoundation.org>
Date:   Mon, 19 Jul 2021 18:28:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210719184345.989046417@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/21 12:44 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.4 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.4-rc2.gz
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
