Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44334F47D9
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346060AbiDEVWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573620AbiDETZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 15:25:53 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1BB23BE3;
        Tue,  5 Apr 2022 12:23:54 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id w7so351560pfu.11;
        Tue, 05 Apr 2022 12:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=O0dRfohcK9eaCbUDhlBpC1urlIj5YnREU7mZeC4aRPA=;
        b=JU+tKh0f8/luzEG0btiFrlNVuNiB8mUtzVjvBS+AmCaPzZbzVVh1+jRIkYXhiGqoDD
         fq3NbXQEVcMA53v54TgfM3xF9nRxGWi7UWx43K+7iNPcAUrsCKbwihnxzSwyOTyIhm7g
         1T+lb5T5nTF9Z1Lq5783NZpAU7ZwtqvcriefbkZVdnQJU6HSBBcfi1C+7O/UlgD4br5X
         +AWs1mk6GUrYbPGS8gbkwaRxRnyB+rKKhRJM+4txkcsxjiF8+CC497EKi1TTPZFJzOIU
         TyzS5y5J96616jBkXJnGZIS9pyGmDMcYtypotuqNyxBCI5rU6J82vB/EKXJScdTGYxBG
         +lgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=O0dRfohcK9eaCbUDhlBpC1urlIj5YnREU7mZeC4aRPA=;
        b=FOnYqPFgzeURRNBQ9K0xjYMnyKnaAQffRX3kyh+iazqs9ztIeSPqK3mKKDdwSrQR1Y
         ltNJ76lA9tkZPX8V3iHS6nrOdqVqfoG8sAmQpXs+iaLzIImI4gKLYG3g1tOLSbX4BBi2
         U59p6/EtCiHJrz+dOf74mLofq6vmRFsW1hFZngMcKZCaLzmzYueMn+CdhWzaZ6KS1SEg
         2WWSCmUWDvF+vwg8NalU//iQg7lukR5HEAw5ND4y8DhxmU8PP0YjIel/wdz9lhUdnRwC
         oB4n7oOSfOEuS2RtgySdo2kcTHr4ulcS8ASxOOWO0dLK6EaUar9gFII1+B3Xy4gihkO5
         TSQg==
X-Gm-Message-State: AOAM5317r78bsworFLWg/cp7ICqNzHEgBm30hTtifDaqadjpq5h/h1v6
        o6K2em0XtweReBzKN4nZ6Gw=
X-Google-Smtp-Source: ABdhPJwpDSZAMF6gJOjM9mDC/i4Q7L2YVV8ImLdDxgohwgHMGcZ8gdeTrllWt1lVpnatNoHo9tnrSQ==
X-Received: by 2002:a05:6a00:b47:b0:4fd:a5b5:a279 with SMTP id p7-20020a056a000b4700b004fda5b5a279mr5249909pfo.19.1649186633627;
        Tue, 05 Apr 2022 12:23:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f20-20020a056a00229400b004fb16860af6sm17180793pfe.195.2022.04.05.12.23.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 12:23:52 -0700 (PDT)
Message-ID: <378246d1-f926-7c39-b4ed-4fe1b87a5525@gmail.com>
Date:   Tue, 5 Apr 2022 12:23:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.17 0000/1126] 5.17.2-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220405070407.513532867@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/22 00:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
