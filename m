Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D346B4576D9
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 20:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbhKSTF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 14:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbhKSTF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 14:05:58 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAB6C061574;
        Fri, 19 Nov 2021 11:02:56 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id b11so8798312pld.12;
        Fri, 19 Nov 2021 11:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l9Ikqxwffx28rzFOT+MDzvh/Hy9XNgRXjs9M7rYzZPY=;
        b=CWDP5fkd+gqQEOcsP/kA4LsIr1VUEia4w+O7f5r32yyhzKlyjk0MOYaseV9dMObyyY
         B5/wNlWWw2I3Y7zNGfXgL+kgBxTuPdEeEMCMzuSwgIaIiebfjC+nQ5AlzLVP7YXyA/JL
         dEJEmC+b3pAaLixWZodXM8A274UtOIj6J30QBHmZz8IixCEwW65wCwxUpe6hRaWlrrf1
         YHPHYfJilUN81IZJzpZ8naKe1FbO/TO/9oz0MrZB6dDX5+D5/MdV4Qzmv7PWk5jJMv2d
         y/W8uq3WVIPkKHbK2PPinBS/5iIlv/dI82yMo89uusa1P62KdENwtOkFW8iYBMi7ZYhD
         QsWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l9Ikqxwffx28rzFOT+MDzvh/Hy9XNgRXjs9M7rYzZPY=;
        b=q6CG7u4Ohu0VaQQcc2i24j0fP9J5LL3ZE5aHU7RbcSnhDeQf5VHuCHwPemhNKyJNzQ
         2AWpf3CyvzdSYmuOjKuXQtrMxDprVZUb9f/y+11klfEVByks4WCeFvmZ//0NRCtIun2v
         7vvUA8qj+IgHxqsVzdYqU2P5fP6/agRRnHc+HQNS+sn3aZg+WS1E3BalYjnsDVepIuml
         wqvb0hRkuzA3H+YzUQTsaGbNlQwe2bIgu1TPhCN/9Bx9NueBFEEVTIqz71hAbj2keE2x
         8mXzzELzmfG39YFzrShoPCWm/DJnmhBdKU22cBl73ZjDOoT3F91z5ZhpNzvzFKnBpjro
         lUqQ==
X-Gm-Message-State: AOAM533RH4/xoJCqo2leFQG9VizPxZHXn38KvGuCHMUoVYRZLtZKGeEC
        VDuJx5ri7DMoWOsyiM5bzaTugFc/W80=
X-Google-Smtp-Source: ABdhPJzQvxE0Qt/0W+ric4saOa2K6hYLAZjI580rdcKvEZ+TMxMR4iMFgXgxOsnizfiC3BMyWIki/w==
X-Received: by 2002:a17:90b:4f84:: with SMTP id qe4mr2453801pjb.102.1637348575929;
        Fri, 19 Nov 2021 11:02:55 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a12sm337274pgg.28.2021.11.19.11.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 11:02:55 -0800 (PST)
Subject: Re: [PATCH 5.14 00/15] 5.14.21-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211119171443.724340448@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <334112e7-3ef8-2ccd-79c4-8b7a96185b0a@gmail.com>
Date:   Fri, 19 Nov 2021 11:02:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211119171443.724340448@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/19/21 9:38 AM, Greg Kroah-Hartman wrote:
> --------------------
> 
> Note, this will be the LAST 5.14.y kernel release.  After this one it
> will be marked end-of-life.  Please move to the 5.15.y tree at this
> point in time.
> 
> --------------------
> 
> This is the start of the stable review cycle for the 5.14.21 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
