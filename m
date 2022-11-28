Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3342D63B4AE
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 23:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiK1WM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 17:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbiK1WMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 17:12:53 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1A111A2B;
        Mon, 28 Nov 2022 14:12:52 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 82so3748236pgc.0;
        Mon, 28 Nov 2022 14:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7VnIiqkaLT/AOA+Uh3vYc89XGyhScngUhSEYmii9N7E=;
        b=hf/Rd5cgspTnUYicP8bfp0SxkTZo9YWJxzNwarpU4xJULh5zWcfQXnuff3SuYQYzO2
         1hUYiP8DJRkQP23pUYDWiUHSaT5pUDVGXcxNg/2asHYrasdRz1d5QLYVO2LBAdx1Dkqe
         21Pf7WCRasOTddkVfVSFxdmDTpvc4zJMmNXI8SXYDGscpx0iwe0VCv1xLFwx9cPvqmoa
         EavQ+dTGheMEqFf+eMklvPIy4rYjnvaoWdMRthxzrcPt9K+Vi6YANBMPD9vZy3k+bNlJ
         sI/3o9p9RLgbGwGf0WvrhN3gY6iqLS01sIDVaV8bxJAMuqxx+w74yVtF/pC5Ymj7509+
         ZeoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7VnIiqkaLT/AOA+Uh3vYc89XGyhScngUhSEYmii9N7E=;
        b=RZRWgwLaVqU3UHbEFxeVYWAUZPvUHvM01367cvBqlWd83ygO0zRWpBsGsVssPE8jnH
         9VKyJE/JZLTo3DfXuSPg6EVFtoplOmUNcC28YE0IS8omUyQTHrA84OWkqmA4qqkeDtHH
         S5+Wwi64et3wQ3dFZJeDKzbS+HqbrnSTGd3NOZTVVOng/8bEwPEfGNDuhGlvJs21AF0r
         wdDbrWO8cKZGWI4i8wsumMgq6pa+eu00KuvP/czoNEAlIPbyxUQrZr2JGB41Mnsh8uvW
         brV9M+rFUB7rfbnbAkVhWrr9GaneEzx+QKK3G29jltHgd5J0MJuC3XWHplvqky1X1lSm
         eRxg==
X-Gm-Message-State: ANoB5pkBZ/nULrRqZLSAsJXvbGHE0M58W7pcATgHSUA0lESMOoFJvWcT
        qCwUa+e0UJDB+1W8FyMjQX0=
X-Google-Smtp-Source: AA0mqf7gi2938a6aMIhx7F3eopAf9BP6LPatYMG6aV5lHkMTn+qjJcYL7NMxg0OZsK+ou+Q0IcsCzQ==
X-Received: by 2002:a62:84c5:0:b0:574:32ac:a47a with SMTP id k188-20020a6284c5000000b0057432aca47amr30644859pfd.7.1669673571506;
        Mon, 28 Nov 2022 14:12:51 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pc16-20020a17090b3b9000b00212cf2fe8c3sm40644pjb.1.2022.11.28.14.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 14:12:51 -0800 (PST)
Message-ID: <e6d08779-6e40-ef74-fdde-25335bcb9cc0@gmail.com>
Date:   Mon, 28 Nov 2022 14:12:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 000/156] 5.4.225-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221123084557.816085212@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/23/22 00:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.225 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.225-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

