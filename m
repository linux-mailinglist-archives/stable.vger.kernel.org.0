Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1FDB5FE38B
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 22:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJMUxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 16:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiJMUxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 16:53:22 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D341530569;
        Thu, 13 Oct 2022 13:53:21 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id h15so2538772qtu.2;
        Thu, 13 Oct 2022 13:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lYFDP/p0oDmvmHQzvKjGd+SXW0/wWau3FYCTmUlV558=;
        b=KBmTScRRcD5XphURomWbvY1DA1JiMtDQ622RPyVyyW1qY3zxg6abue21jN1WbTuDzB
         estr7MbrQq6CdWx7DylQSH8WMmCvphEPIb6IPskYx/1X4lSI+WDyYZGMepkqqQgSTRrq
         LFlP1tengzcs5xkWXTbKzaL1jqg/4di8JIzK4jiwRdj3sCknids4iQpRweDCf3pkLJBT
         FWrVN2a1x38wWchC5o4rtdlvGVcl7HFH+bCzF/rkaOCsySMPI47HE28mB7tdfT28otbl
         q6UDyYeKETBuALRryKDDXgXdInG45SiNG6ZSWQv2BrYtN8OFHaFq9nJcQrcIyV1aP5KY
         WuSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lYFDP/p0oDmvmHQzvKjGd+SXW0/wWau3FYCTmUlV558=;
        b=yWY0NrlNodFUkOkCTfH1bQ6KZNdlRGEsinsyJTqADhHiLltmaSmS9Ju3xaVbEUrtZo
         7PkxKbYnfA7ylPxqjySQ+gsSKLvnf3N5kncLfcneIik8pDzO+uIXbSLlzF6K34Fz60YT
         fMx1NulbGSYHrA/NUxcvV8QsB7BwuOy38xFPRJEYN8YDiPU7tx2GZVsxUX6R3d5ZsmfG
         aFiBqsoubJApGNOgbtAupUFGCi1An0BcOvjT4S+JgvZQVlin/NI1lX4FGM1JXbiagUsu
         khgzIxct6r65Ki7AME4uOJMcJ5q8r7m/iHdTHvy6wnsAIpmXDYwasuxZza6q89kciHt2
         OGSw==
X-Gm-Message-State: ACrzQf0KMzPOjAihKL/qsrJ0K84zI2bTn7UUIyOkVUCB57SLtC2Fcp/f
        l8rPnVnL/UwUxUnAZ9Q1SaY=
X-Google-Smtp-Source: AMsMyM6Bcwqzloi8IqpId4CQ8IbCa4ngymOT+4M2jos8pnbEQnC2Crg/VDmMPiKOEn9gnN/J/iqPwg==
X-Received: by 2002:a05:622a:409:b0:35d:5a1e:888d with SMTP id n9-20020a05622a040900b0035d5a1e888dmr1576695qtx.561.1665694400946;
        Thu, 13 Oct 2022 13:53:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ez4-20020a05622a4c8400b00398a7c860c2sm737799qtb.4.2022.10.13.13.53.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 13:53:20 -0700 (PDT)
Message-ID: <a9c43deb-b553-baa4-85b3-edd38ebf2f0f@gmail.com>
Date:   Thu, 13 Oct 2022 13:53:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 00/27] 5.15.74-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221013175143.518476113@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221013175143.518476113@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/13/22 10:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.74 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.74-rc1.gz
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
