Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222FA49F1A6
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 04:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242003AbiA1DKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 22:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237367AbiA1DKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 22:10:11 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58138C061714;
        Thu, 27 Jan 2022 19:10:11 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id p37so4860458pfh.4;
        Thu, 27 Jan 2022 19:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WT+dzScPHjtxOJeWm6NnhEPv2pwUS3Z5EerJCwhXQik=;
        b=af1u/TXU0N7BN38F5MXSj84y4pWSuuedJRa1100L6dMPupNd51yioCaeHDJVuMHFkD
         EsApslg2/SUrpVrWb62xxGV6L34Q8lYglgn53DdqcmaUtnj6QBA4CRr9VlV5SzGR5yki
         7WXPQNGnCPUIijN+tn8c7sDTCRtjZqra1m8Nzpdrh3rRlx2Oj96kOXfWZtKYZe65HByb
         t8+Kce8p4uu7PNRvbmRo27jccwB6EqA/MHFzLoE/1QZQf0Ks9nizz5H28AW+Pr/3phu9
         Vie+PjaRFcAUJ3z9YfkB25XOvOYcZIKWT3+sKjHrq8CMg4VZroiD+kj6glyHEMkXBOsH
         9SUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WT+dzScPHjtxOJeWm6NnhEPv2pwUS3Z5EerJCwhXQik=;
        b=dCOleoQZ7RjaxIjo3ck9C68KovyQPTcvlIs7DJt4EedAscMiqDPza1bLL70k+zSsTI
         87XbNRebLFLZFu8r27quQZnuGvU/qhb+SoQPmby42Mrv5u4oCmcnBC0xbaEu0OlLtW5S
         RbI7SxzdCcgrB8/NEf4Q6HeUjqc9S3jO8kOBahjHG63lqHwEuK4PWHhdKI2R+gpYznJ6
         1Ls3TLki+TixCo7trzvplG26+9pqMfOpUzjvyXwBfN+QzVwlvM2OG/do8BzL6bLavBR5
         BIHBC/3SB/0S20aIE4jZibeBmusqYJntEa5SZBjRAzX2POZuN1bY8t1nDyVirE4V0oFm
         Z7qg==
X-Gm-Message-State: AOAM532nKs4A5aZgzejMCCS6YtgKp+QYmbERTqwB2cUKTJoTJz83AB2U
        MQxuqRbaGq7hTAR4sh4J8EE=
X-Google-Smtp-Source: ABdhPJwQDer5PJOkJoaN2aMrSnQ9FZczxjhSUlJAI2U3G65+Riz1Qmk/PSnDfsJ7s5KEZZXfzbjZHg==
X-Received: by 2002:a62:dd16:: with SMTP id w22mr6306015pff.56.1643339410717;
        Thu, 27 Jan 2022 19:10:10 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id n35sm19447181pgb.25.2022.01.27.19.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 19:10:10 -0800 (PST)
Message-ID: <45fcc4c5-5267-de3a-0f98-968220ca30ba@gmail.com>
Date:   Thu, 27 Jan 2022 19:10:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 0/9] 5.16.4-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com
References: <20220127180258.892788582@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220127180258.892788582@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/27/2022 10:09 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.4 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.4-rc1.gz
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
