Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257925FE42E
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 23:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiJMV2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 17:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJMV2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 17:28:32 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7E01905FB;
        Thu, 13 Oct 2022 14:28:31 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id f22so2594877qto.3;
        Thu, 13 Oct 2022 14:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jXfZZJP0l0pMBcRTe50/Rz6rplWvN8+bEorBTLbabT0=;
        b=R6rIwllRDoqi12bWZog70PzGcD+OwrSpYp8WT3W8SXbhnCDfh02IOSIvrAB6X+65M2
         7ovIPaFQU1gXv+gmuzEvtFZ+vYPefoFVqqP1S+jQjP8/EZh1gVAa6I6N1NR+LlOt+IVL
         CnP+QMXiFutAQO1NuUgZuw79xldiqKVxAtRD5n/lvNZwl01I4ctTzkIaJm98vqORlHan
         TYeKKVa/n8U3SxOJK0hUuPJ8dWyPhMWYlmfXfJDTPl7d7SCgY/mv2Ii5cl++ogHjG73Q
         9A40PSUb24HYR6PeXr2wPWc1xsaH0DPpU7Qu4Dhmfqt8XHzKzXFxzZGH2LlmPIqvyKEo
         dQ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jXfZZJP0l0pMBcRTe50/Rz6rplWvN8+bEorBTLbabT0=;
        b=4GJMaEPwqqR4evK9IUW0hrbkBFGJSoCnVSPUhwxeT7e9h9j078mSLjq3tA1AH19MUc
         SN6rZG3POLAhhfSiIHfSUmCtJc+26hUGSGCZX/GL1J1hn8PZIwTG9SsFsfVbFZ7kqzKw
         OKa9u93rQqcqGQijNlfH7MRbY2HVSe2+zCPfcUsGC23vpH+Zg6dIjrpSgdqF+FlW0kl7
         lPzwA05ry2VHNOEtMB8jwPDibYyHWigKZqEIYK5FqyJ+DWmVUZ937ASj6u3Us1M8hP1v
         YNhLArzMw1hywuMoLORkX8FNntjnPDBcjVh4A9pXKFwDjdx05b51STYX8jYwd0iF9ORk
         npPQ==
X-Gm-Message-State: ACrzQf3nyZxwJg4jnqQigGoBmztPsK5liE5qxpLxVx5hTOT/g3wG+ROm
        9C5xWsnDmaYZtWkTLEAB9v6trcvf3t0=
X-Google-Smtp-Source: AMsMyM6dXqUX204m7wnzDlJR8+tXz/3ko+DdPLRzfskK/5i/uA/SGZ4ZUqfBy5x5EnDHvvZLS86FBw==
X-Received: by 2002:a05:622a:1902:b0:397:82c9:d6b2 with SMTP id w2-20020a05622a190200b0039782c9d6b2mr1719905qtc.469.1665696510927;
        Thu, 13 Oct 2022 14:28:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u5-20020ac87505000000b0039a8b075248sm756752qtq.14.2022.10.13.14.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 14:28:30 -0700 (PDT)
Message-ID: <7fcae004-3c5e-db13-f34a-cda94708505c@gmail.com>
Date:   Thu, 13 Oct 2022 14:28:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 6.0 00/34] 6.0.2-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221013175146.507746257@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/13/22 10:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
