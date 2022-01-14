Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CEA48F26E
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 23:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiANW3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 17:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiANW3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 17:29:06 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83CEC06173E;
        Fri, 14 Jan 2022 14:29:06 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id g2so3859207pgo.9;
        Fri, 14 Jan 2022 14:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NBxVTn0du8/apgRw9wjiw5xd6D8rrVeNvphwxQy6weQ=;
        b=Qk2Y4pHrafDC/h+ccvLQNfzdfS/fWPLIsaroJQHEbOieMZtWE02IRt4Gz8mWGVSIjY
         4L3uF6zUHg+Lpriplt88nK+Nkat+ovRaBLzlol+IKSBr8eCaV+H1dyhCsdKJ0LPKz/fU
         wxKN1V1n2uXjsJtkHWCokVdtpbabaaNsqHH7hZ21Fu3gOSovAq0HDVNfZqLpD8bdFFfm
         S9Y4VfkDjofdm/0Nm8ZyYEgcvP5SlERybhxEgdF+2oY7UWLz7+Q9XU9hcoTsvpEIR218
         As1E6i3xGydOHIa1P8ZK6qI+g2NA+zAXBqhLvn0cbcx0lqEFWCJTQT5oWmn5z/gCyPtO
         0pLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NBxVTn0du8/apgRw9wjiw5xd6D8rrVeNvphwxQy6weQ=;
        b=4BirUU0d/RGpXtXlGSDNeG7WNZ8SKmiTkjZIGSOawoOYRlLTOQpaDkUfAJIUqGyMXi
         /rCrjkfUNWirIBV9OhDyUnl/wjdXryWcTPLu+X5MJr1j/YJFmUulLwOL/wyC2Zs6yfiv
         +8xn1dxW2E6aP+uoND54ZSjMhudW7uQc8J3T6h1WdWnmYJ9kaQ98k0fFFD9ikvO349kj
         7hV5Dnog5CVpDkAWQ8CligwbzAaulZ7W2ijeFmSc/FbXm4Pw0FZE7xpnKjH28U3jY+me
         IT7REU9l7ekklF6G0qLZi513J1Q4VZKYHnUgLoPmuQi8tHLPVR/w2R4WW2lFKvlKoqA7
         C8eg==
X-Gm-Message-State: AOAM53167vE5kSbvwzFllcT/pjp58k+06at9PCZv5ScYBoXHogBet7Yk
        vlWdn6r8Zg7eEK/7HHx0IMZtbrhHDAo=
X-Google-Smtp-Source: ABdhPJyT0Ifc7MfE3kMF8aoWUsA4tuPOBTIDbA5OSfxKT3GjlP/x3gLEtWxu+YPLfznrpi8cCkW8wQ==
X-Received: by 2002:aa7:985d:0:b0:4bd:8a52:63f0 with SMTP id n29-20020aa7985d000000b004bd8a5263f0mr10848043pfq.56.1642199345902;
        Fri, 14 Jan 2022 14:29:05 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id nn6sm6147080pjb.51.2022.01.14.14.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 14:29:05 -0800 (PST)
Subject: Re: [PATCH 5.10 00/25] 5.10.92-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220114081542.698002137@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d1a10ea1-e21d-7db5-75c6-18319c9d124d@gmail.com>
Date:   Fri, 14 Jan 2022 14:29:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/22 12:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.92 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.92-rc1.gz
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
