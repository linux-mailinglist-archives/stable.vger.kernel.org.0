Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4952D3FE4D4
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 23:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244999AbhIAVXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 17:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244521AbhIAVXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 17:23:05 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2614C061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 14:22:06 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id b7so992258iob.4
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 14:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZRR+XXBLYLncXhDSqosmRp28PE/9Ppok9V3u1BHd+bc=;
        b=dDb81ogLGHnwCfr5JQ8v4vBKSjFNewjFKe4ecNRYcNEpKrfSe0T0/V8iKhzU0PqePA
         yxKpRdz1Ntfx5M7nD2CHBiBfMzmMtXRLAjxKWp5jmRRMGr89Nab+ssycAJbRTl9mFM9z
         vw5DX2InYH4Xh1nio/u186hcO4TJPwsQonBPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZRR+XXBLYLncXhDSqosmRp28PE/9Ppok9V3u1BHd+bc=;
        b=ORxwq9P/wxbjFhTmaZQVpO3z1ozgUdLzqo7Yf6Vlyn20czlp53dG/aBzbTdy22c7pM
         pVu7LP4XY+PLrHRHH8dYAp3vyrjQAFvpDpDwd8Z+gdFd9OB0K8QvLr+ipFgeqxOpiOg3
         WnYwHWPdcW8a0ITsqnRo2ELoX/SYQ98isoHWnwNdT9nxJfO5pSHUfjAD56I5fi/t9XNp
         o6r3zxZXHVxmVtpS0D+m6XsvfSN9Gts9uC6ji0kpJlMJpOKIxELKrc/eIIB6X98x80Mq
         Ns0fssyRfFfTyqyd1m+hHkSZp3YTbYNFO53xTn+WucJ3CrIKTtCOh30b18MmHOlncZUl
         U+kg==
X-Gm-Message-State: AOAM5323FRZYRfIYaxiNhAXW5DAJxnojKz91DhfpDa3JpISQ8kgP8n/x
        LokNutMWImxraNSby1Nq/ssj+w==
X-Google-Smtp-Source: ABdhPJzF2MdoVt+n11CcGA8G1vJPViH87fN/z4Lo3pd6MGLHI5ZLEvUqubTI0ipu6LyzLa27G2rnnw==
X-Received: by 2002:a02:9566:: with SMTP id y93mr1383692jah.55.1630531326254;
        Wed, 01 Sep 2021 14:22:06 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id n11sm438472ioo.44.2021.09.01.14.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 14:22:05 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/48] 5.4.144-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <60b68a12-6795-00c0-f846-b6b5b2ae32ac@linuxfoundation.org>
Date:   Wed, 1 Sep 2021 15:22:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/1/21 6:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.144 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.144-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
