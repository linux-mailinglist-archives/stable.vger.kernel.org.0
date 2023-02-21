Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723B769E84C
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 20:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjBUTbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 14:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjBUTbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 14:31:08 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2C730B2F;
        Tue, 21 Feb 2023 11:30:33 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id z10so3102209ple.6;
        Tue, 21 Feb 2023 11:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P/MifN3kOHh8dGdr85tdLTw6o2pirAXtYEvHxB2DK0I=;
        b=Ds0XYlYblvHTuq1YbaF9QXpK+EuWFR51VHNmRz2S064Hq2utjqyBCCsfsio3Zqebx9
         CFpDBDEEabGMdejdTMrZcmBPIvoHFccUslFo6ju9lKKCdDa5/PkpgMiUYj7Z6tXdtgNd
         R5RhpboVo8HE9Mv+mZjBxCUsNjRzvUKNFmpA9FxwpVjWkfB85Qab4187RvLWd7fttS1c
         WMevq9q3zaqSxhxqo1GQNh0L3LewrzCjOXi4J1+UrMZqAPWezr9Mr+fItm6cX1Fw+oJh
         VM7eu7D4xoM2at+8tAc4MvrQA3dhbxIKCueoZDEBgQkDygpITVHdGjv2hZNcQQxRvLhp
         bK2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P/MifN3kOHh8dGdr85tdLTw6o2pirAXtYEvHxB2DK0I=;
        b=zQ2uACkrSHH7ZWB2E2dRJH2NILOg6xCOFHiSYB7fU/o4iQPy3AC2KRqLRRYVbX71H0
         CRV+cGmd0zttCToj2cQcRwQ6ijlPJZryqovuhq9YV9QUNfcwi4I8Qe2g0IAzjPggiocK
         +yBg5TjedI3uMDVmYiDFry43pjErHTewJBpQgBpMsy1zbX0sZfhZ7xOMA9Jc1c4oQmUp
         Vn68w+P2Qr5RHPEW6xcYFl4UfJPxwup9SPUfd481wyZO+58FsQySSL/Q7SEf2YARGgNG
         xmJEoRpzkRdUOT0AzVX0jDSmNCaPvNbY+w6I8kGotE25dAil20Yfqtyjc5EXbBe31Tow
         QulQ==
X-Gm-Message-State: AO0yUKUt/S5y6NcOrnVjxSHa31vjAKOxRu/t3m7aYUx6NZXbH3A/fn1c
        cfnP+q7E14HwgYSgF6Te9Q4=
X-Google-Smtp-Source: AK7set8f2K4CBSzOdZkvrAUe1MOnQOs2LPIo8Jt9mgMl0j4CT7t+k1PkMMj5p3R11fzqo3w1mwQoDg==
X-Received: by 2002:a17:902:e5c9:b0:199:5208:44de with SMTP id u9-20020a170902e5c900b00199520844demr7417875plf.21.1677007822951;
        Tue, 21 Feb 2023 11:30:22 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h2-20020a170902f7c200b00194caf3e975sm10250014plw.208.2023.02.21.11.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 11:30:22 -0800 (PST)
Message-ID: <d10e3960-8fe6-2cae-27b9-22fac5aac0e2@gmail.com>
Date:   Tue, 21 Feb 2023 11:30:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 000/156] 5.4.232-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230220133602.515342638@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
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

On 2/20/23 05:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.232 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.232-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

