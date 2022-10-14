Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFB45FF0A2
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 16:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiJNOvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 10:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiJNOvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 10:51:51 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBD91793BF
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 07:51:50 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id o13so2631904ilc.7
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 07:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YmPYNAZyKnnwa+ukepIR2Z6PR5vn1ERX8lO7JMd5uLY=;
        b=aGucy2TnF+A2Omll/iMRIvyJLGJ1dclZF6D3iWjcuDmMyZDpbLkjWMv//YEiDJAWzi
         8pSPlVhPnQ1QJesjJIJ9c8J64t1US9jgALcvTiGj5Il7EElk0IwU1O0b06+0d94WYpOX
         8+EBt1MhQy0CQNH9VkIf4E4zFWy6Ubo/adBGY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YmPYNAZyKnnwa+ukepIR2Z6PR5vn1ERX8lO7JMd5uLY=;
        b=AKLuY9CxCj8BCRyUvdeTa5yEmix/uoPtyRBRXwk0iXxVIikkSt4Ssewr5FTAihjp6q
         TFDik8PJlRIiOcdqQUM/00+25E5RnUpHezNd6YhHN97T52UCKaBfLaY94MUgVFHA7MA2
         ESqGozglnYW0vfPPIBZkGsuLP0/gRotOG3xt3hsTTjtctjQnGYYn8ylwTi7igbSMkNIc
         UOut1OFR5fkCVQ107/x+WNNboEFFv+KKas8FxnzS/iA7Oa5BN0iIJoeNaVd09BqdWJQW
         AFuyquDSKeZdDbsfPirq/ej0h2aE/OZIs/So0r42dt1YuiwN0202QC5pWxTx7EJX+CxE
         LODQ==
X-Gm-Message-State: ACrzQf1U6E8WyY1wME5xFAG9stbhMhFQRYNCRC/muoPyyWtGHvacyhwZ
        o25yP41ifaVGkylAnl5zPos3Cw==
X-Google-Smtp-Source: AMsMyM7GeOcqtQD7n3BYzmmFiRsHJ4LOntu9PPEgZG+3Ctz49UTpwxhBQI/dCpFJ5oVQsQrAmXgNDg==
X-Received: by 2002:a05:6e02:1605:b0:2fc:405a:d04d with SMTP id t5-20020a056e02160500b002fc405ad04dmr2605050ilu.320.1665759110121;
        Fri, 14 Oct 2022 07:51:50 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id a71-20020a02944d000000b00363b5d4e701sm1171537jai.167.2022.10.14.07.51.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 07:51:49 -0700 (PDT)
Message-ID: <183d3125-1791-29d1-cf0d-ec5d1df8940c@linuxfoundation.org>
Date:   Fri, 14 Oct 2022 08:51:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 00/34] 6.0.2-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221013175146.507746257@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/13/22 11:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
