Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34FD34D5271
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242890AbiCJTfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 14:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241800AbiCJTfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 14:35:47 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD5D153386
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 11:34:45 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id 195so7784244iou.0
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 11:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ikFy+g0Qff1RcPBTztueUofboGgJYJB+i1yAWEft3EU=;
        b=GycB/Cwzk6DtbT/p0r302LfzivVzangIFBLF0Erst+bYjLus5cOr3BD+WrZxH/XhI8
         Yunfwx20QGCXupDOmU1/gF3HcQzBtT74SscmpHU27guUSEJRms6ExBfSnjcJNg5VmX2r
         Ia2Qh/RagFEtZOAV62fZkQEsiv/9CjaB8FOts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ikFy+g0Qff1RcPBTztueUofboGgJYJB+i1yAWEft3EU=;
        b=mAeqvfGzc/lXbvPtw85RyFt7fsvcFpuyBz4JmqjeWH79q6CfW+2/Yo8Nig/kcW4Cri
         Q4C+/dfYym4Oa2SicCYkPlGIHMgFMSDTwiK0dnRUsHjuc4R8CWT44orEa5KdzO88Y1MY
         nhjvwGFVOTfoRezfQtOrjGo/hcRWsHgnUYUdPhdxl/MmCc2ztkpg8YvXxTwThwoULZ4F
         sbcL152d02EB8fkf0znb+BdZOd0WQQ2K8UGhR3g+qjMgXSAQkefKDWO3yrrOhh9MYjgU
         dWXHeY16x1fSCT6DmLXNZgRUrKQE1/C1+KzIToUxGXFId1Wc10edpk0NzXH+cWNfZ17m
         FRMg==
X-Gm-Message-State: AOAM5325Ie+xJe5U5NN5Rfa0r2HlWJJIm2YwEA3R9vCX/9vpop8pHKdL
        edRBvo9Nmi4JRamcFPgCaP57Kg==
X-Google-Smtp-Source: ABdhPJy+/RMKT6ree9MSOpAB4dGDwQOukmrZ6ETZ/uPkhC0GmHgWJThOk74LTnmZcJrKYbteDp4LfQ==
X-Received: by 2002:a02:690f:0:b0:319:c67b:174e with SMTP id e15-20020a02690f000000b00319c67b174emr1163287jac.124.1646940884855;
        Thu, 10 Mar 2022 11:34:44 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id s8-20020a056e0210c800b002c63be70db9sm3075916ilj.82.2022.03.10.11.34.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 11:34:44 -0800 (PST)
Subject: Re: [PATCH 4.19 00/33] 4.19.234-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220310140807.749164737@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <31f9721d-f91a-0522-fa8c-076526175c24@linuxfoundation.org>
Date:   Thu, 10 Mar 2022 12:34:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220310140807.749164737@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/22 7:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.234 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.234-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
