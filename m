Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965C642AFAD
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 00:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhJLWgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 18:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhJLWgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 18:36:47 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC37C061570;
        Tue, 12 Oct 2021 15:34:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so2993764pjw.0;
        Tue, 12 Oct 2021 15:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zFBLAPiQSdahK9ydDDjVPJvs5EdfecbtRsUt+yKWNhA=;
        b=eD0tO7KyebqEI5NLxPLPuD2hShU9D/tSZboF78St5+4w00ePhEjjJMgXh6mFFPuptU
         dL1AOBiMV2mihXi+eAVolUBATncv47FNFU1XGbAuUL5BiVUDpCOgtKNtKB7+g4QSFWcu
         J8GQ9t70gFvhk+EF/uZfVkYLqyO6WqcXod0XSS5r6NTvhvBZrDUxv85I9o6rYXVT59MV
         A6UGuxL7i8ZXtPUyq9k3qyi9V2g2u3o2J4zNHV1JqMbVZmm/virn0iHCRxuYV4tD7O8k
         nBMqHEZGZTENUjx55oYCISi/grm+oEVNP1d4Ruty/nJamyryhmcVR43gi3A+QJQNYhAO
         sYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zFBLAPiQSdahK9ydDDjVPJvs5EdfecbtRsUt+yKWNhA=;
        b=Gv2HuSQvTSfShGTNZbfgSnDCfDWjediT3jfbhLvA6GGe3bSUUEOuo/ADKvqF2OpBc/
         vAOHNi70JuDPLJFs3tG7dsGzyP98OG9NK6mEMQZHD7i+oWXXtSaliCcxpCej4lQ3mtzj
         UFlWUolJ27AVz3WA5XEZt+wc1z9ucUGJeJx5rpWXn6cAQLKzdG9tUWKo16o67hR6HMou
         NAGpoPgTDc3OmdmQWImcxMwswBKkTWQsybzuubbfDKMudQCqJwbzlywyzasBlWjEdxv/
         bvcaAAJmOwd39Qygfi6gfoV6h2NooK4end2iofpmQob2Ls7VPDIBENBFSSJPn2Fl3fZn
         Iaww==
X-Gm-Message-State: AOAM531MxDEbx2Xnd45cHA3mzpQTIVveRazUIOMZM+Ca84yML/RFegvD
        dNvI8nXGT4cFmdTli/7CMDy8OOHmO04=
X-Google-Smtp-Source: ABdhPJzA/P05NWXAUJt0pIPyca9DSNS73C/sJBSyiM/LMe6OVbD5KAMqwyPUpk7LHzQBBqwmnpePQA==
X-Received: by 2002:a17:90a:4483:: with SMTP id t3mr9090405pjg.44.1634078083842;
        Tue, 12 Oct 2021 15:34:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x10sm12238646pfn.172.2021.10.12.15.34.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 15:34:43 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/81] 5.10.73-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211012093348.134236881@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4de747dd-af57-4bc1-3fda-54983c7aa5bb@gmail.com>
Date:   Tue, 12 Oct 2021 15:34:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211012093348.134236881@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/12/21 2:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.73 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Oct 2021 09:33:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.73-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
