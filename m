Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E39D422E40
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 18:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236607AbhJEQrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 12:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236533AbhJEQrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 12:47:40 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D90C06174E;
        Tue,  5 Oct 2021 09:45:49 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id np13so36964pjb.4;
        Tue, 05 Oct 2021 09:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6srS1k2qdPW920E5YZh5fYcOcaMDKYMrwsk2+Bt1p4E=;
        b=YSF9L1bHgIT8ISF3RBdVXKnsTRPGVNPeK0rky1Fi/eePJ3D2QF/CZw/18DNX+XRCrS
         NB2vvyEA67g+MxiJi/ZpPUsf6EkPN9nARwBVXgVhWBZKGR0nQi8hEv4j6zVS6L2YdSyI
         DmKdiYDOsPRhjG4haRqHwpSX+gERF2kNZRPGFreqCJ/08a/9uVrz4STWpmWeiVpLMwiS
         KDMJEuFSXJph60r0c2c87Ls/PHOx+b52nwKnBBzZ8/LbgpnYadtjnMweDw35ofaFqy7S
         /jJ9/uJdC0VaszTB6xPRSJPBdxXe+wrymwWy6fY41eqct+81PVTPpH1CcSrddylcQQtl
         nsDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6srS1k2qdPW920E5YZh5fYcOcaMDKYMrwsk2+Bt1p4E=;
        b=aopZFp01uNl+r0ier76SaAxEySzLolSsDnaBiD0Wy0v+IAnTQHbYqV4KQmAW1zwt4l
         UsBHsJglhL0VrQsimNrceh1Bn0rJzCLIPEbH4VX34J2wNt4fkPxt4EtfzU5N5Gn2PnC+
         rseCA7JQ4SPscbg8chW2lD8Q1DwyCiVule7kNw9RVDM8USYsRWVXXfuhsqapnPqs6Q/J
         vLznv/b9o59xkzOaFA3t2Hmx4sEy94EmEYfwZcNqDb1PQGPKtJolr/twOwgdJ3Cn9jMJ
         6pVOdovv4zezLrdQE/O6luMgzpLSDz5EYyK8JXm/gqusjUdg/pPWzFVoqbuBWYBhx/II
         NQHg==
X-Gm-Message-State: AOAM530So9kzUtj7ERFNwoLlaWFoqa7+HzswplEs3FiomESBoeFXH6g5
        WJSexW2K2Zn+jpwgunSbXv/yJkXZ/08=
X-Google-Smtp-Source: ABdhPJx9N8b1ZeYJu6VzPFAy3rNzseJzD9Pg/K9dNBrLB0eBY2LHcOzLdRgrSNWVEmU0Y6dvKdnqmA==
X-Received: by 2002:a17:90b:685:: with SMTP id m5mr5045191pjz.108.1633452348615;
        Tue, 05 Oct 2021 09:45:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e13sm17953357pfd.205.2021.10.05.09.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 09:45:48 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/57] 4.9.285-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211005083255.847113698@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <32e8a3a8-5b0c-ef6c-3f80-8947e6ab1e2a@gmail.com>
Date:   Tue, 5 Oct 2021 09:45:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211005083255.847113698@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/5/21 1:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.285 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.285-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
