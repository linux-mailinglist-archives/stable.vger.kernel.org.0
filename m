Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F8D48F288
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 23:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiANWmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 17:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiANWmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 17:42:02 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76E8C061574;
        Fri, 14 Jan 2022 14:42:01 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id h23so3876987pgk.11;
        Fri, 14 Jan 2022 14:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Lv3lA8SvlVmISJSLyktGARSgPbJOqFseutvaR6jlKNk=;
        b=RMrv1v6/uquseT1gJS3yoz/gzo2H4tOyT3V1rax7BoH62ol88JVl2rm7p8VTqHQKjf
         riVNpvVAFB7Uh6pbJJUFLFmJnc2jJi2acZtlH/ataW6CX+eszSwWjYi7K3/zXc7jL5UV
         l4LHlhuCScYKbozuzquwyztYFYhz9KFZzOstgaRRpCpeTU8HIkMIfjIi29Nc69Xx5OFx
         MjDT2xAimhPPPRSnBFbJBRWXXt2KW+Wvd1fCS3lIQEOtEaPhWRef44O8cSOpkhXN/UqB
         YAN7gJP/XgZH8DNzgD8r5y0rDhG1osSk0NAAnC0fPfF+168lB97K6i4kNFo+lNXluG/l
         5hsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lv3lA8SvlVmISJSLyktGARSgPbJOqFseutvaR6jlKNk=;
        b=RY4mVoerjzzlK2FxABDgnAWTzCWZwd2yQ5f37J9vF8w2RSr6qBZE4sW7Ooh4nbhfrh
         x+rLAhV72HfmsZx54uGnHVAH7W4AuRGcmiWahkBlUY0C2rzYO+rHhojWDp+asYpBKj2v
         X56BvR92vlclunqX/+2ZSkaTFRrEFKVcvKdsSiKjKUZcQ8Qk0hgSu8Q6r1ZRDxNVgBOM
         bxTQHVJ4+/byLNIplVBH14Vgi4dsXFC6Svq6/Yk6s//7rkHz9FOpdorhm9BuUSGEBrmV
         qxxCysV/vvLsLg7AT5a5ZQkCiAklVNPBaOyms7A0UPB8Q9eDgVNCBrogqgFKftNXSSQS
         ksdQ==
X-Gm-Message-State: AOAM533vcKYyt1EhIruEudle2Qzlw8xWkRvSYM5dbnP4k4R3GqwbH3Fc
        xrKzAyiMeGZebSZG6Ig4YT/yeGIt7RI=
X-Google-Smtp-Source: ABdhPJz7O0Culpd+LPEIRnLOk3Z381ZLp5s+B7zENLUAwjXyVg7JfngqJlqIDZ4MyKCvswgdNnZVDw==
X-Received: by 2002:aa7:8499:0:b0:4be:f48e:b144 with SMTP id u25-20020aa78499000000b004bef48eb144mr10899376pfn.66.1642200120910;
        Fri, 14 Jan 2022 14:42:00 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id rj1sm6184792pjb.36.2022.01.14.14.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 14:42:00 -0800 (PST)
Subject: Re: [PATCH 5.16 00/37] 5.16.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220114081544.849748488@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bbba4edb-684c-b8fb-5578-14d823aed189@gmail.com>
Date:   Fri, 14 Jan 2022 14:41:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/22 12:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.1 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
