Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393236BBE7B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 22:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbjCOVFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 17:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbjCOVFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 17:05:36 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D07914986;
        Wed, 15 Mar 2023 14:05:02 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id qh28so1296719qvb.7;
        Wed, 15 Mar 2023 14:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678914299;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HhB1eHhKNybt7fmqo/e14U8GDGgKPuLXz5imrXdqBM0=;
        b=U/XEbURniFfeRL6bJBqVPnzxsAuTuxlHyPhhbSPpa74fQl/jJQNSCzYWmi5hGcPeDy
         SUQ+2YsZgCCSuf7JR+HrYgDcmgRXeTf0DR1HXBloe18js1RkzBCd6rxYB0L3KWJ+JjRR
         imevI/J3wc/706FZcQF3IuEN/pajngrQItmJxg7zGoTGiRZdj6kJUHkqUxmTCJlVoudZ
         W+Ai07/6nNStkqj5+mbVnneWJPPf+5nZcX8jrMR5F9+j0byZh/DtzIoSuCfepTB1FpbU
         QSkS4PFxJ028zb9IzB6ou6c/TKzeShPNtuv2eAnhuJWBUHniRHqZHHCdDIrKu1cOfisv
         VpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678914299;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HhB1eHhKNybt7fmqo/e14U8GDGgKPuLXz5imrXdqBM0=;
        b=1rTlaqTHBe2P8ELJxi65rPH2kBk9ag/R0Qj6BI8pBGCEwRysFjM4FP8nftIfNna6aL
         2zfEES+ghNajI8zB00SVG5HgrVOVKVxU8+h5nKCgHL+fBPhmthjKqdZmolfbFXEA0l5U
         p3vWqt1iTrn5S2WlOSUzy571ol/AxXcPigku8Sdyq0uUQBdSIGW8Mp1ZzcGIVLXekNxs
         Vj92wz/a8vfWQvI0H7d8mTR9yl/RqFgKC50fDvOVW2yh9YcO8eNZp60bmfL+xbV23S0l
         6y0Tacwvw/kL7lsXEizdB9m/Ld/TqN2qb/Bjf6sxN0nBEUrOSoRmpG/X5+wX/VBg4aOQ
         +ZLQ==
X-Gm-Message-State: AO0yUKUom6Xt+FE7N/B/IsZoo4VlKUCOD04pCCLmQMOcS9H7hGptKWZ+
        hKngIsAZ+vhygAeoyJ871k19+dLYt1I=
X-Google-Smtp-Source: AK7set+1/1fKijypVrC8Dgh8Dn7sY5apPvhBycX+NHOd3R2nYSl7ce9c+pyW3Cd/BPaEEjhECT24qQ==
X-Received: by 2002:a05:6214:48f:b0:5a2:abf1:7d33 with SMTP id pt15-20020a056214048f00b005a2abf17d33mr26055654qvb.50.1678914299257;
        Wed, 15 Mar 2023 14:04:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g28-20020a05620a109c00b0073fe1056b00sm4400863qkk.55.2023.03.15.14.04.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 14:04:58 -0700 (PDT)
Message-ID: <75bb3ba6-c1cd-d38f-0e0c-b4b1916aa1f2@gmail.com>
Date:   Wed, 15 Mar 2023 14:04:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 000/145] 5.15.103-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115738.951067403@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/15/23 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.103-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

