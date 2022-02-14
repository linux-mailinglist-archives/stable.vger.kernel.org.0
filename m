Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CD04B5D90
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 23:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiBNWYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 17:24:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiBNWYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 17:24:52 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E270212D239
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 14:24:43 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id f13so13471978ilq.5
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 14:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ogRV7ZSL7SDSAR5mn+RUaB80LZYIK0RrJJ+hPOyIuRg=;
        b=ZIXxLgwBvDXHQWUbbXHQ81y/5BVhla341Wp8m87N2iubaQJ9OBrtnUmcx1J7BSE8ZU
         Pt6jUDt+lZpMz3y/hn26U+yUT9OzjQ3cWK45K1Q4QjK5EEWW3pWBEXHV52JMxgeOLrqw
         yFfhgvtOqfkq3il7yX3JW7jEp8kIAEEHXPtcQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ogRV7ZSL7SDSAR5mn+RUaB80LZYIK0RrJJ+hPOyIuRg=;
        b=zLVeLwa/2v/HVF/aUxGpwvu1eq2/9Dws9fSEzcrOVj3UCdIR+9CtzUnAVIpr9/pS/Y
         OyGWU8zEzpmgB7yrPSXAOzp0yuIdhO7HHrO3AWZSSrLvaSXwJRLBfvTaIq5Eh1MHwgOS
         FXyysj5jQYcAuhCcT/6xb3LoSi4W0WEpVPd/o6pZ52a3Iiz5FORbKwY+3RtUDfZjvmaH
         tGy2IBNhlagq1jS7xtu1k5CzNtm9Af+FJtsjFsogqA8TGOZ9qoHAJ9d4N/QXWeK65GDN
         VQLY6SjwoGwpVV8dIApbkl63EbAzpASC0S7sYkoOMQYgXsnVSYK1N/OQg3VkIw8fEjyM
         lz0A==
X-Gm-Message-State: AOAM530QuRdZJFXwAxeBSdcpaRNj4wC87kKRnf/NQv9Ngcbu5ZUSDUbu
        zsBFcCEGyaorTtUPb54rC0i1DQ==
X-Google-Smtp-Source: ABdhPJy+yRcezzlrG8jzeQ1xoMVYfeFa537j9WWCm8trI6pdLHHT6CAwujU3eZ2roCW+V8HcyuXxZQ==
X-Received: by 2002:a05:6e02:1524:: with SMTP id i4mr661086ilu.150.1644877483326;
        Mon, 14 Feb 2022 14:24:43 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id r7sm14197766ilm.14.2022.02.14.14.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 14:24:43 -0800 (PST)
Subject: Re: [PATCH 5.16 000/203] 5.16.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <80bf4bea-02b0-5823-2089-cac242950366@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 15:24:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/22 2:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.10 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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
