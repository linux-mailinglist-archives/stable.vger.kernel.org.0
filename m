Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF064393BCF
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 05:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbhE1DK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 23:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbhE1DK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 23:10:28 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A1FC061574;
        Thu, 27 May 2021 20:08:53 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d20so933359pls.13;
        Thu, 27 May 2021 20:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OgH48G6jS/shq0yobRMKYMCpLZwcGy0o1ktzLZXa1kw=;
        b=djJn2BUHCYqwEH/pHiNL5QhiH7vwsxkK8dtvxU/T0VEdi/s+9gGxa/tk8MGyKf+UmB
         i7Cy8YVLpRY7jG7aFS9I7NIFr0tLCYqx0e73mr/e2FQU0cJ5Ov4rgrG/XsLvlPFltqlM
         iJbL8UH5BPYU4ktgcG6xIdZRkg59uwyMo4VfxVrtnJGLbL5iyl0OZnKKxKAr10MW4IXJ
         fgCV1XiPstZD/iaOlRojh5GVXMr79LhW7ew+dDkBASWStJw3OjJw7d9WAwOuK7G7TIe1
         Zur0vdJHpUtWOoC+XGTU5SRUGXtFFcFDqaBz0gKewCdavFOjPk1bi3zSyzdeEDk6bqHf
         wdIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OgH48G6jS/shq0yobRMKYMCpLZwcGy0o1ktzLZXa1kw=;
        b=INx+oHYUSfl/mzVYqhau2f2YEcsVrft1M1b4MGZaW/vifBa7zbVLDifvhAN65MYwKz
         aug3nTnMLUB/eNILv9sqOXtuur9SGXHmQEm9RFZoaF67rFNvHdO/t3ZC7t20/M7kV42P
         Q6sOpME1zK1Y3WX2jeXJ3nmVpKPFwaBeQvB4eXAodGJ6gpXZocTqgik/vbdwBVt6gnYL
         agNGN9QM676t/PcvM7qJYiUA6UAexm3oiUBO6AHKQ8zLZH8IufV/nhsnjeSJfy3Y9qdi
         8HGMeh52rUCerRt5TmdUgRCwgB///lGzMku1KI3Sd4vNGfVIjUg1RRzg4JqoNwzQS7Kg
         3hrA==
X-Gm-Message-State: AOAM530nL4US10zotk1uNupDMqni6TDQg65mEkytf1/gQ95r1MDL14sY
        comQdAxB2jeDga546O3I8m3aXmDkwCrEpg==
X-Google-Smtp-Source: ABdhPJwFXMrUlE1Dw03TX27HiPVmTE81U4SDh5S8IiCI1b+K7ZZEGjUXGII5/EX+zLuB2UOaooM5+w==
X-Received: by 2002:a17:902:ce8d:b029:fc:86b1:51ea with SMTP id f13-20020a170902ce8db02900fc86b151eamr6005042plg.3.1622171332585;
        Thu, 27 May 2021 20:08:52 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id u12sm2958387pfm.2.2021.05.27.20.08.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 20:08:51 -0700 (PDT)
Subject: Re: [PATCH 5.10 0/9] 5.10.41-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210527151139.242182390@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1dda0b01-2ee9-9891-0dd5-a54019e65706@gmail.com>
Date:   Thu, 27 May 2021 20:08:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210527151139.242182390@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/27/2021 8:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.41 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.41-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
