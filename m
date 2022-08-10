Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910EA58EEB6
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 16:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiHJOq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 10:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbiHJOqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 10:46:50 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2E161100
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 07:46:47 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id d4so8388378ilc.8
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 07:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=SfFZHHAcVd+kOmri6C0f7K4Tf+tdshtHftrDLHABmA4=;
        b=J72rCbJ2B3TF3kdYJCO1d9Uiq+lSco5cMBpKqasua9iBVVrR68eIAoltXfk7jtDeGy
         EFoPlxQTAiXLcpomqoJVd0v+PA28h3GnXDnmHatIwcDyuyVez1rDd2/9G+FDaoPoSHY5
         H8oBWlXxkcK2AxPlMxuVliYEe1G5SI5ulnD3s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=SfFZHHAcVd+kOmri6C0f7K4Tf+tdshtHftrDLHABmA4=;
        b=gF9199nwCkbLKo+DnYhl0uhQ9O/MnwpS8vxi2hjX3kYr/KPy1xQuW+Bzvsvig3e87T
         sjN46t9hV0I/X5dNmufDJDuvyBiMsfIsWZWXS9O+zNZDJbtB1BsALQcxlXz324i4IjqF
         A2BpdFLhZw4Zo+ghprI0K6F72rgQzrGO7IcdWu2S7YnfcAN6irQHzHKp9cMYfJ+m9+hf
         NQy3iDUfiQkPwN04OZGhGuUoLht3DoQbPVxyVRYKvevkh71mQW7x80zwCZYDKpgiwr92
         /Psagqk/VgFTUYK7zvagFmw7UxiIVGR696Q/1dNfKJrVEWbgRo0MXjp6/HZw66gB5Kvi
         tIwA==
X-Gm-Message-State: ACgBeo06Bwjee9CjR86HZkYZg6u71KI64lPHolHBiVujgd6lmgWjRWQU
        bFcmy9DOAYPeLlsKk67Pwyphvg==
X-Google-Smtp-Source: AA6agR78OS6so0+UPA0bin3J9DLGfKxCm0U6SKg7TKrC8hM1dIoOyyq+fXan6DDHqgVKJGeoMGhhhw==
X-Received: by 2002:a92:c26d:0:b0:2de:bfd7:17e with SMTP id h13-20020a92c26d000000b002debfd7017emr12872921ild.156.1660142806505;
        Wed, 10 Aug 2022 07:46:46 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q4-20020a056638040400b003429e0ae7b6sm7471795jap.125.2022.08.10.07.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 07:46:46 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/32] 4.19.255-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220809175513.082573955@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <573b83ee-0f91-043e-4e66-9ed2c2a91e3d@linuxfoundation.org>
Date:   Wed, 10 Aug 2022 08:46:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/9/22 11:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.255 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.255-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
