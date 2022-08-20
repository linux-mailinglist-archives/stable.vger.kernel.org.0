Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF7D59AA43
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 02:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245716AbiHTAlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 20:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245664AbiHTAlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 20:41:06 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C47113DF2
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 17:41:05 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id y19so85331ilq.9
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 17:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=89UxtBEv+PhhoumjisXfK/1f+Vl1bRyW6NMktPfVdbI=;
        b=gvfCiK64WTAq6dCA7AgFQEAYYtTojisLZFwDVvymx+92txksgGa+Z5PzuTH7FkGUwh
         El/SIDAmPaWQmwWUK/bQ6HAbk+mF+wIvNvOPi9CeKLYSUN5qEPzTa0TFmrcwZTWLUZ36
         Kr7OI5pJY3P2gV7j7DNhSkBSIqpv8+NZRmkYo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=89UxtBEv+PhhoumjisXfK/1f+Vl1bRyW6NMktPfVdbI=;
        b=EsJcugWoE56HahHTu9i6Lons6fiE+OsMPrfDw+zGAYDwurj+CzLunDebLRL0eZuxvG
         vR6UX2a2zV8zSTckiw6vpZ/7NShNOA9L12m8L708cKrFfiCcOwYzGXWS46DPaIgYGRZx
         v/wLChlD2xbVG3vMm9qCsPehS5c/JPk6HKRCCHOv4Q1OvhX9uvfRtp5xus0n9/qyhZ7x
         fHcb7xes2wxukEXL1OHVoa0Xmie2iw6qGB9AGwAXu10h24HWvibKRtHfId1azZnUQz3q
         bUz6iWs17OWUdDJ7C5/3nPsr+ps9nClImjOG6Aof8JqsSqd4qA2rZuV0L4OTY582H6FH
         j7mQ==
X-Gm-Message-State: ACgBeo0WGRqpO8zKfTHns6hpfJnR433usnK5G24DzDaTL0m7XbvEmo9o
        y6NAYjVhvFmsi+w41ArgM2yIi2ZMY9GUCQ==
X-Google-Smtp-Source: AA6agR5+Mr/BT0d0FTkil/2xJZ+c6gchDUvIHYS2oTtGHqiPch2I1u1DqLstrRcJ5s2VXOMwxqA/mw==
X-Received: by 2002:a05:6e02:1d16:b0:2e5:813b:d172 with SMTP id i22-20020a056e021d1600b002e5813bd172mr4848627ila.164.1660956064856;
        Fri, 19 Aug 2022 17:41:04 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id m2-20020a02a142000000b00349bfd5a61bsm43346jah.78.2022.08.19.17.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 17:41:04 -0700 (PDT)
Subject: Re: [PATCH 5.18 0/6] 5.18.19-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220819153710.430046927@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6d98fb3d-385f-bb2f-5eb7-fc52cfad112a@linuxfoundation.org>
Date:   Fri, 19 Aug 2022 18:41:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220819153710.430046927@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/19/22 9:40 AM, Greg Kroah-Hartman wrote:
> -------------------
> NOTE, this is the LAST 5.18.y stable release.  This tree will be
> end-of-life after this one.  Please move to 5.19.y at this point in time
> or let us know why that is not possible.
> -------------------
> 
> This is the start of the stable review cycle for the 5.18.19 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.19-rc1.gz
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
