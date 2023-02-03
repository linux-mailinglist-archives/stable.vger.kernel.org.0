Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1880768A32A
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 20:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbjBCTno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 14:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjBCTnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 14:43:42 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFFC9DEED;
        Fri,  3 Feb 2023 11:43:41 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id v23so6335525plo.1;
        Fri, 03 Feb 2023 11:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=42CtTtaJ+bIWw65Z5N53SH3D5A7x3sruWivwIA8MBz4=;
        b=YBApVbZdYcIYgirrMardhbQqxnlujFcRrYiSbTrhwQ6tSdI/JpBHQLS5jxc60vg+ul
         N6xB0HTS7/al/+RQW0NHpJnrKKiesii+OPNHShNxn/JUE5SIxzMugJwbm4AtbZsVOoap
         gfnMnpiFSDzKh7THWY+kDWLk/Qd4ukYWItdFbwQZPmvdXbKHz65tpRmTiYedYiSqrv5e
         JJyngGKrQe3Wd5oHfcql7rVxDBf08nXfKGQF3H3nNnfTXevpUzWEkMVzuWutADol5CT8
         6R5SFOpHdgk5GZoF6mSbySBj694BMSKNbyk/EyO5gjQCjtRgXj5hN56zjmMZzcNrihta
         gbeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=42CtTtaJ+bIWw65Z5N53SH3D5A7x3sruWivwIA8MBz4=;
        b=sRVdYfkCn9VBZQ86/KIq7Ri2YYyslmGLwv3H/MBmDlZp0lwPLfOUKko9eFjxQmpvun
         xgkfybTH2zZKLpdTC65D38hcWgtPrfD2lAg0Y1S2ZF9dt1xmphvOrXHwij8u65vyhulr
         RWqvRPQFn8pXosApMy+1ze5pklBGWoV9EEMLEUFomWXF8MoJ0QT1arM1FBNEK4+V4Awo
         vYQHNHlBowFRT0W820VYPA54aePn/c79yCT9x0xVxNn7sqBQLp7u4OFuV/BrEpPQXUwZ
         IqH3Did2F3RNfxZ3Xcy3P10ooIfVgeSnKYMTcIW23kunp903fFOQuPPI7MdpmkF7lSeY
         5j2A==
X-Gm-Message-State: AO0yUKUIkRNg86N7ZFsHKO6KEvLBWCu5W9TQvKgjPYO3nkQU/0vwEH+G
        Y3HQzjD0uyrwEapMbftXdsE=
X-Google-Smtp-Source: AK7set9CeAhZOXwl0vO0C7M4hLMVyJt2o2PkRR8mPMMQV5vdtyaNxysn9P247BCKotJaAwBcNbgNPQ==
X-Received: by 2002:a05:6a21:1644:b0:bf:8aea:c555 with SMTP id no4-20020a056a21164400b000bf8aeac555mr7563018pzb.13.1675453420752;
        Fri, 03 Feb 2023 11:43:40 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o16-20020a170902d4d000b0019678eb963fsm1984607plg.145.2023.02.03.11.43.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 11:43:39 -0800 (PST)
Message-ID: <52da33af-f6cb-3179-b77c-636894eef52a@gmail.com>
Date:   Fri, 3 Feb 2023 11:43:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 0/9] 5.10.167-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230203101006.422534094@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230203101006.422534094@linuxfoundation.org>
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

On 2/3/23 02:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.167 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.167-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

