Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751D6683578
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 19:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjAaSjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 13:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjAaSjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 13:39:18 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C0353578;
        Tue, 31 Jan 2023 10:39:17 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id lc15so3790431qvb.7;
        Tue, 31 Jan 2023 10:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a5bhN7BpeXO0zsBNEiLmOP22urYR7JBKuNRMAigGlSA=;
        b=miQawrxs53UWUQMUfq15K7NHSEODdHqDcf8flxyoAGy/CZVxHJISwixIQuNoop9dpm
         N3T6QeLh57+G4evVS4MmMhuzNauCgXRQzHAmf94fGS6d8Bw8OgzrDrk7xKIh0SjFkY/F
         qJxEtJqP/nGAZkzPQlPvtSdEJxcT91jdWl2GIqzwfGk5RAc8fO6Nm5G58MgpndnEb4X/
         LL+gaquzwUkQJ+gYCVv219UG5lWj2OBXn8e0QKJlGhJux+7qAly1jDMU2MjGO2oKc6HR
         lt2nF3xRRqqEUllbIKCBRkyBLwQOXvawXgRLD9GsdwTToM7yyL/Ax2QX9HTM+l3XvMZC
         otNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a5bhN7BpeXO0zsBNEiLmOP22urYR7JBKuNRMAigGlSA=;
        b=dx39Wv/qxtPRYaGTM4z6bH7Ez2jThvXafTCiSXVLkpvvrLg9s5Yb3yL25n0NFwleIy
         YeCdPBfv80Gv9eQILBf/ZxX2oyFK3NjO1m6o83k0DfzM/aVMrYdb4nlu8ntaej5Qk0YF
         B8XFmlSqGwM3BRHDH7APl56B90x+T/k/WJmwsO0T0EmapYvsVc9pnAqBgYkLu5CvSgN/
         gWpVnN7C60SMW5tea4RzYiAxDAAuZzWn02L+9SlUfNhR+77mejts5KwLxahmRxI4bfIJ
         +cnMWpE+C2MMtoYMES+wb0wfEoZSCss6ksIPTDCtepXgg5dcHSiT0ziMDWXBoS/GD86Z
         Llzg==
X-Gm-Message-State: AO0yUKXeIbhhmjS7J4YNq2wN1BScW+U5fFYs56k6iFwosYF0AK/Y06eb
        BZKRxRlHmHiC9P8S5tMjJnY=
X-Google-Smtp-Source: AK7set8+nzDfobB9Iksxv/h4Z0qTOMJ8cAQMIQERiTHT3zqH2UcMfA5WKy/qJbERMeZDir58IxIcrw==
X-Received: by 2002:a05:6214:1712:b0:537:ab77:fbd9 with SMTP id db18-20020a056214171200b00537ab77fbd9mr25289308qvb.28.1675190356955;
        Tue, 31 Jan 2023 10:39:16 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x1-20020ae9f801000000b006fa7b5ea2d1sm10433563qkh.125.2023.01.31.10.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 10:39:14 -0800 (PST)
Message-ID: <9d50f623-e088-a234-0c69-4e84f1bab625@gmail.com>
Date:   Tue, 31 Jan 2023 10:39:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/306] 6.1.9-rc3 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230131072621.746783417@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230131072621.746783417@linuxfoundation.org>
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

On 1/30/23 23:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Feb 2023 07:25:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

