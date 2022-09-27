Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4B55EB69E
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 03:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiI0BCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 21:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiI0BCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 21:02:04 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BAD92F61
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 18:02:03 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id r5so2981307ilm.10
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 18:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=LQiDahHbDe4UL1SSMsBtYl1Mu+bPkOHLGYOi+0ZFZf8=;
        b=ItxLjxnzT5YOiCsynwbeNANyPYZCiRNtCDt3GKHsUiftUCc+HCdzeGnCjRINfTFls4
         bYBhoe1KF6yfHIgLEvk6Gmxujo214pZmUlDuNm8lar0cSFl0IahHzJAUhYZEgqfl9gNu
         uaJLqfboownZFWJoauadTBC9+ehktr5xcjKDw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=LQiDahHbDe4UL1SSMsBtYl1Mu+bPkOHLGYOi+0ZFZf8=;
        b=0mlhbfs6ycZxdQiqvo9WsQx3vjgBQ6gOyoc1HlQTWwxhpyvC9CyIYaCQ+91yMubp65
         rbHMLE8uRfkm+MWxOQ93yEkSdIXseU0tkzguRDpqjlGx+JKDIuoVniG4PtakI+LqlbFV
         crcCmUH6FgxRt5JfcPdbr6MUkth5UAQglVW5rgmquaqTC7CaYcDfptCWiAYNYdC2TOkN
         oFQvdz8RMF9UuLj0mdr3yCFjWpgqpZOXQ7SeLar6h4qtqE2u2tnAgchjSKxNve1b7W0w
         S5Up+UNIz/Lsb17Mv9APnSMRLFwQMGVps75hnHqPUKOr0OSVivwXgPxNULYtqsaMlQrF
         GFvw==
X-Gm-Message-State: ACrzQf2g8wKkeiW0/fkgiAHCfoGGS+iGM8s4ba3UtBt0ITRKruxvjChG
        h9L8Lj/8XW2UlV+YnXMOGWvrMA==
X-Google-Smtp-Source: AMsMyM4EgfXtH9bDGFGAY3yw0rs41NTUT3g8YWOloep2/b95IJ80j3Lm6trR1oFarAJN256ySICaTQ==
X-Received: by 2002:a05:6e02:144e:b0:2f5:412e:7d1b with SMTP id p14-20020a056e02144e00b002f5412e7d1bmr11454672ilo.196.1664240522521;
        Mon, 26 Sep 2022 18:02:02 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id d67-20020a026246000000b0035aea8cce87sm34160jac.141.2022.09.26.18.02.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 18:02:02 -0700 (PDT)
Message-ID: <d9736f79-16ce-bed0-6323-b2a187971777@linuxfoundation.org>
Date:   Mon, 26 Sep 2022 19:02:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.9 00/30] 4.9.330-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220926100736.153157100@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20220926100736.153157100@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/26/22 04:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.330 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.330-rc1.gz
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
