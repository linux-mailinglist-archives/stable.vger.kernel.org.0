Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10AE4D8E90
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 22:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245227AbiCNVNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 17:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbiCNVNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 17:13:07 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2763DA66;
        Mon, 14 Mar 2022 14:11:57 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id s8so16141079pfk.12;
        Mon, 14 Mar 2022 14:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y4FlVNs2QdYZ1hne9SFHL7s6tiC0DTzsD4q8fehyHAk=;
        b=KCpsYH6/c6Jp29jpMKE4KyHqYxxKhJaIadavFbMEYpu2qfW6zFbq5MkfuHiWME/0Jq
         zb+pv1ToRhrXK5AZZqXoUMoSq9L1TEMtw46pX0XoZJ8Vbc5iOUIHZRBLz5yE7G9GXZt4
         7jdkA2kVOlAyrHRx00gUZgQTZBK3mO/2w5Njl/aZN51oWB6IldRHTnjgsI8s03wyyeEr
         LBOC/WzarxZN4+pn1VH1Sfnx76D27goRmK9f2WEAYM+53ooBDwyromWLVgVMWR5Y/eUQ
         FTJ3hBq7Ag/UZnMUO6aOOfHp15fjDhr0jCeNK8kXsUlInS2oGTcFWP19+erNNtoobpVu
         g+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y4FlVNs2QdYZ1hne9SFHL7s6tiC0DTzsD4q8fehyHAk=;
        b=ocVAwPvF+8BbrBH8JLJgfeNcnSoP6mjoCqee0SoeV6Z5ux0tm4St0GCsWlfP+bPlMj
         ckHJPYaTDX52sPlU5hep3PmfYzAHEwrgEpjseGczfIe+LoVNwu2KmxcJ6EOdMXoLk2iG
         ogiPqbKlws3TGw3yRHQ3GwIEFuX2SDHsoikbSJr8Hdb2XNSnEW+XJgWUCB3NJ+goXOPT
         7SoKxoBWm7AuNRSGLqEdCj0bVOwIukKxd8LNeAYIlmDuuobKjIxbKVob4kvqMQ0JSECk
         diC/FJWXHyFlc7wiwEP3ek1OOxh1m0wGKFWpS8PNYXNIdjOt4BUpNuKG/GhC0BuqN988
         Qsjg==
X-Gm-Message-State: AOAM531N94feSrZZHjzwMXMPfHtYwRYF4aMJ3/x+dShTx4fLhBuSvbGU
        Wei4v+UNy20f+Bro4A+YOHI=
X-Google-Smtp-Source: ABdhPJwjO6+KuWIBJz0ZWJ/b8scvSG2dIKVsqBfV6hSwW83HBbtmn+CbWdYH5QClaSHMCOsYGjyOKQ==
X-Received: by 2002:a63:874a:0:b0:37c:7fab:50fe with SMTP id i71-20020a63874a000000b0037c7fab50femr21406280pge.93.1647292316827;
        Mon, 14 Mar 2022 14:11:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g6-20020a056a001a0600b004f7bd56cc08sm6866624pfv.123.2022.03.14.14.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 14:11:56 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/43] 5.4.185-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220314112734.415677317@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6ff98fb1-4850-f6c1-ac15-72aca681882f@gmail.com>
Date:   Mon, 14 Mar 2022 14:11:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 3/14/22 4:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.185 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.185-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
