Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2686E6BC1F4
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 01:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjCPAAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 20:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbjCPAAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 20:00:15 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168D517CDB
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 17:00:14 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id 4so103401ilz.6
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 17:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678924813;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M5n6N4Kf45DWAUdDU8gCqH2UU9H1ulFevAL57GqiUGY=;
        b=UCsuKHu2bj7zopFA1WRte9Z/MDmlBS9AsRyqRGflrYMvGJRbrjvwm0IGO87DgwM73s
         oEd7qDfvdkyKbIRz1jDBuPO6U2XwwI58LomuboMuXBU19cOONe95qY9QpiC9ua2S2q/8
         9Oel2NIJSDLVo8vGcxO3JMIpmJOQwKQSYDye0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924813;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M5n6N4Kf45DWAUdDU8gCqH2UU9H1ulFevAL57GqiUGY=;
        b=7IPPh8I6abKGNnchN3UK8JiRD8+3zcL3vJheN4CtH3OEIOdKc0b1T2tk9hf8cXhzFn
         8HPEVizAmF6tf2ohGjz46Ok59CawOvqMpL66o0zOYiydV+ZzTinapNgQx/LkFNEvV5Xq
         6GblWPcZJpDkNMoS5eyUzQvr4PFB1we5oSG3MIgsBC6FAwu/2KP6goHT8ptm8igvafZv
         hBhGptj5qTsRU8btvOSGoRP4rV5z6E/fFtwEW2pH/r2a0KzRAZK8gUNoKc+lkfJXLNQU
         E5eZ2Oct8wED1EYLRvnA/eb6n/rYskyuKKKQd8ClaAm+mrFbwldtkN8nQyzCsHiTfq14
         xtcA==
X-Gm-Message-State: AO0yUKWj6TTSMUEG1UjpxKs36UQU/KhepJym8voZpn2LYO+duiV192+J
        fqPf+dA3Ql69kKOyjwcfqevF7A==
X-Google-Smtp-Source: AK7set9j3X3dxYOjKgXnzMWtyyMmj4wF08Z8ZmecfQECcUg4gxKG34tkDHCOOfX6oZEObmCswOVK4w==
X-Received: by 2002:a05:6e02:1190:b0:323:504:cff6 with SMTP id y16-20020a056e02119000b003230504cff6mr521499ili.3.1678924813457;
        Wed, 15 Mar 2023 17:00:13 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id y13-20020a92950d000000b003230fd0b2eesm1953198ilh.61.2023.03.15.17.00.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 17:00:13 -0700 (PDT)
Message-ID: <4b45cea8-5881-34af-830f-c37f000e1300@linuxfoundation.org>
Date:   Wed, 15 Mar 2023 18:00:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10 000/104] 5.10.175-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/15/23 06:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.175-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
