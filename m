Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2505672B07
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 23:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjARWE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 17:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjARWEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 17:04:15 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED7564DB4;
        Wed, 18 Jan 2023 14:04:14 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id bj3so521747pjb.0;
        Wed, 18 Jan 2023 14:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u7Vhz02/OiTcxeOxGsxJsAIoe9iATxGL5yF7599ooUk=;
        b=hoPJ94JXYXk76hU9MfRNs+7boN9aFW0tBh8fdqc+Nob3S5GOrjhWYLQp/zotUG9ELE
         yKUiJqEW755ZN3Szrk2sdNEChjX+8DfcGyXM5knao7i+ZYRKGkf57peosXa4OGRmt4Ug
         0+KKyiUB2Jlfoqlgp2s9mG2UI0gawSPeMo0QKzaUUyllnpIUwVkDZxut0VbRNB0pRMzr
         tm71uMghTOsc/S0hr5PWNRJfr41HsoryZkq/FGRY5bpC+LvNw6bzzBgwErnMeWH7evie
         6X8xIKLFo4rwbz8BJQtdVV6lsBCeiq9XDXezSAeq9r4YL4aRVll3EJcTBXJ5XDuysuja
         8T2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u7Vhz02/OiTcxeOxGsxJsAIoe9iATxGL5yF7599ooUk=;
        b=O/7Z+RBnZtiR4Z6SSq0mkuYzcGwFz4lIoHzA6386zvrQUTDnYuEiuHUol5WIy7QbmR
         rxX1qoPm4J8vx9U62//oq/4Biu2LxTpQmS/lbrwWa+Ah7Uz34ARBTWshpSxDVNWbE6r2
         5BmeDM7LtJQ6ccbkyXCEyRXalh/uh4EALFyqJvpGm8kkcuR7JcIe/RPjXrXGyIsTVN2M
         n3lEnUuh8kRQQ1OAsFLWC/Ak9qbb2xy8Hzc4ULHb2GQ4cZC7/OyCByHiCwbVQNcz9j/D
         WZUAfLJKQ0AeCaEKeuw5BLYk0yQ+GQ6M0KIFRwWzn9a3mLcnRza1oE0sDJNJ7kcSRINt
         qzAw==
X-Gm-Message-State: AFqh2kqALQIXLMMGWH/GmsVDN4rVKf2EWpwtujZXuzI7YJyKXDq1QIjz
        tyGhJ6Q5ONAWAQnv9GtquD0=
X-Google-Smtp-Source: AMrXdXuRu+al6gKD7Fwz8pu7Gtw+rxuIQEa/EUi6RFO98P1EdnAh+8aOlY66AsrugF1PBF7dm+S3zw==
X-Received: by 2002:a17:902:6ac3:b0:194:c25a:d824 with SMTP id i3-20020a1709026ac300b00194c25ad824mr1864045plt.26.1674079453629;
        Wed, 18 Jan 2023 14:04:13 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z6-20020a1709027e8600b0019445b8ef29sm15990755pla.61.2023.01.18.14.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 14:04:12 -0800 (PST)
Message-ID: <3def289a-74a6-0b90-c9e0-bcc6a0dd16d3@gmail.com>
Date:   Wed, 18 Jan 2023 14:04:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230117124546.116438951@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/17/2023 4:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

