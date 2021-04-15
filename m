Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A2E361596
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 00:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbhDOWmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 18:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbhDOWmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 18:42:35 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F2FC061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 15:42:11 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id v3so4375770ion.12
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 15:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UoXeWMwmfagwc1jyb5n8hWuTFgqgRhUoTnRewFdDYRc=;
        b=H963yag+LBgewX9qNulzOkmpnZxfdEhe8mAkFOZCAFUrZ3LLt2IHoDJ+sGvQKPH8/H
         g6PT4uNWgHqQEtih2p9eZOb+ncuhGTHw8PnP3prxC1mp8LZPk+d+4gtlox7EDSAisEoD
         vFysf/mfObRQVtgFvZnHhwywIPmcH4mHRiM+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UoXeWMwmfagwc1jyb5n8hWuTFgqgRhUoTnRewFdDYRc=;
        b=S3RHjEeL0npmBVRAV9VUOBf+B3E4R1nYT/bo3dPeVILxpwaV2JYArUlgyeiEdi35PK
         sVaa/mRys4GDq2zJ/7XyVJYvbjEacbmsEhp0j+03f0izc8Eml2RdjL2FEVoYf01dSA42
         b8mkKOHvwN3J/H2HNfKEuKiobmM32yrLtg5cR0k75a43g0UtilPcWwSdleq3fuHEbfLw
         WT29ISjQPrDMKSJ1GVXNS8nRA6b/8+80prUnJDhkPNcg4GQOCzW2UdG0/BomIksPUWHp
         F9xWHuBdbvlPWSbP4JngtY3d7UC6u+EQ5isN9j+lnFZyQanQyWjsuHxN4giCu8iALQrp
         enPA==
X-Gm-Message-State: AOAM533E9gbLFS2VBg2rNQzL656yya2Ue6pEPDIdi0U4VI8gwD62o1CH
        V517oPnD33vyXKvijamk4eTE/w==
X-Google-Smtp-Source: ABdhPJyYNoiNSmwCr1KavTmejSIUmTYcYTBrnbV8DcTpCpuIhPZ6yy1TxStWRPHlXmGrEzBnrl6qhQ==
X-Received: by 2002:a02:8607:: with SMTP id e7mr1349016jai.27.1618526531163;
        Thu, 15 Apr 2021 15:42:11 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id v8sm1889280ilq.0.2021.04.15.15.42.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 15:42:10 -0700 (PDT)
Subject: Re: [PATCH 5.11 00/23] 5.11.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210415144413.146131392@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <04f561e8-c1ba-a7a3-f465-ee5ecbdabacc@linuxfoundation.org>
Date:   Thu, 15 Apr 2021 16:42:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210415144413.146131392@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/15/21 8:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.15 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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

