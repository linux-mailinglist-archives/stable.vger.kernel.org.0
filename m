Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2206F52988E
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 06:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiEQENH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 00:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238665AbiEQEND (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 00:13:03 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0C84704F
        for <stable@vger.kernel.org>; Mon, 16 May 2022 21:13:02 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id r1so21016687oie.4
        for <stable@vger.kernel.org>; Mon, 16 May 2022 21:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aBwoO06ft9Lp2y52M7Cthcdf6jcDkJDrbRarPRSc4Rk=;
        b=afINIqztxbpVjEo5/iH1CMBtsE4WvyFUQ6AVLokM5vJmisCoiDFdRRQdClGdZuMT2p
         /A2q7M0OLQ/oNACSP3JrasANl1RitjR5hdMTUHnu2RmB+1Nq2OW+dmnIHPpJJBV/rMSv
         T74DYdNwT/2a6EQz+urvNhVOEsE5gkZOZa1n8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aBwoO06ft9Lp2y52M7Cthcdf6jcDkJDrbRarPRSc4Rk=;
        b=eJAclCqNnPp1XdFY+cLfTYLrvjhlkIEaeGNBgKg4o8/gog/h7q0BK6D+cujNY/CHsa
         hwSMsNMeqlWpJlTm36qwWynZQ/HFlvdrxvoVVPawnxBQe1eIkMpAu0SK+1jDETm0TmbS
         DUYDFPZjun9tPjcZLcR1D70mERb7c3JGSMSOrwEega8SbDu7JN0nd9pHfbhHbym3VmKK
         GzALpt6l76TClj4Gq36d97rTaWFAzYM7ZJuGA18Ya4U1UnJZkWMycd1gl3Jno9B6o2sW
         o/wqqVw16Vz7LBZwCq1MaxVnYMAQRo7N6jxMohop002V9JZ73Byr2rz1VyyTIYViZa5w
         pCpg==
X-Gm-Message-State: AOAM5324ZypY/dwRiZmsrdY13luFb92lROk9PeW8QVRU47oclqWuv+4A
        Qb1sc5rM5g5pvHAuGVpBStafpg==
X-Google-Smtp-Source: ABdhPJyfuBgSW2p9/USLe277sAtt85wBwIXZVpVJMgMPSRAVlAjgJ1d7ubwEDpVENmQslWbgk5J+DQ==
X-Received: by 2002:a05:6808:2029:b0:328:c2ff:a649 with SMTP id q41-20020a056808202900b00328c2ffa649mr8719160oiw.229.1652760781296;
        Mon, 16 May 2022 21:13:01 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id v2-20020a056870310200b000e686d1386csm6292305oaa.6.2022.05.16.21.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 21:13:00 -0700 (PDT)
Subject: Re: [PATCH 5.15 000/102] 5.15.41-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c0a8ec60-c148-c107-debe-2e988f8e4be9@linuxfoundation.org>
Date:   Mon, 16 May 2022 22:12:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/16/22 1:35 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.41 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.41-rc1.gz
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
