Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E10639D0B
	for <lists+stable@lfdr.de>; Sun, 27 Nov 2022 21:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiK0U60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 15:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiK0U6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Nov 2022 15:58:25 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707C7261C;
        Sun, 27 Nov 2022 12:58:24 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id l15so5587724qtv.4;
        Sun, 27 Nov 2022 12:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9z9H623YyFpG25RUIa9AcX5Q4BaOKDFmx3+FsI4Hjo0=;
        b=kIKOr46dScPmq82WG73HKGJ3DxDc3QohtTk32WAwA8BB53HL/cU1Zd9JrpLVzbPjKJ
         tbGocktc39UMu+PuS17GmtPxqEjClzBIgJhPNlE7V9DXcWiSRuoqEHXW7Zputi7reqXP
         ZN9G/J93jW7gzJH91B8do8l01F7HVdOxs4lYgEL5k4A7qESjOYW+yrlc3XbWBLqDd2TS
         rzGoQ4r1P5lXol9Da8uNds066GgQTcjHICSC2Tj83OMrB0HkE3qXq+y7LrQ45TCk3KE2
         oRFPWn6FZjzyjoyLKkh85zMTIgol5Yq90GKPvBQvtV6VLPAcWuMVhvVg1Sv8z9noi8k8
         2MFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9z9H623YyFpG25RUIa9AcX5Q4BaOKDFmx3+FsI4Hjo0=;
        b=UUpwMwb/tOSveg+DJ4RyOo9TFogEvm7YuUTM3M+7y5TbOcNG5YtpfI7swOBOraX+sZ
         LOyT5noA2ETQh0GPKGWV8gRqb4rQFbrZxtgp3pERNheBtvQ280h9wTieJaqXvFADHFtN
         5VIGKrwP7PwEjGEZdGDep/VGGfydJlgT0ezd63N/O/DxSIU5QKxobSLIVjV5fVyILIdH
         Ylnwagkco4iZNXRywNEnaAH/iK7+e+W5gSj0TuOX2TohPxV4qJFXaHgT/UBOLf0dARr+
         yek6pmGa24dBsUcbX69oALTSufvxK0yemJpf49HD+OqEemkrIhP0p5CY75xBbXr4Qjri
         67UA==
X-Gm-Message-State: ANoB5pmXAXJIx/+tmzvGx/9OR0nHzCqE2grgJDqRqHaJ7OzBfyBAc6zM
        F5MTONTGsPtZNS21ylnPCoQ=
X-Google-Smtp-Source: AA0mqf6XfDiTe4HDarvewLHJ64J8JYj8LZ0AIwPf6hnZaBhAFqZ23/QLfBypLs+hafawdP2MFjlarw==
X-Received: by 2002:ac8:4d51:0:b0:3a5:1e6e:ad6a with SMTP id x17-20020ac84d51000000b003a51e6ead6amr45058614qtv.556.1669582703502;
        Sun, 27 Nov 2022 12:58:23 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id o22-20020a05620a2a1600b006eeb3165554sm7021787qkp.19.2022.11.27.12.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Nov 2022 12:58:22 -0800 (PST)
Message-ID: <bd2843ef-b226-d603-0474-c0f6d325c6c0@gmail.com>
Date:   Sun, 27 Nov 2022 12:58:19 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 5.15 000/180] 5.15.80-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221125075750.019489581@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221125075750.019489581@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/24/2022 11:58 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 180 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Nov 2022 07:57:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.80-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
