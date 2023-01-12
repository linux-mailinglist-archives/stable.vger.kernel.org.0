Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B0D668511
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 22:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbjALVIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 16:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240625AbjALVIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 16:08:12 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D2A5F493;
        Thu, 12 Jan 2023 12:52:37 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id x7so7415655qtv.13;
        Thu, 12 Jan 2023 12:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v7UZeg8WZH4vThWTlw3VjelHJJ+pjC2jFdvq2/134J0=;
        b=HKrZAuFxYvG5Is33K7J62e6jnU9DKkjx6vBIQ+mO+IxIN5HHlIpAu8lnam2gSnfDJD
         xzdUnjiBS0R/SsoFFXUrwhmTStSv1w3nvPR4yu6EBxENXBvRHfWmlnxPTUxY2vV3AA+U
         0U4JGb8JSlKdL8HMv/Ze2XbX7h2/IEGqRkOQ4SoZBCenw+QVQdTqcBhe8+3R9rds9ruG
         jm8GiNdHhBNKuMRi/mFiPGkqbhyxZuGG6IjLV0pTH0YFUDWugQYYnrzjADfiJ6WnoG7W
         dBcTWQCc0UzY8phyT9V4HFgwIKhztIqOTOsPZKXZlfRSEpGi3q3Q8wVQZh9SZlD3Jxg2
         BRvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v7UZeg8WZH4vThWTlw3VjelHJJ+pjC2jFdvq2/134J0=;
        b=vMOKdmt7zsFe1jF9tdhcLttNBApzwpvQuvKX5zfB8VoT/D3hcsztqdg6WevsOHnHb0
         Blt8Uff4UISb0FEEWTr/ODeFb6NPX+Jcxxy4nyMVGwZmR0uPRZttnm5JVXRudLpZcjoU
         1Dk8Nx7dts3lhe9yW4stkWCVbDXLVDPbnBFRiHYJWdvZ9cnLNaPYJhRTgTrONiKxK90n
         CN3F+uDBmQmXoXZ6HZpDD5DwIhu1X1mFBnlIv1lmGAM9I3HCNPuvPqid73G2goMJhW5d
         oZoJcaDXZ6EiFwykRm7EdVl60DidE/AF9JczfwtA0Pohk2cgAZ72JyxIpUFYF6WD8ytW
         3eEA==
X-Gm-Message-State: AFqh2krHkCckqJIr6/gqCse/TXl/6IOKYJtH7XHbgvHYGYZjDc6Hgyjl
        VofTYoxHFw56DxdDvylXOf4=
X-Google-Smtp-Source: AMrXdXvBg6hye74elpjLgIPaScfZlEZs+P2nrkYQPhY0bFkyjFk5hAvoryoIsF7oKRLYsOlHQcbQkQ==
X-Received: by 2002:a05:622a:801b:b0:3ac:77ed:3995 with SMTP id jr27-20020a05622a801b00b003ac77ed3995mr26467607qtb.26.1673556756951;
        Thu, 12 Jan 2023 12:52:36 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ci26-20020a05622a261a00b003b1020128edsm2540482qtb.41.2023.01.12.12.52.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 12:52:36 -0800 (PST)
Message-ID: <21962784-53e8-4305-d934-b8a5a8bc20fa@gmail.com>
Date:   Thu, 12 Jan 2023 12:52:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 00/10] 5.15.88-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230112135326.689857506@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
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

On 1/12/23 05:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.88 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.88-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

