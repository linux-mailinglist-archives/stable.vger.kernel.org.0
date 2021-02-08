Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE07E3140C4
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 21:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbhBHUoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 15:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbhBHUnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 15:43:51 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589C9C061797
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 12:42:45 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id e133so16427249iof.8
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 12:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NYkpRIKoQEziEfmxZHcyacDzEAn9HqZQPpM6B68wbgg=;
        b=Ufp4qTP6R8yxFdPeI1A6XodAcAFmJAQ223I6fycZ8IUeuLE9T7+kJ2ngaE0jPEuucx
         E1c1hPK30k02Dkd66svllSBF1u+rXCOGHvvDAFSHBumyl7/ntStyO2wYd0jXQ9erACyJ
         qLCQxGZwS5JGDDetpHFt2bD8ubiX5b1TT4988=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NYkpRIKoQEziEfmxZHcyacDzEAn9HqZQPpM6B68wbgg=;
        b=o5R2J7DsUgyaiS5vELTcf7cqSXmFgiOUWZk/bprPhfob43ZCeY8HRZLXspdrkATS9r
         9M63Tvksyzrt3CRJ9t4rLA0n/PWahlMT9pSZWCivk8lPIlpJgKqI7e9pZwXy2Kfe0JHn
         l+uhr7a74WtJ1SjrxNXvmAcb283MDVcCQptcG+6q8/OVJhdNrvd75Sg/MUo7tmCP/2DM
         odhyutBwzKc5OQugwyQVWbnKYV+uUzcHESP4/QBsdPa+Pd7KpwxtGNThdAySNgUHmd4Z
         hg8MflqPrCo6t3I+2MAD/sNc7Jxl/7CZlvlFo1pHC8vVa8se6/nLPhIG3NnPyF0Eh6yZ
         oOZw==
X-Gm-Message-State: AOAM533oFZJLn35FCA+KFbvxZKUDnDb5Jp7q97LnW54bUyRq5eMcjdA8
        F90rqyPFPF+v/k9DJ1Z23IPO2bFUmEY0Zw==
X-Google-Smtp-Source: ABdhPJxxAwDRVXrUwmE4LtCFsi7pcA6rtNOki4SFW7uB7Tt7rVOC5aqoi0t4NCxXLApkha8uOWPm+g==
X-Received: by 2002:a02:9a02:: with SMTP id b2mr19870894jal.51.1612816964889;
        Mon, 08 Feb 2021 12:42:44 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l20sm9404113ioh.49.2021.02.08.12.42.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 12:42:44 -0800 (PST)
Subject: Re: [PATCH 4.19 00/38] 4.19.175-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210208145806.141056364@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <40e3c9f5-7e84-6259-7ba7-ca07b7e2c30c@linuxfoundation.org>
Date:   Mon, 8 Feb 2021 13:42:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/8/21 8:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.175 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.175-rc1.gz
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
