Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B4558360D
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 02:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbiG1AsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 20:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiG1AsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 20:48:16 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B7F5A177;
        Wed, 27 Jul 2022 17:48:16 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id y15so424726plp.10;
        Wed, 27 Jul 2022 17:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=T0sL0XnJkncypoWkEhEH3dj3z+lxGzyNkbrr0SmJH6Q=;
        b=bxpwONXPqPNpRCOenGs8YTjEOKB78iXI6gX+aEKIPFGvQLBu6IjWm4c1Bhan1KFFPF
         x2lcMabdxWNjWqof5Ado8U6SdN6/XX88XZAHy2CBHoxo0+alcPUgLgH14B4mWf1tm879
         1em7GytN5b7xKYyIkpb08Hg5cwhAIKnNl8ezppHRHhiKYYsr+VxIFNhRLF9vKA61KhOf
         Le+fYJMRwghkxo/skObFr11nFkjnBiDjbKA1TPBNU/VYEkXPnOsope/9Tjsa7DbeWqze
         Rb4mCsQbZHbBqn5Bhl455xncWDRwOj47oeJHd/41ry7eLy17f6lqYIM7b0ViVsOEs0nL
         UEiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=T0sL0XnJkncypoWkEhEH3dj3z+lxGzyNkbrr0SmJH6Q=;
        b=aS9kadufYiH3UYytneckEUhTdSlUvQije3H+xstL2laU+Y3BKNmJonf4mKtMB2Clt/
         sCJQP2GUt/B6GuKogfI34jHoK0Iqe9xyKOtwDGcc58pDFVmo+G4u2udcffZA4hOWgaaD
         YzX3+nN6/UkdaqNqYTPuVfVbkAKxvLY6zmo1ySrWe5LSMxn0UEf5y07hSCHiTN+/RTx1
         756+W90OFAdiWsAT7RswXmqf+GESiaRIaryDsrabbb+LTmUzkO13wgbOJDRrvLLqqiX7
         sQLoACHV2FlW3G4p9YF6WAxlczC8QmqqrgUbWketVqUJGeaieYxzCsX3geCymg3phQGD
         fsCQ==
X-Gm-Message-State: AJIora9njMLPFe4REWseXozpS4fgGs8cQf4t+R+efQYRXvxpv5Pr9IEB
        TxCKfeFCsYfrFm5K8m7L8Ag=
X-Google-Smtp-Source: AGRyM1v290IK4T13ORDXLX28StcVZB/qyOC2m3rSSm5iiqDU4acScmDk8+SR+G5Ug1xEm/omwSZsRw==
X-Received: by 2002:a17:90b:390:b0:1f3:ee2:62a8 with SMTP id ga16-20020a17090b039000b001f30ee262a8mr5146355pjb.148.1658969295811;
        Wed, 27 Jul 2022 17:48:15 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id x1-20020a170902b40100b0016bf803341asm4337829plr.146.2022.07.27.17.48.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 17:48:15 -0700 (PDT)
Message-ID: <a0968736-5fb8-8ff9-7a70-d6d871175bb6@gmail.com>
Date:   Wed, 27 Jul 2022 17:48:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.18 000/158] 5.18.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220727161021.428340041@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
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

On 7/27/22 09:11, Greg Kroah-Hartman wrote:
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

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
