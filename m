Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B3964F1CD
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 20:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbiLPT3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 14:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPT3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 14:29:47 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC989FC7;
        Fri, 16 Dec 2022 11:29:44 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id s9so3495427qtx.6;
        Fri, 16 Dec 2022 11:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ivm4Ys7XgJf3YYzv4BAQtpAC/aUCSXOPDDFKz4AguEI=;
        b=T2KjADE3vFRdeeLM3QPEW1ZQxBrwrazAjdzbOtVetkqh5X2egPgvfF4W4abf2+hFt7
         tJJ53H4xNxgVnLzCoH9DyeXWUmrYWx2JvmWhfwNmbOkc+zFOTvGN+BM3h40zHll6N/GK
         Cm2Ou4Qb1L0CV87Nluev0yXYuQxqECe2YaNUIZknKnhjfdZj+vPyGuuOOmsMDiXhlEaE
         rWwpltSuLXzrDOpBGrHRy8I40xQQOK2gYwO6PJAU3TmB5CdOpO9sh6cJc4Z1TE3q4B2F
         2Qxf3jSOrIXtT60nhds+Orh9UuZ1Dd29bNuqvhFnDzDSLRxfIR+gyRowiokookQutO06
         drig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ivm4Ys7XgJf3YYzv4BAQtpAC/aUCSXOPDDFKz4AguEI=;
        b=YSPbIB9G0YKzNNMp3qdPKZRYVa/zAOajdAHB4XeS7SNXUTmmDvGLlnf16TFp4jnGRz
         +CKzh6y2OatSQrY7izVon3cw0ua96Ik9U9BWtEBXJl4F4W3L9JMWvyWHqfrkBSkG0Vkf
         ccYTkjlNq7NXMQsnWm4V2W4JP/cKtHcsv9wVojXR12TYRt66a7L//Mw4KTbRHK4pOUtC
         j7qzqlvbgGSSF3Hwk5i5gLk6HLatBFy7apDr5/RaP9j1hDPRZbMJd6A6Nsx0rbW7Nof+
         mn8KG7EBvLVArnJtZ0dQ8yjpwZgC1ouj9s+S33RJrS4MFnLpjZ85MQF2WaeTa7ub2auG
         YVBQ==
X-Gm-Message-State: ANoB5pkFlqhKRzNXzTxeNIkSd2bEN5DvAqZ8dKY+5gd8conMSSvwmeQV
        hVeiSOhtODyouaku9xEe4oGdPMyHRX+Xlg==
X-Google-Smtp-Source: AA0mqf4a2wZSscbBjBMTalnfXiZzcPcbJkPZ2m+oVUABZ87B+JtRN8O6gr7/XDLHldFWYTmheWXkvg==
X-Received: by 2002:a05:622a:5a19:b0:39c:fa1a:af56 with SMTP id fy25-20020a05622a5a1900b0039cfa1aaf56mr43429727qtb.56.1671218983813;
        Fri, 16 Dec 2022 11:29:43 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h3-20020a05620a244300b006fc9847d207sm2058098qkn.79.2022.12.16.11.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 11:29:43 -0800 (PST)
Message-ID: <c25d4315-c609-2fc6-0812-12c9980c1b70@gmail.com>
Date:   Fri, 16 Dec 2022 11:29:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/15] 5.10.160-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221215172906.638553794@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 12/15/22 10:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.160 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.160-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

