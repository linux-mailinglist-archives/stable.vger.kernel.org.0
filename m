Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF7E3C622C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 19:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbhGLRuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 13:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbhGLRuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 13:50:12 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D0CC0613DD;
        Mon, 12 Jul 2021 10:47:23 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id w127so25428105oig.12;
        Mon, 12 Jul 2021 10:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kEpFrpKP/UisosbyMZgD/6vFLvp/fZ7o1cKY0y9m4dI=;
        b=pO3WQoj7aKiS/Yadr6bdJNC2OUf/ridqvY9WwECL+qZvWSyGcmZwF9at3k9j8y3h1t
         2YWAJQ1M+f67ov1LOmwN/FHmzDnui+4r/hbaxX0jKNSKgxh6oNRmuyLIlVjhbjv1+CCv
         df0IMudNBzPGiyOsQPMad8qjjc9x0f5o/a3rlcH3jR+gGOlqpOlKA61dDRkT30n5bsi5
         RjjFEqrfkbvr76npVDh267bTxwD12tDWJkCHtIr5sgTCXssSG6IwEshxDcZEIyHRjrUU
         uOhy1zN5z6tx2aA0KbfGRTJyRasUHR3qisU0mSesRasCys4pOUQlr/7cDKgGpqcPzXT1
         e1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kEpFrpKP/UisosbyMZgD/6vFLvp/fZ7o1cKY0y9m4dI=;
        b=S5nADQgXpRcadqfSladCtnBIjKSgKpCmRh4bOyeu1tVvhOjnIpVFggrOQoQV0MAXPd
         CtFwME85ShihjOy3gfVkWJohklYojwZmsy0oveO9Z6c5L1devOEyeNEw7dhf+AporuAr
         a/o9hN7RDV1uHRQGZtdQTOS3BE1fiPc4VJrf0nxBczu2Y33SPDzCOqEfSctY4rRrMNA1
         A9B246KhocB34bohlDTeDqUavzpi4LoYiKI77JAWEOWsxHd/8YyWkOyGwEReYa0Yw38o
         S5rSHwEfzaFLISjV7JYk83ui7GYz6XbyOSnjCG9psA2yztkp5iIIWimnLbJyrWLlz89Z
         qPeQ==
X-Gm-Message-State: AOAM532mzAhU00gs2BlmjT4H/uBnthffZJ9X3AdhFsv1QjN7OPN4KCiC
        HElS0aac4WNvbXrpvxX0OU+dIqz7L4Y=
X-Google-Smtp-Source: ABdhPJyOUZJWIBpuklFrhKl3z1nEBuE+p1vLxbeO+9fCmic+bF/KGnS6NNZtsXE0AUy5MR1AMXxx2w==
X-Received: by 2002:a05:6808:2115:: with SMTP id r21mr11470453oiw.10.1626112042116;
        Mon, 12 Jul 2021 10:47:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d3sm1906001otl.16.2021.07.12.10.47.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 10:47:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210712060912.995381202@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <9297ae2e-b7e7-3b11-28a5-4c7ab1db6a58@roeck-us.net>
Date:   Mon, 12 Jul 2021 10:47:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/21 11:00 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.2 release.
> There are 800 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 152 fail: 2
Failed builds:
	riscv32:allmodconfig
	riscv:allmodconfig
Qemu test results:
	total: 462 pass: 462 fail: 0

riscv build failures as before, inherited from mainline.

Error log:
cc1: error: '5904' is not a valid offset in '-mstack-protector-guard-offset='

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
