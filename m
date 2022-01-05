Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291A9484C6B
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 03:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236855AbiAECTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 21:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237027AbiAECTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 21:19:51 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DF1C061784
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 18:19:51 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id x6so46356420iol.13
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 18:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wlNPtxZcsOPibw1mUl0kqsfX9asoOi5IsIWUpPfIolY=;
        b=Ijblyuw3DYHdSETFoeBLlDcm9stNT9rRXpgTX7H614tbqkDs3xQPLxznQzPFLbFqeo
         anGKy/NWsDn9dp/Wgec0SuFIVlf1X2UaoBUIHXlmN3mTtW9TIWzAF9whI/zsNR8qnJHD
         1EaB71aDSuwzHsHddEH6DUtxo3I3g5DD/yzBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wlNPtxZcsOPibw1mUl0kqsfX9asoOi5IsIWUpPfIolY=;
        b=sLwtZAfgq96tmwzBflg+nQTUZioOgkFRXL5s4uOlzqwZhwutOBBZla50CM289vMHMX
         ZcJBuhkzUiX/PtkRNFjEi98XcEpxFs5i8QHe9XJC2z6c4QIQyEx0w42k0/Hrr/kPoDsa
         lWVgICFvBfMWvGcL842mRY8FWM41Ig6OQPlzyf77m6ValxF4b6pGGKX4C3ETegGPZ35A
         cQuDS0rhAvIQLoce9NTEawrQCgSRp5ZMp1t3yMe7+TtkOx3s4pKuxuT7PcE01vWdWJUa
         70VQryqbVXvzAcsQpQFXB1PXxjLzHMlLeu+6ns4vvVcCBSAIdcQGClK6TsJKPBCQR6Rf
         Z1uw==
X-Gm-Message-State: AOAM5309UOvyRzna2EThZ/wmdln36ZW2FfXscnwy2sGcYnZHeSbG+4g6
        JPFWADgRSCR9hgbq34gbV7vKXA==
X-Google-Smtp-Source: ABdhPJwS+m+Rv6aXcKb+kZomcphdY4IKuUfnpvYm89Ov61NBA+pTkz6uVt9N8XgoLukJPXjreVIT7g==
X-Received: by 2002:a5e:d502:: with SMTP id e2mr24324141iom.118.1641349191017;
        Tue, 04 Jan 2022 18:19:51 -0800 (PST)
Received: from [192.168.1.128] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l13sm23576739ilv.75.2022.01.04.18.19.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 18:19:50 -0800 (PST)
Subject: Re: [PATCH 4.9 00/13] 4.9.296-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220103142051.979780231@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <88a3bd33-d604-3a0e-d41d-e7e795463eee@linuxfoundation.org>
Date:   Tue, 4 Jan 2022 19:19:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220103142051.979780231@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/3/22 7:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.296 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.296-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

