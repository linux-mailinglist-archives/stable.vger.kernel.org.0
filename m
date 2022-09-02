Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE595AB7E7
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 20:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbiIBSA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 14:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236064AbiIBSAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 14:00:55 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7558F63FF;
        Fri,  2 Sep 2022 11:00:54 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id j1so1988653qvv.8;
        Fri, 02 Sep 2022 11:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Jbms1HIha0aMqLul65bCHKVP46BkhL+XHEeUL+b913c=;
        b=d2stSbbEu1tcK9i4Ab7B4jqL3HXn/JZCi3ZGYTAxrfFY0+PyjEawzkfO/mcITf3AIJ
         5JuJcu7+QQH51iSBMcZ6UyhSBYVJjf7aDiUHlQdwN/jzlhtVkfVsP8VLJyWFlkA4cgwH
         mmUsVgCRkBiJWSRTm6/PnS9wKAhiyFP+OaQI2Ep20OadNoxLRTnj9bC87b3hip3HIhT2
         jWa/rMVvT+yVTCj9wwqh2CSX44tg3sGZdJXjXbd8875fq5bALhdmGqjGe72zvAq1EGoo
         u2iPfVui8BV42hvJa3/VtHQ/E7utfVZfLMgiQoblb4c8YMcr4xzbd9vysDtabhHCE6J3
         F/ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Jbms1HIha0aMqLul65bCHKVP46BkhL+XHEeUL+b913c=;
        b=ISDQ8TO+7a2qN/S0TJ4jYpuE2qGHHUyw2nySJ0m7jAzCFl97IK7ipmaA5mV5kO375T
         Cu5d/T9gqeZEtMWbHcB27FpDao72SQi1n/ejSHd81u9Ny+1ifCOWuHNZEjw832ituWhK
         3s1fR5c/KfwFj5mdKLoI04WjIVLPzrkcXgKf3QkWRwBsYCpQmzOFtK+zvO08CQyJU3Cl
         hOOhiO4a5nfiF//Sl6QQcsoDByY2dCFBj7o3PSV771KQGLcOhnKBTf7A4oJ7eP1nVuNY
         xPBeT9u8CMztHkFJnWnpfBi+wZcF4gh/dVMGpleSKU/7lXiJaA19tyrfha7zYSi5vnMK
         IRIA==
X-Gm-Message-State: ACgBeo3O7v1MsMqdZCsP45/2G34uERQwxmZI6T6kuNyL01ZrH63G1C5i
        0VNDm7ZzeaGJ3LNnQuONuJI=
X-Google-Smtp-Source: AA6agR4bO1J1XhYSTcN7lBT0vqh58aCMIe/pBY8DUiT1GE+NdweDzGAfrhBBiPY/7vLQOKWm56HIkg==
X-Received: by 2002:a0c:db8f:0:b0:496:d7fc:a4f3 with SMTP id m15-20020a0cdb8f000000b00496d7fca4f3mr30551065qvk.82.1662141653844;
        Fri, 02 Sep 2022 11:00:53 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id z1-20020ac87101000000b00346414a0ca1sm1365474qto.1.2022.09.02.11.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 11:00:53 -0700 (PDT)
Message-ID: <1ccf4d76-5590-5dc3-e639-86da751d6544@gmail.com>
Date:   Fri, 2 Sep 2022 11:00:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 5.15 00/73] 5.15.65-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220902121404.435662285@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
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



On 9/2/2022 5:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.65 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.65-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
