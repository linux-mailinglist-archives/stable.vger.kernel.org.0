Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8073C6180
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 19:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbhGLRIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 13:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbhGLRIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 13:08:55 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEDBC0613DD;
        Mon, 12 Jul 2021 10:06:05 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x16so16964340pfa.13;
        Mon, 12 Jul 2021 10:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x9V9SPELmsLpmwvtG8zXzGzO1op9evPXLNAl9MK5WD0=;
        b=U+V1Tt74Zb29UZ5gZh8F1PCt03cpDSuokdYWV/yWI9PTvS7qwQLlRj0wUHzzjnSHkd
         I+PWGz3DKSJEU/7EdMgQ8wCmSZbsPsr7NHl5zmRyLCpcm2u3diB5Iio3OmfUHPt+avyc
         v8K0wkP59QPnqZ1CQp2MxGwiIBnrllvzx39MmIWUTHClN0KXMVW2Ru12KtO5Zm2Ur0yB
         qPJ74/7xSQqvwsqDAxyd5qn0DvoUnNoD+vCNOwrS0OyXbizN8UxcHIrxbL5o5meB9qSo
         jZXeG+STK6TNn3cpwhTuhWqgtQseKBoPn6CQ/oQF09oVL90SoYRAFX2Q1AQAs5nNsY/w
         sC8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x9V9SPELmsLpmwvtG8zXzGzO1op9evPXLNAl9MK5WD0=;
        b=aVwL4pAyCG9N6+6bGMpsdZuGFd0ST1mjnrg9Haf3X8Zd6v8B28Fpk3yWGzgDuq+sto
         71VaxCZtJ0hZXsx7gBH4BF7GH25Z6zdgnjRxd/45v66dCju7sDtoGTYPX58c8tSysnJP
         1tLju1HYxtC3P+THuOgOIca2yhlnR90sh+G394TtB5J0vRpgsWUUFOsvILqga4uaNUoN
         BRnz3HvKdTZFQ3trqsdYlV30IityC80fRhiCUHUQYCQv0/EDZwh9ldO9G48j+TXwiZkj
         OYhLhfPnZOluq980YbIJp46oBBJw88kOos2tJoQI8oFATsQ1KmoTD1Hp2Ld/n89/fcY2
         alrQ==
X-Gm-Message-State: AOAM533kUx1ypLCObUHNh5T4LuVWL0CGMOjcDu6JUBoaBIifgztYnkJG
        doKIA+/tB3r0e2as5E+gqQopmVn4L+EowA==
X-Google-Smtp-Source: ABdhPJyAaijT/dH1cyStY8IhG1E1drKWZTh6M9w/JEYQ7GlEshjSK4F/mlBDuMP+tL4MNzYU+CGk7A==
X-Received: by 2002:a65:5b0f:: with SMTP id y15mr100351pgq.263.1626109565071;
        Mon, 12 Jul 2021 10:06:05 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a5sm17036414pff.143.2021.07.12.10.06.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 10:06:04 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/593] 5.10.50-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210712060843.180606720@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7e0ea175-75bf-4ec2-23c7-2a038344c380@gmail.com>
Date:   Mon, 12 Jul 2021 10:05:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/21 11:02 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.50 release.
> There are 593 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.50-rc1.gz
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
