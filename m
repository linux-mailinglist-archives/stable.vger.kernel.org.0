Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733395E66EF
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiIVPV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbiIVPV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:21:58 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F63DF6851;
        Thu, 22 Sep 2022 08:21:56 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id h21so6502058qta.3;
        Thu, 22 Sep 2022 08:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date;
        bh=EHgGy1b4fKR2VlhBEDXkInmqsgSWH6kP/tOJUohtCnU=;
        b=b1x7BJhFdALiDbdINeWXxQwoJhbNHuUcLLLFwNz/X5WtIQdFsjwcFPUscwh+6bU1Mm
         RIj2NRvE5PgUIC4Y8XCek//ayoD9GFN3+jd+TBty9l1CZ+R4KfZG+yb1NMUwTXop1wUP
         yXjPTSARbkHX81YUff1RvhsCj4aCZ+dH5CsCyQJRmdxt/C2CKsDenw5NtCxugTPIdZAQ
         ST8ymrA75BmyRfmGYm4bQOYc0B7FLIDAdzhGZceIdUnnyZSXQoWWLxmUS8DQRGx6YxA3
         VWHkkvtmzc5Ky6RCVDLAowDKYXSarUzgZ5cjCaOTZu5eUdqkeMz3Nyw6n25/6CP8oGVn
         uKmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=EHgGy1b4fKR2VlhBEDXkInmqsgSWH6kP/tOJUohtCnU=;
        b=RlPnijidB7G1rlkrfv0I7B4snlkmouf3RWEIyFcsc0/e//7jkBSZL2Syu9EOXa3BP4
         2ARC2IfqEgB4+p8ABh64iv+LbI85zeUK0nh5z4PXMVHCKkVFYvKxWNU4/14AVxstGw6h
         htdqBi1mRv2p5rLXJyQ0iNsgjOQ2deQ4CKNtTES4j9Pp1+nLOX6UT+yyoihngLHoK25w
         klIXh3d/nd+1VcbHkCF3Dhh3vnZYEM+Y2xkCKyGhebCdzvMfzNAIAlR3WLQyn3+a+V0M
         qhcN6G5PgfzXWsC2EC2BP/s0rfYwwmgzy1yNs+njUn7nTh2DSlOxVV9nGJkU2oSoYoM5
         LAVA==
X-Gm-Message-State: ACrzQf2SVJOo/z7Rd+lnIE1STMmU/HoZD5QUESe+6l6aMtcdEE20F1To
        mnjalXRcYQvpQ7WdQKvmbTw=
X-Google-Smtp-Source: AMsMyM5CRzrCNQ1BnOCTZiPkVmExfKWdkM/ggKr1EEVHDjkBNt/qIWOitKdVVxcFF108eJiygbRPPg==
X-Received: by 2002:ac8:5209:0:b0:35b:b179:9ca1 with SMTP id r9-20020ac85209000000b0035bb1799ca1mr3361696qtn.260.1663860115665;
        Thu, 22 Sep 2022 08:21:55 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id c3-20020a37e103000000b006ce3fcee2bdsm3861031qkm.50.2022.09.22.08.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 08:21:55 -0700 (PDT)
Message-ID: <e76947a1-7990-84dc-641e-375e95b86528@gmail.com>
Date:   Thu, 22 Sep 2022 08:21:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 00/45] 5.15.70-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220921153646.931277075@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/21/22 08:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.70 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.70-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
