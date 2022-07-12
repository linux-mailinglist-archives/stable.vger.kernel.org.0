Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7C757103E
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 04:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiGLCel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 22:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiGLCel (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 22:34:41 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8390558DC
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 19:34:39 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z81so6712034iof.0
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 19:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ETPdg8nnx17yfHxQ+EGHdzx9tHj3Xodr9J9qfcB4T/U=;
        b=iIQ6u/XCk1zaTw7h9ehx64fHPnLypAG32CIIBASDVwqFH1A7dmly0xhr+LZam3SrwI
         wc0OWTN/ODDijcZoAmVRZ0VwnHuNwhGYPjRZGojgy/R3Hrmv/bmUkkZm6KocGLtup0wU
         pEoqy4D9Yos/I+isT9Izae4J4bkc7sFl4gZD8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ETPdg8nnx17yfHxQ+EGHdzx9tHj3Xodr9J9qfcB4T/U=;
        b=ps57o2+5rDTcQ2d0gzHm3oV3UI9veg1AlTSoFp3MGQJCeJrMwr37+n0egltLyA2qXj
         0K/rz+1NANsgYQ0MrUyFwfgrl1zPsXjLwaeA2bPUac4j5X06K0f4iCHiXhRQ0sK/4LkN
         ZrkuZA5vjE01bEt5ILNsFfYRwdTf8neWWbznkO5Trab0P5Pf5RqxKpQ5XSZgcGPm9zcg
         5BlWRmxLP2zxqgupjLpLGnJZa+a6aFHKZaJeDPbZBf4oyycNC3SI7TywXyur1PuwXzyi
         9F/dNs8c/hB4Qj3j3Rp6OBc40ins3osbR42uUq30cKTPEdaARaUZ6+0M73Ic8DQmaXif
         4zVw==
X-Gm-Message-State: AJIora/cWKEWVXRP/obAtQ/Bn8NXnAS2m2QDTmOzQrolrR2BIuO4bR3e
        XThCw4WarOHqB6RblnXUzUTsGEGCYb56Hw==
X-Google-Smtp-Source: AGRyM1vZ9dEyeFz1PF165DHhGGpXRjpSGwHFDiP02tjSD5Ttz9Nyu6wHw+qsAkVcI9jP1R5I6PubqA==
X-Received: by 2002:a05:6638:2389:b0:33e:9a38:2280 with SMTP id q9-20020a056638238900b0033e9a382280mr11870913jat.106.1657593279206;
        Mon, 11 Jul 2022 19:34:39 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id m21-20020a02a155000000b00339e2f0a9bfsm3610164jah.13.2022.07.11.19.34.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 19:34:38 -0700 (PDT)
Subject: Re: [PATCH 5.18 000/112] 5.18.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <aba94233-96ac-6cbb-2b9a-bd396f6be533@linuxfoundation.org>
Date:   Mon, 11 Jul 2022 20:34:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/22 3:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.11 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
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
