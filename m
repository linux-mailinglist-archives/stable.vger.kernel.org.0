Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37B74FFBE0
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 18:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbiDMQ7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 12:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiDMQ7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 12:59:05 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E70F6A029;
        Wed, 13 Apr 2022 09:56:43 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 125so2317140pgc.11;
        Wed, 13 Apr 2022 09:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wulehCKZ9CzkZdNSpoxl3pLVYOp3Zk9PVvJlllk+y8I=;
        b=nyAUdImgrTwhrcUpVxaBvH+jx9VYnKRqN9BUVE/T6dn28rNpCRSiRahYH43aBiYhCP
         jnxRsD3NeVTFgd6NrZCzqkSRJK6lihCiDKt6r1n3extUdJ4TOFHx2hmhGFbBiZPm9e8J
         AOob+KnFLrtA9Ob3yCrR8LfRgzT293D1xFYhfwSRrp4A94A1o12h8Hpp15aJUf+7MEN6
         YMFlUI9P2j7vSTHWOQvy5eoCOc8Lr1UadPJp8C0N5uuwvk/pULIHuOf7HGe3VqnljKmj
         LvlHkEP2f5xvDzIZV0v58RDyQ+ljRdOc+LO7ec2FyWGAlHBIn6c8U0Ct6LreYrrwk72M
         IxPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wulehCKZ9CzkZdNSpoxl3pLVYOp3Zk9PVvJlllk+y8I=;
        b=KCsw4IQdU3vt6JAluvktj+KDCfJ2raj3UjfrDpzY3Ws2jG4NOW9uv+Z7VGPGpdxE3h
         TFCOapJ6DZw1BOala7vE2B/nj1Z6+ioejziVoeGWqqWA4eFzQLAc7rxzmGAaOwx6jz+E
         IjugPIssH3kghPEj2q3cElj08az8ACgcSvFM24NQhCQBm2wIIrMO9VIlmo7bG9qcFgGY
         pUOeDntZXNukE9oukUQM2Uqbk/k1M8BZa7skah5zyAZF40o4rRWKh0wc9qoTuz+2zgsl
         TIcz4CzBXqyOwQLj3Dtbi6+W2oMaZeazY3dg8Couk7KIasfX1ZmfKKvOhVE/YtH4Gmt6
         1I5w==
X-Gm-Message-State: AOAM532nXsPYaoLKt6LjPPuHN+apUXVodAS/maXuKhMl74+qBaGXDaym
        KAxHV5fgO03C+GalEXL4HIQ=
X-Google-Smtp-Source: ABdhPJzFMkSv6sxQM8M75/+HeAn97L4EpIhOemkvCXh/OetwEuhSw23yxATgg01hr3OayEksPgVJ5Q==
X-Received: by 2002:a05:6a00:1304:b0:4e1:2338:f11e with SMTP id j4-20020a056a00130400b004e12338f11emr44265176pfu.24.1649869002880;
        Wed, 13 Apr 2022 09:56:42 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id s89-20020a17090a69e200b001cd5b0dcaa1sm2443600pjj.17.2022.04.13.09.56.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 09:56:42 -0700 (PDT)
Message-ID: <712c71e6-0bde-1e04-9181-5ced33de2b90@gmail.com>
Date:   Wed, 13 Apr 2022 09:56:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 5.10 000/170] 5.10.111-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220412173819.234884577@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220412173819.234884577@linuxfoundation.org>
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



On 4/12/2022 10:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.111 release.
> There are 170 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 17:37:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.111-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
