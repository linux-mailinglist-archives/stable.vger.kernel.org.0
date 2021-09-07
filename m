Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8813B402F66
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 22:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhIGUIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 16:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346032AbhIGUIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 16:08:15 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C25C061575
        for <stable@vger.kernel.org>; Tue,  7 Sep 2021 13:07:08 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id g9so80024ioq.11
        for <stable@vger.kernel.org>; Tue, 07 Sep 2021 13:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jWF0MJ8RHShf60H0Al3vsRUSnCSCXskM+/8Zxzt1hH0=;
        b=eporpyfJC0T74qsMDAYiyqrTFSqm5ustWC2GeNoZrhFP+B0fcJ3nh6xMKWfSpm4fTD
         Apm1jI0E6daDI5sgx63kZg0i5dhEbXn6TOALHgIHtqwCDLTfpwj1pYDtWb9BLI77JIMA
         GB7QOiGtm3XnYhTPnatyq/pslwbowqHmOj438=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jWF0MJ8RHShf60H0Al3vsRUSnCSCXskM+/8Zxzt1hH0=;
        b=Tb9b8NtOUgdJIHfzDv6gou30pqTZ1VKNLm2Y9CnuOhLg+cm5esi+UkEYWASU/RFw5q
         nvtTdrMPDouuJeZEGTX+dGyF50isHWi4pOP9XD4+95V6UBvO2LXJWujkdFpBDDnZWg2A
         T3NdyoiP0MgtOICbZLXdUX8Fe2ZTa28M6A6FNq1e6NsvXRPs9T0fPUshVw6XsIu/Wk4T
         1QRwGK8ZZKLiDIucqvpH/uI5cgicCoVpzhZJYOgurC8+OhBH2WC+AbbYCkCyBCpgodPY
         nt7BYTJ+EGKfcogsCPiN7GZrJn/9Jl/8ifExlMYN7+W51Kg6pqAz1gcfuj+IfGfsywo4
         WZXg==
X-Gm-Message-State: AOAM5315GTncNwTiB6BaauZTN4WiI4HCPjipmKzTuFVnxVNlTY4VRzC5
        5kKuwPj21vLKtO1yvJadz0Cqeg==
X-Google-Smtp-Source: ABdhPJwbGXo3L/fCwasQU4Bw2TOxIcDe9nzcK04pJIfAWo6o+Poev8a3wvtWyWBz7BNIhamHI3eWeg==
X-Received: by 2002:a6b:5c0c:: with SMTP id z12mr15837385ioh.171.1631045228057;
        Tue, 07 Sep 2021 13:07:08 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id d17sm50598ilf.49.2021.09.07.13.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 13:07:07 -0700 (PDT)
Subject: Re: [PATCH 5.13 00/24] 5.13.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210906125449.112564040@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <05a8bf29-52a0-b3d4-c299-e86e73c7d355@linuxfoundation.org>
Date:   Tue, 7 Sep 2021 14:07:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210906125449.112564040@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/6/21 6:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.15 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.15-rc1.gz
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

