Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887A54D06CC
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 19:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbiCGSrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 13:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiCGSrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 13:47:31 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D489C89CCB;
        Mon,  7 Mar 2022 10:46:35 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id t5so14957406pfg.4;
        Mon, 07 Mar 2022 10:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fxKMK7UCdJbBPbPCFvDMLXZUSzTlavV72kZHFoZsD0U=;
        b=RSF+x3XQQo9a2d79IpGr6B7cnoPkPEYuOJ8IyWgZBx2obiQSHyrXZ3RO3pbNcu6XFz
         Iq1D7sXfpX7ZHYM+2Qth2EXZn1EdYsP5Q3Y4UGjn+YfUBOX25hShvCFsmKr1+x0FdsQb
         9jWrNUuvlZu/dPt0GASQOK5Bb0ofMLLHS1E36DPJqm6lHwuMHp7JA7yz3eENOIHVIh0j
         zFby3x8wU60vceHP4FSty3BlcutJJTJNDHTqn4g4i+MCRM4nQIVsLNv5s38YzQ7bC4z3
         0oQvpMw6ZhRJiWXWSLjTTGCWMPdSm3R1fOHGRk9u8nj9ugfY5gLM5+SvjEmBoEI2kOc1
         /M0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fxKMK7UCdJbBPbPCFvDMLXZUSzTlavV72kZHFoZsD0U=;
        b=p8dInydzwp0wSpBzAXyzEsXWo76XCEz7nuUQR63VXLSSpHLvO0weL8aYaB3WUlnXmF
         lQglUdjG7fK2g3DcahZJEXMsU/3thbD8aIh/7e/ykx5qrp7i9I1bOhV6J72j53Kjbnhc
         WYXU9l3/eYgx3JkA7IzTKGMYus3y5inbxrXzwDT66E2m6HYlvt2ytkn76mkiElLUZpbC
         S+778mlKB9WCTCjSGr7P7L4qiP8COZkzxPATsNefEDwzrpdiKNVn/amw52Db7JbX7KBY
         ll4lH4oz7hutrmuBOELdeVGYK7BjkOQmUDI3oxPofg8/J9+N9PKWRX/NA2tZ8LBk/zhN
         37Lg==
X-Gm-Message-State: AOAM531DDl92ZgY9EheyKLRpD5L63fTT2SdV6bIMGR10UJ25B/t1hTSo
        XqK9WSqaf8nJ+j8Uq9PR2rsX9lhDT1c=
X-Google-Smtp-Source: ABdhPJz8um4I2EEfOe6kNKBk8mQw1s1D+D0Eb5xKw8V2GY5pTxpnxMN0kro8QqduxA5rwswo9gmzGg==
X-Received: by 2002:a05:6a00:2489:b0:4f7:1c56:2e15 with SMTP id c9-20020a056a00248900b004f71c562e15mr2344149pfv.62.1646678795317;
        Mon, 07 Mar 2022 10:46:35 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ob13-20020a17090b390d00b001becfd7c6f3sm86573pjb.27.2022.03.07.10.46.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 10:46:34 -0800 (PST)
Subject: Re: [PATCH 5.4 00/64] 5.4.183-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220307091639.136830784@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <70173f00-aae1-ea5b-4072-4866cfb3064d@gmail.com>
Date:   Mon, 7 Mar 2022 10:46:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
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

On 3/7/22 1:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.183 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.183-rc1.gz
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
