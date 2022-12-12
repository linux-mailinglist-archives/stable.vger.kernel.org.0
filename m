Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D37D64ABE0
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 00:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbiLLX6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 18:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbiLLX6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 18:58:53 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4D31C101
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 15:58:51 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id i25so4237340ila.8
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 15:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OZjN4DfBt1MpKQnJvB+t2SgFukuSJ9KwUKmZ/hzFAhI=;
        b=gzz8jhfC+YxU6CPIUoPEFVa32AeoGayYHzFWctIg35CBZHX08zzy5LNGJYniDlAUsK
         cQw9aRyIjWsHnIjEMJPpsvBN7JSLwGDKbk2V1Eq4eapWt0DGmtfbtO9SbgwJ7Enm4ybm
         R+BIiF1fLLil6hOamE8OgtsDessM+iXrogq1U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OZjN4DfBt1MpKQnJvB+t2SgFukuSJ9KwUKmZ/hzFAhI=;
        b=YWqNeWxWBdjxXrnuXSMO2JIFWnbIzm6Z8IyobxwbBMN6T9Kw0vjdg51leThvBmFNwg
         GlztL5KYKq3Na57XGBqdj7XvImAEAqinNcd6OsF+wEIGeyEucI9hL7cvF0DG1zO4QwV/
         yINdorg7XPNi+7UdfbthjJ56b20YLP4IApkh+CcCwPwOW7GUO2IOsLeAJ6g9ipUnuMaR
         VkjQi0NtGghW7Fo7moQFel6gltPevbdJNXEFIVFiQrmHBwToTWecXCgipYvJVMkSJ0jZ
         ug/V2bzjn/8Tqh5Ao+Gc9MFiwl9DvWvMhChMyoHe0+1YZ0Qe2IRvlO0gTDeCztvk1j2S
         S5Wg==
X-Gm-Message-State: ANoB5pn13V+yNtKAJbERHtxX5cn5Y4hAhyVDm4wtzOuMiUOcm/yghHkF
        5LLWzHVbf4kBZFDorgMzGqS5SQ==
X-Google-Smtp-Source: AA0mqf5PU7eqBo0BF+Q2Sro7x9KVt3tYrLlLLX882/S+IjtN28no4eMFYTFNE6ze8+7d40T21fy2jg==
X-Received: by 2002:a92:cd4e:0:b0:303:1141:1044 with SMTP id v14-20020a92cd4e000000b0030311411044mr1994430ilq.1.1670889531058;
        Mon, 12 Dec 2022 15:58:51 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c4-20020a92d3c4000000b00302e09e0bb2sm3295862ilh.50.2022.12.12.15.58.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 15:58:50 -0800 (PST)
Message-ID: <6c96b2f0-8144-8442-b127-e38aa46e252d@linuxfoundation.org>
Date:   Mon, 12 Dec 2022 16:58:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/123] 5.15.83-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/22 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.83 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.83-rc1.gz
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
