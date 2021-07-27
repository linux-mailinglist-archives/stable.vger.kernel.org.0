Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488DA3D7DA1
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 20:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhG0S2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 14:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhG0S2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 14:28:41 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8A7C061757;
        Tue, 27 Jul 2021 11:28:40 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id b6so631995pji.4;
        Tue, 27 Jul 2021 11:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PDWrLM4kYIpPnETyo+7zlukVWrfhj7u2LKf/MzayyZA=;
        b=U/iq1mW9odIk7JeL08N94dNyXX3Q2+1alqPn70NqKz/IgSwxep7BBRFlnqTcWJG6B8
         P6BvpOh4gPpco0DshqSDjvv5L4wenm9bV+EvLhfKoQVPaNhlJKrzJCJ2PSkFBzuCAvHy
         JS5w+KL/1TqqenKH8O9sFS/6faAYH2XWs6dEV9idy2bKLgnjsH0G24/Gllmv857ngwqv
         K36fmzzp5hUMzvZqeXIPuGMWT7IdEA4CjHdhm8Kn01J1lA+4zwono6LYGK8+vKe8HZdM
         izZpekLmeJ2X0Q308BZZL6rvREGOS1cfsvPouEE7/WChMX9YF8YMFS8hkXK6s/HZuEaU
         W87A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PDWrLM4kYIpPnETyo+7zlukVWrfhj7u2LKf/MzayyZA=;
        b=noKRrxkiSBKnfOrFJvI7UvJKlOiBvUMdk5emVglklVsMNRKBHgQS2c7JoV77jh9Q3k
         kJZura7dMnYSjR18TbrpqYztEzELfjbfT4VIAMc5ex/fMEGGkDGab/BNe+s66ngZpYOW
         VEtQ2qU+Rxq0yNJhqiuqETafnP5Qx6xLcJON3qEWdy3ldiiVZ0pOqByGRQNoImtwWoYa
         dD91JvVbm799PG0+HS5+q0pcVrOt5Ju72iqkJkinDfKdYbhgcHjjs687q6E3+85oHlup
         /fw5e/jkenyfKIK/C2R6xCJaRRsZtg4Zx/6ty3AsvefZ5aecot23ktMvItJ3rgLzZhEL
         zZsQ==
X-Gm-Message-State: AOAM533df3Jy6NB1gFZWOHTzNuB1bHPYTgI2Yn/1rDOB5YbmVPcyomTP
        gZ7xlRZUtO4FSe/DkHdUvKRlz+M857A=
X-Google-Smtp-Source: ABdhPJxO21MCQmMBjX39MAyK4BJTwASKWQXRUQ4VS36AfIC4jGJXWN9Uco/oes5ki4njAwXa1vsE4A==
X-Received: by 2002:a17:902:ab98:b029:12b:acc0:e18c with SMTP id f24-20020a170902ab98b029012bacc0e18cmr19678244plr.10.1627410520086;
        Tue, 27 Jul 2021 11:28:40 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g2sm3568478pjt.51.2021.07.27.11.28.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 11:28:39 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/224] 5.13.6-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210726165238.919699741@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b73395fb-6bef-664d-28a3-a46ba93f59b1@gmail.com>
Date:   Tue, 27 Jul 2021 11:28:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210726165238.919699741@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 10:06 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.6 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 16:52:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.6-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
