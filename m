Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D8368A376
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 21:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbjBCURT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 15:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbjBCURR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 15:17:17 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9241BA8793;
        Fri,  3 Feb 2023 12:17:11 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id h24so6820249qta.12;
        Fri, 03 Feb 2023 12:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tz0vkX+QDBEXSWfMljU2RoqMurA9Jj1S2vJ9oKVLxt8=;
        b=aXJoYibQR7crF+jW9fEGAoKlJ/KsYWmA5ifgHpQ0/K0l8n40v9AZANBPYjnQ2d5IQn
         1di2VGiN+y3Is5q2/dc0EQjaAtmQaHNeNoUBO0+BqlHXE0Y+YoHyZHMps2sXfS8y6QBs
         2sT51xEeRu5weYRRGgQJqKmZeuWvIybeAtOUVajqbvt+fm1y+rKLJlt0rMs1D1rwewux
         mlszvBjqFy8Dg7ZPbtbo70D+jePKpRZ6SxldplVPlZVBtqXwMNPOC3c7725E4aROxbPt
         YSa+El7DxBDUJNi0LfikJBPmBdIrA0AoGzfhcNvI9mlxodqJAA0C1xQD1w2FEuu9/p34
         WjvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tz0vkX+QDBEXSWfMljU2RoqMurA9Jj1S2vJ9oKVLxt8=;
        b=uxCYv/j+eyYVE2cssCaNZIe1XmMV0WuwTauLY5J6uawhfEMDAHrRaJSu5tTPt84zuw
         HUz1NVk94QJepFy5PTRdimlBsUXyLwtB2HJAlX4aHlei2HIVYDRoRjSgTmqYc5uArYzD
         94GnHAhKQCwiUhXm77TxcCkVLrcpm9QQJIVI+8b5APpsxtDlQY9vmiFb4sD86vPxrErQ
         LVLFCzHSLmZUHzXLwcr4ODlQTxH/jPGrXe1k0PBIL2nxePA42Tf9q39uJfMOVRjAWXVP
         1MdiwTk0/Q3cQFDiOXH/O1YvtbgyuoUS2P9CO+k3KjoHaylMZm+eGlQ+I8uE28SK6+7q
         TMoQ==
X-Gm-Message-State: AO0yUKXWRTCRldtpoq0cG5efC8IrJIwf/am9Hy2x241ZuYv04I9ifhEX
        aCllQiDa8GVoJEtiZ2eyQvE=
X-Google-Smtp-Source: AK7set/CmQZEZRWboM3v9kcrW+AxXPaCGo0l2YSRSUATFBKPk0vu9Ry5Ooq/EcVNGZ55Sz3o7olD1w==
X-Received: by 2002:a05:622a:2c7:b0:3b2:e2e3:df2c with SMTP id a7-20020a05622a02c700b003b2e2e3df2cmr22328219qtx.57.1675455430620;
        Fri, 03 Feb 2023 12:17:10 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 3-20020ac856e3000000b003b86c0046a0sm2147233qtu.20.2023.02.03.12.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 12:17:09 -0800 (PST)
Message-ID: <c10eefe6-af9d-94da-dcb5-a8f0f5874dd8@gmail.com>
Date:   Fri, 3 Feb 2023 12:16:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230203101009.946745030@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/23 02:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

