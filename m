Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B2E594EF3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 05:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiHPDKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 23:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbiHPDJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 23:09:08 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B742EB1B2
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 16:40:00 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id z8so4624125ile.0
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 16:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=RJHB791tw7vsinRSzcnY37Rv84tgjTiIIGJ1yXlICfI=;
        b=P0ixV1cLkgxstejp9MLm1vbSbbHn8NKDXQuPJ6pZa3f3+KgqXSaBsxXLrMcqY6Ap74
         9EIWB5E8rMuy8OHGfSuHX0djX17L09iySCCum6LXCI0fVkD4NKOrWv/LJj2ncYLrGA5h
         6cJsqK1HsnL7J6KknzLlq/Obh5NlH4y65s4tg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=RJHB791tw7vsinRSzcnY37Rv84tgjTiIIGJ1yXlICfI=;
        b=Xa7anbXXWwBXkF4HNAzy8ueZWLZvphdo6rstmtfbhtnNKPqC2XLscb7nY7vJcd7Gat
         L2aX6TPRkvRBtT5WLqG5tBEf88ERACWcwCmzybWuF2J1xmQnHpaCnV7g6gwcFtOAGeAm
         VQznIbRPF71EjtBITqMNGv9q1KCNm8v75HEGeqGUDlWvpPLb4e1T0gPAatX7G4dHoyMI
         AIIfb8evYXiwStam0YPHSbrsmJ3yTPBMljl6vdav5FrMAidbNjamqPX9GjjlN5lpbqjY
         WEoXs29gHEoJuNEM9DbpVhngC4HSgyiDDPa+lDrkjlsIXwta2POC7LukEfIE87kSG/8O
         Qlcg==
X-Gm-Message-State: ACgBeo2B5/D70zSInCj3C/G04IDC5JKX1ECQxyaOMZiWga6QUsYV21gq
        xaXhOBY9l40XEH9tnlDYsF6P/A==
X-Google-Smtp-Source: AA6agR578k6g9mRKGUJ+L33pQ4BZdwTpCEp+TNKSPZ5MFNJJkosu8ZUBlQ9Pus17WODbyg2RfJC3HQ==
X-Received: by 2002:a05:6e02:190e:b0:2dd:f67b:6202 with SMTP id w14-20020a056e02190e00b002ddf67b6202mr8060537ilu.121.1660606798507;
        Mon, 15 Aug 2022 16:39:58 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id e14-20020a92690e000000b002de6fa0d0c0sm4349083ilc.63.2022.08.15.16.39.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 16:39:58 -0700 (PDT)
Subject: Re: [PATCH 5.15 000/779] 5.15.61-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3d30186f-ba60-d8c9-c7e5-2788ab627311@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 17:39:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
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

On 8/15/22 11:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.61 release.
> There are 779 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Aug 2022 18:01:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.61-rc1.gz
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
