Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADEB422DF8
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 18:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbhJEQba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 12:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbhJEQb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 12:31:29 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50990C061749;
        Tue,  5 Oct 2021 09:29:39 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id k26so4991pfi.5;
        Tue, 05 Oct 2021 09:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3ef05so0Rs+jgYfMW3YGS4l9qvn+4nlVR3YmDCrPXYw=;
        b=cU3tL+Q9fUwO24t1n/2NII5XrnMn/vm5SAVsFqkEwD2nlrS0sRbVVLIozF20SGGJed
         OdLEEPcppisO0V4NMM1NAmFap4KoISr7yxYSdL9f67fk42/0xG52HO4CEeYs1kfenShH
         ZVuD2b8OFqBqQ0mBdHSCI1FJDOdPMt4WVdZ1gjoayFrZXdz6sa2XaBEweji2YdOUbMid
         4DG1GG2d/WxWp2qSacLEutw+HIQ3HDZcaTNhy/f1JkEF6eI9S2qC7kVRGsCn8iT9HcvQ
         gJUI2BLTKGnClKSI1WpdXXLT8PbsQB8QRm88Nn9ZStAdh7CzPrdHYpX3o7JH+rrsuNIO
         gUEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ef05so0Rs+jgYfMW3YGS4l9qvn+4nlVR3YmDCrPXYw=;
        b=2Vs2Pb/Ea3Bj+QFF8xeAAl+iNlciAem7TL1mGCf8EPNqaZbMmSlIqX8lKCu4PYxEj0
         J6+cc25J/VRv5C+u8hgV8s9k6IbBYbinaTChiluieg6IEuOXYqX/W+R5N1WkMudoKTf+
         4lGd4MBISfaE354bJiQKEU6HmOFa44gAI6A2JrLIEf4jVwBnOOTKV+J8d35NnH9y0UC2
         XdVUZDYxSdSIcLD+U48JFPMrwUNdqKiWUoQ02nxzaFQLkcN58Bo5rJ5UVb9b6H7TpnFD
         2WV0vq5L4cnDlTnyE17Tj2ffb+/Cxyagfu+lx5zkDhBov8I1MsVecQNlKkpBiILbiYD/
         R8KQ==
X-Gm-Message-State: AOAM531rEy7TBup3oA1t4WN396Y5YkBPqNoSRfLDYJqNvKB0hl2+oD9P
        NFJtLMV0mvk8xylPgvBopeDcf6ZLAdw=
X-Google-Smtp-Source: ABdhPJxsbDU62npd3kBmiIs+3wpNxNitZg593jGipqJz8ZLnziQ5yHRwp3tm1Zqv7kO9N9uu/GjQIA==
X-Received: by 2002:a63:ed03:: with SMTP id d3mr16408704pgi.24.1633451378436;
        Tue, 05 Oct 2021 09:29:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r7sm18046561pff.112.2021.10.05.09.29.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 09:29:37 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/92] 5.10.71-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211005083301.812942169@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c1082247-3d0a-f4eb-9f31-23dcbb0ad2cf@gmail.com>
Date:   Tue, 5 Oct 2021 09:29:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211005083301.812942169@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/5/21 1:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.71 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.71-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
