Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFB74ACB38
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 22:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238724AbiBGVYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 16:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238704AbiBGVYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 16:24:32 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0538C0612A4
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 13:24:31 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id n17so18658531iod.4
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 13:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oT+LNhuj9fD9A69yds26bgbcEp0sloDsTmyXN4K0Xmk=;
        b=Rhqz87i9T4+CxZsMtaXLI8MHvLL4EXu/XJMC9i4QlAmPc4+LVmVf+qOrml9gTiLmSh
         O1ga2RwU5p1frAuK1587Z874ZDUltdb9uPy19ipZ2ZQAUqIHuz77OcknV0fEvmmcQx0e
         Mqbi6DSmlYBbpIk1Qeht7nI39BSWRxp9GT8KQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oT+LNhuj9fD9A69yds26bgbcEp0sloDsTmyXN4K0Xmk=;
        b=JZk9E2BjhDQsxKz5mr74ZCZOoE2YUOGHDwe3XrVMrf8EFaT5Gs7lMZlvSinUdypyl5
         OlaTkjnR+73Osd3RmUjBVC84o/nQZ2o/k4RM9ETENuLuLDVAK08ULtPZmS5s0digUy7c
         iZnkyUamLo2yVudRsLxnBztupaCclt/5RDVEuIEPTj02Te2CHVXe7+JjQVdmSZwB5Lof
         54RRQuAymRPrP2g3E9+zBqhQxosf+Hj5G/7763dkwB4rJbkK5JnqdDFiONZONXsc7vA1
         XPwB5bZnHJlQsazxzxeAzruVuzVaQoPxlD7arfyUaVYrHkwLNJ+zJWiWwD5EfAsiS4fc
         zxAw==
X-Gm-Message-State: AOAM530SXMxuTSM72gAiCJmB39ChYo2DhwWsT9uSDWrryQy747tQZSHJ
        rDMD4wC5ZKmOezK9FSvbTH9+vQ==
X-Google-Smtp-Source: ABdhPJxA0E2chBY0z2MCza+jd2jsW8HuoPBbISUT7x0avVdGWPrUm7HKgjsPkG+4GXe47poOWCEiaw==
X-Received: by 2002:a05:6638:1028:: with SMTP id n8mr775381jan.318.1644269071143;
        Mon, 07 Feb 2022 13:24:31 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id i3sm6304980ilu.28.2022.02.07.13.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 13:24:30 -0800 (PST)
Subject: Re: [PATCH 5.15 000/111] 5.15.22-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220207133903.595766086@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2001dae9-5137-9f0b-0672-f89bb35ce94b@linuxfoundation.org>
Date:   Mon, 7 Feb 2022 14:24:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207133903.595766086@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/7/22 7:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.22 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 13:38:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.22-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
