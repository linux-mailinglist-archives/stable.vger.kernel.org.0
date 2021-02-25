Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486D83258C0
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 22:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbhBYVhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 16:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbhBYVhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 16:37:02 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B80C061788;
        Thu, 25 Feb 2021 13:36:15 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id h4so4671686pgf.13;
        Thu, 25 Feb 2021 13:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gvaWQnEWct6fpKfCa7T/5XaaZi/ox2GWt7/ncZyXPl8=;
        b=DROKf6iFbQFfQgGuU8TzV+XRA6//TJOBFm7TqVuZx8dKyI5aH9siAnL332CM5YrqNi
         n4q7gI+3sI/aJY4XEMmno1BzrlGnzMVzw8Ilfk3992m2ExjVFMwrLv1eHpOugkNXYCk3
         WT/GSSfNH6hwTxilRme8T7CiLJMnmQ7lxURrSWoutkJ095j027yB44KtZT7SjBqAIVms
         QcmwJ2ulCvT0fSryMFVX4liS1062uBkp2J6jZk3D0bTBt1MH+cDCtFhYYhFFH5KGUc62
         SbuJHE7ums96mnboUq/etQbAdJD2v+d5HVJ8FFNvPn7D0pOQENNPkKdrEnGSGNtVY/qz
         hiBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gvaWQnEWct6fpKfCa7T/5XaaZi/ox2GWt7/ncZyXPl8=;
        b=B9Fw0/7Qxv6QfLGCB1hgv6s/0U+l0099ytVyXJKBczPqG8FldBg4M2sFk6/6d+pVY8
         NTHLXwTeAWMoKsEv93ZEX/wxOOr4CJj3w/gMuxXCyNiO4iE7dtf63bZtc9Co5kEcwoUv
         4tCaECU1yYoQHhdV8+/JxBCszCygqugUCpQ1I1O2XrsbIAbIFKLiYG/pLV+jm8Ojx+qE
         5PBmmpSAGZez/7eUYL0ZW3vucIenWrnTfdbWZV+MgBMl2mRxr47Y1Vqm2xTSImXvtAp2
         sbYpuXm7oOXt2hSLfkAe7cbgz+w7T6WnwayBIiDiibZI13zZoo4cVBXiAdgcZouGpSVC
         tLeg==
X-Gm-Message-State: AOAM531NIzObn2rs0UQjGLDIBsEJdMIg05JgmLYI7LdXuivahjY54L5+
        OQ0fUzgy36nXfMgwXVajfNwzzEuRkKI=
X-Google-Smtp-Source: ABdhPJzfxoR7+zNSllT4pPOU52nuC/dqqsC2ZBVVUkRko442QW03g2DQ10F3jLsn0VuQWmhYMp6hUg==
X-Received: by 2002:a65:690a:: with SMTP id s10mr4720085pgq.162.1614288974338;
        Thu, 25 Feb 2021 13:36:14 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e21sm6496880pgv.74.2021.02.25.13.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 13:36:13 -0800 (PST)
Subject: Re: [PATCH 5.10 00/23] 5.10.19-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210225092516.531932232@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <98c41989-3c79-d77f-3d3d-85db91750178@gmail.com>
Date:   Thu, 25 Feb 2021 13:35:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/25/2021 1:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.19 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Feb 2021 09:25:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
