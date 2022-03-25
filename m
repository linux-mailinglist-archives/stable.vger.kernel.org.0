Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619E34E7D84
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiCYW7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 18:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbiCYW7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 18:59:12 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A097338DBD;
        Fri, 25 Mar 2022 15:57:36 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so9764558pjf.1;
        Fri, 25 Mar 2022 15:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=T/H9zB8PAl0HAulWpdroY7dfqIUxKQJYXCSXrYVzijc=;
        b=Ra6jAb6UlR4nOFojKTm+HdHRLBKlIcHxv9mW7jPrtW4RU1ITyM4c6J57tjyNJLQVz+
         gHvLlBHx4o/i/K4uNHIkTOgpA3gJ7H2FyMrPL5i3jysrzN36use1/cF3ofm/MHA9p/kM
         0Il0J6nrjKjh59ihDt9s9As8n3cWx1ZJ6zdBC1EyOOmtTf260tZ1RcVKCME3qHjvKtvn
         OqjfYT5i+ErOORmuitt4yuhJpJVDHJ7JlvNjeXggN8uktCigys3gOnVtNiGDKn61bdJI
         O6R4jimGIO8xy3adOoAE8hlEF5uYiYv6X/JYyycigNuvfoy65juhIPCMBQFXnvTWQz5g
         jB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=T/H9zB8PAl0HAulWpdroY7dfqIUxKQJYXCSXrYVzijc=;
        b=CPYR2z8YdSNhC1Mh+M+6ko0XFD6NzsQtCn4gIBJycR7lZ84+f1DydL1vKMYZQ3W+D/
         fb5dfF0Shvd5PGbY6bRpFqflighqt88gLvodt+GBSCDtjM+KHQtUy+KjBcQNZEsjKqGA
         cD322d3aUI18c4DIzDgMSnaLuM6KbLYs+q+rXBXYHpx230NY9BJSMRgJ7DMcxyOmdGhC
         r5e7qC5QxV+4GOV44kiOmrmO5cx01IbIW4R795b6pHjiAUJeoH74YaHAwq1tQVc+oiXe
         P2lUushKo9Mkxc8h96WYm96GAJIcHuypQ0gMqq4Jzfqe8LfmFWCQHbsqrmkM74eAjyNq
         h9Mw==
X-Gm-Message-State: AOAM533ALQpH1lCggoX7CN3nGvxLQC8X6cnfQoJhIpQesZVwBZtYNSNg
        9zNKvAdApjs17iLbNAWPtyw=
X-Google-Smtp-Source: ABdhPJz42bbf3ert1/RONH+7Y75irVdGlCG2UGTTUprJ9ZEIDixv14y45n086LTqjjLjhFgCWR4Y/A==
X-Received: by 2002:a17:902:d88f:b0:155:e660:b769 with SMTP id b15-20020a170902d88f00b00155e660b769mr2400112plz.36.1648249056103;
        Fri, 25 Mar 2022 15:57:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id on12-20020a17090b1d0c00b001c7a548e4efsm7925361pjb.54.2022.03.25.15.57.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 15:57:35 -0700 (PDT)
Message-ID: <b23ed7f1-007d-47e2-df33-b82cf6e2e700@gmail.com>
Date:   Fri, 25 Mar 2022 15:57:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.10 00/38] 5.10.109-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220325150419.757836392@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220325150419.757836392@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/22 08:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.109 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.109-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
