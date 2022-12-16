Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F72764F162
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 20:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiLPTGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 14:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbiLPTGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 14:06:53 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A380165FB;
        Fri, 16 Dec 2022 11:06:50 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-3c090251d59so46107747b3.4;
        Fri, 16 Dec 2022 11:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BKNh90Lruex5LAQVx5cYcXCYZ3q4FsH8oAZBjIKNToo=;
        b=faEBGsNCbPrJQjhPt7zew12CHmk9bGgxaalNqc4ELtgLZCac6DcgndYwqv2fumfjGZ
         0QnVb6LOj5Lx6fXwEHvR9gmnBa29rOZZsg/VET3NiLv9BqQ6gGIzVCLvKVDWM8z38s4l
         wj3hcQFbBtlk3MHGItM+fNwqiALGHyTwqRO0Rwv0PwrmTXTI5Z+/o72vGihY0mSADsMF
         Rk8E0MXXA8NNFr5F5hd/DZ69FTOTlhYIwE5uDbMIXgrURlJgUR9L19ARqqQtUc3qVld7
         9I8L8Y83AmN3nqzASkJ6L1d6xbuzKIXv42DQIg22sijzO64DNSn6UT9pYIewkQiWdimr
         nKAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BKNh90Lruex5LAQVx5cYcXCYZ3q4FsH8oAZBjIKNToo=;
        b=AaSeDHH1kgZXoBBC/tyHdfGWYmHvw5CdMjQOASQb5coQo4BxvdNMjw2f6Af/rcm+mk
         m2AnqF/DBKdW/mYhe19ybR76RR6JcdGhUXj70t80WzvWXtSzFD/uOJsHf1esnqI+lBEE
         niiUKl6gDJHn9KPVmPvDSm8Q5XiBqL5KZOoij8EgmSPCh4r1iZv5nUc18v3DWy5jldbe
         gxbDVAN5cuHKPGwZcHrGnwuc6cF12fncJiVN1TwLFIRXP+cq9hAys8SCCPdiHZ9ftM7N
         k/1nRSJkzONGad/1jkN3Tu5rTHJPrwe/q+G/UOwxHuLrdmJsTGm1v4S1Qf0mGBEtgaUA
         yN4g==
X-Gm-Message-State: ANoB5pkAP0pnW/mlj4XvCShvJDIK9IlXWkKPDLzHYBLmdUkBcXErEkn1
        iw8xId3s/7efp1S2V1KjdIo=
X-Google-Smtp-Source: AA0mqf5McHIiY23aK+5KDxvpzI54RDbkKkvL3/zZY31DOkZjpjvJiWHlsng4dOOC6LzVCjGmB3J6nA==
X-Received: by 2002:a05:7500:413:b0:ea:8267:6a4 with SMTP id f19-20020a057500041300b000ea826706a4mr5475544gab.40.1671217609769;
        Fri, 16 Dec 2022 11:06:49 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x17-20020a05620a449100b006fc2e2198easm2057704qkp.95.2022.12.16.11.06.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 11:06:49 -0800 (PST)
Message-ID: <656e4296-5810-9eff-a7cf-513d134656de@gmail.com>
Date:   Fri, 16 Dec 2022 11:06:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 0/9] 5.4.228-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221215172905.468656378@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221215172905.468656378@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/22 10:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.228 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.228-rc1.gz
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

