Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562DD4D8FEA
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 23:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343538AbiCNW5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 18:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237538AbiCNW5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 18:57:15 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42574193ED;
        Mon, 14 Mar 2022 15:56:05 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id z16so16568609pfh.3;
        Mon, 14 Mar 2022 15:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tkUxFtgh7dt/j+em7adxop2hrp3WQXxu8H1R5Y1Ax/M=;
        b=AcZDURPwTzl/gbtfiLrk4DvnEIbB7EfSOu9nrl4+YuYrdYCb0ajWQ+mdrPJPQIt0XA
         E7DfPZtKtLq+yRFeqX2LfBEoDKHlCyimoXKsYdn+IhkWfQJNWF6UxxZuKccHu+0ArzYy
         gzi7ry2/FeMmYGRBHj8frke1/m3SlF89FCsfHN8x/iXtAD80s9N9tix+QUJHI5lvAV9d
         LMw44HIsMeQH53bQg92Zdgx+SrjAPiVAILyTdHMsScMwNhZk0GKw3sIZZ+TAkMbrJM8H
         fMEqsRW68iVth+NVtiAlHHypiQcFYXbZa+RGjryK2bKR7i2v/lB2Yb+lwwryipCIPUlQ
         YMng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tkUxFtgh7dt/j+em7adxop2hrp3WQXxu8H1R5Y1Ax/M=;
        b=mcnZoZ0mG9bUUNSpzzthpX7/a+dpaoroMODfkjUONkMBhsjYziHSJP4tNpI8hhl94+
         OS96Pc5zbEN4FfRDaXaI4prSWieEgbRb1vfxRhZABIJUL2uvl2+CK1y6uxwviV8El3SM
         94vpN4iczVRtzoMC0Bzh6uXUYf5GPjKVyhFGGSbt/SsJzA6o9khLd1Nc59fcv2sEuMPB
         SnUdeXTpFEMm+GcNRAtUjc+g3qWM/CR5mRtS/0iLOiXDKAi/9vPF5wbsMxf+5467XmhG
         Bcx9Ijol4qT/eqDmXsChZx8qCl8F6gAUYt2Ui3kl/nSfzz2pjMu67H1BEDlOnG/SHure
         VM3g==
X-Gm-Message-State: AOAM5326e1QRPCxJvJ/8KDs6ZwzSosj7eG0gTOdLnijbShMU75+qJ9yf
        VKSYdrRegUCvKPARht6m/So=
X-Google-Smtp-Source: ABdhPJz7roehTGZWpHj0+zQhbfbRBmCaAhViYY0MW9l//VvrQ/lSnym9HFkJsAb6eJkaInAkvumLpQ==
X-Received: by 2002:a05:6a00:1253:b0:4f7:61c7:9313 with SMTP id u19-20020a056a00125300b004f761c79313mr26026579pfi.14.1647298564702;
        Mon, 14 Mar 2022 15:56:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r32-20020a17090a43a300b001bf48047434sm525174pjg.32.2022.03.14.15.56.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 15:56:04 -0700 (PDT)
Subject: Re: [PATCH 5.16 000/121] 5.16.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220314112744.120491875@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <62d287b0-22a6-e4d2-c440-d6ca20467e67@gmail.com>
Date:   Mon, 14 Mar 2022 15:55:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 5.16.15 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.15-rc1.gz
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
