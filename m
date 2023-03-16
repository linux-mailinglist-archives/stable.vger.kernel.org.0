Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D494C6BD80B
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 19:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjCPSSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 14:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjCPSSs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 14:18:48 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAB1E1CB7;
        Thu, 16 Mar 2023 11:18:07 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id qh28so1829553qvb.7;
        Thu, 16 Mar 2023 11:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678990686;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oZLGHJ6+3en7wcpDA1c5BiqkKAkKpDqfiHyz3caHyFE=;
        b=W8M9hEzvOYxxUxLe9cGr1pEw2qRyYlm3E97AOCY42wX1PNAxqD7g9VadohnIeVSLb9
         K+jUtAJmccpQDkK37ooPm4aEdsWvJ8kTLGTj2hYxSHW4/U/+DRQOdc87rfS8TnpsKe13
         z+ZfEdA+UNJ3tjQ44w2RV9S6KBFOsx5wSpFRkcQoBhJcouqPQl0vWQ++iTNewbaHMjCA
         kY8t9QyrSl+IIU1EPUyVtCFVMmrIe2W0SJjULxLqgYnzDrWNW1qyhddrOr6ATbwcJjXx
         tfYXd9Fa1gwG7yYmtH4G5s5m3SneLXZvguqz2JyEC/EG1+SQRwOb+HgleOkZm0iUMu+9
         MupA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678990686;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oZLGHJ6+3en7wcpDA1c5BiqkKAkKpDqfiHyz3caHyFE=;
        b=sp6tVyhs5HmTVzamGIdAEvzP6WLdpinQLhjv11ULsIvVrj6yrpdTd7DAZjNV1TEWPI
         ujlODVKm19YHWU7PCnojczN/tS+f7rzs1J8h0/SyydZklizYN6TAaqYIAdThN/w9wlm0
         iimTJXv8LwSAuzxXaRbKnylA/NY8r+czrHAs5e7l5Km31S40jOUe6k+aYEH0qM75bOO3
         PjQvqGa/VyghMDlFBS2ZB4p2qsEg8DQNjyylwYbkYoXlJVwq2dn7JNgqRdjZMYEzh2kx
         7/nhy+JgLw3qtgR9OgcBf1SAqf/zUWYEWBa9KSJlDZBbDuDEQofGOPvSIRI6bIfTMRJ7
         Uu+Q==
X-Gm-Message-State: AO0yUKW5w8YT6/ipeTr654Ktg5QGGANxjoMzOvfU94fRXsprPbkcAiW/
        u5Kc1lPHpEiAI5cUtRUaCNo=
X-Google-Smtp-Source: AK7set+fEui6EyOvMdH0qNoEjcEL6H16nBqpNbg6DV9CrSS0yq6BEabvKSlFnSAwAyPs3j0qBXvSkQ==
X-Received: by 2002:a05:6214:20c1:b0:535:5492:b427 with SMTP id 1-20020a05621420c100b005355492b427mr33869325qve.28.1678990686077;
        Thu, 16 Mar 2023 11:18:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j9-20020a05620a288900b0070648cf78bdsm42704qkp.54.2023.03.16.11.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 11:18:05 -0700 (PDT)
Message-ID: <3bc1da60-92d2-eba9-5f0b-b6b7020e19d0@gmail.com>
Date:   Thu, 16 Mar 2023 11:17:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 00/91] 5.10.175-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230316083430.973448646@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230316083430.973448646@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/16/23 01:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.175-rc2.gz
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

