Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4342E4E7DD1
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbiCYXQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 19:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiCYXQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 19:16:35 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCDD53B48;
        Fri, 25 Mar 2022 16:14:58 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id w7so5052047pfu.11;
        Fri, 25 Mar 2022 16:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=W0xnyeZEQua1jzbacwkINnvnEOXWT/JNGDIZRnq568E=;
        b=Fk/hDnd/1agmbbldpeTEBeRVOa8Txc5BXFMB7imeBiUKSwE4UTCnfVXsz7AZhhqdpm
         4kT9cYEdhZFo5yVo7iGQG9tpVwMKdwQdlH4XpAmaZsnARmYk5czz4EgqEnHFgptnELT7
         BGxJ3SLRx7HOSFkr5TVErrkSLLtEMcojXFRUZgHmFPZWJp7G1DvCGwidkbcObniurOyL
         u5Q4xpK8xHuqOWGIAtqwW98UMmPiz1bPIPH3otPo7MUing+P05nXMKTLfJOZ7cBruyMd
         8XBAjMc3//iEE7n0sZjXAl5aDyaZ7gS+l/qSM+wSC3W5P6ssXnrxNlcgScv9ckcsEFb0
         6+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W0xnyeZEQua1jzbacwkINnvnEOXWT/JNGDIZRnq568E=;
        b=hrrAuc/EU3R58Ggu3lbfaZkOZLz/wEuT911LX/hwR+qoeMgCtwX+juPAYKXi2TAnh8
         pqE4LZ6CoB/mUr0ZEHn+UI7Eu2HYM49hx71nTzbGG4NWMLyEmQn2d/VVd6LkA5clmcy9
         LiB/t+AOS+X2qlN9uAby3DmWu85XzIYveemy7u6A8JFQwziMXXqoeRF+g242nPdViBOv
         I2ks+NMp2yElo91rDVcD+EuqEa+7VmLP7M1QGf70LbOLKIFQlp+r6Jp4ir3DHDRowu5L
         yi8aQs2T3eWKAeVFXORIbnkWEUfF96R3oBGZbhT1BfyxIaHG1MK83NEamQCW4l67m2R9
         7PMg==
X-Gm-Message-State: AOAM531I8esnZlKQUxHrGcCRhi4uGL6kjtLd3EaEpmyX9W2TA8lCMe3+
        VqAqhNJjQfvvYnqjxCX2FR4=
X-Google-Smtp-Source: ABdhPJyJtx47O58cmNmxO+4gogiqtjIv6+HBp4oXebXy4R3tnxClEFBGRUYbBIWLW2MDf2L7+w5rDQ==
X-Received: by 2002:a63:1003:0:b0:378:7d70:2ec5 with SMTP id f3-20020a631003000000b003787d702ec5mr1372859pgl.351.1648250098170;
        Fri, 25 Mar 2022 16:14:58 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s18-20020a639e12000000b00381bd8604ecsm6206543pgd.40.2022.03.25.16.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 16:14:57 -0700 (PDT)
Message-ID: <77a64c6d-5394-1cab-9fe7-ad22f9ca5e5f@gmail.com>
Date:   Fri, 25 Mar 2022 16:14:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.15 00/37] 5.15.32-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220325150419.931802116@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220325150419.931802116@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/22 08:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.32 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
