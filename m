Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B815F37DB
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 23:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiJCVdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 17:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiJCVda (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 17:33:30 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014D126F8
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 14:29:01 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id a17so5449713ilq.1
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 14:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=LY8eeaK8Pu9GR7k7z1a4/PFZoWyqSXh2iFNVRAiOyu4=;
        b=MkWv0QCN7e6zRpPGc7T/WVD4nt5f9FrO4QkNJjKWavCFndA20SfqKyiZ+Jb9YnpYef
         I43BRzaVDyv8F8unGZlnhqErakwHAhtRFva8aVnZzWSO2UfarBfoCxLZys1WOnieUN6W
         JfqWC3oX5hqYY1oLhE66I1f6s0atJHscIX6H8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=LY8eeaK8Pu9GR7k7z1a4/PFZoWyqSXh2iFNVRAiOyu4=;
        b=Z4Jfa6UuFC0DQg1njbynA1rwO2EIYYlo3E0wpB+di6i0DTDencBiCouF9PUHqqOLDX
         8EI37McN0i81sC/3JXl3QlprTEtEDYjk5XVPnInK+4a+iYBG2ESFLK94DWhpdmq3uf1b
         rTTeU2lnHOnmepPw8oK8yQcNkGXnEPh0IVn5kkaDItkLmxEejtDp0P91fsRd+VY/3phB
         lwn5FvwzigawYof89OOGqQnb8umho1DpAfCdIp0mCLddLsv3ewPZtwKG5bPWbdUd+z7j
         I5Zq9EWhdeqIYf0waLMWGCPscrdl80izTEWWLE4akwHDfgwVgSVBYMYtm+6v94TfdX29
         DWFA==
X-Gm-Message-State: ACrzQf0JhMyWG9FJ9oWKtDa/8m/s1+BavbyOfN9uY+Rcpfd7BMceyrAR
        p1pzsoClgDzi55dTGZ6VKsPkEQ==
X-Google-Smtp-Source: AMsMyM71pQY3eEIltIwKVev/0zu1Yn9yaIZ8YQUXc1WLJrhciwRUQFZfWrJYoIhVmBFVTG+m7+26uQ==
X-Received: by 2002:a05:6e02:164d:b0:2f9:46bb:6ffb with SMTP id v13-20020a056e02164d00b002f946bb6ffbmr8499069ilu.320.1664832540314;
        Mon, 03 Oct 2022 14:29:00 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id y1-20020a027301000000b0034e0cdeecc2sm4568826jab.98.2022.10.03.14.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 14:28:59 -0700 (PDT)
Message-ID: <28f27d09-1121-10a2-f0be-9c1733343d70@linuxfoundation.org>
Date:   Mon, 3 Oct 2022 15:28:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.19 000/101] 5.19.13-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/3/22 01:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.13 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
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
