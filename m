Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569755B93CF
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 07:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiIOFHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 01:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIOFHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 01:07:54 -0400
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A460858DD6;
        Wed, 14 Sep 2022 22:07:53 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id 13so10452349ejn.3;
        Wed, 14 Sep 2022 22:07:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=zojTFDyuvKcOJaxO1AymXYxpm5d2DDlLy5o8gGhudDU=;
        b=1EB3VyAhczeUfx+bPfWQBjfZQs6mqU93+XFedurORiN/pnRf/Y0P27mIJdzdiE16/p
         ImljJn+UaAWOTtaMft2qaa/4OCLg9hREnos1y3Xg9s+4ye/ze6UZICUSPmz/rJiynxSW
         WTp8mCcEAMj0mATU0YKEz1BOW4b247/HNj0GGYW6+CDGQ6gfCEra38AGD/a8cOUuv3CD
         JXpwAmd8ByaIpg09hjsNFJu61DWaoCTgVXhtgJ0E8ND0nfX1eMprdOLRbrU+31B5P+Ms
         gNYQeSjS8U2/cHr5RhmAZaov6VRrgRBEhrzyuYS10elRW7eletdRrRZremUbitl6/2GU
         mCDg==
X-Gm-Message-State: ACgBeo3YCWouBwZcWaTBIgudLb/sWpYnkUMrA87nNkKsXSOLsF4hRJm2
        U5sPk3P1ZY78PQC8mHTl8j0=
X-Google-Smtp-Source: AA6agR5aGs12XozTFJwtClQkbG2agbkGtAXRrHDGetj93UQwoDd/rxLrp+lemjfS8Q6BYl9rOJTr+w==
X-Received: by 2002:a17:907:72c8:b0:77f:e3f1:db2a with SMTP id du8-20020a17090772c800b0077fe3f1db2amr8358970ejc.198.1663218472120;
        Wed, 14 Sep 2022 22:07:52 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id p8-20020aa7d308000000b00443d657d8a4sm10790418edq.61.2022.09.14.22.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 22:07:51 -0700 (PDT)
Message-ID: <132bb286-4bc4-31c8-3780-c08985e97b3c@kernel.org>
Date:   Thu, 15 Sep 2022 07:07:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 5.19 000/192] 5.19.9-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220913140410.043243217@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13. 09. 22, 16:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.9 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.

openSUSE configs¹⁾ all green.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs

