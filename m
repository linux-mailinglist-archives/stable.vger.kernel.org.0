Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA45825E26F
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 22:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgIDUKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 16:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgIDUKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 16:10:09 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A81BC061244
        for <stable@vger.kernel.org>; Fri,  4 Sep 2020 13:10:09 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id l4so7462899ilq.2
        for <stable@vger.kernel.org>; Fri, 04 Sep 2020 13:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0Jg9VU73gZ+7YHgdtpsBvolMRud2ea97/XzW1kHoQ78=;
        b=drgRPsaTFf2IoqCMs2qQUUD6T2aRkWsilesRkIJmWBhZCw+Z7A+0mD+fbyls5lYR8e
         V3I5boO2IbRk6BAsIapKarliFDFzI41FdDLgQWvnS3oNw9wuQDPBNPaRJyIk/LPNahTe
         ovLxfoINDEpXd12w5eforYLmFXjYmP5u1BaxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Jg9VU73gZ+7YHgdtpsBvolMRud2ea97/XzW1kHoQ78=;
        b=TLYk1ISA+UiG6Wk8j0CyegRXg+AVLpG+xznxRIupAafKNmy7afy2Gcq0Xj8Z0uEeDz
         XHC7EsTQh3G6CDm6BT8RZr7pZqDm9KOw4iQusxIql2fVLmxytH5OWLvzano+sHgBDXRI
         qe/avOH6WsRMIH0CAXgHNNQ6FhgwAtTqEBqBAakcW3UgON0NSXj2zAlCQ4y2l0SThte7
         zZus99V6KJv84fZPRV0mFkhuHC0wLWIZDttfxG37fvQmYBjkevb8KRddEU52+JYQK2Dw
         /DgmqOF76JZWrismLuk9aD60urpl+hBus6Lqy+4ovXc5rzpAhRWWYr6g6yL/dBuEnqXY
         9b+Q==
X-Gm-Message-State: AOAM531hTWBZagdl1/BTogbD9WbHmQ0NSw1xOgRdvksil+hNg1u5VuBb
        jGk5pFLz+UY1ppduhGk5HCuGRA==
X-Google-Smtp-Source: ABdhPJwRZrm7hpuD3sortxqwL+6h/N369d/kvC0s0f1ETskEGIAlcADB7xD3nvi1nzK3Unx8NNos3A==
X-Received: by 2002:a05:6e02:146:: with SMTP id j6mr9828929ilr.132.1599250208332;
        Fri, 04 Sep 2020 13:10:08 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h15sm3465334ils.74.2020.09.04.13.10.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 13:10:07 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/16] 5.4.63-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200904120257.203708503@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c9508e8f-1fb3-3bc1-8006-dffad4923026@linuxfoundation.org>
Date:   Fri, 4 Sep 2020 14:10:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200904120257.203708503@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/4/20 7:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.63 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Sep 2020 12:02:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.63-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

