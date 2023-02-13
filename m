Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB58C69526B
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 21:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBMU5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 15:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBMU5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 15:57:35 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99431F936;
        Mon, 13 Feb 2023 12:57:34 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id y2so3600711qvo.4;
        Mon, 13 Feb 2023 12:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X9T1XxacdA8ndnvUpLliuxpb8eQwtpX1tyf1SdPkzuc=;
        b=nvhM8oNBR/PWWGy0uSLopHV6OaM89T+GBlnrlad8bBhcH1uk1wOLodXVWXzRKGesRm
         52IXvnsGYnJTF/35BlOCurz9tFEnk5GsDk8zekIMQ0Rt2t0MI2vQacI73QTyuAD7avGt
         fyLsRrWHcFWIYih0Z+KqbfeoIGB/6k9RNyVDN3q12kzgrQGCL7S9Ej3XD417dRINYnIR
         CSuujm5GNQDRYSnxlbgaVaQcqf2Lw/1+cygPZEqZxl0JJRBOTG67JhWNTnDkuRIhVq+2
         Pe458RMZDpLu5MSqVj6IIXhFPcdYHdFK2w6gTmqA8nJ8moq/GFf1XplsiwQ8uZP7gjv7
         M1ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X9T1XxacdA8ndnvUpLliuxpb8eQwtpX1tyf1SdPkzuc=;
        b=kfXkdiJ8Wg3hHPWH86SPvM660E48AvqjU1XZ8k5J9xhPhm+jYjbuAr/JGQnsh3G6cX
         LIPESyALE7B3+BXcZdXa3j6qTWLTxuRqsL7Xfbg09xqYd/xp3Pe9mOf7BRgP4cRLptJH
         9XonIJnUHLimVPO25PZvqPCCivC1ZqXuGUhOWQliRGF5ZaVBMFkWrdE3gnX0EnEpw4+X
         Cz+6eWHcpNhk1qtQnVxt5zBz0sE18KK+xay35kGAKFgfR48p4XM/OsIlwFFDCxhriZhM
         nHVUgZJFoguZ0uHCvWG+2dtk+xr4zOpdl2aq0UG/qH2+o/Zl+r+ZcaPaJesJuw01DSjX
         njYA==
X-Gm-Message-State: AO0yUKVJwl+3DX3KiHDK+9BmDePxQ9VNZnmdax84WUcY88VOO8cQ/xOK
        haJvT7dG9xMssGDhyzu0Sg8=
X-Google-Smtp-Source: AK7set+COE3Ki8x13mf7uSUyaVPrSP2/TE12cUHxsDwlLZ85G2gUP5pumFlHX1Rr518NciO2lIwgrQ==
X-Received: by 2002:a05:6214:4017:b0:56e:b33c:d990 with SMTP id kd23-20020a056214401700b0056eb33cd990mr585415qvb.24.1676321853859;
        Mon, 13 Feb 2023 12:57:33 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l67-20020a37bb46000000b0071d0f1d01easm10424569qkf.57.2023.02.13.12.57.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 12:57:33 -0800 (PST)
Message-ID: <a4b17949-a7a2-1ffc-12cc-eec4b2fbead3@gmail.com>
Date:   Mon, 13 Feb 2023 12:57:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/114] 6.1.12-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230213144742.219399167@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/23 06:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.12 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

