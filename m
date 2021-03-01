Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF12E329426
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 22:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhCAVtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 16:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241393AbhCAVqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 16:46:12 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4125BC06178A
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 13:45:29 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id z9so5826734iln.1
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 13:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O31tOFTyhK0djp6m6OrIXX6oPRMc3ctb7d3CKjziyQM=;
        b=iZXJU82iyp3QVzr+N1Zak2tnH+1ZTftwPqNERIILPiqAKmeiCRMuGy/XHuAFpWCyIH
         66r4rwzD8VotdSS7H+uApxFH2nWG9ETL+yt4RYT03+TA328vOzPIJn/NMEMgL4orupvl
         fZcILysqYwraG+HiQW6iKqmlQj52jjqzok8ig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O31tOFTyhK0djp6m6OrIXX6oPRMc3ctb7d3CKjziyQM=;
        b=nKuF9FmLv03zAHstU/N7X1WlCAm6vJwGprji79iaag9BVScgoMywLZjKBGJIzJEPRG
         TvqUAWentUifFz/QOjmkospmlMLwTOfZBpZz7cKVcel7yS8aXn35FQdL+HzUxb2tz29x
         GkF9bxEvNRSwikmc/RjArvzWVi8GXXlxRMMDugRHBAB3yGsIpCQO6WF/sK/3eTAnHWyf
         cMQCy659xDAQBL+dJjvYj6jrv1C/nPAFtH6qbbZtopkI6pV34fHTznPeTLjakj+4b3JC
         5R0jBEfyRFuCIcnNWIxO2gxTt6jDeZw3uSIiwh//lEO3fl9zDkrUnCOlkvFP2lCAnmu0
         GcPQ==
X-Gm-Message-State: AOAM5338Bd8UV2Mb+lSjSBcgyu3FaahjYzKCb9qdGgvWm+4tPglIPsE1
        QlySgOUQK3bJwUTGTQSJzIfLiQ==
X-Google-Smtp-Source: ABdhPJx/dy+CXuGH5+tjCHcsJ9on4j0yZ7fwpnnfn2PQAQKT4A+LjDDqCNL4rq9D1F8iO3VcL50czg==
X-Received: by 2002:a05:6e02:1b0c:: with SMTP id i12mr14923537ilv.200.1614635128780;
        Mon, 01 Mar 2021 13:45:28 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a13sm9854619ilf.9.2021.03.01.13.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 13:45:28 -0800 (PST)
Subject: Re: [PATCH 4.9 000/134] 4.9.259-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ccef7680-1b85-1927-9757-3e1e8aa97aee@linuxfoundation.org>
Date:   Mon, 1 Mar 2021 14:45:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/21 9:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.259 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 16:09:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.259-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
