Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D0C4D5270
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343685AbiCJTgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 14:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343680AbiCJTgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 14:36:08 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE33158791
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 11:35:06 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id 195so7785276iou.0
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 11:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=laExCu15MSDIwht4Fb7sSTYAywV43I/hN2LqXzvWbPY=;
        b=Equa8ke+JtOLoQL5wwEbL7jrXELLzQxgv3BulI7mQI++7z90IJtYRASum/hpfbkzjL
         bcPw1sTaSzR+0lUS7j48gRqp+Kw2pkzn/l/qFVteuFCOKYg/uXthldh4QXaOqdkMgheC
         aLsamfGe6yoSJCLtB63iNhlwKiuyuWlH3nBUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=laExCu15MSDIwht4Fb7sSTYAywV43I/hN2LqXzvWbPY=;
        b=wKfFAGddpIksZ/Y2mbHKxmlX5T8bOOEvbprwzGCRaDWImC2mrpvhDE1BjXXEpmcQOT
         MDXugeOcmtCm+RFGVAqMuADSbcrndFcTspEkHhTw3qrRdfzIvF4TCxUwqnlsXMiRwpiP
         aa1MbC52nWYOJYipuWFsLTEjet8usw2TRO701cFXdETU2F7juVNcnUssjF/5BekEKpGJ
         +iFadOonGi4TWNGcILxIm4E9kmQuxMQuomKCqUOzGPEIP5+G3L6USnvGoLUBCm/4/nbJ
         2c2tJL3sp3VU66l/6oRFRVpgKUhda1wiMHQpsUmTduroSPpeWiXu8ZxJsBnr+c7Fmg7J
         p86A==
X-Gm-Message-State: AOAM533pVnytwce26BguAYXTXEUdNvEU6NutujGFDslW5odGFTlbA4gq
        ZqACjSuk9QRmNg4hoWE6+3WsnI+t0KBPxg==
X-Google-Smtp-Source: ABdhPJwliYNpoVw89f+qFDqkS2SKG0YAFpFXgZ9PU2wHAi0T8h5Mggu/uQxw32yNfbMrTT7xEBIU1g==
X-Received: by 2002:a05:6602:27c5:b0:631:a30f:143a with SMTP id l5-20020a05660227c500b00631a30f143amr5078294ios.40.1646940906231;
        Thu, 10 Mar 2022 11:35:06 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id m7-20020a056e02158700b002c61541edd7sm3488148ilu.3.2022.03.10.11.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 11:35:05 -0800 (PST)
Subject: Re: [PATCH 4.9 00/38] 4.9.306-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220310140808.136149678@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7253e28c-766c-e2bd-f9d7-80809d81cd2a@linuxfoundation.org>
Date:   Thu, 10 Mar 2022 12:35:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220310140808.136149678@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/22 7:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.306 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.306-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
