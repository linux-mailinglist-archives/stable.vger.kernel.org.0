Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39C44B14A3
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 18:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245384AbiBJRye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 12:54:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245379AbiBJRyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 12:54:33 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBDF1A8;
        Thu, 10 Feb 2022 09:54:34 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso9309251pjt.4;
        Thu, 10 Feb 2022 09:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j6VklXNfL6k5eUjJlLYz2A3oBYRWOpdX7+tGhrBhGFU=;
        b=aH8DDobGL9QfTU+sukYmgW9PVhyOW/T75zs3RVNVdrYT/wdOo6WkNKEh7/eyXJ4alR
         yMdzB+sg9YqY0fyckhW1AeedfI5Kl1F8YodJAfdLccvtd1u6zdMx8q7ry/6ju4t+DHv+
         k7fqX4mU3L1dM9DVb4pEk4XfvW96rnFI8CNX+NiKlSGj7+7ERpHNdS7ckA1J7qqOSEID
         CDLyr8kj3sUhPx2WC6MDvqUUyotFaIYlKFd0cyZEQ3ZXPUbdiR5z4Rkjzc2m9AJS1kAn
         jg8G0WrmLiRQHT5t91/pYc2niq5nrAyF9WjA2FkhwtYZ19Y5W2YsFhqpA8VrosUPa5v5
         M92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j6VklXNfL6k5eUjJlLYz2A3oBYRWOpdX7+tGhrBhGFU=;
        b=z4YJh8jB5Uz86ocHU18FIjDlrRPm7KRw03bdnVQIbT2qKPB8veXsytW23c7uzu0pyZ
         bFIEaLFzqhRZQMBTWNwi6PaHn2GOP7acjGL3AGcQtq5jeU8tRv165fAPEam6bo8ti+mX
         DrTuua3p/WhI1NMorC3+xEaFvzqa+hRD9RCHJ7V4tWONz+Bo3jmxDosgwZvwsJ/5xZ2b
         oJGLM35TGmHCqAd0/nROhV00lb1QHPLDpn0+7DPT9Yttu5HPPfKv6IreI4G1fGngwixI
         stYUNvqChugxjHqagUIKLg8+Ye+kf5YW9KZPNgrrKpc9Ow3jV7C/TA4FxJRy3ngZOSVg
         yPLw==
X-Gm-Message-State: AOAM530lNNlAb0KB9ChYO6HJFWDYIIItxKl9tgCD3KAsd+6RVgmfiNrg
        gOa7SsE81kC1S/9yapLoPqI=
X-Google-Smtp-Source: ABdhPJyqA0PRFak1ycm5kPbDCqBDwIMXwRmH7xo1hcQnl8URdvZxgOXGg1a2XhU5d1mLAJn3gaImig==
X-Received: by 2002:a17:90b:a06:: with SMTP id gg6mr4010128pjb.153.1644515674061;
        Thu, 10 Feb 2022 09:54:34 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q2sm17465582pgt.47.2022.02.10.09.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 09:54:33 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 0/5] 5.15.23-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220209191249.980911721@linuxfoundation.org>
Message-ID: <93bb31dc-bd3f-21b6-eb35-4ee087b667e8@gmail.com>
Date:   Thu, 10 Feb 2022 09:54:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220209191249.980911721@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/9/2022 11:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.23 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.23-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

