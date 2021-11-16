Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECBB4539A6
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 19:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239227AbhKPTBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238997AbhKPTBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 14:01:45 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30F7C061746
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 10:58:48 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id m11so193705ilh.5
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 10:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d2+SDCvP4D6/OHLFjGKGm9XygoGwxW+0weshmpM22LQ=;
        b=CiOpv6noCDlRuQu+8wd+Jq6KZ1gmi6Q+a3oOeEC0JSjC9iNDNvjTLIlxYPiK+LF4/z
         qWRbMgotXpkwPT6hQ4RbWXfW/MSKjsT2OMP6G3ch0xQzo3Z0hhPjTqnbPKlP5pkJdpzB
         q6envRmYqm9ft+AMcCAsl6q0T6wSVBzM/jhYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d2+SDCvP4D6/OHLFjGKGm9XygoGwxW+0weshmpM22LQ=;
        b=rYE9TCTK01m5o7TGIZq+Zg1X+R8TdajiSaQF6HdJBOvi/OdUtI7V6Fb4Ojm5OkLxVl
         63u5ONDrItBXV0+QKtHI+EPAzD3oXowGwKKKz3+SGFPfVi32+cDK3qltIxxB7zr9iJ3e
         hyATgRVOkx32NFrGE6E8MRrg1lByT73syTV6LsMGaVibtPjXYEjX3CcGqLnyXpd2r+pg
         OTqf52AhONd5mDS8yvDWJJJbVWjeVd+Ut0o7piP84CE9NwKRWgUatawjKck2qz3dsMSH
         7gvOdp01m9tM98Ix5F0iVAHVBuKJUtIsnMQHK/kAQ6hYRP4NKFfKiYbetuXttaXMeIOw
         rvBw==
X-Gm-Message-State: AOAM532+tt2J43clSI/kyzC+UNbNntKGqhDXQWlxowOzTii0tz1hq2H6
        J6qYHpDZrwllP48nsUJZEjwy+Q==
X-Google-Smtp-Source: ABdhPJzWJIXx9zti39B5CNYlGBOX5mmO/LDBdUQUaMDawIkF1LCwYA1yVkDUIX/uXO7m2+kgQiDX1A==
X-Received: by 2002:a05:6e02:1561:: with SMTP id k1mr6213040ilu.135.1637089128086;
        Tue, 16 Nov 2021 10:58:48 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c4sm9950968ioo.48.2021.11.16.10.58.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 10:58:47 -0800 (PST)
Subject: Re: [PATCH 5.4 000/353] 5.4.160-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211116142514.833707661@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4b3a546a-7e99-2cdf-d57a-35ed0396bf18@linuxfoundation.org>
Date:   Tue, 16 Nov 2021 11:58:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211116142514.833707661@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/21 8:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.160 release.
> There are 353 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.160-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
