Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E489D393BF6
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 05:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234626AbhE1DgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 23:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbhE1DgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 23:36:17 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD2EC061574;
        Thu, 27 May 2021 20:34:43 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x188so2205828pfd.7;
        Thu, 27 May 2021 20:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3YOhXjfhIZJ1T20VU1xRyXuzy1Lchldmw8x3TbufWfU=;
        b=rV1jrMGUwYeOrjKM8E6kompkg8FuPBvw7mHZXD0HIVuVlWi3Vy2MRU8DpXbkyovu4A
         DIkyEN3AeiCsP/kI1V2wmQZCRArD3NrrGprz5fqLhlZubh28wxswN0pH+CWH5Pf3vpDK
         M5yevDL733M+2p3Nw+Ty+K9A5TeiNnxBKygitl0W7OFDlyoBYen7eJwkFVRFR2pFLvHb
         cnJaAU4eVEZrYXi48MShlDq7TBllX77NiVMqs8rfWGGD1BlVzxWZZinnzgs/yUpCem27
         bQLsY6NmcDQRkvCScbLk9Qq3XkU+/yfNWCZzwkYtb8ONCd3cmEav7g8sTuTEwVgzehds
         BH7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3YOhXjfhIZJ1T20VU1xRyXuzy1Lchldmw8x3TbufWfU=;
        b=gjxAZ4xqDPGN+S1i+wRjGE4d/ugUaJ9uFOUWCifCtQLP585Bv9pB4FjowYSeStzQlQ
         mTYGggXNlBXuuStz4Ry9yw3B/fxpg16F1oj7tq1jzpgB+RAm/kTcHTsKVqodrRzubPaX
         r2vDtTUPchxm6GXp5+va1PzwDsjVwy4vhC9u1iBXxbIWcXcW1sNq8ztMrBJNE1JJEahz
         Yv8jV19Qn7ZbD+GsGDzZDq066qJO4w4fpnlTyFdW4m54PE0RJqZhCT9uT34AHkgVyN31
         yEW3hiBOzJFCf6GM01vYGgsF5mlLJLMxSVZ8XxVrAnzvj47F43fEOBXl3OKXpxxEnKen
         N/JQ==
X-Gm-Message-State: AOAM530f6o3d1DF8SFqSor/egZfxC84Vp39eR74AayVUFFY6O+sLlLBW
        7o69PXfCispZbmzvnnUnwwntZ+GMamo=
X-Google-Smtp-Source: ABdhPJzdtyZiQ5dyTYI9kanfN2lRRBSxgYHOG/UvZvNw2k1w5sy6Z+oP5/hlkYoqb357hvdbo9L6Sw==
X-Received: by 2002:a63:a749:: with SMTP id w9mr6845892pgo.234.1622172882194;
        Thu, 27 May 2021 20:34:42 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l126sm2991771pga.41.2021.05.27.20.34.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 20:34:41 -0700 (PDT)
Subject: Re: [PATCH 5.12 0/7] 5.12.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210527151139.241267495@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <425204b7-8848-60b9-531d-5361d3910782@gmail.com>
Date:   Thu, 27 May 2021 20:34:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210527151139.241267495@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/27/2021 8:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.8 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
