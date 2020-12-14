Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A43F2DA34E
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 23:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438762AbgLNWVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 17:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388490AbgLNWVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 17:21:20 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAA8C0613D6
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 14:20:40 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id i18so18517846ioa.1
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 14:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QRlSeeT9Km7abG56Ccl3cXJFJk9i8/zfSmnWV1GsI4o=;
        b=LkvPM2V3qkclDXWi447dJmcqtjfISVZd+Dct/HUg9FOmd5KXSfBVShx3pYhXLqfyke
         F+vOUajwl25Cq5jBUW9ZaDBbWLDUn6dOW0Reb0rL382aG6at1Z1yTzgd2H1mSGoYYbd6
         2JrvgTGCdXmpKdICg/nSXIe7H6rmBopyM4vIw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QRlSeeT9Km7abG56Ccl3cXJFJk9i8/zfSmnWV1GsI4o=;
        b=faQRY1MWwUUsCeUTZRjQwhoVeKHqDLEjEWvt/iEDISK9rS/B6sYt9aUZQsga3SExUf
         ToGpQA5TY+uOcveSCb1Qul9yXi0kHfAAA2mqSnxYE2AiMUDs+hR8nXr4d/dpLeAkeJ9H
         hIWMYOSmgO1wr6ofUr7gVANw4KFEump1ZcarOsTy//zK1uwTGzyQPFQ+NXQx2DglnHYo
         IMUvLBzC/MA/V2f4k5vxbir/pZOFI2JnrIwaCAw3IGaAPlzFwXoOwKoQehE8hBa/UbjB
         LqYmChEstwAghcyupD/XNNWYpNcGl6MZZGt4pGcpaF5msQL8Y9Lqh7F1xbDk02v77b1B
         xJBQ==
X-Gm-Message-State: AOAM533ZR22LRZ6JDd7/wrIdrfwa9grNnfNF5LuYq82KmCzINGHS70hg
        hHMSOH51GY+Izj3UIj6MtNrbNh5/3ZYF2g==
X-Google-Smtp-Source: ABdhPJzdy7PSlZ9vv/WN2maOBUGmltupBCk1Uv3uW0CSwFhTVrjwCt3yV8rTMfAcr6Ql+3YbHU3gTw==
X-Received: by 2002:a05:6602:14ca:: with SMTP id b10mr34853162iow.40.1607984439842;
        Mon, 14 Dec 2020 14:20:39 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k23sm12502242ilg.57.2020.12.14.14.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 14:20:38 -0800 (PST)
Subject: Re: [PATCH 5.10 0/2] 5.10.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20201214170452.563016590@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <89f51647-625f-5319-24ed-60e538a32f13@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 15:20:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201214170452.563016590@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/14/20 10:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.1 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Monday, 14 Dec 2020 18:04:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
