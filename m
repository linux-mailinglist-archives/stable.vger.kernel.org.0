Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E120E66D384
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 00:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbjAPX7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 18:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbjAPX7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 18:59:16 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5D9EC78
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:58:53 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id 203so3573136iou.13
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gvce8byWraezThlmNd8HU9XHmnQc8tfuTqYSxzb2BIc=;
        b=HYh6mzDfBWKp4lyw7GXWGOELICipwkoygLnBm8gbOO+SwTNBinHf6qP8aKZnDy+2Bc
         Q/w0eQbzhS660Qu3DBbmBpWmSvqVz2Eg0WGwJbmO9NteYorPYV9VeV3Ixz3XOQGRO11P
         xnOe1UTLg7mgibBT+Or3qj6AmXI8DxsglzeSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gvce8byWraezThlmNd8HU9XHmnQc8tfuTqYSxzb2BIc=;
        b=YG8LK/FkmErf5TTr7qAC2qyFfFxLBhfCIaoGw35ojKqF2wDv8ec5OiV7oK5GRUAaZE
         r97C9PpOYdILZqPuojsZ6QUvIing02p10moTYrH7G0Sgzk2WrdLarGgpKPnkYHhwmnKs
         4fbFacjm4Vx2UFr6YzTSgqFeXhxT0eg5WbVwAsS0pv1c7LSxBba3ON7q0fOw2ihLbhkL
         yH2y+wcZ1gjMVK50uK3cFj46edtEFFdw7Ez3P2dtdPXrum+AEcTpgyPiF0Ow8UsAy+70
         oIdnQWCBs/DaABck/THqpKLmgI7WS2zAhCGKvLTfmckurXlaAl3nqbt9DTzESkYTFu8G
         tA5Q==
X-Gm-Message-State: AFqh2kpJlt/1j8OxMuUTb6Hi9tGtNuyGiqyfvXyCXELq558iMH1DrU0r
        Tqd20l8eMiw7vRdBfYHN/mKFKw==
X-Google-Smtp-Source: AMrXdXu6sHtAAXL8Xvb4XXBKVeSZvhiMTxdi0Zr0P0D+1nx81UBzloPHpx3d082GkE99T1gq/jkItw==
X-Received: by 2002:a5e:c114:0:b0:6ed:1ad7:56bc with SMTP id v20-20020a5ec114000000b006ed1ad756bcmr153584iol.0.1673913532588;
        Mon, 16 Jan 2023 15:58:52 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k5-20020a0566022a4500b006df19c8671fsm10030960iov.27.2023.01.16.15.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 15:58:51 -0800 (PST)
Message-ID: <8826d3a3-a81e-d16b-82a6-aeacd6738ccd@linuxfoundation.org>
Date:   Mon, 16 Jan 2023 16:58:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/16/23 08:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.164-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
