Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23F855C1F7
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238461AbiF0RTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 13:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235998AbiF0RTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 13:19:23 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A9C2649;
        Mon, 27 Jun 2022 10:19:20 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id d14so9973616pjs.3;
        Mon, 27 Jun 2022 10:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ysyHj5D8vVyTiM+tvqv+JQhrMuadO/ymKqFjwXqEZbU=;
        b=OaPn4+NbdQA9w99YYnDiArYTYsmcxLtH2Q8zJvu1DVs0WmRsZS/bXvmUvAikbOfAjD
         aMwPN4kCJOI2ApT697kMTCId9bMKpaITovS3DkAPRZMrNcQT1dbtkkAZu+sXSe3HEjJI
         5bdSiTx2G/FFt8WhUA1zowrebBMr8mbrznPl6MWOt4q59xnKDyVYjPtegK40H0ab1W1w
         37zzULSEiY30Tlk/0d278FTVOp2/+KXwM4U+kPAxcrjX9X/fMyQgmOHUMwbmpY2AvoKZ
         OFWwZN/+JaW9eo/aGTGgjeitrt5zMNMa4vHnpLuDb642v4qSZhVCb2navhq+KiC5gWB/
         ttyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ysyHj5D8vVyTiM+tvqv+JQhrMuadO/ymKqFjwXqEZbU=;
        b=HMwJHR6YoEuVBaVqUHG+4cFtY9M+5Mgz1spQBQvEFgYgX+tsAbKRziMS/KuVbCUK4c
         mdnYgRkt9NJaoKyrrq7GAy1jiYI4E9IexkzLNRFqBRum9w2sB5T6FGKJ73KDyrATgUzW
         VoAwCB2O5ZohYYzkx5I0DmWqqszVPQ+TPyjLof8KucVPIOuWFoBYeMjn1//BRrRMdrld
         5Ry7q0BazfddHyCB6txF/R3VsHW1E4ShtTb5GmaIrs4HIKgCAXPhg6pZexI3YLFhYSgT
         y+shLcDDjKZlkUKnYJqdZg5fmacuy/Cj2tjgUYAWaMeYwlWgj29/uULdhkg9tSzp3EFn
         +1JQ==
X-Gm-Message-State: AJIora/QurmtTWKJF76unl7flvXrF5d30Ugcx4YKUOE16CpjCXSAekEV
        Y85LvBZfJK/iKcVg3a5nQC8=
X-Google-Smtp-Source: AGRyM1s2aO9Xe7cC/M5CrJ/xp2qTBJqBPYuBKTij8dz+hVvvro23qC5p+aoJVyZ/48MqD1a3nEm1NA==
X-Received: by 2002:a17:902:ea02:b0:16a:4b1d:71d9 with SMTP id s2-20020a170902ea0200b0016a4b1d71d9mr16257318plg.52.1656350360298;
        Mon, 27 Jun 2022 10:19:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y3-20020a170902ed4300b0016a1c216b73sm7536086plb.9.2022.06.27.10.19.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 10:19:19 -0700 (PDT)
Message-ID: <9444e633-3513-8cd4-fe98-01fd82598d6f@gmail.com>
Date:   Mon, 27 Jun 2022 10:19:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 000/135] 5.15.51-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220627111938.151743692@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
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

On 6/27/22 04:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.51 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.51-rc1.gz
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
