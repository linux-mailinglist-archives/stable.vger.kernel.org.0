Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D9849309D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 23:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349885AbiARWW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 17:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349882AbiARWWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 17:22:25 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EFFC06161C
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 14:22:24 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id o9so483768iob.3
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 14:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z3QDL2aw6bS278tSb508sE7ZNn8/GGR2WQT8XbfaAwQ=;
        b=Hs0gTHiM3werxiH9OoO74mIdOvDfkTST0zpJDDx4zg5u6xEKxvPh1Ao3lxooUdj/fT
         aQa9ULWo10hDu02nEvIaSP0tcA39N5djVkGySZGXVBPFys8qKH4dGtjDsKzPXF9Ugv32
         7LAYG7dyf1+7iCG50jx4OnkvYNuB/iLMIbW8o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z3QDL2aw6bS278tSb508sE7ZNn8/GGR2WQT8XbfaAwQ=;
        b=ehMzUi9j8q507IfJskcDC6LKWGam+I2klRtRHWp6jVHZEcqdNd5W7glJyd+O/czzUD
         qciR88YYUQNAAchbVspWQerS7UNNcfd6T9EZ5Wmoq0ZBHG4kCPuwIY+4z3RrjwHW3UrD
         xROR7ZaPr8Whu9RHZEVqcq820AkAPLsONWhAqZG7MoxjdIG3x/EpXYb5LvysIvQqMoi4
         LPepprbxg6WiZ3pjaCERWQ0nVr37qhsiqHseequxrkQojU16r2t/LqkUfXi3NNr6Rggi
         SigmcXI2VFNJQxazKujJaGwd8KUXoxe9KL8Lc61p03WY3pJ1D9A/DcA/2mxwGuYQ7KqR
         SlrA==
X-Gm-Message-State: AOAM533zQlH3f5igVOjFq0QGXO/t9A88ApWL1Cf5dO72uLIgWCKB59Zv
        dOs8IYvR7On3Tbr0u6OpaEuM3Q==
X-Google-Smtp-Source: ABdhPJx0up0L+gRdH3c84Vj5yUgBeNsgnj9XiyayCWj1Lj1wQ7VwPSws7dnfkEDGLqFlqeTscSHHKA==
X-Received: by 2002:a05:6638:3049:: with SMTP id u9mr12555733jak.132.1642544544238;
        Tue, 18 Jan 2022 14:22:24 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id d14sm11584468iof.29.2022.01.18.14.22.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 14:22:23 -0800 (PST)
Subject: Re: [PATCH 5.10 00/23] 5.10.93-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220118160451.233828401@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ca72b56c-0a2a-f6e6-ecca-982179ded511@linuxfoundation.org>
Date:   Tue, 18 Jan 2022 15:22:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220118160451.233828401@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/18/22 9:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.93 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.93-rc1.gz
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
