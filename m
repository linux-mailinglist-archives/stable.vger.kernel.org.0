Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6145E4802E6
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 18:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhL0Rnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 12:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbhL0Rno (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 12:43:44 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A19C06173E;
        Mon, 27 Dec 2021 09:43:44 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id m200so8965108vka.6;
        Mon, 27 Dec 2021 09:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=juyT5tMkip7mqK2f2Rwnkc5Znl99y6liEhli6WAJpAQ=;
        b=UX/guQddZ6xQKhFZ0TTkuNIuKWcfXqq+27ytOPLe57HPR2tGiJofa785sk47Wyh1+5
         CayDWk+LFHTcUH57OU8CyaLTuC2jbe9OjJDVkKdYdjwYjo+PfjYv/PdL2aE6pji4N/vB
         xKp0MnunLhLn9ZrNd9o82RQmxwSu26STnAD9f4G28oMWbRec46xEVAAF2wj4PMb0w4kg
         PdkH6ljNxH4dTEXAhx/iU1pt0l/Ks6sTsQhtY05tW4PHIElJYop25/PNMl7fyweKRStj
         Ey6TpZqAzKj8DRxtPUJ74kKN0QIpVaDhM1P5StzPO71oAos0Aua1L/Ke8bv8qyTZyUuf
         Xm6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=juyT5tMkip7mqK2f2Rwnkc5Znl99y6liEhli6WAJpAQ=;
        b=vlAaI1Hvl9a+/6ctfAYvADZhdDUHWhivH8O/gFKxakLqUYl2K9m4hAC/n66hN1GxsL
         QlvzsNrDTr+YQl/Sf2ppQvMkx/mHQoizpOpWjB7m24iqyLnPnc1Zl9LQFVq31ZgNSkq6
         AD+loHf/BY9pi/bZBRceydAZuM/yUNpZwYj26RsYtBxR7BnORz6NNTWtWMUFs7fglkOp
         vOKnvji6pvreDgNN0SQtuADHTxlUkOzyz+ejLgdfzhHnFJQWJ9iuguuBTCZPl/SmZ9je
         ztXgJ41dzaAOBM1KR2EbVkYz3seI/RlfcpHhgNp9xHQV+rSnJkza6A7jQS3WtosZYTuJ
         Ge3Q==
X-Gm-Message-State: AOAM533WMk0q9KqhDv6k//u6tTMJwh4YrQl+0fdN1Qs7IolmEgapMyMf
        jj70XhwDt2GE5M03XEAHDxh4UGlfFCs=
X-Google-Smtp-Source: ABdhPJxSGCOWjCCSeYeAflJLYflhr7UxUfi16OUQg8qqcLAPG5xbJZOhO5fIP9+NRQU2PQ1/FTRJwA==
X-Received: by 2002:a05:6122:88b:: with SMTP id 11mr5301385vkf.10.1640627023368;
        Mon, 27 Dec 2021 09:43:43 -0800 (PST)
Received: from [10.230.29.137] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n17sm3120925vsg.29.2021.12.27.09.43.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Dec 2021 09:43:42 -0800 (PST)
Message-ID: <9cbb0f89-0ec7-abbb-8dd2-7d5c7992b605@gmail.com>
Date:   Mon, 27 Dec 2021 09:43:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 00/47] 5.4.169-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211227151320.801714429@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/27/2021 7:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.169 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.169-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

