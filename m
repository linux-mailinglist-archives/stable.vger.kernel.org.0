Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26A6402F62
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 22:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhIGUHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 16:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbhIGUHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 16:07:48 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807E1C061575
        for <stable@vger.kernel.org>; Tue,  7 Sep 2021 13:06:41 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id h29so344031ila.2
        for <stable@vger.kernel.org>; Tue, 07 Sep 2021 13:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gk7sw5Z2cUyG4Jy93qJQP2ZmL94RuzZS4lGEc0ni2lU=;
        b=XI8sg94HdOFl6qDaf2FQ3ZAByy2Mzq/BBHJHujdGhYTtW+M2uZUow72xaZm/LNcprx
         mCyphBV+J6WyM3+lOe9KsLi00VuOQD1HgSUTMSKNvkaQNoLaQFGNWRH+A/eVHbVwDhPq
         TvtJc2ye6e4ewtzcpr6PXSozJi63CDUXsLziU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gk7sw5Z2cUyG4Jy93qJQP2ZmL94RuzZS4lGEc0ni2lU=;
        b=OaqLs4VNzn6s55EQdzVQp5b2y8uUO4im6ipq+eNU25vuFsq7GXNjd8sEadKYY1UDou
         Rw80SPLMUQf9IxaUaQHSAB3nv8mJKyGpn59UueMdLtgSHZIn5xa1xp8hdBq7RRM0Fo4S
         LHYO9pcHk/kD+FS3esuOHkjTtzl6mnrW0w4cHVUptBg5dbq9qWnB7mJyYHx6dhkFtxuO
         Eg6//oY66YlsZOvOXv9FsGNXYAhozy0LVUKC3YQCiUKutb+ZDTVqqz+8p2vNnuWSe40Y
         YAJoQTQIVaMdGktTQp2yqzePSMTjKvF5FBiA6GILMIIyp/wiS3YxxQxWo+RKEW2bCe1t
         wOBw==
X-Gm-Message-State: AOAM532gPLxRg/AOSgQTv9914/wQOOUoyEZtdkAAt1rLmLGkImiuiNfV
        PnmkHSj8IUCehD7YF0/q+G+FGA==
X-Google-Smtp-Source: ABdhPJyEN5xIadzgfJ1N4XmtIIV0nhaW3MUsYMMgT/ZL0Bzna7mZRxyBeG6m5llKhH6Ko4hDQK6FAg==
X-Received: by 2002:a92:d64e:: with SMTP id x14mr5193ilp.206.1631045200961;
        Tue, 07 Sep 2021 13:06:40 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g14sm65392ila.28.2021.09.07.13.06.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 13:06:40 -0700 (PDT)
Subject: Re: [PATCH 5.14 00/14] 5.14.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210906125448.160263393@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <243d8e79-cd2c-eb37-d0b9-57cb51554171@linuxfoundation.org>
Date:   Tue, 7 Sep 2021 14:06:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/6/21 6:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.2 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
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
