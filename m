Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5A56B1230
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 20:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjCHTlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 14:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCHTlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 14:41:04 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B19984C0;
        Wed,  8 Mar 2023 11:41:03 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so2712516pjp.2;
        Wed, 08 Mar 2023 11:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678304463;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QfzISs/vHmZOX9zS91QPhlLPhKdnC+8JM33FXEkiNg0=;
        b=PwpagZ/XHSlsNjw0GSi48RlFC9z4Pju14ELV9qQnyZYTQc98KhnuoCis1WNMWJS+Ki
         wEiCLLFyPiHZxsA/simJm9Bu8v9Sw9ZVKJlToGCe4UP7JMkKS/C6szwlZPHK/I8aRYqp
         io6vrHHGCRHD4siKliBhgU/cxucJCow+G8LDWqLCICPicJ/SHdwFufGsED0L2ef5NbmX
         LubinGIsJvdMhQCYPFVpnSo2NOuthEYQX9JpLIchqLAKQ19YYcFyWF9w2ZI0Lm5EOvRG
         4Gww/JqSHEr0k3Q1C2gNKYN1sxkcXzoI5cRfLgTa6ERnZcL+XU0S2Pirdv2f9fOb6FkZ
         hoTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678304463;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QfzISs/vHmZOX9zS91QPhlLPhKdnC+8JM33FXEkiNg0=;
        b=WAyV2p5JtxBNdmaSePCZ6wc9qvg45IbvWILWwmPA3jJ39mbaNFb87nKW1L8UMxsOXk
         LIsgxYa69qkHnPmdqKVW4RvCMm9q9ylvQxgFs75Qx4PDp8BCP1i7az8tfIq+UA1X/u4I
         qcbVGPYTVOU0qQdtMd0gL+O/ozwDP5J1FVqno45r2esOO3I+7Yrc5hF444mPDSSHdXU5
         ieiT/aShJe9ExBTmgmIQI7lXcMRuxZX53yKeIhxYCEq3PZGTa3sOnwaHYY4AVOmcpY7S
         M0qXHoaEWDEN7re70lPKFWTuBtPOv0X4ncTYIwKLrEiNMN00qaQ4jbSDk/GyfnziIInG
         xETg==
X-Gm-Message-State: AO0yUKVL1GmY84zdDlM022qpK/oJH23fM05TnH0upG7UhZJqX3IJztzW
        UsTeuhZrgVQ5sUPVH5Bimfs=
X-Google-Smtp-Source: AK7set/XYS3T6e44xp6eVz+HRnlyus+f1bAzW0d7/CXlIzR/wADIv29/dP+KrJht1AU8lKnIUAtIVg==
X-Received: by 2002:a05:6a20:3d92:b0:cc:8266:9951 with SMTP id s18-20020a056a203d9200b000cc82669951mr20436349pzi.56.1678304462948;
        Wed, 08 Mar 2023 11:41:02 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w28-20020a63161c000000b00502ecc282e2sm9422159pgl.5.2023.03.08.11.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 11:41:01 -0800 (PST)
Message-ID: <f9d68c20-52ad-a264-0988-c8ff29624f15@gmail.com>
Date:   Wed, 8 Mar 2023 11:40:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/887] 6.1.16-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230308091853.132772149@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230308091853.132772149@linuxfoundation.org>
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

On 3/8/23 01:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.16 release.
> There are 887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.16-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

