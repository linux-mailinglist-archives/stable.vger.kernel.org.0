Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0D9583556
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 00:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbiG0Wcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 18:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiG0Wcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 18:32:41 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE23558F7;
        Wed, 27 Jul 2022 15:32:41 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id b9so343788pfp.10;
        Wed, 27 Jul 2022 15:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ivh+CA2QBuTsxQxgs/9XoowSnafhpFdMSsuyg7e4DbA=;
        b=k2qvuReON0hBkCipJlggQaNyT8kAxJXAdDOAfQR6kXoUr9HDMolxIgJf+3gs/BFtUw
         4p/TyJqxYOp+K0j/iGgrmpPexQ+TWrped7s3oUaiE0CLHdh7JxitPE2/ENO8GJeNpaBa
         nRK98KN15UNY7P6Vus5Cy4LiJDiOdrxCBdLYpOPwXK4eTfcLwXG3nJp1QmLJSC5auQYZ
         QciFV2T3252cid/vcZE4yXcd/PMxWKVLKiIPr2UiqPWwUc7269Q4YqRSn1nRA4TymKdR
         78eMdxR9KjqVSA/Upo3UX1Ax+e0HKljU9Raaa/uzc6+/cyGv6m4d8ksd0YLS3sN3/m1g
         phAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ivh+CA2QBuTsxQxgs/9XoowSnafhpFdMSsuyg7e4DbA=;
        b=vhmNCq4Hw1UzcUOhmuU2vGm1gUaBe4BbmDaC7HoH6bbeYX5GpiGen5ivNB99omYyaL
         +bmC6VScupfWk7tRIl0YRL4ersmJyTzm1GxbJJ9UZRXIEhB79yX5ZeeU//ohUm30Rz33
         Cv2hQWbASDHZxta2m2+qCWsX9Z0+d38b6GWcVPz0mLusQDsOaRsF93SGIlgAKIhSFEvZ
         tGqqosOEacG1XmB3O3NS6ZPOhrRXcZZS6LKqojx76+frp6sIH1cywtIye2yNk3r8fixX
         MMoZxOCERsUT7OjEza9W6hn4OX22PDxMjisZ1En5+nzOCAVQ5MbwE1itHvpbi+bQMShv
         RLbg==
X-Gm-Message-State: AJIora+UQ4h/XMzv47hboi7bQmxwwEHRYpI+WDCN5X2IujRSx4tKHDM3
        o4ArHWwuxUfCRfUq+5QIMlk=
X-Google-Smtp-Source: AGRyM1uBFa4ee+vJCOJTaUavzQLcTHZ8WSwyJtau5XFR4GIjqIz1RiVyQWFo0yYErbHaduIrr2LbEg==
X-Received: by 2002:a05:6a00:99f:b0:52a:dd61:a50f with SMTP id u31-20020a056a00099f00b0052add61a50fmr24375557pfg.9.1658961160516;
        Wed, 27 Jul 2022 15:32:40 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id qe13-20020a17090b4f8d00b001df264610c4sm3973215pjb.0.2022.07.27.15.32.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 15:32:40 -0700 (PDT)
Message-ID: <e526d967-1601-e451-0220-6275c0edfd35@gmail.com>
Date:   Wed, 27 Jul 2022 15:32:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.4 00/87] 5.4.208-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220727161008.993711844@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
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

On 7/27/22 09:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.208 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.208-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
