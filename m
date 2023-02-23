Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C306A0ED7
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 18:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjBWRmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 12:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjBWRmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 12:42:46 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9067532B0;
        Thu, 23 Feb 2023 09:42:44 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id il18-20020a17090b165200b0023127b2d602so69545pjb.2;
        Thu, 23 Feb 2023 09:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YUQnTxCw0HRxUaX138YoYVUi4ja1Ry/gLGuor7Mye68=;
        b=mlDZ/lbQiBqIVVlqw25sMUcTj9Je6SbGrXb7urUz8nf7RxL2CQmWlJNYxr4t1Tw4FX
         6XZSMT7C4b29T4smnW1QaKZi8Htrij9UNHtmgrjbUjOSCbW8arnUA3eCZAX1J1ZbK10w
         R214O65KuiZwBSmSkhDKa25vUNEXERu115XdIU3srWU37pJW1/0vNlUSHwZKEJzOw7AH
         vbgbmNJHw/bfnAlLGyiZU6JHoC9uBF/E1K76ZXrCmNMI1TaqenddTagol24bqRt4ePZz
         a8RXHUSiBuJ8PlcWNanwFhutdWo33V9ODbOHDrxd53wFLXsh10mp5hBdDt/AyUUiXPZh
         RhFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YUQnTxCw0HRxUaX138YoYVUi4ja1Ry/gLGuor7Mye68=;
        b=dapSMiz7VcQwNWH4OVDxR/kM/URut+7atmvYK2+7K5B4IUWaDvD8x0pqMfQaWRrKwg
         vqt371aPIty08KfHPKWYniem9RSmv1Ef9dhq2gIYfR74aFQujeJlDUqAuUPZswUPYrgK
         xae+YL4ZTwfETU5D7LIDGV7+s0Jrg8kSFNmsgCj3IAMbixXHeZhgVzUjQBuZFDGogtCr
         bxtgtTaNhOtxwAK65TRkDQ3Hjir4b+Bsjro1Iz793Ex9x4LRgFsWwJBvbhElEWUORhEV
         dBUnuNFlp8FgbJXYO8z86vAW4kGkMF/yHq2nq9lR5QyIiw/gOH1P9sqhaUCGvw/vhh29
         l6mw==
X-Gm-Message-State: AO0yUKVN3KnvYPp6JiOKVCwIN/nRbn0RcDArxAwfWPhLjJmPej/EUK8z
        qG+RZnk5pW8k4Z1sPLyfZiw=
X-Google-Smtp-Source: AK7set9NeiIltv+d6Vr8lPtbiRtFk0vymU/QzZJd14XxNmFpFzI0KAJkBY6t/JiW9w+bJUXoRlcr/g==
X-Received: by 2002:a05:6a20:9383:b0:b0:c30:1de with SMTP id x3-20020a056a20938300b000b00c3001demr3706303pzh.61.1677174164269;
        Thu, 23 Feb 2023 09:42:44 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k13-20020a636f0d000000b004fbb48e3e5csm6682556pgc.77.2023.02.23.09.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 09:42:43 -0800 (PST)
Message-ID: <31f37158-13f5-a0c4-c477-b6202d48f429@gmail.com>
Date:   Thu, 23 Feb 2023 09:42:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 00/26] 5.10.170-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223141540.701637224@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230223141540.701637224@linuxfoundation.org>
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

On 2/23/23 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.170 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.170-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

