Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3944E2F93
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 19:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351960AbiCUSGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 14:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349445AbiCUSGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 14:06:04 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB9C4CD61;
        Mon, 21 Mar 2022 11:04:38 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n15so13457993plh.2;
        Mon, 21 Mar 2022 11:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=aLAMIQ8Z/Brx4GgfsQ0HcQtispmXwswle1+zYBDv2JM=;
        b=lrfYWw0h7r5509pqhsgV/reZahtlNdofwS6QxNFbJe7SH/kkWK7a2pHOo/Lz4b4O2d
         HMIiLyOd69phUkQqMsxWcYPCTJ0Wfx3ZqX4uqgBZA2p3Z4hrZFxbYBHmYtqCCTk3HMQ2
         I5FbxpfLD7057G+ykHNj97m+/ID6/qLZN5eRnAUSZ1bD+pFuAgrHygt25SJzaylaJcZH
         t4jMKKg9YJGeqRM3hz6ddmWK7o+n+IllcKX5S71zvYwk4SU2aSaQHcUcWTbxDPF9F6y5
         eXKhWIC8NNMCS6SxzMl7zeZLbemifs0ZBLxg3Ww3p+Dzzy8OJh93w3PtDTD83FMutxg9
         TVvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=aLAMIQ8Z/Brx4GgfsQ0HcQtispmXwswle1+zYBDv2JM=;
        b=CAc3RouA/VdjDDO3BMapZIIWJn56RkYIU34Xz3LwzaL+DrhyZF8eZcnhBRJQqloYYt
         RfawTwHWrFyvRd/Zj3VKfmRLogYQanGBVTeba93AKBW5jyRmXhyTFFaliBddy9v67uCt
         BtOHkiq9lWo03D5E7Hx7VsZzjO61d5eC8I2V3sfctb6MHWO/A/a98a0jlweBmtA+ei9S
         HnXiyaWkp7D12X6HoAo72qzh+8SdArR9ePFoMXsBExdOwo5LyclwBDolvEt25Z+ZsuLF
         pc61TmpmZKXOZ00MvxEOo3aAh592GgdT+ehRkttXXXGnSe5HkrIOwLL0hHOH0/eRbeFX
         UEYg==
X-Gm-Message-State: AOAM533mF9SXCiYX5pEe6C/bVJf2tPCVDnCUgNb1B5XfByuYBwVvmfUa
        DqXL2DEW1m0Pu1xgnd6I1TE=
X-Google-Smtp-Source: ABdhPJzxVKNEzDd2T+O/tM3Jwt/u+g4+SzF/YQt8YFs6HGgO4SYfo1bT7GLj6MME54cabODbsD1T2g==
X-Received: by 2002:a17:90b:1d02:b0:1c7:1802:c00e with SMTP id on2-20020a17090b1d0200b001c71802c00emr331358pjb.99.1647885878110;
        Mon, 21 Mar 2022 11:04:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h2-20020a056a00218200b004f66d50f054sm19871038pfi.158.2022.03.21.11.04.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 11:04:37 -0700 (PDT)
Message-ID: <a88a3172-aca8-adb5-c9a3-e4d32a416190@gmail.com>
Date:   Mon, 21 Mar 2022 11:04:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 00/30] 5.10.108-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220321133219.643490199@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
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

On 3/21/22 06:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.108 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
