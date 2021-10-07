Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC19F424BB3
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 03:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhJGB6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 21:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbhJGB6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 21:58:35 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E659DC061746;
        Wed,  6 Oct 2021 18:56:42 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id np13so3599638pjb.4;
        Wed, 06 Oct 2021 18:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ts4zCp9V734ZwfclS4/anIgwlCmBSwrfENcMVxEllh0=;
        b=Kd6pMvsAdLCY1sMj2RvmZvE4bWSWTL7ihoO1+9lVswhnbuOszspiV1NiJ4A+qDMTU3
         eOA0M8VFZqlQ2XBTf8NSBVD56aeVoUrTF7x5xnz+8sJaG+g4Lb2h0mN8g1YqQh27FHgI
         468Y08xrJfmWs3GUVee4p3HNal4FxWYSFVPA8vTI6i+8sFfvzpR/SZec20odAq+M6n7K
         /u2h4H747v0ZpeIW6SXrwvhlcnz5CK8v614TzP9sccFA0YLuJZI49K0/Qzmz6y+bAPrk
         DS99K0tx2+JGCqXfXOq4Rk9OxBLX3ISk763duaGsogcBeCHsIIFo3ge1414Cldmc/qAZ
         8w/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ts4zCp9V734ZwfclS4/anIgwlCmBSwrfENcMVxEllh0=;
        b=TaPtzpfWhq3ckFz0FBSTxsh9to9A3MZ8oLbs/hk4XxUyh1EsbdEA+R1pmL5UYvdsSm
         VMR+jzWR0it8pmUVoJzKvgW3a17AlSFxNwSKiPvGhxaYjb/+EFWerr7piK6lXKE0PSwI
         uZeuYkCRkCZ2pykzQhcuUjYpisThCJ6fKy0P/YR4pQkUK4MEw+bSZKtQavcEq2jrfUHj
         /q8eI1OMYCIvS8o6Ix0ZXhh4WlXhw6Bz7miiHogmi0DM59GrNev3vKN07F+maxlPTO2U
         BKMAibUlF8DgvzWV+fOzxLN1yjDcKneDfWpI6u5jEXw8ShGyQoFqWdwXUQfuIKUxq6jH
         MygA==
X-Gm-Message-State: AOAM53182yicMneYebvcilQV+2l+2jzIY7+Vn4oT+OjVSm3chvx3pdDm
        LkNLLJ+KKfdNqjpZdLMPPQY=
X-Google-Smtp-Source: ABdhPJz5E7qZI0oaRG6doOLMwhhI9MJWVAGS/XpgtHhDWcNZkTdCmEes9SEfyE5QaPJ+1MgwCo4BNg==
X-Received: by 2002:a17:90b:3a85:: with SMTP id om5mr1691679pjb.115.1633571802407;
        Wed, 06 Oct 2021 18:56:42 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id z8sm22071975pgc.53.2021.10.06.18.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 18:56:41 -0700 (PDT)
Message-ID: <7c1430a8-34d2-05bd-e2f6-f11957e1c9a3@gmail.com>
Date:   Wed, 6 Oct 2021 18:56:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH 5.14 000/172] 5.14.10-rc3 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211006073100.650368172@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211006073100.650368172@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/6/2021 1:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Oct 2021 07:30:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
