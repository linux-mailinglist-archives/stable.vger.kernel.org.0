Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94864C81AB
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 04:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiCADgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 22:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCADgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 22:36:36 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECDF3614F;
        Mon, 28 Feb 2022 19:35:56 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id c9so12451902pll.0;
        Mon, 28 Feb 2022 19:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hp4t2uw0/sPgnHFofQlHvuw9mmi+UuEE/SFLLt4hTuw=;
        b=Pv2oB0lHPU53DlZEWc3HQnbprZRc+OarkESkbAYQhbqrkZZYWQDt8mI0J5MbXmXHY2
         Vli1HEkJ8u7M3YZH3HF5GaEWhFNg0nD/Npg4Y5yhN1YyxF3B3zpKFoHI9SDpkOtZ/tOs
         jxys4Qg0+p6G4Jo+BMBtqBEcwXIcRWQUWriotjDG6EAncqoKRx3JXi/vj3aFr+IpmVjC
         FOMmCpDgvaV6kb9RtitJW77SzXH0xWHti2PYA/uIbQP8ppYqGJ5hmad5H0jHaUVL08MQ
         hPmvgkNOVl57bjlbD7nx5i7B/6Lt9H6etc+LCvBJ70Lj6NsS6+j742XSGuWC9esWP65b
         AV6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hp4t2uw0/sPgnHFofQlHvuw9mmi+UuEE/SFLLt4hTuw=;
        b=Ra90NIW39uFDHYaZRMRRWkYxfKacHkIJr00d8ZwidJovozyQkLMtNTOzASPypixMB2
         E0IsMv+fIGCZ75/q1jKUo9QuVpCkrJk8svQLtQHMdRym3MGsN+n+1FRGp94tih5bsqiQ
         zCtM0rrJv4Qh2TvJDcOTnFX+Lg89DH+WCGQ+8X2Ar1S22jYEpCLJ7V7ZMV4BoVOwXC/R
         FBWZ/K4jhATHOFqNEG+ta3ep26nYxFwoqOdZx9aiqO/InPv/jhBwggPHCojr9Bq6f6IP
         fcwl6aNNs9rwj47wJacZiuepfXcJoMSp5VS6EkEMzSfLSeqKBi8bqd8V7djyuMTRXIl0
         NF8Q==
X-Gm-Message-State: AOAM532fTq1xNcwNfGm2SI8rmgxzq1/zFYi5PJSD9T7Ec3wAal3f90sl
        dNy6J4ApkyN3RymABgMA96A=
X-Google-Smtp-Source: ABdhPJwgvQYs1aylJoUqiDY6UpYCzi1VMR41xneuFI53OM39Qi3zfktNU1RjMAYGvip4+5h4z/EP2w==
X-Received: by 2002:a17:902:d706:b0:14d:b09a:a0b with SMTP id w6-20020a170902d70600b0014db09a0a0bmr24432587ply.52.1646105756154;
        Mon, 28 Feb 2022 19:35:56 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 17-20020a056a00071100b004f0f941d1e8sm14257058pfl.24.2022.02.28.19.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 19:35:55 -0800 (PST)
Message-ID: <1b40b00d-c408-9040-7267-0325ddd72a72@gmail.com>
Date:   Mon, 28 Feb 2022 19:35:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 5.16 000/164] 5.16.12-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220228172359.567256961@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
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



On 2/28/2022 9:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.12 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTb using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
