Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB114BF060
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 05:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiBVEDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 23:03:51 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbiBVEDu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 23:03:50 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70F45BD25;
        Mon, 21 Feb 2022 20:03:18 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id 4so5891623pll.6;
        Mon, 21 Feb 2022 20:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NekY6OGHFgmgKQQ65AFvjUCSNP4TQ0VY4h/CqajA+cc=;
        b=Mr4yqugSYzL6lps3J6ov0s8vC/PJWO5VXX0TIvxXrZWWhddhQw+XkoXvuJvOBcLyoX
         SPsViWfCxADkWxM9nqkXigq0uw/G/l6G6Jos+cIRVvowyzqvhAud4FpR9K1CiORV3+8X
         o003gfki6PQrBe7bMbseSz5izeeHM3YRiBct2FQ7kvx06a6iafTAa0RE+AX3DMiaQpJc
         e7WstS5g54xq7TTiRGpEugInYNwM1gy8/3BwUIMN7EtpdkR2HEwdRo2r2Xoi1eigtZKy
         PjlJWEEkDgkoCzellw+ETy1hcJcW38ItstScudR/XKg+HBR/Q6fDzTjPm6P2YX/hyy4X
         LmKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NekY6OGHFgmgKQQ65AFvjUCSNP4TQ0VY4h/CqajA+cc=;
        b=lIZwihpt4zRPzBtSYbPRFkLsqn7KPPN8OJGFwrPDup4tmeGtEct+Dx6sipOH8uQeyD
         yX0/yfzBgZxOeqJbr8gUi2NS5zRPog56S6ij+thSarTbfVCR6l1kphJdVym8koWGIXHx
         niCjsFGaAAfJzUrsKDEdfuHjQYkNDNM3MEvEuT0zb2G434Yo1xwuu2L5QpjNzqanhiMf
         JMY8CzTVbvmfMgFVnhyN/rCFdZeR8yBvp/IKth+dK4j4t8JP6ugRMN4cqbdR2UU0iezJ
         QUDAVuOCtuz50qU8jB5VeqOhsVJt9vYhg0HYwdFRHXoBcdNLmR/0CvT4iBLrU9d/yTY3
         /2vA==
X-Gm-Message-State: AOAM533dpZY6AaEAEsfjOJ31La5TnindD+8/FaEBzHmEWglcYc1/dIbG
        gpZ4xs1qAY83x68MJOUlTJI=
X-Google-Smtp-Source: ABdhPJxkOxTV/yzIfWx5n/djV8cHp3NF0TBYKPWcDtfsjfkKPdsOj8SwsLoj/R3eR5r+kSir2C0JkA==
X-Received: by 2002:a17:902:f701:b0:14d:7cea:82af with SMTP id h1-20020a170902f70100b0014d7cea82afmr21462121plo.71.1645502598406;
        Mon, 21 Feb 2022 20:03:18 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id l21sm15274151pfu.120.2022.02.21.20.03.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 20:03:17 -0800 (PST)
Message-ID: <42f8abf3-1810-4c9c-2261-8b80d7e10f83@gmail.com>
Date:   Mon, 21 Feb 2022 20:03:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 5.15 000/196] 5.15.25-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220221084930.872957717@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
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



On 2/21/2022 12:47 AM, Greg Kroah-Hartman wrote:
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

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
