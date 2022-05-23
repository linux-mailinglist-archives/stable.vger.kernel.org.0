Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D17275318FB
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiEWTVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 15:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiEWTVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 15:21:15 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E422BF50;
        Mon, 23 May 2022 11:59:34 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id w2-20020a17090ac98200b001e0519fe5a8so115574pjt.4;
        Mon, 23 May 2022 11:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Z0mv39OqDgZ8RxW5qBdf3G/9tpcn8YoRwpPOzCu5TGU=;
        b=JsuvkZ2CB/hi6lgGt5mG3LcRgUwbvDhMGAjGyWnt+3GAD8P4dqQr5pXIc9bvkhCE4Q
         8OKVjX1pDB1yCbBCrUxMywwyw20MK2m+3g3IJuAV9ffDy9ZTBtUIHTm52cwImBdqgcIt
         ZyUA0ZOlQCbFdHr7/ZbbyuAzbdyVc7oYNa0+/Moln5tcQKow/fPB7jVYiVgEgJBZ5mhJ
         +OXcBYL3I+iUuy6/nV87EwpsKVPRjVetpLoGXkjkd18PRx0bpuFdSIKE9aq+i3SQXHFS
         ubc+VHMXw0NgWjZObiW2oBPTlZIbAZSkZe5KxhG3bp0wf57p1DHHxa2xun4qxpU0JK4j
         7kgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z0mv39OqDgZ8RxW5qBdf3G/9tpcn8YoRwpPOzCu5TGU=;
        b=meOKnKQvRuPECDv8LskcGdk5SHXU3mYdU05OWFsEXsoMVutA5GMgdhUdW/qfii2NEd
         R4rI7MLQurqp5jUnVnhpm0uZtVIGmOTXuBnL6+0udQ9dVmus0l0ZuEQwkx0S79QZh/PA
         P/tnFNln1OrhRnsdOocpK9p6t2RFlPajh4meVKzlFm1dlYcmHEh0NR0LqCV/3QHlOdJg
         OV7Vel6tfSJzsLnB7c7E7t7AgjHOPOX5TxsndQVo+w4xcQqt0Wad877kjKNL/fTD2jWm
         Ny8rMFih1CO8VAZ4puDU5Wky0ZH8nEbDLPEiq2bwWPnIsaWuMyFxCfc97cGWGG6HbM5f
         1cTQ==
X-Gm-Message-State: AOAM533uNc4qQrYTbUzYx88m7vTY6bKyDSK9CcFJbJbBCpR1057NPH1O
        mKPK/G7tOWVGIWwxGHp7c2U=
X-Google-Smtp-Source: ABdhPJwHkwHPgV4OcofLcHHU2VqVyeEST/CIl8XaowcmISu3+5i0w6BkAzM32kkKUBBoofccFNWd9Q==
X-Received: by 2002:a17:902:9a07:b0:161:fdc3:3b9d with SMTP id v7-20020a1709029a0700b00161fdc33b9dmr14765427plp.94.1653332374122;
        Mon, 23 May 2022 11:59:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h17-20020a656391000000b003db6f4a96c4sm5064476pgv.32.2022.05.23.11.59.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 11:59:33 -0700 (PDT)
Message-ID: <eb70aa93-4107-f868-6d77-ebf8f5daf8bc@gmail.com>
Date:   Mon, 23 May 2022 11:59:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5.17 000/158] 5.17.10-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220523165830.581652127@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/23/22 10:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.10 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
