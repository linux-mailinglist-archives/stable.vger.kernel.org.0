Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACD53EDF7F
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 23:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbhHPVw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 17:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbhHPVw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 17:52:56 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5E8C061764
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 14:52:24 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id b7so15880573iob.4
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 14:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WM0RiCzaiSp39KfoeBuYCtjssF5wMkgccPnpXtLujk0=;
        b=c8nQlHuxo4ppeF36f/J9zfRczITAMVfVL+AKJR4BOw8an0ESKehiASvrxInlRBCz0l
         vftB86HuBMI/Md0gOJTwGnAt/Fd5zp+ELm/z5a5LqQGf+MkjXYFcBz7V3ihKxdiIhztr
         0d9iXRQGfBwEzAO58b4KIFrZVq4sV17epHymM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WM0RiCzaiSp39KfoeBuYCtjssF5wMkgccPnpXtLujk0=;
        b=WgZJ53qOl1cpQTevCo17E8LZGBtN3unNdn8t4/jfONmo53vmGXE9FzQ072r3wRDhjH
         CH6J6XamU0uAg4bCPs3qxKm6eQLMlBtDeeXG4A4Gspm7gdjYie9rIDAXz0dno0pI2H0+
         sHcbDevRd/eF0bZ78179wk03W6fpf2sjmAugfYJ5hCTfHI4i3IXWRyMFa+jDKPGS3XbC
         DMqP2lV53mrvzmsp+PF5avnH3zpv1gNfYqzfN3JVNw+kp7PFfxrjjy41xI66YK4LUnFh
         IjtEK4nPB4DxLesbKWUyjFjm6VxKWbD1+LVl4DbSCWBZEmKJxtS5C2sLmyubGEZQCLCX
         urxg==
X-Gm-Message-State: AOAM530bmVD7OYUPgAhFqFF7af/+088mAJMbv8Wr94/CMyCElNP1jlth
        0zqtJNlvmwTjvhsWmp86wns4Pw==
X-Google-Smtp-Source: ABdhPJwyZ8KmcNnpd5BdV+bYC6EN/OpcFxaLlo7mIYl3c6924r2yD7QvJENE6I7+zYSTS0sLLr0rug==
X-Received: by 2002:a05:6638:521:: with SMTP id j1mr175jar.122.1629150743490;
        Mon, 16 Aug 2021 14:52:23 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m1sm51826ilf.24.2021.08.16.14.52.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 14:52:23 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/153] 5.13.12-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210816171414.653076979@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <fb044d0b-1af2-378e-ffed-229b6b9980c4@linuxfoundation.org>
Date:   Mon, 16 Aug 2021 15:52:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210816171414.653076979@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/16/21 11:15 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.12 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Aug 2021 17:13:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.12-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

