Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB414FFFDD
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 22:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiDMUT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 16:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbiDMUT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 16:19:27 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527A28020A;
        Wed, 13 Apr 2022 13:17:05 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d15so2866999pll.10;
        Wed, 13 Apr 2022 13:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SFJUv6vAh7OOvj7gpWK0VQAtqObaWClpFAPh15QQLko=;
        b=MlnlWWB6yX4+1iCd9PpMDXaipxazEbnB8zQrOTGpONBXSam2BpnkIjnSNmzGXKHfZ/
         gbpC2qllN41Axgdm0I5yvpfXRdx+bqHImKkPCKESP/M6j6XeeOTDwZAvV6dPi6TcrgtA
         5slPNHQepK4NXwTUBoJ0Seu/NHByxfD1BvUddMHbKGiJcC3TKKBy7joR+b9Li02LiKva
         FplNvG7ojSY64NLwyOdtA4Yo5nrdTmZNwbfBvrW/wvwSQYm5wt6aO7apU1Jcwpw+UaId
         I3Gm4GWe2w0J/ZuEfgIGcaCbObNsMdY5PI65ZXP+8o196osZypt7dw8Dnz2y52DBvW35
         fNcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SFJUv6vAh7OOvj7gpWK0VQAtqObaWClpFAPh15QQLko=;
        b=SSgLHiwTNgL+lwcesjKXR2OIC08SM+OjO2uAolbphpA0/nV4K0mQ4aHZsaAOQAbDLq
         Z30MCn2utKwi6sVjXQlRIrK8Ih4/rg7e1Y9/eerEOxURKe7xdCWszLH36nGxtjtoImz3
         SGTNOUDZraTfsuiVoNmUMpyTM/eu4wILcvnldESQQpGAPuebtwBjuh2Vp+CE3JetD0+5
         //VEIV+A8ejiTiwM2JZZMWQx7/yDr7H8fS/FraqcXu1Qh1d/k4Cbzj5qFLYFwYkyIfZr
         7rPq5hA2yOUhPWuBPW7XGnSuo05ZBWG8PHXC8JVI2Ud3KGph1ARUFkfwRhyDtSXx/IyI
         5qaw==
X-Gm-Message-State: AOAM531qMymyl7mY0uaXV7/8wTguEyFEn0Cx9Iuc/HMjTq1bjsln5Pi2
        DRtW5Bbb2GrFXOj1+GfVq9tpnuKrwX0=
X-Google-Smtp-Source: ABdhPJzHB6EWrKMX4LyOgEU2jiBt3nwNpdaBEi3fMCXLgtgtmxXkSIoepS3dEvU3lZvfU8GYPrGduQ==
X-Received: by 2002:a17:902:ea47:b0:158:b6f0:4aa9 with SMTP id r7-20020a170902ea4700b00158b6f04aa9mr601783plg.168.1649881024843;
        Wed, 13 Apr 2022 13:17:04 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id z11-20020aa7990b000000b005061fcc75b6sm3218928pff.125.2022.04.13.13.17.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 13:17:04 -0700 (PDT)
Message-ID: <6ba5430e-fa09-4c31-faad-4b23893f6a81@gmail.com>
Date:   Wed, 13 Apr 2022 13:17:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 5.16 000/285] 5.16.20-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220412062943.670770901@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/11/2022 11:27 PM, Greg Kroah-Hartman wrote:
> ----------------------
> Note, this will be the LAST 5.16.y kernel to be released.  Please move
> to the 5.17.y tree at this time.
> ----------------------
> 
> This is the start of the stable review cycle for the 5.16.20 release.
> There are 285 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
