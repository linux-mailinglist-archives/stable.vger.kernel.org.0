Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49FD4B5D9E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 23:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbiBNW0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 17:26:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiBNW0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 17:26:20 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DE0145AC6
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 14:26:12 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id e11so12535810ils.3
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 14:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1irCIGKL0ppFWKpsCNeqRZG02MGtlqSun8p6DObg2Js=;
        b=W4uQB7ZmxyeN8AZaA/zWKdgBHv5lCFmA+j45RsVRFykeX7sx5gBIdDzybNUsc+uxA7
         104z4D5dz1yuyDRkKRU8HDyvnPPTuxQCB1U4Gw/u7zB7P4oKgIYwJOtR72asx56vi8NB
         h5itbDDGzyHF68w4feQtvIu3SRrE1ZV+SpRBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1irCIGKL0ppFWKpsCNeqRZG02MGtlqSun8p6DObg2Js=;
        b=35VR4Kuy8m/XtbPhoSzSnc3gHc2UPdi5xZJRAUVsCqKuS+9U74hwy+OR6hqQb8GcyW
         N121R2d4cGeMmkF6211uwIM8WHfuyYUIGwucnRoG7MUI42hP8jONArbSL7n6SGykZLeY
         qhzdwQddBIlcF9PXiCUoa4n+roqRj826zASKf2tMLGLqiASu9JJZ6FdEEhOz8TV0exwg
         Fy+nTvgwWWhWsirprrNgrJFKDXFf4CquAK0O1CZOAQJYdax5lW/raOY395Ko6ImbUUit
         /xA0pTjfkRkXzWcRP7EIewfE7LqeWM7rwoKUd3/odcvpsJDpczp6kG7egrVHPfn8wpbP
         ei6w==
X-Gm-Message-State: AOAM5304nrzp3Y6BniddZ0h0C1HBY0E/A880+hH0H6c8B1ADGnNeKJMb
        r3YIBcSxnPG8kfK4Z4ExjGvyXg==
X-Google-Smtp-Source: ABdhPJzou/7qc/J9ttzAQXptk30ivUIsMvpLR3PmLrwg0mkaSAuwH+RofTz5vVxMP/XoLnMlfcWUuA==
X-Received: by 2002:a05:6e02:1605:: with SMTP id t5mr664210ilu.158.1644877571599;
        Mon, 14 Feb 2022 14:26:11 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id u3sm11988667ilv.27.2022.02.14.14.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 14:26:11 -0800 (PST)
Subject: Re: [PATCH 5.4 00/71] 5.4.180-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2c6a70c6-a6ed-c381-253d-426a10390bd6@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 15:26:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/22 2:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.180 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.180-rc1.gz
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


