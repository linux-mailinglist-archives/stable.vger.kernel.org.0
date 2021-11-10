Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEADB44C912
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 20:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhKJTmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 14:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbhKJTmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 14:42:44 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E8DC061764;
        Wed, 10 Nov 2021 11:39:56 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so2537612pjb.5;
        Wed, 10 Nov 2021 11:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9AM8RsbJTgfCsmJxaC87H1ATiXpfkb0e/XY+0PNeV34=;
        b=Bzo7kAxCDLpTv5k3AWTzFreZ6OxX9egrnkQiEIRM4fQHFmztkBwD8WP1gcSyGhilFL
         BT6Jv43CsLAmq2yE4bbPEVdmwJznc5HcXIIQYMKiQk5XiVjD5zoXsYpi1FaM78yN/8Sw
         Oz3YNYg2pMY3JG9vC6A9l4/ws1sKj/3LYUKlUKyyjIDicQipJelMvaTGy6gPB7w5FwD3
         rz7H0mOmujehBk1Yyblfs8hkFgIwg7OmjrKYe4CsTg9xpqIyCQhuPq7cSleZzF6bjCnw
         WFee4lStbgI9CLajzZCcTRJGeN0nV/Ju+b6IdJT1p8ect6lCqicp4wBMSkLxF9kQAu7p
         2pog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9AM8RsbJTgfCsmJxaC87H1ATiXpfkb0e/XY+0PNeV34=;
        b=p8obTpaChNUCG5frC1gqnscOQ45tm3W1dWvo1dCkxv6Y1gp5A6vx2xw93c/hlpYr1N
         MtpyMmwGnxcvIKF0NTNnGI5fu5H4ud2n8Y+C/EqXOxk6n+uodyf3IBQjTiTyMA6RZWrP
         yhVnAcDb1mhx377wP2v2BEeaqxBJ1JJEHen1aIpqmu+9Wdkwjer+kX6ATfhvdkF6opcV
         aqry5+o85swq7Ta9cGYEEzUHhrWsgNPJQNK5DAA5Hd3pys7TMrZ57l9OogO7yGcmo9Z6
         lBbVX+1CxFHmYgHRge1r6ADxnBBfr18W8NTYP6CDEEWIRq0XMv7rlI5K4sdII/12jB3J
         q6qA==
X-Gm-Message-State: AOAM530t7qAh1cxMrj0qNtZNBPrICjJUyCzioBVx17qc+gAOXwEJCuUJ
        UialbGzi2lfdXwWWOnClclESHFzQzfQ=
X-Google-Smtp-Source: ABdhPJxXZjA8fPco0CQbVlDpXHXiUhF0YUI1+IvGgDP3jWx5+IiThkZ5yhIvkWffLkVM3ijKTTBC9g==
X-Received: by 2002:a17:90a:1b4d:: with SMTP id q71mr1607647pjq.29.1636573195592;
        Wed, 10 Nov 2021 11:39:55 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d17sm432036pfo.40.2021.11.10.11.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 11:39:55 -0800 (PST)
Subject: Re: [PATCH 5.4 00/17] 5.4.159-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211110182002.206203228@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f97c1a71-4c07-0ab4-33c5-08531f987c85@gmail.com>
Date:   Wed, 10 Nov 2021 11:39:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211110182002.206203228@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/21 10:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.159 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.159-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
