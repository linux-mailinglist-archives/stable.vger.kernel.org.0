Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A555221A0
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 18:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347633AbiEJQuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 12:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347632AbiEJQuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 12:50:07 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBC1546B1;
        Tue, 10 May 2022 09:46:09 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d17so17278741plg.0;
        Tue, 10 May 2022 09:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jYvLRLOMEJER6ORgYpb83b9QnvEzMgcekAJkss3qlts=;
        b=OmFW1mzHmn9plLXOldiTMFtWLitHaDkw2HgKE5Ijgx2qWonq9r3bVXYU8mXsnKEnIk
         dpI7sC5NewDPX2Q3gInh2qvpiKg6cFY4aJe3Bz5XZTd6ow2USSWHTo2D0I4r2fCymNPQ
         5IQcdx19TbPxSt3VsLMUDGMQ8urfQF6zB6Ap5JKX6MhE4t7PUiimrd55icglrUAj/TsS
         fpQtg+EMYIMNjkvCnE4u2gq9RVCIqiYXi1uER+l59OOPXxasTne1fMGwBDgzb1y0as82
         eO9CAfx1F8q805+D3se+UQUtD1kr/UwqqtqkHE0bfJh9A4HImXCWjBeYnuS40ccOnkvM
         4t9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jYvLRLOMEJER6ORgYpb83b9QnvEzMgcekAJkss3qlts=;
        b=CEskf9AMdBTXfbq0/YGUQywcE/ajGITaZ/DwbAGZyuiQk2h4alK+t01e4Iwgpo5GT/
         ryiEDeB+Af7+CM8JIgQY4Rv9qkuqmEuqSKbY5RHw5VLw3kwW0lys4BiWwppwDrAxIRu5
         xTbjmM+LXfbqsTD88/xCCLtjiLZVEUD2/Pjofn5mWlac6rLnwXfTOfekI931PkpGI5mE
         AR6Fwmw5/tIlgN+wbvwqIQaZW1iiTP/gzkKs6eNsVk2k2jOQGnMfK3naLwRHZMwHe3uv
         nEgT+P+ttqqFUx7QCeQXpywLzFt4aNBgR+yQg1gCdc7BYdYZOsnkp7QiWPTa5KQljxuC
         2w8w==
X-Gm-Message-State: AOAM531ZfuVcjPLsWBuFrfLHGoa5ItLntDKumm0SyIFDz6tIfhGYMzec
        a452tDOy+Ttha9ISPANWKGg=
X-Google-Smtp-Source: ABdhPJxqmtVg6qVUZoRWZktpbtNbyGB5Q4GoEP0d3wH2XBumLnUV1VFvR7cr8o5QF8DR10PwnNny3w==
X-Received: by 2002:a17:903:240e:b0:158:eab9:2662 with SMTP id e14-20020a170903240e00b00158eab92662mr21446189plo.87.1652201169378;
        Tue, 10 May 2022 09:46:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y21-20020a626415000000b0050dc762819esm10978904pfb.120.2022.05.10.09.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 09:46:09 -0700 (PDT)
Message-ID: <72c233bc-32fe-87af-ada9-d18577d10e00@gmail.com>
Date:   Tue, 10 May 2022 09:46:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 4.9 00/66] 4.9.313-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220510130729.762341544@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/22 06:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.313 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.313-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
