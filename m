Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E33454A1C4
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 23:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiFMVuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 17:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbiFMVub (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 17:50:31 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1869183AB;
        Mon, 13 Jun 2022 14:50:30 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x138so6873621pfc.12;
        Mon, 13 Jun 2022 14:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZTQwpAOp9AcUkA0U6WT8EGdzTxalKTj+KD7FQNTIe3I=;
        b=bx/o2QGsa4QNbSEQm8kD5tWvm4mgWMiI9JDlBj0Rg2WQVa5sXW0x99Ykohg6u1jNc6
         I/ZZMQtIS10ghMV7EDnjwvK5Vl7/TlOSq3szdmC1REuD4rNolKxTocu5dQ9kW1cnZckz
         lPwR5LKexecWo4bit5sj+89O7SsRYsDIdlXsgC1acThQHRTIUCaNM8pBzH3tawCW1RJX
         CIuuUB3X+pMQ2YxBnKFZkoZqlN+TUsyYB8p/AqntNMPD1RgMNy8L1X27XRPJzzWdCXIJ
         tQpCojGCrJal01gQI8GjftHeWPyIElPdbUsK9M/3/U/dmBGbkv7bjvVURAxtN1kbT8/e
         p8NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZTQwpAOp9AcUkA0U6WT8EGdzTxalKTj+KD7FQNTIe3I=;
        b=MxQrQva0w3SoxwY2M83efXZJ4fQWD9pf+dfHmypj4L0BS91wfgzGE7EGpgtuM55TVW
         FVzCppC6pyznLTy6ByHofmg8VlMsKuvTm23x2+JAC/WONjC6reZUwv35MJJheDdHpHRU
         +jHP2fOrSEZwhSBrVI1PeQhRQCK2dUWGbftDLDAr0ruqDqG99sA6fZwDOdNwhZbxffxr
         tSgLAxb9ZInVgflSU8yKMJjyv5qW19tYzJbzyz9NvvqtAVMS93Sas+4HsxADx4A3GxPp
         8Zlu3qzFODRnZ6w2T1t7R70yyiGHowmaUbkHsrEIyP09eyTCR+E4pTXF/uMf2DHJd5gX
         CLgQ==
X-Gm-Message-State: AOAM530sLOeRaRvbLz+7eSN9K5eJSMbgbdscVsQQY/nGI25YsyLuVVKb
        Av/8/SoyWLQIkBvMStgiT5CIldsocHM=
X-Google-Smtp-Source: ABdhPJwzNn7V3TEIYXhCR8aot4l05ka9/RQ8tWiMgytrjscLJzpCEyrPq8uzfLE3P3Y8mNJmwLjSqQ==
X-Received: by 2002:a05:6a00:140b:b0:4e1:2cbd:30ba with SMTP id l11-20020a056a00140b00b004e12cbd30bamr1303795pfu.46.1655157030294;
        Mon, 13 Jun 2022 14:50:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c3-20020a170902d90300b00163c0a1f718sm5579898plz.303.2022.06.13.14.50.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 14:50:29 -0700 (PDT)
Message-ID: <c65bcfa9-442a-8966-ded2-3a23eb3badb0@gmail.com>
Date:   Mon, 13 Jun 2022 14:50:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.18 000/343] 5.18.4-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220613181233.078148768@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220613181233.078148768@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/22 11:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.4 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:11:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.4-rc2.gz
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
