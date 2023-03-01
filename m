Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF4D6A749E
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 20:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjCATz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 14:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjCATzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 14:55:24 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38554ECF4;
        Wed,  1 Mar 2023 11:55:02 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id c3so11381521qtc.8;
        Wed, 01 Mar 2023 11:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677700500;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S7q6UpnF9np505yO0BiawmWibmxherXG1GGRZXT3ORY=;
        b=Bpusk7J2C3GqMTl+Q4+nEw1X16Wd3qLO1jyutq9Ww1XPik2cz9qi7osLJ4fdLkCYcp
         afCy+tnO8FdJhM6q0z7Z8gn7/6Hz1l88kWezKycf4G/skRgDwPCEh9UhfgCTB50GlIky
         Faw7hqjcLvTm0z5xDHC95Ke+C7INy2z6aRty3DBZZcw/Lnv1mk11fa+R7ftKXueXgl3u
         RYGWm49nCzjQ7gWsW3a6CGG37jW4WgYtlzxSaLfa9EuQY5Tvzrs1WAjLCMAahq/SGJKA
         T2jRTUzClX5o8xDFBX0xJ3Eq2iFcf290jpMpsNSjkFuob5M+361ee5uc/tw2pIZnuVHT
         nq9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677700500;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S7q6UpnF9np505yO0BiawmWibmxherXG1GGRZXT3ORY=;
        b=gsuRgTQTTaZtC6IfqYnaMeV03TmpJOkMXJQg5mowgkVeebUTFhAPxTphUA8q80wjbz
         m55EaTTn7/lkOonUunQn/jgitVXtKg+5bkZbKk5HlM5DfCM0f59WW6gnjJsJ1dbsZEL9
         ZDh6VZveyiGlDaFhaXtLPQAazVWr4SngQLff+/IpK96xJkOCV1Y/N7u5eeQSgd69+/58
         oq7nwRAj6hBOJE9WvYeAILTnGCBcZOO82zTHOPk6D7CR6VtKmc+uOWxk6hL2hwh1gj2P
         XYKJIc9DoMZgT+5MHcAENgAHdoYiEabFQ1thE1r8ZOY0ScbySV8onZwXxb7y7/VSlGKC
         oy8g==
X-Gm-Message-State: AO0yUKWd57b42aEbPLgO/ZDQPr27ul+K8IQwUn7fsEIjiqhGw7/gy3Yr
        fOWexr7ChU7vgcGB9s2a29ZsAebweas=
X-Google-Smtp-Source: AK7set/aIZURiBH8Q8ywlza1eyf0gl0yMai4LqAejDTsVmBCEgyJwoIu0dCkCdheB360KIhRIt80bQ==
X-Received: by 2002:a05:622a:1004:b0:3b8:6711:a472 with SMTP id d4-20020a05622a100400b003b86711a472mr13310897qte.20.1677700500479;
        Wed, 01 Mar 2023 11:55:00 -0800 (PST)
Received: from [10.69.40.170] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k13-20020ac8074d000000b003bfd27755d7sm6834730qth.19.2023.03.01.11.54.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 11:55:00 -0800 (PST)
Message-ID: <fbc9c0fa-fc46-6a94-f9fe-fdc63efb79f2@gmail.com>
Date:   Wed, 1 Mar 2023 11:54:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230301180652.316428563@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/1/2023 10:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.171 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.171-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
