Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D1A659B0F
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 18:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbiL3Rr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 12:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiL3Rr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 12:47:57 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1391C13A;
        Fri, 30 Dec 2022 09:47:56 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id h4so5493479vkn.3;
        Fri, 30 Dec 2022 09:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AyGeXSWlMzOIy/hkiCrKDhhX38vwiuPZQyYWri0c344=;
        b=fR973Yi+rzbjCJmZ2Umj9yji3Guz0I05vIcCGfdewhFGacXUwu4l1TcLcNOBkOurUh
         /XubpBw0bC3q2Q3u0nyc9VXmeN5rKatQJZbrDNFCQybb9Klt0TWsMJYKGN5NOSX7mUeR
         tAg3s13KnfM9q+ncqw2zVuY8RrRaTfXCdCrE3MienFY/5Eag/L8cBJov3UgcqZ3m6NG4
         str981CIrMLdkPUMeJEDv+rHL+Q2l1f4bBYK0df8dQlcVeR48Qt8g86P21dClL8FT5ET
         GcXTDCzyDh3PvEIUjmvoI0DIgLThU1a+gfFJgI7ie/VXv94eF4MxjqtCaZftB4s4DHKe
         o8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AyGeXSWlMzOIy/hkiCrKDhhX38vwiuPZQyYWri0c344=;
        b=zZ0TWby65NhCQ9cR4O/HbDyg6b8B/8fG+GPSu0pyxuaWaR5qBBktgJNHp43z583bUt
         fUYoqhmNGl4Ntm3njONKJS961e/upRNNRbYX/xkjbueuQ/HGqIebHFMTGx0+dUOjG2h+
         yrR9T/3ax/UyFoMU95S5kQyaF5x8ylJOt9bWvYH3xooZH02+ifVStigE8rZYiE2WBDZU
         Y+cua9/6N4/Mi68WVrmXF7f/yiQXdFFVoxUG2U7ivVRHQ90wtmMT4XiyikpvTnoxtrXP
         8MbcJ2NbZoCUIQb9JIMNFDTmObR+J0Qa1DCGzTq085wzXQGgW+H3NMBJoRWfimDpKKpG
         /PDg==
X-Gm-Message-State: AFqh2kpx2AJu5lyw3pkeQLfm52JNvJS6JsCR1CCmr6i5f6tMglov83tF
        gAylxaLWkcrHYnVXf/52lvE=
X-Google-Smtp-Source: AMrXdXtIKiPWDx+0UOs3naUIh3gCGa8SMJcHXcqH43H23R7Tm8owAXf9uJnog/mXR7egfTPoTxqyGw==
X-Received: by 2002:a1f:19ca:0:b0:3d0:f9d5:637f with SMTP id 193-20020a1f19ca000000b003d0f9d5637fmr14217557vkz.0.1672422474963;
        Fri, 30 Dec 2022 09:47:54 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id f9-20020a05620a280900b0070531c5d655sm1233816qkp.90.2022.12.30.09.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Dec 2022 09:47:54 -0800 (PST)
Message-ID: <791d5db1-a6a7-fb9c-2623-efadc351d891@gmail.com>
Date:   Fri, 30 Dec 2022 09:47:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221230094059.698032393@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221230094059.698032393@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/30/2022 1:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1066 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.16-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
