Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931AD4F6E03
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 00:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237206AbiDFWuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 18:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbiDFWuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 18:50:20 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAA11EA29D
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 15:48:22 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id p22so4822465iod.2
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 15:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KO4euBsF029o8wkCU9xHqGUQVAQ0j+cGxrf0+f/zmC0=;
        b=L6BIobOlo8l0E3R0m4HIp/UnC6U6b3mRFiZcLZlKCXkMuTcqlpaac3W4KKlG86MxEV
         7MMUBvb1qQaiXDx4NLLqineLYxMegtfRMm1zLGbIsc62XsMMb1cCUyRFRey61Efhq5zJ
         2S8Zm6AaXtZjs8JHTI0RdUQdyp0DFifyqGsSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KO4euBsF029o8wkCU9xHqGUQVAQ0j+cGxrf0+f/zmC0=;
        b=vnnZTm6Y2SLW/uki8ZP8XJkkvUX2K8WQlvprsDpEmLgpRg3f1JzER2+BkNLsz4z8Jw
         h4QK7vmxZG5ObGvwPUmX2TLj3t0NTRGwA8bP3LLEZbT05wcDR5zGmQEpzxyycRk5dbk7
         9iFrBYwpndyd5R/NjwpCrWNcA0iXZRtk5t+3Hy/DkbDt4yoVeETNNQVoY4o0THzDEX0d
         MnRJDF+wPHluiDn6OgW6m9XFmjRJP4NceskWBXm9v6IhEttTg5cg82fIV2wEQweZnfHA
         ylkdiQqQd32VC8l5nEixWDrkD/flq8jWIagXDtRpyXqW1E3AbQjZxpQD8DDF6eqY1ko7
         4fbQ==
X-Gm-Message-State: AOAM532ufeJG+WYOkrgjwrPsKLWO4L/uX19d/E3qC87rZMbD1PgwrlYb
        4cPovs6tEUS44pnk9L2PEYMm/Q==
X-Google-Smtp-Source: ABdhPJwPW4xInbRlES3o48NcEGZGCc1DiqjW4ymkgdgl3kzlBql4NXPXgCM4RquAzvCsPBJFdSXstg==
X-Received: by 2002:a05:6638:34a8:b0:323:90f4:11f8 with SMTP id t40-20020a05663834a800b0032390f411f8mr5657869jal.226.1649285302388;
        Wed, 06 Apr 2022 15:48:22 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id f20-20020a6be814000000b00649d9a4db2asm11558941ioh.27.2022.04.06.15.48.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 15:48:21 -0700 (PDT)
Subject: Re: [PATCH 5.17 0000/1123] 5.17.2-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220406133122.897434068@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ae850aef-5d72-82bd-bae2-493db1c662df@linuxfoundation.org>
Date:   Wed, 6 Apr 2022 16:48:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220406133122.897434068@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/6/22 7:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
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
