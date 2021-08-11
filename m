Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E993E994E
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 22:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhHKUAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 16:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhHKUAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 16:00:24 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF522C061765;
        Wed, 11 Aug 2021 12:59:59 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id n123so3717383qkn.12;
        Wed, 11 Aug 2021 12:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=swA8xeXMRhgIlNWRvRrMhH3nt0Z+rwQODRGQ7rGuH9o=;
        b=iHZy+FrwZHeRglvct0ExF1zmF9R/Qg/M+Q+gGWyzSol2XFsqp0z5EdgiLbY3IIsb33
         Y0SDMFtJQE7mLbBX/cdYa95C9u9KCtl0BxbrFIX1NnO9kVLDyx0+cFlOAwnVl/Bervpu
         ync+65HmH1acdMbLAOOq1nXrBYKsO7H/1f0YmpU8lXQLfXJP9K9t52gplVKNBPYqdcrl
         36KHAenFNWuxzMxAsCxqMRL9rka4bfikqhMcSgQBLmMXNFmAubqwbFPBJD2kYumpVYsD
         qiFersG3T5YXzrGQn3UiNxw+bhYbAwGfIu98uknaUFhnutVQvdUOM1U0mI18C2ktf7f0
         9Wrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=swA8xeXMRhgIlNWRvRrMhH3nt0Z+rwQODRGQ7rGuH9o=;
        b=JfPcbDaS4Z67uFjje8xrJxzjZ38aXdjqSUHNkekjrjfR85GN/jGhaA24p4IIoYn4RJ
         0j+CpyiV7WkBON54TXPzIzeUDT1tb73RjD73PVdqDl8uvZH7iAu4AKyXawAxC5C5LPAF
         MmEaqsJHoHSLFyx6drirqixdIaklr7a10dfxH8ynNWYS7YK30gJZE8P5rIdgLFk4wngt
         +Y6sqsF5yzF0nF10m5tEWVJldFtUDizKfFFS+pNu6SPOY8a707iAoRFcidaLJdvEZNBj
         nxNRxD4nkliFOOgkOk4JeMTxWzvBP1BxBoNvqboZKzlpNtXRhWuYqgx7QF5bRZFoWzxK
         ZJtg==
X-Gm-Message-State: AOAM533MXyaVD5hVJX0+FnBcpehs4zMlGkHycaWiwhZ9Ku5SuAvZQ+8r
        uX1fPKOflVHzJC73sy6qwww=
X-Google-Smtp-Source: ABdhPJzP/iNqCWqSf4N5KjDLo9IGTBZZAbbBmskV2sA+RokuiEusjoXzUr/k5T+ELtYwijYxbGRvEQ==
X-Received: by 2002:a05:620a:1341:: with SMTP id c1mr794920qkl.348.1628711999188;
        Wed, 11 Aug 2021 12:59:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w9sm120599qtn.58.2021.08.11.12.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 12:59:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 11 Aug 2021 12:59:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/85] 5.4.140-rc1 review
Message-ID: <20210811195957.GA966765@roeck-us.net>
References: <20210810172948.192298392@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 10, 2021 at 07:29:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.140 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
