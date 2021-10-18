Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633994328AC
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 22:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhJRVBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 17:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbhJRVBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 17:01:17 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08EFC06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 13:59:05 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id k3so16298728ilu.2
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 13:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KsZipfhox8sAC6nabmr5ZcwU+y/Qqu43iIwjjODEwR0=;
        b=EjbM7ybL2F08UJ+UOe6abiVAvp7nZoGnF+afJu8Pn8xqm2CqvTGcq7cmeorQMIKSPq
         nyuaz8aomBZeiJzu58or0v7pUrhz3owkTCpoo5Z1CxewCcb2yAGnAHgCfxqGIok3f2Vl
         ztwhTjxWwPosb6xHtVz3PZpTvkkbESl41r0Mo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KsZipfhox8sAC6nabmr5ZcwU+y/Qqu43iIwjjODEwR0=;
        b=7KPgAw5gah8tEkceKhq7WE+d0Xl1v6EObaz1KvfytKc/VG8QSTsactypacFlXs5GMO
         rD6xBXHiAqU1m50a7Tnh2jsmJPl3e9TFSl657o21Ancyxl7ttFTKV85A7kvgIVGU3Dc5
         ldF+RURe4xBbiRKfkEQhN6Jkpuio7CvG3b6JisUmei+WfZZ7Zkfd0lrrYJVHbS0Up/7K
         XXLBHgBdfRiNcBBNCVSAGMUOb26CWU0nbYA5O52xaR//S09OT1qJVD6oglMgMPMAm9b2
         NMO+NGHiyHxZPB2nLB5aqMKZQtWlrp3zOhamJmA8t+kbGXm/tRmArhi05m3MlCHFBj5S
         jfkQ==
X-Gm-Message-State: AOAM533LbdRrrcpkpUkYryLrAbewD8Rz/U/nL1mwigLWA6X14JwPsL8i
        yFCPJvVq86dpM6vwbF7tS0Zl+Q==
X-Google-Smtp-Source: ABdhPJzk88AX1DHF/XwLOuvnRlb75ORTqO9EWetSTR+Ql/t1v9EmzUzTC06f1/ZPt4S6PKGn/0MMyg==
X-Received: by 2002:a05:6e02:1569:: with SMTP id k9mr16492472ilu.19.1634590745196;
        Mon, 18 Oct 2021 13:59:05 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t12sm7334274ilp.43.2021.10.18.13.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 13:59:04 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/103] 5.10.75-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6d5d9000-61a6-c2c9-eada-69fcd7c09de4@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 14:59:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/18/21 7:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.75 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.75-rc1.gz
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
