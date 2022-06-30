Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161C256273E
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 01:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiF3Xqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 19:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiF3Xqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 19:46:32 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BF15A2CA;
        Thu, 30 Jun 2022 16:46:23 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id dw10-20020a17090b094a00b001ed00a16eb4so1005793pjb.2;
        Thu, 30 Jun 2022 16:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ksja30tHqQB+wliESoq3wQHUXNoN886Osza3Cvc7dwo=;
        b=mBLsEJlhhDea1A5Ewv7xQP8wxFNNX3VXR64Z9ClPk25x2DVo7LZzC0wq4nxzrZgE8V
         jArX2vIdYg+Qm3vIJndAgDlRaa5yYyoUDuEexYnSFWYDzlbK6mzH89K0yiBqeKmHL/6G
         k4KrTxqzbL6QFbSRfEIxMei1Xj9xi7AEfA3VAR0SnIrHMxNL0gxrV40gwkI/IYAw+QMg
         HbDKGhGxx0NjDVM7fAx6aZZ4DGqGW9724eW6bZtYuCPuM0d6V/kyVvMkloKi6gYubOzR
         vF/1wK/iLx93mlemwnX41NiFsZ3kJ5C47zCDWrT1fpiH4P7fkzEzIU42mbr/IoQzOVIZ
         BeTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ksja30tHqQB+wliESoq3wQHUXNoN886Osza3Cvc7dwo=;
        b=KbyHi2qwxjuc+pq1mEotuFeMzxNm42OrL6hrOl5HXheopNtJsw2Uff2jGw6an3aXft
         vvyXsUC1zgOVK3Ro+TxfM6vBL3653u9uzm6fTbMBGUhjulGhnfvRq08+O9YCM+i9ewRt
         NVfu9CcAqzMULGVeXFkfs7MWVr/zOmrppS4Jz2MDGjR0xWCrPn6KBShVDfHXtBiz94Pz
         EHevjbw6S0jcLKVa/GzJsWu2Q2jEt47nLcqgkZ53fbkh5+KgIgbNLVkgLJO7wv+PL1Wd
         6FMorBcU1c9/6zDKQPj0g6596GEfk7QQvweZHhtHVWVCTNalOclJ8B8zOCPAZwfu7c/k
         +8sA==
X-Gm-Message-State: AJIora9rKKGIZ2qPuCQ1pvjsDqd9O7wNL4OwfCarp0mfYLA/9oswZCUO
        6AtGeeGclhXekDv1A7MB6SQ=
X-Google-Smtp-Source: AGRyM1s4N3Ywmbodo0vHw0DXmUO30u3oS67uOjxp799x8qp5bP3Cg4QiVaH9eaTZUD7QocbMYCUzhQ==
X-Received: by 2002:a17:90b:4d84:b0:1ec:aa85:b8ea with SMTP id oj4-20020a17090b4d8400b001ecaa85b8eamr12916217pjb.194.1656632783072;
        Thu, 30 Jun 2022 16:46:23 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 15-20020a17090a0d4f00b001eca3c66f6asm2554079pju.43.2022.06.30.16.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 16:46:22 -0700 (PDT)
Message-ID: <d59a31c4-23f2-1233-b685-20967c8a0013@gmail.com>
Date:   Thu, 30 Jun 2022 16:46:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.18 0/6] 5.18.9-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220630133230.239507521@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220630133230.239507521@linuxfoundation.org>
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



On 6/30/2022 6:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.9 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
