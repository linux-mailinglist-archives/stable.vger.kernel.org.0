Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D9B4B5D61
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 23:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiBNWB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 17:01:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiBNWB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 17:01:58 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9E81162B9;
        Mon, 14 Feb 2022 14:01:49 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id ki18-20020a17090ae91200b001b8be87e9abso463580pjb.1;
        Mon, 14 Feb 2022 14:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8JRYYIJjTV4Ag00N9ugDshOifTAtBHQ7MXz0rMIEcU4=;
        b=gkYuyWcZDJfYm1SHrV3GOwfQg+AeEO59GDTZ96XyBfxGRUiilnnwyIQa4UVe2hHzOH
         z6b10qn+0UDCb6ZUOkqqPkmhFjmZPFrEHXrlgQxblw0gPo6f/jlEwQWDyBC2rGDkMx+J
         PHPaoYjilAEglmCeYP2D5yXWiwiBpYwHsH6MpXrKhwUDib1An2YiIGAbGyo9g6sLi0Mo
         +BxFOpLrkmWqByVs4gOI6sdBQGFpmpZnl61NL8iHxSzsftwDbpu8WTOF0U9LD7NNLUY8
         9jFWIIdZRtGx5Ujsoah5G0lckwr9OhAQHswfa4U4qbNoIcBAdRWFXi7gVurjeS7rik7J
         NZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8JRYYIJjTV4Ag00N9ugDshOifTAtBHQ7MXz0rMIEcU4=;
        b=AgsflbhcYWUnhqFRHH+BUwCtWCoXVwvZPfE5AbqA9IBnXFdqqpHarHHDT44h+xS2Vv
         WFEe6qGX+D/uSkJLuAITemHih7S9yyjXxKp1vqniy4G9Bs9sFKAeSVRxpD6WHVKOzh3G
         KIMXCIFghYeaX4xQdrvU7/cD6h+/ifWz3Omf2lXgvbGwIkH4v28qcaElbH8w32E158lq
         Wi03zTabHwCNpM0+rS3cXm2Xn68b1xzLu+lCkkNXxJxD5CJz7vvuh8nPJy1+MPzDuZLk
         VVhfNQiK4LIJYuS2g/EqaI+DWxsiwEfI7NMzE4o+wdTWLN0i09uYeFNCh6y72Y2LRp6v
         usXA==
X-Gm-Message-State: AOAM533VEgyfMQNursqXuu5GTsfWSotkuEPMEEnU3PnGAKcSTXUS7A/7
        EE76QTTxdlg7fgjvMMzo8bY=
X-Google-Smtp-Source: ABdhPJyksqZZUsCRzZnby+G+h1Lv/dV8MKjqdNTvgXiV8ajte+TezFm0JzOP/Pym/hb9t9vyTKM5ng==
X-Received: by 2002:a17:902:9b8f:: with SMTP id y15mr1086580plp.61.1644876109374;
        Mon, 14 Feb 2022 14:01:49 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t2sm37078904pfj.211.2022.02.14.14.01.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 14:01:48 -0800 (PST)
Subject: Re: [PATCH 5.15 000/172] 5.15.24-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220214092506.354292783@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7eaf3216-37da-6830-b890-1dfcf2273bdd@gmail.com>
Date:   Mon, 14 Feb 2022 14:01:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
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

On 2/14/22 1:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.24 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.24-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
