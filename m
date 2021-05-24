Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637B538F576
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 00:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhEXWNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 18:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbhEXWNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 18:13:46 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17698C061574;
        Mon, 24 May 2021 15:12:18 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x18so17688055pfi.9;
        Mon, 24 May 2021 15:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=feIiDSu2+lxsYRjCRFr1nJ9JzDDaOXfINk3gAYzE5QM=;
        b=Ihz+HHYD1ddQAHSHQKatHPg5/qx3D2B5MjckPmMHyP+vo6HmcwoSyR9DGiQ3tau6dN
         +UaLmXtfhU6SdKO207VAjWSleng/IRnztfu030ohWJVxjFHQqqpHCPg16F5R/pqJU9cM
         i3+MK+B2dDNTbGpS8C1kmgTJlze4LglDYruQ5i6tS+quGgIoniUWH/rboW8+LinoDp4G
         WJlg0lrPnZavrpmoYD0xMnbIgea18rTIaUvCRAis332wdeY5LVkux9U3oy8rCYzlU8rz
         ilY4JC9of0f0KMgBwFzlu/hrkU9lFRX3gAGrMV8MKSogfsR3u6gZ/WyX1vk2O8R4U7AS
         8fSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=feIiDSu2+lxsYRjCRFr1nJ9JzDDaOXfINk3gAYzE5QM=;
        b=L5DfdVHL59+Gurtx4LIsgPDEAS21XIQ8t/mN76lPDSXK3PC0xvAaaaHMqvQB7NMFfV
         N18UGVIyldsjQ1Go6euuW3v3L4jYjS9CIo+WWEPLu+UVHdgpoYskDeaXjgKfATYKxVJd
         PeH34uZQ2QvtHNNwFjEcUQ7fo3qsGx84DkEjk/ZVzV7G85hHXtanDXSMJcspAFemmiVL
         dImZKiyHYI7ajlHJwEAkxrPzcF1Aq6cjKkBmILRtswbSAzZiQSQKpTFsex0YADrxbHr7
         sQPLf/hJxn+lsaxTa/PZb8UwcW8Da159GkmkO2OlKvbKgrk04wBf8vBzmhgXIWJoGgXU
         M5zA==
X-Gm-Message-State: AOAM533NXWBFjbDVYzx7Z0sW94lNXvR01pmeHyuLagGBrAFhQbGIF9Pi
        aJb9YeHKJygWITHqd1ks+BcQ77TTQvg=
X-Google-Smtp-Source: ABdhPJwdz04ykCaYqtxwdXZDy8bu7bDvt1qYIx17h5Jw/tBvoM11lham15zBbakSl5I9tkOkJhRZAg==
X-Received: by 2002:aa7:84d9:0:b029:2dc:9bd3:91f3 with SMTP id x25-20020aa784d90000b02902dc9bd391f3mr27469627pfn.0.1621894337236;
        Mon, 24 May 2021 15:12:17 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f13sm11840039pfa.207.2021.05.24.15.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 15:12:16 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/127] 5.12.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210524152334.857620285@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f57d15d4-b6cd-33d4-173d-98d7ef21582e@gmail.com>
Date:   Mon, 24 May 2021 15:12:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/24/21 8:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.7 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.7-rc1.gz
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
