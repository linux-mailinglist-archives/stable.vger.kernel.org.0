Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAD2558C80
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 02:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiFXAyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 20:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiFXAyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 20:54:54 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC204F1CE
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 17:54:53 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id w83so1738717oiw.1
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 17:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eV2JuCUr5+X04jCCSPybO/EIt8VDRg3eC2TlmtofrbM=;
        b=gbMP93VlmFM/x78NL3MtwoXnyWYVq615V1skSMqiNysmZfGOcB4cVOwDxh2O9ItY7O
         DSa1vQTdx6R85oU1jc/wO1kk90CrrDw+djUki3kkeZbRjPfX87Z5QLjHGiKMkXPG/os9
         8LldfCzFK0p7kJZNMU/Xv1VtiaS/PGW/dRfAo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eV2JuCUr5+X04jCCSPybO/EIt8VDRg3eC2TlmtofrbM=;
        b=NhAK9gyRSNatVbWUCslj65k2orskjYJH40WJu/E0GotaZuDmHTfc5M3dz3mOZTq/We
         VReRhqMrDqg51JQxzQgx/egkKwGNsTgBTP0GMPt0dqWCGlQ4lWwOOviUb/zs2sw5QPLY
         h+dCunXqb7D8JaeERaNt6hRsY97ky5irKxcKkNnME1YhYDvaIarNFtgZnWTNGlvz7gIK
         gX+qE64W8xjGmPW+6+jXInAGacd4Ty+7x7axcCCryN5LyF2g3cDaI/GoXDvslOISujca
         7GkBFB/A8khUnTOBM0sU7tUHkFqwHkILntfbG+I4wYtFFKEeDYvyeWZJ3Gpr1mRBnNSf
         SS0g==
X-Gm-Message-State: AJIora9ZHMooCyh90UDJGiQWI0svbMrS7DsOu7cwAtE2rM7Ri3umRm9W
        CaeuhcsJCVFqeXysGKc72lv/PA==
X-Google-Smtp-Source: AGRyM1uRW/Uninni/GyJUc0M9HC/ynvehxJHRoUAtnw2d3lSML3WeQGqGHlX7u/VAQ/+B+y59i36dQ==
X-Received: by 2002:a05:6808:1591:b0:32e:de38:c06e with SMTP id t17-20020a056808159100b0032ede38c06emr494244oiw.54.1656032093073;
        Thu, 23 Jun 2022 17:54:53 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k8-20020a9d4b88000000b0060b0b638583sm729557otf.13.2022.06.23.17.54.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 17:54:52 -0700 (PDT)
Subject: Re: [PATCH 4.9 000/264] 4.9.320-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3df70235-59be-3d9b-b097-a6233ef2819e@linuxfoundation.org>
Date:   Thu, 23 Jun 2022 18:54:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/23/22 10:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.320 release.
> There are 264 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.320-rc1.gz
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
