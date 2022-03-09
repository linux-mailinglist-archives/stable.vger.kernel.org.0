Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5D34D3B04
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 21:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235104AbiCIU1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 15:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbiCIU1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 15:27:05 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B6A323
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 12:26:06 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id n16so1149050ile.11
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 12:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qNRBFNAWwgbrtCvaKgMruA1CPCeSAHI2kdKDPY9VLbw=;
        b=dbQlULAxQIK9kG7QWSDHbYuPQZzdp6pdJtfZItEfmn8+IZSkM0M8MxMwO5MhsQCdc9
         tr0Wnglr+d0FleW9hDrBEgh9TkyccuuxgM08SJGUiMpDBBjS6hnk+ThiMtIc1BajG4kK
         ma97moN4oDKKwWDlrlOp8CCFq5i+oXNgFwu/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qNRBFNAWwgbrtCvaKgMruA1CPCeSAHI2kdKDPY9VLbw=;
        b=wLDnSodfAMqdxsiB+0cfhJgNpkpMbPfZ8Q4R5InPLqZJJmHgWMW9ywkX9tfm7x5LOw
         ZyQcq0FSI54eul4bUPTBevAUUuHziMIAWuNuHmdHYIzcW7mDFrOeY4dlsUU7L0pxlD8v
         oNcqW5U3AwgrRTk+gsY43qW4jJ++XrnSH2dbluJf81YZk1oqb9rLbQiUtT3tZ6dp5r8U
         qbMU9ogBYbDfzV++OO/DTn2THRq6X3kKwuX7f+md2YB0WbXhnysxr6/MivVOjplQfzQe
         NLPxBU7nJVU4wF8zIiPeUvwk/elPrK6FcJgxRhw2owOxAIVjl7NMOSwfOF3uAds1tKrq
         fRQA==
X-Gm-Message-State: AOAM5312F5YfNY9MpaI7oK5auJxKe1pDbFQYMAGrT1DBhWRSKn6Pdg89
        laxSgxN78QfdTZdbm9v+oQr3cQ==
X-Google-Smtp-Source: ABdhPJzDuy1Gmt+a6MUNnO+o2tUGJU2saY3HPHLvH8QFMXQA7UaAReP+2whGCr9zKzS2TSJHjmiKfQ==
X-Received: by 2002:a92:d40b:0:b0:2c6:6b2c:8a4a with SMTP id q11-20020a92d40b000000b002c66b2c8a4amr948796ilm.131.1646857566099;
        Wed, 09 Mar 2022 12:26:06 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id 5-20020a92c645000000b002c632ac65c5sm1575290ill.43.2022.03.09.12.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 12:26:05 -0800 (PST)
Subject: Re: [PATCH 4.9 00/24] 4.9.306-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220309155856.295480966@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4b4743d3-8465-50ac-4d35-e86510557244@linuxfoundation.org>
Date:   Wed, 9 Mar 2022 13:26:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220309155856.295480966@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/22 8:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.306 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.306-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
