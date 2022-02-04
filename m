Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E21B4AA12C
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 21:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237918AbiBDUch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 15:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiBDUch (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 15:32:37 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25492C061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 12:32:37 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id c188so8830222iof.6
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 12:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7FQ8RAJtS2IXkE2nku0Q/J4KXLIy7y7Nmy0mg4WfpqI=;
        b=a0t1yAPonrS2fXvdWFvRflccHI8L+xY/LYETP44jV+MGMf6bPjX3hAI7OHeVOFPqw8
         MWC633/k/b4qYVqzx4/iXkqr5zc6PizXZgQUPWNvFyhUxmlqfiZyX8v1rQkGq9t06jFK
         NdIV2YzjbrEGeL7NRb5vsFRsUu6eagXLwMXFk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7FQ8RAJtS2IXkE2nku0Q/J4KXLIy7y7Nmy0mg4WfpqI=;
        b=l9WOC2ryM5PnMzLiMmdRESczRkTHuRWujRJ9r9KATUgjpNB4Lmx2N7IFQbZpPYM0bd
         8Ytf83y9WdNoMpqEx3/SoSHEZsTykeKD3N/QqnM0lVrmqYnG7kYwySRsce1KP5w+tbih
         BU9W9SPklJXo34LBboKPbHEnGEDm0pRhXmcKCJ3rZlbXdhAWBlJwisrF3TztYomLlktV
         UpuoXgKVGSsscKmJNgoHqpBRis2b5MetQcagu8laRgQIN+yuPw6dXMxGXJ+9WhAzTGQb
         B6lusho6AfScCZWwaP6Nb1twP1LLIXPR40gm8eWHCracqbgMEQFJwSr5GEVqLF7u5bO+
         YjIA==
X-Gm-Message-State: AOAM532H9VGRgfgX571Z4CwuFZHCoYyRMAwSLxc7gOHjRLbZmLOderrF
        Ty17aEaW1KsGUvEUm4JQlmDsXQ==
X-Google-Smtp-Source: ABdhPJwQruLCJgiUHu28Vbv7KaxBy8hI2r6iZuMagTcm4h2XdYAVm1OUES3zRhZgFRzjT5NIM4SV5w==
X-Received: by 2002:a05:6638:1348:: with SMTP id u8mr453928jad.4.1644006756576;
        Fri, 04 Feb 2022 12:32:36 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id y22sm1429064iow.2.2022.02.04.12.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 12:32:36 -0800 (PST)
Subject: Re: [PATCH 5.10 00/25] 5.10.97-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220204091914.280602669@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e4a0b744-e5fa-2ead-20b3-007cb795a4a6@linuxfoundation.org>
Date:   Fri, 4 Feb 2022 13:32:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/4/22 2:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.97 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.97-rc1.gz
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
