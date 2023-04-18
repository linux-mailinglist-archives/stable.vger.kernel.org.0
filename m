Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62CE6E6F63
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 00:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjDRWcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 18:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjDRWcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 18:32:20 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CA240C9;
        Tue, 18 Apr 2023 15:32:19 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a686260adcso27696535ad.0;
        Tue, 18 Apr 2023 15:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681857138; x=1684449138;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QWumH5jSTQJEu5E26uuxjLhMaYa16981H9nAq/7awlg=;
        b=EmGEubnwDXGIytjygKwVWzMvy/p++gLjdLWieYdg8ogn5SJ5QMdF5jCLnRPZTKONz0
         /v4tKeOVWassklOfHy/f2KO4erJBXbYm5DTAaF1REno/h/hPG6T0S9OzTkvgn5OXEy/T
         jGgV8Dg1K0wOXrcYXEgcCMF+t8O/UOu4o0246Pzgrcd4vCs0yTlN2GF9XhVaeSi0Qnct
         gf+Su29hSlfFiw45pGx9MDur2WQei6Ri62y3j5a/+6ejNRc1LrZiZ8KM7symbmffx67S
         C/8SSj67aTReBUDamL1mfVvkb1OJE8mC2mqOfplinPhaG774lmlvHuol9eo15nsny+Vs
         Fi6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681857138; x=1684449138;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QWumH5jSTQJEu5E26uuxjLhMaYa16981H9nAq/7awlg=;
        b=DN7rSkUwVf/suzIPg8+V4IV9k1G05Ins9yuvmlVs/8a43e18BOXlN7KJzcuHLqOel5
         VbSDonlrMT8TjMpbccDpk+qdLxKePxPJb7E8bOzYwRiCmDu9Vei5ZXPLVIKI+H4jbUA+
         w/BfwoJSpONfP/nmT+xqh6eqOjDo5tDdny7aT/x3cEKXuc4rKvJV7qE24quuYXC8pOjf
         NkKJqegRttsmN8rBIx52kPAUHk4FSoi/y02A5+N5nO3W9ylofdpwB0FEpmu2CXI1ZBZj
         paRefvrp3Zcg8KpNDB5ArNOi4K0PbeldCogusvVov4nWjbR3lOZQnOnQBAuuUtyWmPxU
         zCSA==
X-Gm-Message-State: AAQBX9fbt64di+OBKxe7awcovrZXZDxgMMcxCX1CzucFcm2oAUI/UofG
        AdpomHs++qpUixd405x33wCv429LE79K9A==
X-Google-Smtp-Source: AKy350ZEOEZfDbKRfmeepXRguKPu6pEtFsm9Xi5BcpK+zWcQnb805CHK23Vv/2C0tKw5m+pzO8sQmQ==
X-Received: by 2002:a17:902:c40a:b0:1a2:56f4:d369 with SMTP id k10-20020a170902c40a00b001a256f4d369mr4070373plk.19.1681857138646;
        Tue, 18 Apr 2023 15:32:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x19-20020a170902821300b001a6d781eda6sm4135319pln.120.2023.04.18.15.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 15:32:17 -0700 (PDT)
Message-ID: <19f316a5-1f8f-c929-2997-c72f84637906@gmail.com>
Date:   Tue, 18 Apr 2023 15:32:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 000/134] 6.1.25-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230418120313.001025904@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/18/2023 5:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.25-rc1.gz
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

