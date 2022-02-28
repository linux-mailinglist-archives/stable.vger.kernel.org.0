Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37194C7BD9
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 22:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiB1VZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 16:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiB1VZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 16:25:09 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F97C1201BB;
        Mon, 28 Feb 2022 13:24:30 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id e6so11250042pgn.2;
        Mon, 28 Feb 2022 13:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/BZ9ICbf1U+hKDT4v40btmacZirBqs9pkjE0c/BZegw=;
        b=J6VTALh0jlhAPsV9di0Bt9jFsK8X4itmOEoLHplua8jA94wngD29TXhEqJbbRTxK0P
         dwYqogijwYlEz5FzHUX+7gCfHJTY3IExnEjr8iPnyG3Hw2+Wl3tzwrzFosAHmJZpzw9O
         LniBNTugcnAR3uzlzRyc3hJi6z85d6VgWL26MNITazp0Phf0QT3VSh5EUCm8hSEUA55l
         Pmcpsw2872auO0G83rd7KE0FjysfnY3XvT1lIka4SPSXM3NhqOO9FjcrkwmCNCwUVSDT
         u+sxaXph0Li0G+lVvpxVtU2dM6mFjQCgnsOpKuYzCAN8qIl1D+x7Pl0Tx9cI+Zw2xMUz
         Nmtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/BZ9ICbf1U+hKDT4v40btmacZirBqs9pkjE0c/BZegw=;
        b=71rbxHIheMTnGsMd81DqH99PJ9ZByHCNXruG/ZFBCoyoxM49rjd2FxKwmgnIdpI1za
         DFxI6spAF4jiCagbL3XYirITHmPr1jafzb7dBWsz5oYTSNNnpP/JenigJToezs7cfVr8
         fBErvTQ8g0iLlDpMwmH8ZbnCrXM51nGvpbfyolfYn8jjuwcR3vX4NydJWOu69MrmTcoc
         ixIflalAxHPCnAM5NViHDbCuQmjB0RFUYXfzLk4GvdBSJyGwNowRusxgZbsDgnJNiDrS
         iK9lNxEZYjaihRzrf43uEfJhx8zUNMuABF+SftMqUBUhz9Uq9RL5CIsU1bAr1aJ0GGU+
         YUig==
X-Gm-Message-State: AOAM533/RCMuYeJiCkc7/9NBK4ydKqThCyTgoRTPCMsJ50HO9NiJmpQp
        4ysxUlGaWW0XRLRd/+OUzyo=
X-Google-Smtp-Source: ABdhPJwlgZsp49t98S3sfpFV/5jNHYOEK9jcl0aBJV8JgDhrofRirUn/jsTGnZ3ubPBatQ8OgnCfoQ==
X-Received: by 2002:a05:6a00:1901:b0:4f3:c0f6:5c47 with SMTP id y1-20020a056a00190100b004f3c0f65c47mr22673731pfi.69.1646083469641;
        Mon, 28 Feb 2022 13:24:29 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id z14-20020aa7888e000000b004e5c2c0b9dcsm14761445pfe.30.2022.02.28.13.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 13:24:29 -0800 (PST)
Message-ID: <48c74800-32c6-0327-52e2-96a59c1afda3@gmail.com>
Date:   Mon, 28 Feb 2022 13:24:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 4.9 00/29] 4.9.304-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220228172141.744228435@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220228172141.744228435@linuxfoundation.org>
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



On 2/28/2022 9:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.304 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.304-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTb using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
