Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A85C4FEAA2
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 01:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiDLXfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 19:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbiDLXdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 19:33:03 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417EEC6ECE
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 15:21:46 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e1so14533090ile.2
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 15:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZRBtQePDBALOI3aSwVMe04POvI2ku+o19e5nkskODvs=;
        b=Jsp0Ea1H/tE20jjj7llhVIUkbSSUR0BBBeRsAFijDgtANB6tZvR5PmuJ5aiLavgG3F
         6t2Wqe2qXL/1qX+GeRVA0kuXW6fE0IuEHVOj98N7lUA97VA/qmbdSzgY22KI0tphzXAl
         CjffKcWyFE71iyx3Uy1D5l0k6cGwxxL+982gY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZRBtQePDBALOI3aSwVMe04POvI2ku+o19e5nkskODvs=;
        b=aAJ2SPYRDR6JybbPmhjTUsXkFeUmUXhWCjhwnozyr1n0eqdNZswwkPFdWVJtzZOqzq
         rFp4gKbxp3VGtb8hlkJV76c1g7ZSOBS332wtxu+hIdubZkQ6PrdNO+f55CVnba9KzGan
         NhdJnpSRv/aQOkYsPXiPvc7+5OhlfWyALIC2mIve6v8nJELc4M13NWkxgxx71ohyB+1s
         W5VgYpYlXfOXVYgdTmxXPUPmy2G0v0d8fzlFIQBf3TtkBaRGFc6u320nDaDgasx9QCzB
         pYaQ7w7L0Z/B7yBeXtIwAWp//cZNXZWM9FWxBVp++UOWN6VcAs7qJxyiubmLEZZdjdsm
         e+IA==
X-Gm-Message-State: AOAM532yvIbLryXqB3qpnpNjclfc0uMWRunECjQ5Z/JILNIWKQDx4QF4
        PiELUH43JZmYrEuA9xZZkzpprA==
X-Google-Smtp-Source: ABdhPJxlFhFLstyxpytdgKpIepjihEBeRCmxutRGwywd/OZN1dmyv3Jhu8QTSCAD96prda8v2+Gl9Q==
X-Received: by 2002:a05:6e02:170c:b0:2ca:7da4:e69a with SMTP id u12-20020a056e02170c00b002ca7da4e69amr11351287ill.228.1649802105616;
        Tue, 12 Apr 2022 15:21:45 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id g14-20020a056602150e00b0064d30c94155sm8641432iow.37.2022.04.12.15.21.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 15:21:45 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/170] 5.10.111-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220412173819.234884577@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f10e754b-21f1-f50e-12ba-a951c80e73dd@linuxfoundation.org>
Date:   Tue, 12 Apr 2022 16:21:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220412173819.234884577@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/22 11:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.111 release.
> There are 170 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 17:37:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.111-rc2.gz
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
