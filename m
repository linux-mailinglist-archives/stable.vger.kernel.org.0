Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EFE6516C6
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 00:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbiLSXj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 18:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbiLSXjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 18:39:20 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F1FFAC3;
        Mon, 19 Dec 2022 15:39:18 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id w20so3980730ply.12;
        Mon, 19 Dec 2022 15:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cU0EULG5kGzbbYWrVKM4b1SAYqw/pF7UW0YzwIO0qqw=;
        b=ncDxBFKa4l/h/V2M+5c7fGINY4vb8GI4dLqcqjFlFn6iSrjec9zivJ/SBr1xh7EoAE
         c2RVgBcT2zq7LCZ4gMxOz5D4MyhcIgnuf+C2/lxfuKqHmMmEnoYXTIGNP7OZfhtwIcCz
         vkvfcM/EFVYZoPWuIlZi1z6XsTqyh+d19xBvRvG/02PdkaTpRBZquGpLJRH70jlMf+x6
         FrpjSVBdFKPqpEiY/SdFbS7OAC6cS0zb2L9wIX6ZhThiBx6BqY9g+CPM6Eqh9VtnO6gD
         lwMTtDdi+RTTNkP1CnlrhTpp/39PjEUhYP/hBMJbnExN33UfpKb6xzzE/azsJcGaCFtj
         C4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cU0EULG5kGzbbYWrVKM4b1SAYqw/pF7UW0YzwIO0qqw=;
        b=yRP8jhlYaeeVkoBgZl9V6rpTRkFmFjI7vrRwk8FxAebjg57Bt+ZfvO5MxEJL3AC6kj
         Fm4BcJZNkWoK63SOfzP0OBSzIf3VAUMJENsFwXEnoDGw+GkzYUqdv761yjozGfl2urUQ
         P3DovbZkkqmHq4egpaRGTTcDiyoXcReOF+2OTGudkRrHVbU3unRfg7wJdjS650/gluzv
         32k9mMH21v8w62+p478gbJ2fmaL7daEfVWDcrfmzVe7j9/zvuql73O7dlHzqSpRZtZPN
         BuEwTKM7HUM1cYpTczT5Jsc0nEol0ggGS8GnrLEWNB/1XBMkNXXbi1F9076aU+SuO4f0
         p68w==
X-Gm-Message-State: AFqh2kpfz1943B97iXju2kxKEmq0rmVXCA4j37hL4YabRDfx+SiPZWu7
        yCzEYwlzS5Cf5E43k1a+dXw=
X-Google-Smtp-Source: AMrXdXsxXclB+EqvSnq+kgI26v0UQr5z0JnNuTW5Ez0zZzPFp/2KtGdvth237YbBa47hLvdHGTlySQ==
X-Received: by 2002:a17:902:e88e:b0:189:8a45:8e31 with SMTP id w14-20020a170902e88e00b001898a458e31mr17429289plg.15.1671493157939;
        Mon, 19 Dec 2022 15:39:17 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e5-20020a170902784500b001782aab6318sm7718929pln.68.2022.12.19.15.39.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 15:39:17 -0800 (PST)
Message-ID: <cdbf8bdb-8597-9399-a7de-c891ec8f7e7b@gmail.com>
Date:   Mon, 19 Dec 2022 15:39:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221219182940.739981110@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
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

On 12/19/22 11:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.85 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.85-rc1.gz
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

