Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21234E7D72
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbiCYX0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 19:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbiCYX0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 19:26:40 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E6D286FB
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 16:25:06 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id h18so1639405ila.12
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 16:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Rpn+g2LbchiJckiA/OmOIhbRrJT+pg3ibQSlbzWrHPM=;
        b=LSgpHeSXxtfosmIoNLZTxq5v4gZMQ+MfTROOKfcsrhorW/FZd71UQVx+HXf/aSZZGj
         6p/6KnvDkV113aO4dkXgKph7CFn9xw6kNVnQAR4BSoUMNBhwAurb5RluMxTjnaFLJQoP
         ytMf+kueKBroABhPNIVzNkarFj2uZP3XWyEvc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Rpn+g2LbchiJckiA/OmOIhbRrJT+pg3ibQSlbzWrHPM=;
        b=BWdkiTe9sGBb/i1lk5M9McudgbY9GEIdlXyTVUKzEEl1pJTC2Zc49u/ndjWARhwkOI
         0fazr42ox3VEsnVZzMDmVArb8Nz8AbdC36KUyihBrJdk8yhojrxZ6x0RCcPgmzfg8po3
         k2+j/oW7Us4KnwhxcbFgJjiLxtSl2Y8BxKex0ooot1Q9/VuRn3UHUjPgl3EYj0LI8IiJ
         LzWKJN37tqDmVHWWVUPiYO1PN0Nksgkln+P/5TpKQeezHgQLHEFi3sGKMhDoo1bVLEfA
         oBz9L/M2yKUvnXbsa+GVAnQPGmvQ7/H9R/XhhcUYTWllnO+kXt/qX0+Ns7T5DEji15XF
         duxw==
X-Gm-Message-State: AOAM530J2sgGk/UuWU/8U8EEjs8aqPCrWfuklp+qQKDEvfPQ3uvpiSta
        WGyS3PdrySDFFx4D29Fvvq8FJQ==
X-Google-Smtp-Source: ABdhPJyewDAX9OhbPQNGeJhh1wIZafJ17tymZDPCQRgZVD14WP2qbRdT+XO7SJuXY5cw/4zsu7cPqw==
X-Received: by 2002:a05:6e02:1525:b0:2c8:5d23:f939 with SMTP id i5-20020a056e02152500b002c85d23f939mr586690ilu.315.1648250705384;
        Fri, 25 Mar 2022 16:25:05 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id p6-20020a0566022b0600b0064c59797e67sm1191434iov.46.2022.03.25.16.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 16:25:05 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/29] 5.4.188-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220325150418.585286754@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5f2384ad-12b5-d2c4-390f-07dab103dd18@linuxfoundation.org>
Date:   Fri, 25 Mar 2022 17:25:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220325150418.585286754@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/22 9:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.188 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.188-rc1.gz
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
