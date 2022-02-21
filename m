Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0991A4BECB2
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 22:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbiBUVkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 16:40:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233273AbiBUVkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 16:40:11 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107DF22BC4
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 13:39:47 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id w3-20020a056830060300b005ad10e3becaso8330707oti.3
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 13:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ajwf0G5A3/8t4OAqzmkxp1C2/fmQ0tVsXaO6KjuIxu8=;
        b=MsWuxn6HQgogBzWEea0NVI0wyH6bkIgNe4WHazOVrcbaQbial3UTINJt62zA5Yh32l
         Mx+Rxd6IzqsM8w8b+WYVxeQNHQ1A9ciZY+bAuGhcYyjE+W0SYJqFnRBGIyZO2pEgeHw+
         wn/jTAUbbHz01gPB1CFmo+7g5lYJEZbpF/BDw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ajwf0G5A3/8t4OAqzmkxp1C2/fmQ0tVsXaO6KjuIxu8=;
        b=QFIYSDhNTkO32ilcCgRleIYrpdDN5Q2WyJOUa4XZOho1wFQEOaQ8vWosI99/c/8e9u
         irmyvzrQv7GUbRe6qch29bFv62rDJ5/B3+92kWBE/mPX+/9mu5VNLCuFD7gXrQtftMvX
         HwpT0rgsChSb9M3HW4V4JHJoSvMLXXX8GMNtCZ7ay/wNU/wCz7XDDuYRaRTRDdviDBeT
         OjWGq+lkLHZ3xeUn3mNMx3YRiDJNTDuV0C5B1b37oyIZ1mnphnyud5xu7bwddzIKy2Xh
         pzFcOoM5MgAj9oZv2gKotShAVrPe03vtUDAYjRU/2kQEawoA1I9Md2ciiIzx+DDOf+lF
         TGvQ==
X-Gm-Message-State: AOAM531uDl1Dem3PVS5pFU5hWgvhnzAtnHTTBWZO3DrSPmzA3zP60Ax7
        D+4zHbw2e6ylCgI308s8MOD2hQ==
X-Google-Smtp-Source: ABdhPJzI40iTGIBpk3p1jQXgbo+K1XoQef3bnJPk46GRhv3VLjDPiuzahyJgzzSWmrWckTLdOgHawg==
X-Received: by 2002:a05:6830:4d4:b0:5ad:52fd:5c38 with SMTP id s20-20020a05683004d400b005ad52fd5c38mr4912236otd.255.1645479587076;
        Mon, 21 Feb 2022 13:39:47 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id d14sm5413490ooh.44.2022.02.21.13.39.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 13:39:46 -0800 (PST)
Subject: Re: [PATCH 5.15 000/196] 5.15.25-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <91ce113b-e954-1dc8-dcd2-c42db40af073@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 14:39:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
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

On 2/21/22 1:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.25 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.25-rc1.gz
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
