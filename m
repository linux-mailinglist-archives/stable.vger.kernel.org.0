Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDEC5FE3B1
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 23:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJMVF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 17:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiJMVFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 17:05:25 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4E774BAD;
        Thu, 13 Oct 2022 14:05:23 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id hh9so2533666qtb.13;
        Thu, 13 Oct 2022 14:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IpziDW8NH/r2N+nsGIcszHmIfyG4LougN21b7cgGScw=;
        b=eufQ1Zqz/YdpycjgMEOfM9hDgxsIWDulz+dPmrCMxVUBDlj6rA1yAFkx8YXHFoygsk
         LrXm5ghRGd0xsCt59Lt2ofuWt8JVhOmSKWGzuKaGpBWCKl+no8Nf5cwP80KlHKlwQ7fa
         dK1ooVav7sBrHinUxnEvTVVylqHMi0sGBxU93VPoqAQc3b00A/GUYV+VTFMT+y8ECwrb
         xav5op+Vp8tAidvQy65bpcPgMBoWp6jNLKUZ2TR6v1WjLz46lPlCTzxYVtbrATs56qN0
         g/SbsVm82ACW534emcQFPtRcFtggKH132165ac82wmdjsfyYf0h4CNGTAN7Jtgj6Bgd7
         wXeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IpziDW8NH/r2N+nsGIcszHmIfyG4LougN21b7cgGScw=;
        b=Cm9Z6dwCY0SsbJSmTSyuwB49n5dykJ4e+zGmpc4UlEcwhZW9RsBSNJmUEC4X/EfTLL
         LTBRkfF3SloKJTzvL2DhogkKCaeUHNBiHKFaMqQYH9tNmLPz6+KX1SfsO3CIrN6HPQjX
         u4Jkfq1O4GkJqhAhtXmuwEnLDG1GWeAQABFeW7nTzYpVZGfkOB7pHA/CBISelCUy+DXc
         MqZ6JxHmRoajHtS+ogqCT0wQFmj6Apsi0x8ZW/CdvBT2tKvoxXv5houag68mfeN5MDpa
         iDY2pwjs+wIniRWv+dAKN+gITi1MyoE6PmJO2NdrK0wvvVuqwBhaZFAlmhpbG0T6UKGW
         s5fQ==
X-Gm-Message-State: ACrzQf1XdZpb1gvGqNtL/9cs2HRRo0zxRnxw1rNbsknWo7iYuJ91iDo0
        Xaz/ZBmQw8dLXw786FuqjSk=
X-Google-Smtp-Source: AMsMyM6R7GNwFX6JymZRq/EaAYi2HZv75XaSCkQMxOIIBO9cnIrV7fIvmi3xOcgsKh3uQmC8p98QpQ==
X-Received: by 2002:a05:622a:1c7:b0:39c:d5a6:605e with SMTP id t7-20020a05622a01c700b0039cd5a6605emr1653795qtw.592.1665695122732;
        Thu, 13 Oct 2022 14:05:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fz25-20020a05622a5a9900b00399ad646794sm736054qtb.41.2022.10.13.14.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 14:05:22 -0700 (PDT)
Message-ID: <b8512a2f-d562-092e-99f7-f199522dc656@gmail.com>
Date:   Thu, 13 Oct 2022 14:05:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.19 00/33] 5.19.16-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221013175145.236739253@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221013175145.236739253@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/13/22 10:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.16 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
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
