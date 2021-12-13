Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47718473627
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 21:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242995AbhLMUk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 15:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242303AbhLMUkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 15:40:25 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C03C061574;
        Mon, 13 Dec 2021 12:40:25 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id x131so15940582pfc.12;
        Mon, 13 Dec 2021 12:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3JBisSlC8A8dHMAJp3+1oo1A3553PhksPDuIiS7h0ZI=;
        b=E16o/cNRYQYx2zRYpqz9Jzo1DFZ/GU+E7nT9gldMgDfB9F1huOiM94PHzjpWXXc3cU
         2UUXeafbxxJz/Jd//Pesl2Eg7EVvFDkCkAFC64u8ObXAuGQ8+JStDOkIhWHrfTnaKYP8
         pt5yyGTzGJ6PMMkuNtPIIg2Fpe73Cw5zfbb9pYrZmWLYWUcLzi1+Mu2GW01a0YSZTzYB
         uq7EKrnNWNudOv/lIvAEfVd2l/lq4SWdIbOvchKUtoUObZ7oJRumi0Xy7BxBIeIDkZQa
         eM1dmO/t7m5VuIHFDfXG7Q4ivLDQDoLEdsMHcRMwwfUsPQkjug/OQRg0enfBVNQlZQsr
         Lj6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3JBisSlC8A8dHMAJp3+1oo1A3553PhksPDuIiS7h0ZI=;
        b=H7vBCLobipt6EzqnkxMDkoiRBhWupKhCju7acLoPbAWLpqau1TUJIUwbrD5m8XP3XY
         YLqf0eZk14T+FZ5lSn0/NKRI5A7WnvMGaSQ9Ylau8c4HuoUd1QxfMyc3PoGYd2Nv5pYd
         pbJi1jL49Q5Nh/2HBVb7P6zbCpb9i5XHQaVsOjGqTkojOVHevlj+LJaNCQbWKx8ImKr9
         /0OYa5Nik/YHeppb4xZ9Hb+mp1H/iDgeSNljiBWjtC4rpvlZmdIPjvg97eC6R83S7GDC
         OsylEqaz9CJRWgma4HrTpjLYrjJsEuvCIU9p2vu691jOs0aDgQ4ZmvarDF7bQv1PgGAl
         gLhQ==
X-Gm-Message-State: AOAM533yRWBGVywEZ//tPaa1Y2nV3mC1Q+gtbKZhvzpACWD9EEOLLsz5
        ZyEu2R1rt9wwex++ljp+wh3l7q4b3VM=
X-Google-Smtp-Source: ABdhPJyIin8oDE3HG9Jjmua1Q/HbDfCLSvXZmGPJMOcX1xXw6k6i3zZ2OKOhwdDpY4vThiaolf+tUg==
X-Received: by 2002:a05:6a00:1412:b0:4a7:ec46:29d1 with SMTP id l18-20020a056a00141200b004a7ec4629d1mr531245pfu.16.1639428024530;
        Mon, 13 Dec 2021 12:40:24 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k8sm13811924pfc.197.2021.12.13.12.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 12:40:23 -0800 (PST)
Subject: Re: [PATCH 5.10 000/132] 5.10.85-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211213092939.074326017@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9c04413d-79b9-4ff2-cb2e-2703fbb434e7@gmail.com>
Date:   Mon, 13 Dec 2021 12:40:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 1:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.85 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.85-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
