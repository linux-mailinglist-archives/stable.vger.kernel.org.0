Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A4B4ACB53
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 22:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239693AbiBGV3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 16:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiBGV3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 16:29:24 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433CFC061355
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 13:29:24 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id o10so12321349ilh.0
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 13:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jOgA3pSSAKNdGgRKEE4AjEam+tqusyVtFE0cVMEfM10=;
        b=Nva5TpWxQ5v79ciD7l3O1KNjet0TxpPDuMeNxWEt+nkWapiWoQCkOm6mYiiB7BoWG3
         +vIpaY9l3OueN4Aq0dPAUlkDgrU9KZTRwGshMITWX8nuNy79aRfChyr+HaASdCGMb0Y3
         iMsygt6b+LgwDJql8RZQ7rwVa/nur3nvYMvII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jOgA3pSSAKNdGgRKEE4AjEam+tqusyVtFE0cVMEfM10=;
        b=gKDDUg9rSuxGUPBLpYxG/t6052GFbJtTSAZyugD4Tzh8wrWtnK05ypL8L/YsgFnjtP
         o+lAoTrTu+N6z6x09+lqJruFL3jKUWbo+FK4CsvGrj5WKjSAnCshfrXPwJFd7HQl9yYb
         ZmF4WgCOtj7B/R/TggI3zmbezf0QFL6dYUgg3h2I5OygCaRSq+Tzuov2n4jm5lIcp+8b
         RZrNCVzJCwgkUWgBLttJSdqHhrsFXWK9X9V8p/3BlpBrErcW96ycFIW6keUDq9oSWaWj
         71DIckdpAD3wZCEIYPPypA8K+ID/MErpejE+95EKralDrOLQ1rO9miuVM9Vpj1oIL/Eg
         SZbQ==
X-Gm-Message-State: AOAM532Ae8fiz+p3InEyX5ANF8+Bb8M4IF/ItZIJEqzTmCuBRCMIoLA7
        caqE//DdBsJTTInkz8TAcuGeKxLaGtl2eg==
X-Google-Smtp-Source: ABdhPJwbWx7WJrn+PczkXfnSNrY216m0joVsgirUQj52qH9YUX4vBM/r9ao4+kBGtJq1/K3aPcjmXw==
X-Received: by 2002:a05:6e02:1489:: with SMTP id n9mr685956ilk.313.1644269363703;
        Mon, 07 Feb 2022 13:29:23 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id c12sm5020450ilo.70.2022.02.07.13.29.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 13:29:23 -0800 (PST)
Subject: Re: [PATCH 5.4 00/44] 5.4.178-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220207103753.155627314@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f8e14a61-42d3-972e-0511-4457c7273b41@linuxfoundation.org>
Date:   Mon, 7 Feb 2022 14:29:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207103753.155627314@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/7/22 4:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.178 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.178-rc1.gz
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
