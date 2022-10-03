Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A9B5F34B8
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 19:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiJCRoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 13:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiJCRob (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 13:44:31 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56291EADC;
        Mon,  3 Oct 2022 10:44:30 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id o7so6982247qkj.10;
        Mon, 03 Oct 2022 10:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=D/pIDqnzeyWYmZ2XfNVlIHN+07DkZKSXm+5e11EtwXo=;
        b=ElwpmRCm+1gm87dwrZ3UCK+LGNsQRcxVtRnGzj8lAyj/6wIeo3/O8ZPQRw8y6Rzm9c
         xlUPf1TJgNb0zZIl0w4JeREQT2VNsxB/qbYv+5BHN7dpXcYiSjZJ/Fxw0f/nNYagoFe8
         7AoXQQVY2MqIgeT4hsn19azw6bdTi4tE+PQOtmMcTJL4uWkJSM8ygcr/kt38leaUWFPl
         Wewco9CqrncWk38B9LU7i+5AHTpavLAu+G/BALfIPDjPIh7SKJWmpegAcIQ1EvLtdiWJ
         SkE71WgMEd2kZauGtcpGuJB3U+9y6fkraEh66gglg8dKRbwN+MRsmEWFI+UJo4jucOKT
         duUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=D/pIDqnzeyWYmZ2XfNVlIHN+07DkZKSXm+5e11EtwXo=;
        b=XOaRm+LZDXrHEmvyiCzX+im5C593qRXwcdOdpK2scNPGQNm2cl6duaREwqTX+CIm57
         Wz3+j50T7VkFvDkeV1InKs1uhpMqsSaPGqUlT3QZ9KCAjPYf1Nm1vVJ6+7+M63i9Gvut
         y5q2zdTfnSlLR0X7dpBEubtU98HelgVlWO29q3JDPVqa9eS2fkY3G8M7Qo3aXSK2psZ6
         9nm3BLGWvT0TJHN2sXcGNJ7DBTKypw9HxvYx6rfU/2Fts/mCNHgsbqjvhLBL5tFliHBK
         5gYO+wgRblEo2aRJLjALAZYPKVwZt3IAEuejYy9qp2xgBbQPULeplamiO9ewl2o5Bg85
         xvAg==
X-Gm-Message-State: ACrzQf2pjpxAYtHXCUt2KoVqgNZls3Y/XMf+QYgxKd3aF4y9ULWBg4lb
        5hMGzbafdH/HR484o67g//A=
X-Google-Smtp-Source: AMsMyM40rE9MbmPo7Q6eZCZh9hZqy+iNQYYkcLJLlsrVPUIIlT1otLmYUmvOSLGpZV+Rpd7mKLXzkw==
X-Received: by 2002:a37:aa57:0:b0:6cb:ca9d:973c with SMTP id t84-20020a37aa57000000b006cbca9d973cmr14501901qke.7.1664819069875;
        Mon, 03 Oct 2022 10:44:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a21-20020ac86115000000b0035d1f846b91sm10361716qtm.64.2022.10.03.10.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 10:44:29 -0700 (PDT)
Message-ID: <033e9350-12bd-3258-8ff4-340d88236aaa@gmail.com>
Date:   Mon, 3 Oct 2022 10:44:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.4 00/30] 5.4.216-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221003070716.269502440@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221003070716.269502440@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/3/22 00:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.216 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.216-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
