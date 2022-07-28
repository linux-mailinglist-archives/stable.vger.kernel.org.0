Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A1A5841E2
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbiG1OjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiG1OjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:39:06 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178326C11B
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 07:37:05 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id v185so1495003ioe.11
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 07:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1Mph2jFK7ZvjRCBseRSlFGNDOkdjD8AM8ows1OdKr24=;
        b=GYEtKQvZkifdPm8Kpnar+uW65wh6U2XEHAcTfsIcuKnjyswHSAFvQKwW3VPEHxC2OV
         rJCksvkfrFNO/0vRDvyoH4wVt2X7sIEqwmobt60tkR3N4bOn/8Jj021mRKqRRRX8+ydF
         yuirBFn7NV0Tda/FuWskAiwmAgPPtWTZlxwIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Mph2jFK7ZvjRCBseRSlFGNDOkdjD8AM8ows1OdKr24=;
        b=nuVqwP/qiLgtWhIILAKFfo43lrnahuWZh8FT/W1tKzV3TDAfn7RCxL4UlF2iU2k8C2
         Es+LlQmPxWlf6N2SR9qxBbKuainCeLwn1oayBlCGnSwPuw++4a9LRPFSwkb9r/7vGKTY
         6zbxKgup9mnIesZ9jQEISfg0qrKOhyhsGmTEv5Ogh9cVo6M5Lppy7UrduzeTzen9dkcv
         LtTPz8rQswdc/7ZXYDm0pnGxiNNOry8p5k2WJ4CeiHWQXwM88cFreD1lJgTgqpmhKsB9
         tinJN+ZlWIQXB46W9vXiR7lDW9h1BfZ/Z29TdTnAJFVDMrjFl2nfmWGZR75xiAdqr7eG
         2HSA==
X-Gm-Message-State: AJIora+/XHgjb2AKc2OWg7ojB2IVZ0FWuppsUykcruzKbZa3L0B1YQX3
        TKRe+7UvJ08H6yiIwu48wbXppw==
X-Google-Smtp-Source: AGRyM1tJnjP4Ht9/dGsjfbXMmWa/1AHSoRtlQG01a6RgKPAxbqoIjpwJAWG2DH+re/rR5uvk/0RHRQ==
X-Received: by 2002:a05:6638:12d4:b0:33f:aaab:8d84 with SMTP id v20-20020a05663812d400b0033faaab8d84mr11106740jas.67.1659019021847;
        Thu, 28 Jul 2022 07:37:01 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id f7-20020a028487000000b00341d28e07f4sm431968jai.105.2022.07.28.07.37.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 07:37:01 -0700 (PDT)
Subject: Re: [PATCH 5.18 000/158] 5.18.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <bffaa419-aa9b-07ff-d651-5c03d6f5b6b5@linuxfoundation.org>
Date:   Thu, 28 Jul 2022 08:37:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/22 10:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.15 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
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
