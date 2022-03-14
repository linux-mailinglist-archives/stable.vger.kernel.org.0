Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721D64D8F70
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 23:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244764AbiCNWVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 18:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbiCNWVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 18:21:20 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FC83C73B;
        Mon, 14 Mar 2022 15:20:09 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id w4so14693913ply.13;
        Mon, 14 Mar 2022 15:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lvRjlJk9we320qn0uDquUmJMPKvc+9+Dqsk8AR+7ALE=;
        b=XReh1sK7o1xHJOF1L1k6ybcRiIBm1Y4xWsBVpHEQ7NSg6PjwG+a7jm+BdOas5jMv/a
         57aKszuE6EHSUTxLcqqnKnpbi5Q5IEH/SiukgZ2t6mImCCFF5CsCoN6zsL27sqVCUJ+y
         GI0hR5U8Xjk/QyMPqcNcz85jn0kAbCiPfuhPE1YCo586O1b9EZ96Z+YOTxgICKYMr43B
         YAexSadl9z1dhjLiEKPpQVIVugPboKsNKrvez4KJi84hlWBqmq0f8nNq7Q307eMd6xAa
         /niXZQxerZwCSeRPR6NCYyo9h83UGQ9eqN3TWxUxdms60r5CF1qrRDiORK7WV4teiU3/
         IsGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lvRjlJk9we320qn0uDquUmJMPKvc+9+Dqsk8AR+7ALE=;
        b=Y5ZGj9taBHz57C+uL/JSz5jVcLjAJWzxtjE/Dq5W4dX5lrriqASY0Sriejy7CUPUFZ
         DpgdMj86T0Fwq5U424moj6DSDeFNe6IadocsEn9fFVjxUyVUcdASn4K/thp9ZeKGxjtd
         JQZpuu2safPg5pNJOQ5tjIIkBTk29dB7tsCdh/jgzcOOK2fCJnItLQCWBxadRlx8f/ZR
         xROwm1Ndbqa8AIvGpIIhcjraDiMXKI5cKN8oA7tqPCLyI0I5RVw8E109FKn1REHNwGMm
         +6GTNLcu2S43YZPpBy9tR1bSkzszpaOsaypYzFP4aZ+o46anfoxlUqdGJ6k7v2ONcLck
         VWSQ==
X-Gm-Message-State: AOAM53118h91vHWA3I6xxp1M6xUcHvjW56djKKqhD6GuBgJ+TDNKZr6c
        /RbFZRSa1pv/+Z8hAU+1Zog=
X-Google-Smtp-Source: ABdhPJyHPg2e5iyH1mSA9zzYNOI2+pWtnccfcUIOzPjiyKA/E+DK7fMVOT6+s8xL9phF8aw0EymOsw==
X-Received: by 2002:a17:90b:1c83:b0:1b9:caa:8230 with SMTP id oo3-20020a17090b1c8300b001b90caa8230mr1359652pjb.26.1647296408955;
        Mon, 14 Mar 2022 15:20:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c22-20020a17090abf1600b001bf4b374d1dsm460932pjs.47.2022.03.14.15.19.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 15:20:08 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/71] 5.10.106-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220314112737.929694832@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <66f31198-afd4-1b4e-f847-f9190be77b81@gmail.com>
Date:   Mon, 14 Mar 2022 15:19:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 3/14/22 4:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.106 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.106-rc1.gz
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
