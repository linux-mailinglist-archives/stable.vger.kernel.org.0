Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3B75696AC
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 02:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbiGGAAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 20:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234383AbiGGAAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 20:00:46 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BD52D1E5
        for <stable@vger.kernel.org>; Wed,  6 Jul 2022 17:00:44 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id p128so15457155iof.1
        for <stable@vger.kernel.org>; Wed, 06 Jul 2022 17:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vznw20ylo/oPgaF7mRf1/U3Zbr5N3zAqVrSkbulF/yc=;
        b=V9hDvwROCjPX+C6R5oEgtSGo0ouHydzzG4Bq6xVSk72kofRyZf/rsK4i8982guV6zg
         UP/eMqW5rYeyF9jJ1DHWFKmetqu6p1eWdZPpUv+Za8HwR619gCyxgN3ASHbtFMYi52TF
         Y3Qs0+lsaUrM1CEu0ZgFo3fu41GHtcTwsUX8w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vznw20ylo/oPgaF7mRf1/U3Zbr5N3zAqVrSkbulF/yc=;
        b=odxmAO+ZK7yu/IqZDbF+w61J2UPJbCN/ToRR9COWgXiqzOFox2FW9+mf06vg9GSZFK
         ngV4BEebRAXhgnbz+/h9JD1yegbqmQt7bHDL47/J8L4+MRkNkAHd5nOU9uSAkDhe1g0Y
         AXB8MPl3xsMZhYzjZu47fGQnlYe1By8gxAE73sgqZRYkzQuqZogZgyjj632jGIBUu0yq
         kafTEgNR79xoQDTDju4SQ0fmxgMkgmFkEt1kmSr0PCzIhyh6B0N8ZWBqUOvF5Z3KEah/
         0KzH/aw4QNf4lZ9dHPzoRnYudDC2MhdGXjDDkwpcZt+OTHdfk7v9g0X6drnnLxAHF7Zi
         JsQQ==
X-Gm-Message-State: AJIora/v4XoKnmiZufE2oqLUDLf+zBgjuhmfj3iDPEuLpM1CYu0aXl/1
        8JLTZvGyrgkX/cApsj8ruOB/6g==
X-Google-Smtp-Source: AGRyM1t/vmMhUrDmc0Oy+awh49RenWwNh9LI2T7h3qj65fAqYwLGFqSB7Pv71oM2BWXnUafmXP33Ig==
X-Received: by 2002:a02:cf34:0:b0:339:e4de:6cb6 with SMTP id s20-20020a02cf34000000b00339e4de6cb6mr26020492jar.241.1657152044317;
        Wed, 06 Jul 2022 17:00:44 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id z22-20020a5e8616000000b00674f8979801sm17453822ioj.0.2022.07.06.17.00.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 17:00:43 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/58] 5.4.204-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a15b3a49-7ccc-4705-42c1-b181e6f5267b@linuxfoundation.org>
Date:   Wed, 6 Jul 2022 18:00:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/5/22 5:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.204 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.204-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
